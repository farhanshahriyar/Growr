import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../domain/onboarding_state.dart';
import '../../profile/application/profile_controller.dart';
import '../../profile/domain/user_profile.dart';

final onboardingControllerProvider = NotifierProvider<OnboardingController, OnboardingState>(() {
  return OnboardingController();
});

class OnboardingController extends Notifier<OnboardingState> {
  final PageController pageController = PageController();

  @override
  OnboardingState build() {
    return const OnboardingState();
  }

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void updateGoal(String goal) {
    state = state.copyWith(primaryGoal: goal);
  }

  void updateBudgetMode(String mode) {
    state = state.copyWith(budgetMode: mode);
  }

  void updateWorkoutMode(String mode) {
    state = state.copyWith(workoutMode: mode);
  }

  void nextStep() {
    if (state.currentStep < 3) {
      state = state.copyWith(currentStep: state.currentStep + 1);
      pageController.animateToPage(
        state.currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
      pageController.animateToPage(
        state.currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> submit() async {
    state = state.copyWith(isSubmitting: true);
    try {
      // Basic math defaults for MVP bulk
      int calorieGoal;
      int proteinGoal;

      if (state.primaryGoal == 'lean_bulk') {
        calorieGoal = 2800; // Benchmark target for avg build
        proteinGoal = 140; // Approx 1.6g per kg rule of thumb
      } else { // 'maintain' MVP fallback
        calorieGoal = 2400;
        proteinGoal = 120;
      }

      final profile = UserProfile(
        id: const Uuid().v4(),
        name: state.name.trim().isEmpty ? 'Builder' : state.name.trim(),
        primaryGoal: state.primaryGoal,
        budgetMode: state.budgetMode,
        workoutMode: state.workoutMode,
        dailyCalorieGoal: calorieGoal,
        dailyProteinGoalG: proteinGoal,
        waterGoalMl: 3000, // Fixed 3L = ~12 glasses MVP rule
        createdAt: DateTime.now(),
      );

      // Save to SharedPreferences -> triggers Router redirect guard implicitly
      await ref.read(profileControllerProvider.notifier).saveProfile(profile);
    } finally {
      // Keep submitting state active briefly to avoid UI jitter before router pops
      state = state.copyWith(isSubmitting: false);
    }
  }
}
