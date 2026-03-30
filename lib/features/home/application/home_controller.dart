import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../profile/application/profile_controller.dart';
import '../../profile/domain/user_profile.dart';
import '../domain/home_summary_state.dart';
import '../../meals/application/meals_controller.dart';
import '../../hydration/application/hydration_controller.dart';
import '../../workout/application/workout_controller.dart';
import '../../data/repositories/workout_repository.dart';

final homeControllerProvider = Provider<HomeSummaryState>((ref) {
  // Profile is required
  final profileAsync = ref.watch(profileProvider);
  final profile = profileAsync.value;
  if (profile == null) {
    throw StateError('Cannot build home dashboard without an active profile.');
  }

  // Meals totals
  final mealsSummary = ref.watch(todayMealsTotalsProvider);
  final caloriesConsumed = mealsSummary.totalCalories;
  final proteinConsumedG = mealsSummary.totalProtein;

  // Hydration
  final waterMl = ref.watch(todayHydrationMlProvider).value ?? 0;

  // Workout status
  final sessionAsync = ref.watch(activeWorkoutSessionProvider);
  final session = sessionAsync.value;
  final workoutCompletedToday = session?.completed ?? false;

  // Determine active workout day name based on weekday
  final now = DateTime.now();
  final weekday = now.weekday; // 1=Mon, 7=Sun
  // Map to 5-day split: Mon(1)->1, Tue(2)->2, Wed(3)->3, Thu(4)->4, Fri(5)->5, Sat(6)->1, Sun(7)->2
  final dayNumber = weekday <= 5 ? weekday : ((weekday - 6) % 5) + 1;
  final dayNames = {
    1: 'Day 1: Upper Body Push',
    2: 'Day 2: Upper Body Pull',
    3: 'Day 3: Lower Body',
    4: 'Day 4: Shoulders',
    5: 'Day 5: Full Body',
  };
  final activeWorkoutDay = dayNames[dayNumber] ?? 'Workout';

  // Tip based on budget mode
  final tip = _getBudgetTip(profile.budgetMode);

  return HomeSummaryState(
    caloriesConsumed: caloriesConsumed,
    calorieGoal: profile.dailyCalorieGoal,
    proteinConsumedG: proteinConsumedG,
    proteinGoalG: profile.dailyProteinGoalG,
    waterLoggedMl: waterMl,
    waterGoalMl: profile.waterGoalMl,
    activeWorkoutDay: activeWorkoutDay,
    workoutCompletedToday: workoutCompletedToday,
    tipOfTheDay: tip,
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
