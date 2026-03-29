import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../app/theme/app_colors.dart';
import '../application/onboarding_controller.dart';

class GoalStep extends ConsumerWidget {
  final VoidCallback onNext;

  const GoalStep({super.key, required this.onNext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);
    final notifier = ref.read(onboardingControllerProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 48),
          Text(
            'What is your primary goal?',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 48),
          _GoalCard(
            title: 'Lean Bulk',
            subtitle: 'Build muscle steadily with a small caloric surplus.',
            icon: Icons.fitness_center,
            isSelected: state.goal == 'lean_bulk',
            onTap: () => notifier.updateGoal('lean_bulk'),
          ),
          const SizedBox(height: 16),
          _GoalCard(
            title: 'Maintain',
            subtitle: 'Keep your current physique and improve strength.',
            icon: Icons.monitor_weight_outlined,
            isSelected: state.goal == 'maintain',
            onTap: () => notifier.updateGoal('maintain'),
          ),
          const SizedBox(height: 16),
          _GoalCard(
            title: 'Fat Loss',
            subtitle: 'Lose fat while preserving muscle mass.',
            icon: Icons.trending_down,
            isSelected: state.goal == 'fat_loss',
            onTap: () => notifier.updateGoal('fat_loss'),
          ),
          const Spacer(),
          PrimaryButton(
            text: 'Continue',
            onPressed: state.isGoalReady ? onNext : () {},
            // Disable appearance logic can be handled via styling or state
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _GoalCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: isSelected ? Border.all(color: AppColors.primary, width: 2) : Border.all(color: Colors.transparent, width: 2),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppColors.primary : AppColors.inverseSurface.withOpacity(0.5), size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: isSelected ? AppColors.primary : AppColors.inverseSurface,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.inverseSurface.withOpacity(0.6),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
