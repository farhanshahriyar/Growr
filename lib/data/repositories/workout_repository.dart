import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../local/db/app_database.dart';
import '../../features/workout/domain/workout_plan.dart';
import '../../features/workout/domain/workout_session.dart';
import '../../features/workout/domain/logged_exercise.dart';

final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {
  return WorkoutRepository(ref.watch(databaseProvider));
});

class WorkoutRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();

  WorkoutRepository(this._db);

  Stream<WorkoutSessionEntity?> watchTodaySession() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1));

    final query = _db.select(_db.workoutSessions)
      ..where((t) => t.startedAt.isBiggerOrEqualValue(start))
      ..where((t) => t.startedAt.isSmallerThanValue(end));

    return query.watchSingleOrNull().map((row) {
      if (row == null) return null;
      return WorkoutSessionEntity(
        id: row.id,
        planId: row.planId,
        startedAt: row.startedAt,
        endedAt: row.endedAt,
        completed: row.completed,
      );
    });
  }

  Future<WorkoutSessionEntity> startWorkoutSession(String planId) async {
    final sessionId = _uuid.v4();
    final now = DateTime.now();

    await into(_db.workoutSessions).insert(
      WorkoutSessionsCompanion.insert(
        id: sessionId,
        planId: planId,
        startedAt: now,
        endedAt: null,
        completed: false,
      ),
    );

    return WorkoutSessionEntity(
      id: sessionId,
      planId: planId,
      startedAt: now,
      endedAt: null,
      completed: false,
    );
  }

  Future<void> completeWorkout(String sessionId) async {
    await (_db.update(_db.workoutSessions)
          ..where((t) => t.id.equals(sessionId)))
        .write(const WorkoutSessionsCompanion(
          endedAt: Value(DateTime.now()),
          completed: Value(true),
        ));
  }

  Future<void> logExerciseSet({
    required String sessionId,
    required String exerciseId,
    required int setNo,
    required int reps,
    double? weightKg,
  }) async {
    // First, ensure exercise is logged for this session
    final existingLoggedExercises = await (_db.select(_db.workoutLoggedExercises)
          ..where((t) => t.sessionId.equals(sessionId))
          ..where((t) => t.exerciseId.equals(exerciseId)))
        .get();

    String loggedExerciseId;
    if (existingLoggedExercises.isEmpty) {
      loggedExerciseId = _uuid.v4();
      await into(_db.workoutLoggedExercises).insert(
        WorkoutLoggedExercisesCompanion.insert(
          id: loggedExerciseId,
          sessionId: sessionId,
          exerciseId: exerciseId,
        ),
      );
    } else {
      loggedExerciseId = existingLoggedExercises.first.id;
    }

    // Log the set
    final setId = _uuid.v4();
    await into(_db.workoutLoggedSets).insert(
      WorkoutLoggedSetsCompanion.insert(
        id: setId,
        loggedExerciseId: loggedExerciseId,
        setNo: setNo,
        reps: reps,
        weightKg: weightKg,
        done: true,
      ),
    );
  }

  Future<List<WorkoutExerciseEntity>> getExercisesForPlan(String planId) async {
    final rows = await (_db.select(_db.workoutExercises)
          ..where((t) => t.planId.equals(planId)))
        .get();

    return rows.map((row) {
      return WorkoutExerciseEntity(
        id: row.id,
        planId: row.planId,
        name: row.name,
        sets: row.sets,
        repRange: row.repRange,
        defaultRestSec: row.defaultRestSec,
      );
    }).toList();
  }

  Future<List<WorkoutPlanEntity>> getAllPlans() async {
    final rows = await (_db.select(_db.workoutPlans)).get();

    return rows.map((row) {
      return WorkoutPlanEntity(
        id: row.id,
        name: row.name,
        day: row.day,
        title: row.title,
        durationMin: row.durationMin,
      );
    }).toList();
  }

  Stream<Map<String, dynamic>> watchWeeklyWorkoutStats() {
    final now = DateTime.now();
    final weekStart = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 6));

    return (_db.select(_db.workoutSessions)
          ..where((t) => t.startedAt.isBiggerOrEqualValue(weekStart))
          ..where((t) => t.startedAt.isSmallerThanValue(now.add(const Duration(days: 1))))
          ..orderBy([(t) => OrderingTerm.asc(t.startedAt)]))
        .watch()
        .map((sessions) {
      // Map sessions by day
      final dailyStatus = <DateTime, bool>{};
      for (final session in sessions) {
        final day = DateTime(session.startedAt.year, session.startedAt.month, session.startedAt.day);
        dailyStatus[day] = session.completed;
      }

      int completedCount = sessions.where((s) => s.completed).length;

      return {
        'completedThisWeek': completedCount,
        'totalSessions': sessions.length,
        'dailyStatus': dailyStatus,
      };
    });
  }

  Future<void> clearAllWorkouts() async {
    await delete(_db.workoutLoggedSets).go();
    await delete(_db.workoutLoggedExercises).go();
    await delete(_db.workoutSessions).go();
    await delete(_db.workoutExercises).go();
    await delete(_db.workoutPlans).go();
  }

  // Helper methods for active workout tracking
  Future<List<LoggedExerciseEntity>> getLoggedExercisesForSession(String sessionId) async {
    final rows = await (_db.select(_db.workoutLoggedExercises)
          ..where((t) => t.sessionId.equals(sessionId)))
        .get();
    return rows.map((row) => LoggedExerciseEntity(
      id: row.id,
      sessionId: row.sessionId,
      exerciseId: row.exerciseId,
    )).toList();
  }

  Future<List<LoggedSetEntity>> getSetsForLoggedExercise(String loggedExerciseId) async {
    final rows = await (_db.select(_db.workoutLoggedSets)
          ..where((t) => t.loggedExerciseId.equals(loggedExerciseId)))
        .get();
    return rows.map((row) => LoggedSetEntity(
      id: row.id,
      loggedExerciseId: row.loggedExerciseId,
      setNo: row.setNo,
      reps: row.reps,
      weightKg: row.weightKg,
      done: row.done,
    )).toList();
  }
}
