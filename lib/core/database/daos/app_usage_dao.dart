import 'package:drift/drift.dart';
import '../tables/app_usage_table.dart';
import '../app_database.dart';

part 'app_usage_dao.g.dart';

@DriftAccessor(tables: [AppUsageTable])
class AppUsageDao extends DatabaseAccessor<AppDatabase>
    with _$AppUsageDaoMixin {
  AppUsageDao(super.db);

  /// Get all usage records for a given date range, sorted by usage time descending
  Future<List<AppUsageTableData>> getUsageForRange(
      DateTime start, DateTime end) {
    return (select(appUsageTable)
          ..where(
              (t) => t.date.isBetweenValues(start, end))
          ..orderBy([(t) => OrderingTerm.desc(t.usageTimeMs)]))
        .get();
  }

  /// Get usage for today
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

  /// Clear all records older than given days
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
}
