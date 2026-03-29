import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/foods_table.dart';
import 'tables/meal_logs_table.dart';
import '../seed/seed_foods.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Foods, MealLogs])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        // Seed default foods upon creation
        await _seedFoods();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Handle future migrations
      },
    );
  }

  Future<void> _seedFoods() async {
    final seeds = SeedFoods.getDefaultFoods();
    await batch((batch) {
      batch.insertAll(foods, seeds);
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'growr_db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
