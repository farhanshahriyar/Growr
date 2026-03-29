import 'package:drift/drift.dart';

@DataClassName('WorkoutExerciseEntity')
class WorkoutExercises extends Table {
  TextColumn get id => text()();
  TextColumn get planId => text().references(WorkoutPlans, #id)();
  TextColumn get name => text()();
  IntColumn get sets => integer()();
  TextColumn get repRange => text()();
  IntColumn get defaultRestSec => integer().nullable()();
  TextColumn get image => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
