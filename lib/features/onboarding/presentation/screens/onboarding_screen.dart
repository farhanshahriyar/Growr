import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/onboarding_controller.dart';
import 'widgets/welcome_step.dart';
import 'widgets/goal_step.dart';
import 'widgets/budget_mode_step.dart';
import 'widgets/workout_mode_step.dart';
import '../../../app/theme/app_colors.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(onboardingControllerProvider.notifier);
    final state = ref.watch(onboardingControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Simple Progress Indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                children: List.generate(4, (index) {
                  return Expanded(
                    child: Container(
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      decoration: BoxDecoration(
                        color: index <= state.currentStep
                            ? AppColors.primary
                            : AppColors.inverseSurface.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Expanded(
              child: PageView(
                controller: controller.pageController,
                physics: const NeverScrollableScrollPhysics(), // Force button nav
                children: const [
                  WelcomeStep(),
                  GoalStep(),
                  BudgetModeStep(),
                  WorkoutModeStep(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
