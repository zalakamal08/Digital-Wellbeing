import 'package:drift/drift.dart';
import '../tables/app_usage_table.dart';
import '../app_database.dart';

part 'app_usage_dao.g.dart';

@DriftAccessor(tables: [AppUsageTable])
class AppUsageDao extends DatabaseAccessor<AppDatabase>
    with _$AppUsageDaoMixin {
  AppUsageDao(super.db);

  static DateTime get _weekStart {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day)
        .subtract(const Duration(days: 6));
  }

  /// Gets usage records within the last 7 days
  Future<List<AppUsageTableData>> getWeekUsage() {
    final start = _weekStart;
    final end = DateTime.now().add(const Duration(days: 1));
    return (select(appUsageTable)
          ..where((t) => t.date.isBetweenValues(start, end))
          ..orderBy([(t) => OrderingTerm.desc(t.usageTimeMs)]))
        .get();
  }

  /// Get all usage records for a given date range, sorted by usage time descending
  Future<List<AppUsageTableData>> getUsageForRange(
      DateTime start, DateTime end) {
    return (select(appUsageTable)
          ..where((t) => t.date.isBetweenValues(start, end))
          ..orderBy([(t) => OrderingTerm.desc(t.usageTimeMs)]))
        .get();
  }

  /// Get usage for today only
  Future<List<AppUsageTableData>> getTodayUsage() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    return getUsageForRange(startOfDay, endOfDay);
  }

  /// Upsert: if same packageName+date exists, update; otherwise insert
  Future<void> upsertUsage(AppUsageTableCompanion entry) async {
    await into(appUsageTable).insertOnConflictUpdate(entry);
  }

  /// Look up existing records for a specific package on a specific day
  Future<List<AppUsageTableData>> getByPackageAndDate(
      String packageName, DateTime date) {
    final dayEnd = date.add(const Duration(days: 1));
    return (select(appUsageTable)
          ..where((t) =>
              t.packageName.equals(packageName) &
              t.date.isBiggerOrEqualValue(date) &
              t.date.isSmallerThanValue(dayEnd)))
        .get();
  }

  /// Delete records older than [days] days (keeps DB lean)
  Future<int> deleteOlderThan(int days) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return (delete(appUsageTable)
          ..where((t) => t.date.isSmallerThanValue(cutoff)))
        .go();
  }

  /// Total screen time in ms for today
  Future<int> getTodayTotalMs() async {
    final rows = await getTodayUsage();
    return rows.fold<int>(0, (sum, r) => sum + r.usageTimeMs);
  }

  /// Total screen time in ms for the last 7 days
  Future<int> getWeekTotalMs() async {
    final rows = await getWeekUsage();
    return rows.fold<int>(0, (sum, r) => sum + r.usageTimeMs);
  }
}
