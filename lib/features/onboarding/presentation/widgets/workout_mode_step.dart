import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/onboarding_controller.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/secondary_button.dart';
import '../../../../app/theme/app_colors.dart';

class WorkoutModeStep extends ConsumerWidget {
  const WorkoutModeStep({super.key});

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
            'Training Setup',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Text(
            'Do you train at home or have gym access?',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.inverseSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 48),
          
          _WorkoutCard(
            title: 'Home Bodyweight',
            subtitle: 'Pushups, Pullups, Backpack squats',
            isSelected: state.workoutMode == 'home',
            onTap: () => controller.updateWorkoutMode('home'),
          ),
          const SizedBox(height: 16),
          _WorkoutCard(
            title: 'Gym Access',
            subtitle: 'Dumbbells, Barbells, Machines',
            isSelected: state.workoutMode == 'gym',
            onTap: () => controller.updateWorkoutMode('gym'),
          ),

          const Spacer(),
          PrimaryButton(
            label: state.isSubmitting ? 'Finishing...' : 'Complete Profile',
            isLoading: state.isSubmitting,
            onPressed: () {
              controller.submit();
              // Note: Router redirect will trap and override this context once DB updates
            },
          ),
          const SizedBox(height: 16),
          if (!state.isSubmitting)
            SecondaryButton(
              label: 'Back',
              onPressed: controller.previousStep,
            ),
        ],
      ),
    );
  }
}

class _WorkoutCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _WorkoutCard({
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
          color: isSelected ? AppColors.primaryContainer : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isSelected ? AppColors.onPrimary : AppColors.inverseSurface,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isSelected 
                        ? AppColors.onPrimary.withOpacity(0.8) 
                        : AppColors.inverseSurface.withOpacity(0.6),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
