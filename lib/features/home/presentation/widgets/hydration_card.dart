import 'package:flutter/material.dart';
import '../../../shared/widgets/progress_ring.dart';
import '../../../app/theme/app_colors.dart';

class HydrationCard extends StatelessWidget {
  final int loggedMl;
  final int goalMl;

  const HydrationCard({
    super.key,
    required this.loggedMl,
    required this.goalMl,
  });

  @override
  Widget build(BuildContext context) {
    // Math rules: 1 glass = 250ml
    final glassesLogged = (loggedMl ~/ 250);
    final glassesGoal = (goalMl ~/ 250);
    final progress = goalMl > 0 ? (loggedMl / goalMl).clamp(0.0, 1.0) : 0.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ProgressRing(
            progress: progress,
            size: 80,
            strokeWidth: 8,
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hydration',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.inverseSurface.withOpacity(0.6),
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$glassesLogged / $glassesGoal glasses',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${(loggedMl / 1000).toStringAsFixed(1)}L / ${(goalMl / 1000).toStringAsFixed(1)}L total',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.inverseSurface.withOpacity(0.6),
                      ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // Placeholder for Phase 4 interactions
            },
            icon: const Icon(Icons.add_circle),
            iconSize: 32,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
