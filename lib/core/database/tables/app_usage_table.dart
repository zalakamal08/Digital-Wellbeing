import 'package:drift/drift.dart';

/// Stores per-app usage records (one row per app per calendar day)
/// Unique key: packageName + date (day-truncated)
class AppUsageTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get packageName => text()();
  // Stored permanently at first sync — survives app uninstall
  TextColumn get appName => text()();
  IntColumn get usageTimeMs => integer()(); // usage in milliseconds
  DateTimeColumn get date => dateTime()();  // day-truncated (midnight)
  DateTimeColumn get lastUsed => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Composite unique key: one record per app per day
  @override
  List<Set<Column>> get uniqueKeys => [
        {packageName, date},
      ];
}
