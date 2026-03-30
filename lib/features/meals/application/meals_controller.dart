import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/meals/domain/meal_log_entry.dart';
import '../../features/meals/domain/food_item.dart';
import '../local/db/app_database.dart';

final mealsRepositoryProvider = Provider<MealsRepository>((ref) {
  return MealsRepository(ref.watch(databaseProvider));
});

// Stream provider for today's meal logs
final todayMealsProvider = StreamProvider.autoDispose<List<MealLogEntry>>((ref) {
  final repo = ref.watch(mealsRepositoryProvider);
  return repo.watchLogsForDate(DateTime.now());
});

// Provider for daily totals (calories, protein)
final todayMealsTotalsProvider = Provider.autoDispose<MealsDailySummary>((ref) {
  final logsAsync = ref.watch(todayMealsProvider);

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
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      mealType: mealType,
      foodItemId: food.id,
      quantity: quantityMultiplier,
      calories: (food.calories * quantityMultiplier).round(),
      proteinG: (food.proteinG * quantityMultiplier).round(),
      loggedAt: DateTime.now(),
      note: food.name, // Store food name for quick display
    );
    await _repo.logMeal(entry);
  }

  Future<void> deleteMeal(String id) async {
    await _repo.deleteMeal(id);
  }
}

final mealsControllerProvider = Provider<MealsController>((ref) {
  return MealsController(ref.watch(mealsRepositoryProvider));
});

final quickAddFoodsProvider = FutureProvider.autoDispose<List<FoodItem>>((ref) {
  final repo = ref.watch(mealsRepositoryProvider);
  return repo.getQuickAddFoods();
});

