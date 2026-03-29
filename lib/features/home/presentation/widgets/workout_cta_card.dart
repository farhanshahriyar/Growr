import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';

class WorkoutCtaCard extends StatelessWidget {
  final String activeDay;
  final bool isCompleted;

  const WorkoutCtaCard({
    super.key,
    required this.activeDay,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go('/workout');
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24.0),
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: isCompleted ? AppColors.surfaceContainerLow : AppColors.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isCompleted ? 'Workout Done' : 'Today\'s Workout',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: isCompleted ? AppColors.inverseSurface.withOpacity(0.6) : AppColors.onPrimary.withOpacity(0.8),
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  activeDay,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isCompleted ? AppColors.inverseSurface : AppColors.onPrimary,
                      ),
                ),
              ],
            ),
            Icon(
              isCompleted ? Icons.check_circle : Icons.play_arrow_rounded,
              color: isCompleted ? AppColors.primary : AppColors.onPrimary,
              size: 32,
            ),
          ],
        ),
      ),
    );
  }
}
