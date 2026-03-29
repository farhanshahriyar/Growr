import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../app/theme/app_colors.dart';
import '../application/onboarding_controller.dart';

class BudgetModeStep extends ConsumerWidget {
  final VoidCallback onNext;

  const BudgetModeStep({super.key, required this.onNext});

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
            'How is your food budget?',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          Text(
            'This influences the default food suggestions.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.inverseSurface.withOpacity(0.6),
                ),
          ),
          const SizedBox(height: 48),
          _OptionCard(
            title: 'Affordable / Student',
            subtitle: 'Prioritize eggs, dal, chola, and simple home food.',
            isSelected: state.budgetMode == 'low',
            onTap: () => notifier.updateBudgetMode('low'),
          ),
          const SizedBox(height: 16),
          _OptionCard(
            title: 'Medium',
            subtitle: 'A mix of home food with occasional chicken/fish/milk.',
            isSelected: state.budgetMode == 'medium',
            onTap: () => notifier.updateBudgetMode('medium'),
          ),
          const SizedBox(height: 16),
          _OptionCard(
            title: 'Flexible',
            subtitle: 'Budget is not an issue.',
            isSelected: state.budgetMode == 'flexible',
            onTap: () => notifier.updateBudgetMode('flexible'),
          ),
          const Spacer(),
          PrimaryButton(
            text: 'Continue',
            onPressed: state.isBudgetReady ? onNext : () {},
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionCard({
    required this.title,
    required this.subtitle,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isSelected ? AppColors.primary : AppColors.inverseSurface,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.inverseSurface.withOpacity(0.6),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
