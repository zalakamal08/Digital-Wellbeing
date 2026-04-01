import 'package:workmanager/workmanager.dart';

import '../database/app_database.dart';
import 'usage_stats_service.dart';
import 'call_log_service.dart';
import 'sms_service.dart';
import 'cloud_sync_service.dart';

const _syncTaskName = 'digitalWellbeingSync';
const _uniqueTaskName = 'periodicSync';

class BackgroundSyncService {
  /// Called from WorkManager callback dispatcher
  static Future<void> runSync() async {
    final db = AppDatabase();
    try {
      await UsageStatsService(db).syncTodayUsage();
      await CallLogService(db).syncCallLogs();
      await SmsService(db).syncSms();

      // Trigger Cloud Sync directly after local DB aggregates
      await CloudSyncService(db).syncToCloud();
    } finally {
      await db.close();
    }
  }

  /// Register periodic 15-minute sync
  static Future<void> schedulePeriodicSync({int frequencyMinutes = 15}) async {
    await Workmanager().registerPeriodicTask(
      _uniqueTaskName,
      _syncTaskName,
      frequency: Duration(minutes: frequencyMinutes),
      constraints: Constraints(
        networkType: NetworkType.not_required,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresDeviceIdle: false,
        requiresStorageNotLow: false,
      ),
      existingWorkPolicy: ExistingWorkPolicy.replace,
    );
  }

  static Future<void> cancelSync() async {
    await Workmanager().cancelByUniqueName(_uniqueTaskName);
  }
}
