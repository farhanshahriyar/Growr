import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/meals/domain/meal_log_entry.dart';
import '../../features/meals/domain/food_item.dart';
import '../local/db/app_database.dart';

final mealsRepositoryProvider = Provider<MealsRepository>((ref) {
  return MealsRepository(ref.watch(databaseProvider));
});

class MealsRepository {
  final AppDatabase _db;

  MealsRepository(this._db);

  Future<List<FoodItem>> searchFoods(String query) async {
    final queryLower = '%${query.toLowerCase()}%';

    final foods = await (_db.select(_db.foods)
          ..where((f) => f.name.like(queryLower) | f.category.like(queryLower)))
        .get();

    return foods
        .map((f) => FoodItem(
              id: f.id,
              name: f.name,
              category: f.category,
              portionLabel: f.portionLabel,
              calories: f.calories,
              proteinG: f.proteinG,
              affordable: f.affordable,
              localPriority: f.localPriority,
            ))
        .toList();
  }

  Future<List<FoodItem>> getQuickAddFoods() async {
    final query = _db.select(_db.foods)
      ..where((t) => t.localPriority.equals(true))
      ..limit(10);

    final results = await query.get();
    return results.map((f) => FoodItem(
          id: f.id,
          name: f.name,
          category: f.category,
          portionLabel: f.portionLabel,
          calories: f.calories,
          proteinG: f.proteinG,
          affordable: f.affordable,
          localPriority: f.localPriority,
        )).toList();
  }

  Future<void> logMeal(MealLogEntry entry) async {
    await into(_db.mealLogs).insert(
      MealLogsCompanion.insert(
        id: entry.id,
        mealType: entry.mealType,
        foodItemId: entry.foodItemId,
        quantity: entry.quantity,
        calories: entry.calories,
        proteinG: entry.proteinG,
        loggedAt: entry.loggedAt,
      ),
    );
  }

  Future<void> deleteMeal(String id) async {
    await (_db.delete(_db.mealLogs)..where((t) => t.id.equals(id))).go();
  }

  Stream<List<MealLogEntry>> watchLogsForDate(DateTime date) {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));

    final query = _db.select(_db.mealLogs)
      ..where((t) => t.loggedAt.isBiggerOrEqualValue(start))
      ..where((t) => t.loggedAt.isSmallerThanValue(end));

    return query.watch().map((rows) {
      return rows.map((r) => MealLogEntry(
            id: r.id,
            mealType: r.mealType,
            foodItemId: r.foodItemId,
            quantity: r.quantity,
            calories: r.calories,
            proteinG: r.proteinG,
            loggedAt: r.loggedAt,
            note: r.note,
          )).toList();
    });
  }
}
