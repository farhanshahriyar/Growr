import 'package:drift/drift.dart';

@DataClassName('WaterLogEntity')
class WaterLogs extends Table {
  TextColumn get id => text()();
  IntColumn get amountMl => integer()();
  DateTimeColumn get loggedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
