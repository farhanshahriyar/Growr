import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../app/theme/app_colors.dart';
import '../application/onboarding_controller.dart';

class WorkoutModeStep extends ConsumerWidget {
  final VoidCallback onNext;

  const WorkoutModeStep({super.key, required this.onNext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);
    final notifier = ref.read(onboardingControllerProvider.notifier);
    final isSaving = ref.watch(_isSavingProvider);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 48),
          Text(
            'Where will you workout?',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          Text(
            'Growr focuses on a 5-day split.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.inverseSurface.withOpacity(0.6),
                ),
          ),
          const SizedBox(height: 48),
          _OptionCard(
            title: 'At Home',
            subtitle: 'Bodyweight + Dumbbells focused.',
            icon: Icons.home,
            isSelected: state.workoutMode == 'home',
            onTap: () => notifier.updateWorkoutMode('home'),
          ),
          const SizedBox(height: 16),
          _OptionCard(
            title: 'At the Gym',
            subtitle: 'Full equipment access.',
            icon: Icons.fitness_center,
            isSelected: state.workoutMode == 'gym',
            onTap: () => notifier.updateWorkoutMode('gym'),
          ),
          const Spacer(),
          PrimaryButton(
            text: 'Finish Setup',
            isLoading: isSaving,
            onPressed: state.isWorkoutReady
                ? () async {
                    ref.read(_isSavingProvider.notifier).state = true;
                    await notifier.completeOnboarding();
                    ref.read(_isSavingProvider.notifier).state = false;
                    onNext();
                  }
                : () {},
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

final _isSavingProvider = StateProvider.autoDispose<bool>((ref) => false);

class _OptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionCard({
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
          ],
        ),
      ),
    );
  }
}
