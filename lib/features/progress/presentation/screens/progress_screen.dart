import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/progress_controller.dart';
import '../domain/weight_log.dart';
import '../domain/progress_photo.dart';
import '../../workout/application/workout_controller.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../app/theme/app_colors.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(weeklySummaryProvider);
    final weightAsync = ref.watch(weightHistoryProvider);
    final photosAsync = ref.watch(progressPhotosProvider);
    final workoutStatsAsync = ref.watch(weeklyWorkoutStatsProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Progress'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Weekly Summary Card
            _WeeklySummaryCard(
              summaryAsync: summaryAsync,
              workoutStatsAsync: workoutStatsAsync,
            ),
            const SizedBox(height: 24),

            // Weight Tracking
            const Text(
              'Weight',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.inverseSurface,
              ),
            ),
            const SizedBox(height: 12),
            weightAsync.when(
              data: (history) {
                if (history.isEmpty) {
                  return const _EmptyWeightLog();
                }
                final latest = history.first;
                final previous = history.length > 1 ? history[1] : null;
                final change = previous != null ? latest.weightKg - previous.weightKg : null;

                return Column(
                  children: [
                    _WeightCard(weight: latest, change: change),
                    const SizedBox(height: 12),
                    // Recent weight list
                    ...history.take(5).map((entry) => _WeightEntryTile(entry: entry)),
                  ],
                );
              },
              loading: () => const SizedBox(
                height: 150,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, stack) => Text('Error: $err'),
            ),
            const SizedBox(height: 24),

            // Progress Photos
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Progress Photos',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.inverseSurface,
                  ),
                ),
                // TODO: Add photo upload button
              ],
            ),
            const SizedBox(height: 12),
            photosAsync.when(
              data: (photos) {
                if (photos.isEmpty) {
                  return const _EmptyPhotosPlaceholder();
                }
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: photos.length,
                  itemBuilder: (context, index) {
                    final photo = photos[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.photo, color: AppColors.inverseSurface.withOpacity(0.4)),
                            const SizedBox(height: 8),
                            Text(
                              photo.type,
                              style: TextStyle(
                                color: AppColors.inverseSurface.withOpacity(0.6),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const SizedBox(
                height: 150,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, stack) => Text('Error: $err'),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

class _WeeklySummaryCard extends StatelessWidget {
  final AsyncValue<Map<String, dynamic>> summaryAsync;
  final AsyncValue<Map<String, dynamic>> workoutStatsAsync;

  const _WeeklySummaryCard({
    required this.summaryAsync,
    required this.workoutStatsAsync,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'This Week',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.inverseSurface,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(
                label: 'Avg Calories',
                value: summaryAsync.value?['avgCalories']?.toString() ?? '-',
                unit: 'kcal',
              ),
              _StatItem(
                label: 'Avg Protein',
                value: summaryAsync.value?['avgProtein']?.toString() ?? '-',
                unit: 'g',
              ),
              _StatItem(
                label: 'Workouts',
                value: workoutStatsAsync.value?['completedThisWeek']?.toString() ?? '0',
                unit: 'done',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final String unit;

  const _StatItem({
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.inverseSurface.withOpacity(0.6),
              ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
        ),
        Text(
          unit,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.inverseSurface.withOpacity(0.6),
              ),
        ),
      ],
    );
  }
}

class _WeightCard extends StatelessWidget {
  final WeightLogEntity weight;
  final double? change;

  const _WeightCard({
    required this.weight,
    this.change,
  });

  @override
  Widget build(BuildContext context) {
    final formatted = weight.weightKg.toStringAsFixed(1);
    final changeText = change != null
        ? '${change >= 0 ? '+' : ''}${change!.toStringAsFixed(1)} kg'
        : 'No previous';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Current Weight',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.inverseSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$formatted kg',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.inverseSurface,
                    ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: change != null && change! < 0
                  ? AppColors.primary.withOpacity(0.1)
                  : change != null && change! > 0
                      ? AppColors.secondary.withOpacity(0.1)
                      : AppColors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              changeText,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: change != null && change! < 0
                    ? AppColors.primary
                    : change != null && change! > 0
                        ? AppColors.secondary
                        : AppColors.inverseSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeightEntryTile extends StatelessWidget {
  final WeightLogEntity entry;

  const _WeightEntryTile({required this.entry});

  @override
  Widget build(BuildContext context) {
    final date = '${entry.loggedAt.day}/${entry.loggedAt.month}/${entry.loggedAt.year}';
    final weight = entry.weightKg.toStringAsFixed(1);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            date,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.inverseSurface.withOpacity(0.7),
                ),
          ),
          Text(
            '$weight kg',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.inverseSurface,
                ),
          ),
        ],
      ),
    );
  }
}

class _EmptyWeightLog extends StatelessWidget {
  const _EmptyWeightLog();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const EmptyState(
        icon: Icons.scale,
        title: 'No weight entries yet',
        message: 'Log your weight to track progress',
      ),
    );
  }
}

class _EmptyPhotosPlaceholder extends StatelessWidget {
  const _EmptyPhotosPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: EmptyState(
          icon: Icons.camera_alt,
          title: 'No progress photos',
          message: 'Take photos to visualize your journey',
        ),
      ),
    );
  }
}
