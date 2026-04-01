import 'package:usage_stats/usage_stats.dart';
import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../database/daos/app_usage_dao.dart';

/// Number of days of data to collect and retain.
const kDataWindowDays = 7;

class UsageStatsService {
  final AppDatabase _db;

  UsageStatsService(this._db);

  AppUsageDao get _dao => _db.appUsageDao;

  /// Sync usage stats for the last [kDataWindowDays] days.
  /// Older data is automatically pruned after sync.
  Future<void> syncWeekUsage() async {
    try {
      final now = DateTime.now();
      final weekStart = DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: kDataWindowDays - 1));

      final usageList = await UsageStats.queryUsageStats(weekStart, now);

      for (final usage in usageList) {
        if (usage.packageName == null) continue;
        final packageName = usage.packageName!;

        final usageMs = int.tryParse(usage.totalTimeInForeground ?? '0') ?? 0;
        if (usageMs <= 0) continue;

        final lastUsedMs = int.tryParse(usage.lastTimeUsed ?? '0') ?? 0;
        final lastUsed = lastUsedMs > 0
            ? DateTime.fromMillisecondsSinceEpoch(lastUsedMs)
            : now;

        // Day bucket: always truncate to midnight
        final dayBucket = DateTime(lastUsed.year, lastUsed.month, lastUsed.day);

        // Preserve previously stored readable name if app was uninstalled
        final existingRecords =
            await _dao.getByPackageAndDate(packageName, dayBucket);
        String resolvedName = packageName;
        if (existingRecords.isNotEmpty &&
            existingRecords.first.appName != packageName) {
          resolvedName = existingRecords.first.appName;
        }

        await _dao.upsertUsage(AppUsageTableCompanion(
          packageName: Value(packageName),
          appName: Value(resolvedName),
          usageTimeMs: Value(usageMs),
          date: Value(dayBucket),
          lastUsed: Value(lastUsed),
        ));
      }

      // Prune anything older than the window
      await _dao.deleteOlderThan(kDataWindowDays);
    } catch (e) {
      // Usage stats permission might not be granted
    }
  }

  // ── Queries — all scoped to last 7 days ─────────────────────────────────

  Future<List<AppUsageTableData>> getWeekUsage() => _dao.getWeekUsage();

  Future<List<AppUsageTableData>> getTodayUsage() => _dao.getTodayUsage();

  Future<int> getTodayTotalMs() => _dao.getTodayTotalMs();

  Future<int> getWeekTotalMs() => _dao.getWeekTotalMs();

  Future<List<AppUsageTableData>> getUsageForRange(
          DateTime start, DateTime end) =>
      _dao.getUsageForRange(start, end);

  /// Format milliseconds to human-readable string (e.g., "2h 30m")
  static String formatDuration(int ms) {
    if (ms <= 0) return '0m';
    final duration = Duration(milliseconds: ms);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) return '${hours}h ${minutes}m';
    return '${minutes}m';
  }
}
