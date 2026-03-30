import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/workout_repository.dart';
import '../domain/workout_plan.dart';
import '../domain/workout_session.dart';

final workoutPlansProvider = FutureProvider.autoDispose<List<WorkoutPlanEntity>>((ref) async {
  final repo = ref.watch(workoutRepositoryProvider);
  return repo.getAllPlans();
});

final activeWorkoutSessionProvider = StreamProvider.autoDispose<WorkoutSessionEntity?>((ref) {
  final repo = ref.watch(workoutRepositoryProvider);
  return repo.watchTodaySession();
});

final weeklyWorkoutStatsProvider = StreamProvider.autoDispose<Map<String, dynamic>>((ref) {
  final repo = ref.watch(workoutRepositoryProvider);
  return repo.watchWeeklyWorkoutStats();
});

final workoutControllerProvider = Provider<WorkoutController>((ref) {
  return WorkoutController(ref.watch(workoutRepositoryProvider));
});

class WorkoutController {
  final WorkoutRepository _repo;

  WorkoutController(this._repo);

  /// Determine which plan is for today based on weekday (Mon=1 -> day 1, etc.)
  /// Falls back to the first plan if no matching day found
  WorkoutPlanEntity? getTodayPlan(List<WorkoutPlanEntity> plans) {
    if (plans.isEmpty) return null;
    final weekday = DateTime.now().weekday; // 1=Mon, 7=Sun
    // Map Mon-Fri to days 1-5; Sat/Sun cycle back to day 1/2
    final dayNumber = weekday <= 5 ? weekday : ((weekday - 6) % 5) + 1;
    return plans.firstWhere(
      (p) => p.day == dayNumber,
      orElse: () => plans.first,
    );
  }

  Future<WorkoutSessionEntity> startWorkout(String planId) async {
    return await _repo.startWorkoutSession(planId);
  }

  Future<void> logExerciseSet({
    required String sessionId,
    required String exerciseId,
    required int setNo,
    required int reps,
    double? weightKg,
  }) async {
    await _repo.logExerciseSet(
      sessionId: sessionId,
      exerciseId: exerciseId,
      setNo: setNo,
      reps: reps,
      weightKg: weightKg,
    );
  }

  Future<void> completeWorkout(String sessionId) async {
    await _repo.completeWorkout(sessionId);
  }

  Future<List<WorkoutExerciseEntity>> getExercisesForPlan(String planId) async {
    return await _repo.getExercisesForPlan(planId);
  }
}
