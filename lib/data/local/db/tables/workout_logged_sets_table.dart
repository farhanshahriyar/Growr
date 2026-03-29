import 'package:drift/drift.dart';

@DataClassName('LoggedSetEntity')
class WorkoutLoggedSets extends Table {
  TextColumn get id => text()();
  TextColumn get loggedExerciseId => text().references(WorkoutLoggedExercises, #id)();
  IntColumn get setNo => integer()();
  IntColumn get reps => integer()();
  RealColumn get weightKg => real().nullable()();
  BoolColumn get done => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}
