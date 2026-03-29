import 'package:drift/drift.dart';

@DataClassName('ProgressPhotoEntity')
class ProgressPhotos extends Table {
  TextColumn get id => text()();
  TextColumn get type => text()(); // 'front', 'side', 'back'
  TextColumn get uri => text()();
  DateTimeColumn get loggedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
