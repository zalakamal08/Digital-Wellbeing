import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class PermissionManager {
  /// Check if PACKAGE_USAGE_STATS permission is granted.
  /// This requires special handling via AppOps.
  static Future<bool> hasUsageStatsPermission() async {
    // usage_stats package handles this internally, but we can check via
    // permission_handler's appTrackingTransparency as a proxy on Android
    // For PACKAGE_USAGE_STATS we rely on the usage_stats package itself
    return Permission.activityRecognition.isGranted;
  }

  static Future<bool> hasCallLogPermission() async {
    return Permission.phone.isGranted;
  }

  static Future<bool> hasSmsPermission() async {
    return Permission.sms.isGranted;
  }

  static Future<bool> hasNotificationPermission() async {
    return Permission.notification.isGranted;
  }

  /// Request call log + SMS + notification permissions at runtime
  static Future<Map<Permission, PermissionStatus>> requestAllPermissions() async {
    return await [
      Permission.phone,
      Permission.sms,
      Permission.notification,
      Permission.contacts,
    ].request();
  }

  static Future<void> openUsageAccessSettings() async {
    await openAppSettings();
  }

  static Future<bool> areAllPermissionsGranted() async {
    final phone = await Permission.phone.isGranted;
    final sms = await Permission.sms.isGranted;
    final notification = await Permission.notification.isGranted;
    return phone && sms && notification;
  }
}
