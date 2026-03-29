import 'package:drift/drift.dart';

@DataClassName('WorkoutPlanEntity')
class WorkoutPlans extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get day => integer()(); // 1-5 for 5-day split
  TextColumn get title => text()();
  IntColumn get durationMin => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
