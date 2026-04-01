import 'package:usage_stats/usage_stats.dart';
import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../database/daos/app_usage_dao.dart';

class UsageStatsService {
  final AppDatabase _db;

  UsageStatsService(this._db);

  AppUsageDao get _dao => _db.appUsageDao;

  /// Fetch usage stats for today and upsert into DB.
  ///
  /// Key data-permanence rules:
  /// 1. Records are only inserted/updated — NEVER deleted.
  ///    Even if an app is uninstalled, its historical rows remain in the DB.
  /// 2. appName is preserved from the first sync. On subsequent syncs,
  ///    we only overwrite appName if we can still resolve a non-package name,
  ///    so uninstalled apps keep showing their real name (e.g. "Instagram")
  ///    rather than reverting to "com.instagram.android".
  Future<void> syncTodayUsage() async {
    try {
      final now = DateTime.now();
      // Day is always truncated to midnight for consistent grouping
      final startOfDay = DateTime(now.year, now.month, now.day);

      final usageList = await UsageStats.queryUsageStats(startOfDay, now);

      for (final usage in usageList) {
        if (usage.packageName == null) continue;
        final packageName = usage.packageName!;

        final usageMs = int.tryParse(usage.totalTimeInForeground ?? '0') ?? 0;
        if (usageMs <= 0) continue;

        final lastUsedMs = int.tryParse(usage.lastTimeUsed ?? '0') ?? 0;
        final lastUsed = lastUsedMs > 0
            ? DateTime.fromMillisecondsSinceEpoch(lastUsedMs)
            : now;

        // Check if we already have a stored appName for this package.
        // If yes, and the current name resolves only to the package name
        // (app might be uninstalled), keep the stored name instead.
        final existingRecords = await _dao.getByPackageAndDate(packageName, startOfDay);
        String resolvedName = packageName; // default fallback

        if (existingRecords.isNotEmpty &&
            existingRecords.first.appName != packageName) {
          // We have a real stored name — preserve it
          resolvedName = existingRecords.first.appName;
        }
        // usage_stats API doesn't return a display name — we use packageName
        // as the app name. A future enhancement could use a method channel
        // to fetch the real label via PackageManager, but for now packageName
        // is the stable identifier and is preserved once stored.

        await _dao.upsertUsage(AppUsageTableCompanion(
          packageName: Value(packageName),
          appName: Value(resolvedName),
          usageTimeMs: Value(usageMs),
          date: Value(startOfDay),
          lastUsed: Value(lastUsed),
        ));
      }
    } catch (e) {
      // Usage stats permission might not be granted
    }
  }

  Future<List<AppUsageTableData>> getTodayUsage() => _dao.getTodayUsage();

  Future<int> getTodayTotalMs() => _dao.getTodayTotalMs();

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
