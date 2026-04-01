import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

import '../database/app_database.dart';
import 'usage_stats_service.dart';
import 'call_log_service.dart';
import 'sms_service.dart';

class CloudSyncService {
  final AppDatabase _db;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CloudSyncService(this._db);

  /// Main entry point to push all local 7-day data to Firestore.
  /// Typically called after the local sqlite databases finish syncing.
  Future<void> syncToCloud() async {
    try {
      final deviceId = await _getDeviceId();

      // Get local data
      final usageStats = await UsageStatsService(_db).getWeekUsage();
      final callLogs = await CallLogService(_db).getWeekCalls();
      final smsLogs = await SmsService(_db).getWeekSms();

      // We use batched writes because Firestore limits 500 operations per batch
      // and it's much faster/cheaper to batch write a bulk sync.
      await _syncAppUsage(deviceId, usageStats);
      await _syncCallLogs(deviceId, callLogs);
      await _syncSmsLogs(deviceId, smsLogs);

    } catch (e) {
      print('Cloud sync failed: $e');
    }
  }

  Future<void> _syncAppUsage(String deviceId, List<AppUsageTableData> data) async {
    final batch = _firestore.batch();
    int count = 0;

    for (final usage in data) {
      // Document ID: date_packageName (e.g., 2023-10-25_com.whatsapp)
      final docId = '${usage.date.toIso8601String().split('T')[0]}_${usage.packageName}';
      final docRef = _firestore
          .collection('users')
          .doc(deviceId)
          .collection('app_usage')
          .doc(docId);

      batch.set(docRef, {
        'packageName': usage.packageName,
        'appName': usage.appName,
        'usageTimeMs': usage.usageTimeMs,
        'date': usage.date.toIso8601String(),
        'lastUsed': usage.lastUsed.toIso8601String(),
      }, SetOptions(merge: true));

      count++;
      if (count == 490) {
        await batch.commit();
        count = 0;
      }
    }
    if (count > 0) await batch.commit();
  }

  Future<void> _syncCallLogs(String deviceId, List<CallLogTableData> data) async {
    final batch = _firestore.batch();
    int count = 0;

    for (final call in data) {
      // Document ID: timestamp_number
      final docId = '${call.timestamp.millisecondsSinceEpoch}_${call.number}';
      final docRef = _firestore
          .collection('users')
          .doc(deviceId)
          .collection('call_logs')
          .doc(docId);

      batch.set(docRef, {
        'number': call.number,
        'name': call.name,
        'callType': call.callType,
        'duration': call.duration,
        'timestamp': call.timestamp.toIso8601String(),
      }, SetOptions(merge: true));

      count++;
      if (count == 490) {
        await batch.commit();
        count = 0;
      }
    }
    if (count > 0) await batch.commit();
  }

  Future<void> _syncSmsLogs(String deviceId, List<SmsLogTableData> data) async {
    final batch = _firestore.batch();
    int count = 0;

    for (final sms in data) {
      // Document ID: timestamp_address
      final docId = '${sms.timestamp.millisecondsSinceEpoch}_${sms.address}';
      final docRef = _firestore
          .collection('users')
          .doc(deviceId)
          .collection('sms_logs')
          .doc(docId);

      batch.set(docRef, {
        'address': sms.address,
        'contactName': sms.contactName,
        'body': sms.body,
        'kind': sms.kind,
        'timestamp': sms.timestamp.toIso8601String(),
      }, SetOptions(merge: true));

      count++;
      if (count == 490) {
        await batch.commit();
        count = 0;
      }
    }
    if (count > 0) await batch.commit();
  }

  /// Get a consistent unique ID for this device to namespace data in Firebase
  Future<String> _getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      // id is unique to the device and the signing key combo
      return androidInfo.id;
    }
    return 'unknown_device';
  }
}
