import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/repositories/meals_repository.dart';
import '../domain/meal_log_entry.dart';
import '../domain/food_item.dart';

// Provider exposing today's exact logs
final todayMealsLogsProvider = StreamProvider.autoDispose<List<MealLogEntry>>((ref) {
  final repo = ref.watch(mealsRepositoryProvider);
  return repo.watchLogsForDate(DateTime.now());
});

// A derived provider keeping track of total macros for the day
final todayMealsTotalsProvider = Provider.autoDispose<MealsDailySummary>((ref) {
  final logsAsync = ref.watch(todayMealsLogsProvider);
  
  return logsAsync.maybeWhen(
    data: (logs) {
      if (logs.isEmpty) return const MealsDailySummary(totalCalories: 0, totalProtein: 0);
      
      final calories = logs.fold<int>(0, (sum, item) => sum + item.calories);
      final protein = logs.fold<int>(0, (sum, item) => sum + item.proteinG);
      return MealsDailySummary(totalCalories: calories, totalProtein: protein);
    },
    orElse: () => const MealsDailySummary(totalCalories: 0, totalProtein: 0),
  );
});

class MealsDailySummary {
  final int totalCalories;
  final int totalProtein;

  const MealsDailySummary({
    required this.totalCalories,
    required this.totalProtein,
  });
}

// Controller specifically handling Quick Adds and Search
final mealsControllerProvider = Provider<MealsController>((ref) {
  return MealsController(ref.watch(mealsRepositoryProvider));
});

class MealsController {
  final MealsRepository _repo;

  MealsController(this._repo);

  Future<List<FoodItem>> getQuickAddFoods() {
    return _repo.getQuickAddFoods();
  }

  Future<List<FoodItem>> searchFoods(String query) {
    if (query.isEmpty) return Future.value([]);
    return _repo.searchFoods(query);
  }

  Future<void> logFood(FoodItem food, String mealType, double quantityMultiplier) async {
    final entry = MealLogEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // fast unique ID
      mealType: mealType,
      foodItemId: food.id,
      quantity: quantityMultiplier,
      calories: (food.calories * quantityMultiplier).round(),
      proteinG: (food.proteinG * quantityMultiplier).round(),
      loggedAt: DateTime.now(),
    );
    await _repo.logMeal(entry);
  }
}
