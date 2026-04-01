import 'package:drift/drift.dart';

/// Stores call log entries.
/// Unique key: number + timestamp — prevents duplicates across syncs.
/// Records are NEVER deleted from here even if cleared from the phone's
/// native dialer — this DB is our immutable archive.
class CallLogTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get number => text()();
  TextColumn get name => text().nullable()(); // stored at sync time, preserved even if contact deleted
  TextColumn get callType => text()();        // incoming | outgoing | missed
  IntColumn get duration => integer()();      // seconds
  DateTimeColumn get timestamp => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Composite unique key: one record per (number, timestamp)
  @override
  List<Set<Column>> get uniqueKeys => [
        {number, timestamp},
      ];
}
