import 'package:usage_stats/usage_stats.dart';
import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../database/daos/app_usage_dao.dart';

class UsageStatsService {
  final AppDatabase _db;

  UsageStatsService(this._db);

  AppUsageDao get _dao => _db.appUsageDao;

  /// Fetch usage stats for today and upsert into DB
  Future<void> syncTodayUsage() async {
    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);

      final usageList = await UsageStats.queryUsageStats(startOfDay, now);

      for (final usage in usageList) {
        if (usage.packageName == null) continue;
        final usageMs = int.tryParse(usage.totalTimeInForeground ?? '0') ?? 0;
        if (usageMs <= 0) continue;

        final lastUsedMs = int.tryParse(usage.lastTimeUsed ?? '0') ?? 0;
        final lastUsed = lastUsedMs > 0
            ? DateTime.fromMillisecondsSinceEpoch(lastUsedMs)
            : now;

        await _dao.upsertUsage(AppUsageTableCompanion(
          packageName: Value(usage.packageName!),
          appName: Value(usage.packageName!), // fallback to package name
          usageTimeMs: Value(usageMs),
          date: Value(startOfDay),
          lastUsed: Value(lastUsed),
        ));
      }
    } catch (e) {
      // Usage stats permission might not be granted
    }
  }

  Future<List<AppUsageTableData>> getTodayUsage() =>
      _dao.getTodayUsage();

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
