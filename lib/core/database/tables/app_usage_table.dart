import 'package:drift/drift.dart';

/// Stores per-app usage records (one row per app per hour-bucket)
class AppUsageTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get packageName => text()();
  TextColumn get appName => text()();
  IntColumn get usageTimeMs => integer()(); // usage in milliseconds
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get lastUsed => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
