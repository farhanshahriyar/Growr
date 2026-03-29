import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../local/db/app_database.dart';

final hydrationRepositoryProvider = Provider<HydrationRepository>((ref) {
  return HydrationRepository(ref.watch(databaseProvider));
});

class HydrationRepository {
  final AppDatabase _db;

  HydrationRepository(this._db);

  Future<void> logWater(int amountMl) async {
    await into(_db.waterLogs).insert(
      WaterLogsCompanion.insert(
        id: const Uuid().v4(),
        amountMl: amountMl,
        loggedAt: DateTime.now(),
      ),
    );
  }

  Stream<int> watchTodaysWaterMl() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1));

    final query = _db.select(_db.waterLogs)
      ..where((t) => t.loggedAt.isBiggerOrEqualValue(start))
      ..where((t) => t.loggedAt.isSmallerThanValue(end));

    return query.watch().map((rows) {
      return rows.fold<int>(0, (sum, row) => sum + row.amountMl);
    });
  }

  Stream<List<int>> watchWeeklyWaterMl() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 6));

    return _db.select(_db.waterLogs)
        .watch()
        .map((rows) {
      // Group by day for last 7 days
      final dailyTotals = <DateTime, int>{};
      for (final row in rows) {
        final day = DateTime(row.loggedAt.year, row.loggedAt.month, row.loggedAt.day);
        if (day.isAfter(start) || day == start) {
          dailyTotals[day] = (dailyTotals[day] ?? 0) + row.amountMl;
        }
      }
      // Return in chronological order
      return List.generate(7, (index) {
        final day = start.add(Duration(days: index));
        return dailyTotals[day] ?? 0;
      });
    });
  }

  Future<void> clearWaterLogs() async {
    await delete(_db.waterLogs).go();
  }
}
