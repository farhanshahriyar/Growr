import 'package:drift/drift.dart';

@DataClassName('LoggedExerciseEntity')
class WorkoutLoggedExercises extends Table {
  TextColumn get id => text()();
  TextColumn get sessionId => text().references(WorkoutSessions, #id)();
  TextColumn get exerciseId => text().references(WorkoutExercises, #id)();

  @override
  Set<Column> get primaryKey => {id};
}
