import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../profile/application/profile_controller.dart';
import '../../../core/domain/user_profile.dart';
import '../domain/onboarding_state.dart';

final onboardingControllerProvider = NotifierProvider<OnboardingController, OnboardingState>(() {
  return OnboardingController();
});

class OnboardingController extends Notifier<OnboardingState> {
  @override
  OnboardingState build() {
    return const OnboardingState();
  }

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void updateGoal(String goal) {
    state = state.copyWith(goal: goal);
  }

  void updateBudgetMode(String mode) {
    state = state.copyWith(budgetMode: mode);
  }

  void updateWorkoutMode(String mode) {
    state = state.copyWith(workoutMode: mode);
  }

  void togglePreference(String food) {
    final prefs = List<String>.from(state.preferences);
    if (prefs.contains(food)) {
      prefs.remove(food);
    } else {
      prefs.add(food);
    }
    state = state.copyWith(preferences: prefs);
  }

  Future<void> completeOnboarding() async {
    // Generate the final UserProfile
    final profile = UserProfile(
      id: const Uuid().v4(),
      name: state.name.isEmpty ? 'User' : state.name,
      goal: state.goal.isEmpty ? 'lean_bulk' : state.goal,
      budgetMode: state.budgetMode.isEmpty ? 'flexible' : state.budgetMode,
      workoutMode: state.workoutMode.isEmpty ? 'home' : state.workoutMode,
      waterGoalMl: 2500, // 10 glasses * 250ml
      dailyCalorieGoal: 2500, // standard start
      dailyProteinGoalG: 120, // standard start
      foodPreferences: state.preferences,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Save to SharedPreferences via ProfileController
    await ref.read(profileControllerProvider.notifier).saveProfile(profile);
  }
}
