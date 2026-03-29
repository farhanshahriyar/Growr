import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../local/db/app_database.dart';

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

    return query.watchSingleOrNull();
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
    final exercises = await (_db.select(_db.workoutExercises)
          ..where((t) => t.planId.equals(planId)))
        .get();

    return exercises;
  }

  Future<List<WorkoutPlanEntity>> getAllPlans() async {
    return await (_db.select(_db.workoutPlans)).get();
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
}
