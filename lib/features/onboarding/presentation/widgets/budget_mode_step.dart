import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/onboarding_controller.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/secondary_button.dart';
import '../../../../app/theme/app_colors.dart';

class BudgetModeStep extends ConsumerWidget {
  const BudgetModeStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          Text(
            'Budget Mode',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Text(
            'Growth isn\'t just for the affluent. We cater advice based on your wallet.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.inverseSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 48),
          
          _BudgetCard(
            title: 'Strictly Affordable',
            subtitle: 'Focus on Dal, Egg, Soy, Rice',
            isSelected: state.budgetMode == 'low',
            onTap: () => controller.updateBudgetMode('low'),
          ),
          const SizedBox(height: 16),
          _BudgetCard(
            title: 'Balanced',
            subtitle: 'Regular Chicken, Fish, Milk mixed in',
            isSelected: state.budgetMode == 'medium',
            onTap: () => controller.updateBudgetMode('medium'),
          ),

          const Spacer(),
          PrimaryButton(
            label: 'Next',
            onPressed: controller.nextStep,
          ),
          const SizedBox(height: 16),
          SecondaryButton(
            label: 'Back',
            onPressed: controller.previousStep,
          ),
        ],
      ),
    );
  }
}

class _BudgetCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _BudgetCard({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.tertiaryFixed : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
        ),
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
                    color: isSelected 
                        ? AppColors.primary.withOpacity(0.8) 
                        : AppColors.inverseSurface.withOpacity(0.6),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
