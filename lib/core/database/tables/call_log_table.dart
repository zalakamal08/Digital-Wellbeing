import 'package:drift/drift.dart';

/// Stores call log entries
class CallLogTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get number => text()();
  TextColumn get name => text().nullable()();
  TextColumn get callType => text()(); // incoming | outgoing | missed
  IntColumn get duration => integer()(); // seconds
  DateTimeColumn get timestamp => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
