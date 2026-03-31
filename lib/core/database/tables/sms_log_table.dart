import 'package:drift/drift.dart';

/// Stores SMS log entries
class SmsLogTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get address => text()(); // phone number
  TextColumn get contactName => text().nullable()();
  TextColumn get body => text()();
  TextColumn get kind => text()(); // sent | received
  DateTimeColumn get timestamp => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
