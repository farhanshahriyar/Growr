import 'package:drift/drift.dart';

@DataClassName('FoodEntity')
class Foods extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get aliases => text().withDefault(const Constant('[]'))(); // Store JSON array
  TextColumn get category => text()();
  TextColumn get portionLabel => text()();
  IntColumn get calories => integer()();
  IntColumn get proteinG => integer()();
  IntColumn get carbsG => integer().nullable()();
  IntColumn get fatsG => integer().nullable()();
  BoolColumn get affordable => boolean()();
  BoolColumn get localPriority => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}
