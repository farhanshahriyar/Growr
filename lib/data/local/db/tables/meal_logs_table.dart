import 'package:drift/drift.dart';
import 'foods_table.dart';

@DataClassName('MealLogEntity')
class MealLogs extends Table {
  TextColumn get id => text()();
  TextColumn get mealType => text()(); // breakfast, lunch, snack, dinner
  TextColumn get foodItemId => text().references(Foods, #id)();
  RealColumn get quantity => real()();
  IntColumn get calories => integer()();
  IntColumn get proteinG => integer()();
  DateTimeColumn get loggedAt => dateTime()();
  TextColumn get note => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
