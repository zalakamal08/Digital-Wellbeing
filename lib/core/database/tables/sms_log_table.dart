import 'package:drift/drift.dart';

/// Stores SMS log entries.
/// Unique key: address + timestamp — prevents duplicates across syncs.
/// Records are NEVER deleted from here even if cleared from the phone's
/// native messaging app — this DB is our immutable archive.
class SmsLogTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get address => text()();          // phone number
  TextColumn get contactName => text().nullable()(); // stored at sync, preserved if contact deleted
  TextColumn get body => text()();
  TextColumn get kind => text()();             // sent | received
  DateTimeColumn get timestamp => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Composite unique key: one record per (address, timestamp)
  @override
  List<Set<Column>> get uniqueKeys => [
        {address, timestamp},
      ];
}
