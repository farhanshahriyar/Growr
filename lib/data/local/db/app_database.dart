import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/foods_table.dart';
import 'tables/meal_logs_table.dart';
import 'tables/profiles_table.dart';
import 'tables/workout_plans_table.dart';
import 'tables/workout_exercises_table.dart';
import 'tables/workout_sessions_table.dart';
import 'tables/workout_logged_exercises_table.dart';
import 'tables/workout_logged_sets_table.dart';
import 'tables/water_logs_table.dart';
import 'tables/weight_logs_table.dart';
import 'tables/progress_photos_table.dart';
import '../seed/seed_foods.dart';
import '../seed/seed_workouts.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  Foods,
  MealLogs,
  Profiles,
  WorkoutPlans,
  WorkoutExercises,
  WorkoutSessions,
  WorkoutLoggedExercises,
  WorkoutLoggedSets,
  WaterLogs,
  WeightLogs,
  ProgressPhotos,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await _seedFoods();
        await _seedWorkouts();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.createAll();
        }
      },
    );
  }

  Future<void> _seedFoods() async {
    final seeds = SeedFoods.getDefaultFoods();
    await batch((batch) {
      batch.insertAll(foods, seeds);
    });
  }

  Future<void> _seedWorkouts() async {
    final plans = SeedWorkouts.getDefaultPlans();
    final planIds = plans.map((p) => p.id).toList();
    final exercises = SeedWorkouts.getDefaultExercises(planIds);

    await batch((batch) {
      batch.insertAll(workoutPlans, plans);
      batch.insertAll(workoutExercises, exercises);
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

// Provider for singleton database instance
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});
