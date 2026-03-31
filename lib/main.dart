import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'package:get_it/get_it.dart';

import 'app.dart';
import 'core/database/app_database.dart';
import 'core/services/background_sync_service.dart';
import 'core/services/notification_service.dart';

final GetIt getIt = GetIt.instance;

/// WorkManager callback dispatcher — must be top-level.
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    try {
      await BackgroundSyncService.runSync();
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Database ─────────────────────────────────────────────────────
  final db = AppDatabase();
  getIt.registerSingleton<AppDatabase>(db);

  // ── Notification service ─────────────────────────────────────────
  final notificationService = NotificationService();
  await notificationService.init();
  getIt.registerSingleton<NotificationService>(notificationService);

  // ── WorkManager ──────────────────────────────────────────────────
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  await BackgroundSyncService.schedulePeriodicSync();

  runApp(const MyDigitalWellbeingApp());
}
