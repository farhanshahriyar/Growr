import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../profile/application/profile_controller.dart';
import '../domain/home_summary_state.dart';

final homeControllerProvider = Provider<HomeSummaryState>((ref) {
  final profile = ref.watch(profileControllerProvider);

  if (profile == null) {
    throw StateError('Cannot build home dashboard without an active profile.');
  }

  // Placeholder static data until Phase 4 (Meals) and 5 (Workout) connects the active Streams.
  return HomeSummaryState(
    caloriesConsumed: 0,
    calorieGoal: profile.dailyCalorieGoal,
    proteinConsumedG: 0,
    proteinGoalG: profile.dailyProteinGoalG,
    waterLoggedMl: 0, 
    waterGoalMl: profile.waterGoalMl,
    activeWorkoutDay: 'Day 1: Upper Body',
    workoutCompletedToday: false,
    tipOfTheDay: _getBudgetTip(profile.budgetMode),
  );
});

String _getBudgetTip(String mode) {
  if (mode == 'low') {
    return 'Tip: 2 whole eggs and 1 cup of masoor dal gives you ~20g of high-quality protein for cheap.';
  } else if (mode == 'medium') {
    return 'Tip: Pair an everyday meal with 100g chicken breast to easily spike your protein goal.';
  } else {
    return 'Tip: Consistency is more important than expensive variations. Stick to your basics.';
  }
}
