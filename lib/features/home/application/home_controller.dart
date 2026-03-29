import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../profile/application/profile_controller.dart';
import '../domain/home_summary_state.dart';

final homeControllerProvider = Provider<HomeSummaryState>((ref) {
  final profile = ref.watch(profileControllerProvider);

  if (profile == null) {
    // Should theoretically never hit this if router protects it.
    throw StateError('Cannot build home dashboard without an active profile.');
  }

  // TODO: In Phase 4/5/6, these values will be watched from actual databases:
  // final calories = ref.watch(todayMealsProvider).totalCalories;
  // final protein = ref.watch(todayMealsProvider).totalProtein;
  // final water = ref.watch(todayHydrationProvider).totalMl;
  // final workout = ref.watch(todayWorkoutProvider);

  return HomeSummaryState(
    caloriesConsumed: 0,
    calorieGoal: profile.dailyCalorieGoal,
    proteinConsumedG: 0,
    proteinGoalG: profile.dailyProteinGoalG,
    waterLoggedMl: 0, // Placeholder
    waterGoalMl: profile.waterGoalMl,
    activeWorkoutDay: 'Day 1: Upper Body (Mock)',
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
