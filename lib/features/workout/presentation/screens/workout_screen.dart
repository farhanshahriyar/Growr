import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/workout_controller.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../app/theme/app_colors.dart';

class WorkoutScreen extends ConsumerStatefulWidget {
  const WorkoutScreen({super.key});

  @override
  ConsumerState<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends Consumer<ConsumerStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    final plansAsync = ref.watch(workoutPlansProvider);
    final sessionAsync = ref.watch(activeWorkoutSessionProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Workout'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: sessionAsync.when(
        data: (session) {
          if (session != null) {
            return _ActiveWorkoutView(sessionId: session.id, planId: session.planId);
          } else {
            return plansAsync.when(
              data: (plans) {
                if (plans.isEmpty) {
                  return const EmptyState(
                    icon: Icons.fitness_center,
                    title: 'No workout plans available',
                    message: 'Check back later for workout routines',
                  );
                }
                final controller = ref.read(workoutControllerProvider);
                final todayPlan = controller.getTodayPlan(plans);
                if (todayPlan == null) {
                  return const EmptyState(
                    icon: Icons.error,
                    title: 'No plan for today',
                    message: 'Select a different day\'s workout',
                  );
                }
                return _PlanSelectionView(plan: todayPlan);
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Text('Error: $err'),
              ),
            );
          }
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('Error: $err'),
        ),
      ),
    );
  }
}

class _PlanSelectionView extends ConsumerWidget {
  final WorkoutPlanEntity plan;

  const _PlanSelectionView({
    required this.plan,
  });

  Future<void> _startWorkout(BuildContext context, String planId) async {
    final controller = ref.read(workoutControllerProvider);
    await controller.startWorkout(planId);
    // Force refresh to show active workout
    ref.refresh(activeWorkoutSessionProvider);
  }

  @override
  Widget build(BuildContext context) {
    final exercisesAsync = ref.watch(_planExercisesProvider(plan.id));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plan.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  plan.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.inverseSurface.withOpacity(0.7),
                      ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.schedule, size: 18, color: AppColors.inverseSurface),
                    const SizedBox(width: 6),
                    Text(
                      '${plan.durationMin} min',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.inverseSurface,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Exercises',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.inverseSurface,
            ),
          ),
          const SizedBox(height: 16),
          exercisesAsync.when(
            data: (exercises) {
              if (exercises.isEmpty) {
                return const Text(
                  'No exercises in this plan',
                  style: TextStyle(color: AppColors.inverseSurface),
                );
              }
              return Column(
                children: exercises.map((ex) => _ExerciseCard(
                      exercise: ex,
                    )).toList(),
              );
            },
            loading: () => const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, stack) => Text('Error: $err'),
          ),
          const SizedBox(height: 32),
          PrimaryButton(
            label: 'Start Workout',
            onPressed: () => _startWorkout(context, plan.id),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  final WorkoutExerciseEntity exercise;

  const _ExerciseCard({
    required this.exercise,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.name,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.inverseSurface,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${exercise.sets} sets × ${exercise.repRange}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.inverseSurface.withOpacity(0.7),
                      ),
                ),
              ],
            ),
          ),
          if (exercise.defaultRestSec != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.timer, size: 14, color: AppColors.inverseSurface),
                  const SizedBox(width: 4),
                  Text(
                    '${exercise.defaultRestSec}s',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.inverseSurface,
                        ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ActiveWorkoutView extends ConsumerStatefulWidget {
  final String sessionId;
  final String planId;

  const _ActiveWorkoutView({
    required this.sessionId,
    required this.planId,
  });

  @override
  ConsumerState<_ActiveWorkoutView> createState() => _ActiveWorkoutViewState();
}

class _ActiveWorkoutViewState extends ConsumerState<_ActiveWorkoutView> {
  late Future<List<WorkoutExerciseEntity>> _exercisesFuture;
  final Map<String, int> _completedSetsCount = {};

  @override
  void initState() {
    super.initState();
    _exercisesFuture = ref.read(workoutControllerProvider).getExercisesForPlan(widget.planId);
    _loadCompletedSets();
  }

  Future<void> _loadCompletedSets() async {
    final repo = ref.read(workoutRepositoryProvider);
    // Get all logged sets for this session via logged exercises
    final loggedExercises = await repo.getLoggedExercisesForSession(widget.sessionId);
    final Map<String, int> counts = {};
    for (final ex in loggedExercises) {
      final sets = await repo.getSetsForLoggedExercise(ex.id);
      counts[ex.exerciseId] = sets.length;
    }
    if (mounted) {
      setState(() {
        _completedSetsCount.clear();
        _completedSetsCount.addAll(counts);
      });
    }
  }

  Future<void> _logSet(String exerciseId, int setNo, {double? weight}) async {
    final controller = ref.read(workoutControllerProvider);
    await controller.logExerciseSet(
      sessionId: widget.sessionId,
      exerciseId: exerciseId,
      setNo: setNo,
      reps: 0, // Default reps; MVP doesn't require input for now
      weightKg: weight,
    );
    await _loadCompletedSets();
  }

  Future<void> _completeWorkout() async {
    final controller = ref.read(workoutControllerProvider);
    await controller.completeWorkout(widget.sessionId);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Workout completed!'),
          backgroundColor: AppColors.primary,
        ),
      );
      ref.refresh(activeWorkoutSessionProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final exercisesAsync = FutureBuilder<List<WorkoutExerciseEntity>>(
      future: _exercisesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final exercises = snapshot.data ?? [];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.fiber_manual_record, color: AppColors.secondary, size: 16),
                    SizedBox(width: 8),
                    Text(
                      'Workout in progress',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ...exercises.map((ex) {
                final completed = _completedSetsCount[ex.id] ?? 0;
                final total = ex.sets;
                return _ActiveExerciseCard(
                  exercise: ex,
                  completedSets: completed,
                  totalSets: total,
                  onLogSet: () => _logSet(ex.id, completed + 1),
                );
              }),
              const SizedBox(height: 32),
              PrimaryButton(
                label: 'Complete Workout',
                onPressed: _completeWorkout,
              ),
              const SizedBox(height: 80),
            ],
          ),
        );
      },
    );
    return exercisesAsync;
  }
}

class _ActiveExerciseCard extends StatelessWidget {
  final WorkoutExerciseEntity exercise;
  final int completedSets;
  final int totalSets;
  final VoidCallback onLogSet;

  const _ActiveExerciseCard({
    required this.exercise,
    required this.completedSets,
    required this.totalSets,
    required this.onLogSet,
  });

  @override
  Widget build(BuildContext context) {
    final isComplete = completedSets >= totalSets;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  exercise.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.inverseSurface,
                      ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isComplete
                      ? AppColors.primary.withOpacity(0.1)
                      : AppColors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '$completedSets / $totalSets',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: isComplete ? AppColors.primary : AppColors.inverseSurface,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (!isComplete)
            PrimaryButton(
              label: 'Log Set ${completedSets + 1}',
              onPressed: onLogSet,
            )
          else
            const Row(
              children: [
                Icon(Icons.check_circle, color: AppColors.primary, size: 20),
                SizedBox(width: 8),
                Text(
                  'All sets completed',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

// Provider for exercises of a specific plan
final _planExercisesProvider = FutureProvider.family<List<WorkoutExerciseEntity>, String>((ref, planId) async {
  final controller = ref.watch(workoutControllerProvider);
  return controller.getExercisesForPlan(planId);
});
