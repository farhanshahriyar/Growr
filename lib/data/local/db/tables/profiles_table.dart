import 'package:drift/drift.dart';

@DataClassName('ProfileEntity')
class Profiles extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get primaryGoal => text()();
  TextColumn get budgetMode => text()();
  TextColumn get workoutMode => text()();
  IntColumn get dailyCalorieGoal => integer()();
  IntColumn get dailyProteinGoalG => integer()();
  IntColumn get waterGoalMl => integer()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
