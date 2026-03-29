import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../local/db/app_database.dart';

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  return ProgressRepository(ref.watch(databaseProvider));
});

class ProgressRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();

  ProgressRepository(this._db);

  Future<void> logWeight(double weightKg) async {
    await into(_db.weightLogs).insert(
      WeightLogsCompanion.insert(
        id: _uuid.v4(),
        weightKg: weightKg,
        loggedAt: DateTime.now(),
      ),
    );
  }

  Future<void> logProgressPhoto(String type, String uri) async {
    await into(_db.progressPhotos).insert(
      ProgressPhotosCompanion.insert(
        id: _uuid.v4(),
        type: type,
        uri: uri,
        loggedAt: DateTime.now(),
      ),
    );
  }

  Stream<List<WeightLogEntity>> getWeightHistory({int limit = 10}) {
    final query = _db.select(_db.weightLogs)
      ..orderBy([(t) => OrderingTerm.desc(t.loggedAt)])
      ..limit(limit);

    return query.watch();
  }

  Stream<List<ProgressPhotoEntity>> getProgressPhotos() {
    final query = _db.select(_db.progressPhotos)
      ..orderBy([(t) => OrderingTerm.desc(t.loggedAt)]);

    return query.watch();
  }

  Stream<Map<String, dynamic>> watchWeeklySummary() {
    final now = DateTime.now();
    final weekStart = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 6));

    return (_db.select(_db.mealLogs)
          ..where((t) => t.loggedAt.isBiggerOrEqualValue(weekStart))
          ..where((t) => t.loggedAt.isSmallerThanValue(now.add(const Duration(days: 1)))))
        .watch()
        .map((mealLogs) {
      // Calculate average daily calories and protein
      final dailyTotals = <DateTime, Map<String, int>>{};
      for (final log in mealLogs) {
        final day = DateTime(log.loggedAt.year, log.loggedAt.month, log.loggedAt.day);
        if (!dailyTotals.containsKey(day)) {
          dailyTotals[day] = {'calories': 0, 'protein': 0};
        }
        dailyTotals[day]!['calories'] = (dailyTotals[day]!['calories'] ?? 0) + log.calories;
        dailyTotals[day]!['protein'] = (dailyTotals[day]!['protein'] ?? 0) + log.proteinG;
      }

      double avgCalories = 0;
      double avgProtein = 0;
      if (dailyTotals.isNotEmpty) {
        final totalCalories = dailyTotals.values.fold<int>(0, (sum, day) => sum + (day['calories'] ?? 0));
        final totalProtein = dailyTotals.values.fold<int>(0, (sum, day) => sum + (day['protein'] ?? 0));
        avgCalories = totalCalories / dailyTotals.length;
        avgProtein = totalProtein / dailyTotals.length;
      }

      return {
        'avgCalories': avgCalories.round(),
        'avgProtein': avgProtein.round(),
        'daysLogged': dailyTotals.length,
        'totalMeals': mealLogs.length,
      };
    });
  }

  Future<void> clearAllProgressData() async {
    await delete(_db.progressPhotos).go();
    await delete(_db.weightLogs).go();
  }
}
