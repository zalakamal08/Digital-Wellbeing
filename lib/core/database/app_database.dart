import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/app_usage_table.dart';
import 'tables/call_log_table.dart';
import 'tables/sms_log_table.dart';
import 'daos/app_usage_dao.dart';
import 'daos/call_log_dao.dart';
import 'daos/sms_log_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [AppUsageTable, CallLogTable, SmsLogTable],
  daos: [AppUsageDao, CallLogDao, SmsLogDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // v1 → v2: Add unique composite keys to all three tables.
            // Drift doesn't support ALTER TABLE ADD UNIQUE directly,
            // so we recreate tables with the new schema and copy data over.
            await _migrateToV2(m);
          }
        },
      );

  Future<void> _migrateToV2(Migrator m) async {
    // Recreate tables with the new unique key constraints.
    // We rename old → tmp, create new, copy, drop tmp.

    // App usage
    await customStatement(
        'ALTER TABLE app_usage_table RENAME TO _app_usage_table_old;');
    await m.createTable(appUsageTable);
    await customStatement('''
      INSERT OR IGNORE INTO app_usage_table
        (id, package_name, app_name, usage_time_ms, date, last_used, created_at)
      SELECT id, package_name, app_name, usage_time_ms, date, last_used, created_at
      FROM _app_usage_table_old;
    ''');
    await customStatement('DROP TABLE _app_usage_table_old;');

    // Call log
    await customStatement(
        'ALTER TABLE call_log_table RENAME TO _call_log_table_old;');
    await m.createTable(callLogTable);
    await customStatement('''
      INSERT OR IGNORE INTO call_log_table
        (id, number, name, call_type, duration, timestamp, created_at)
      SELECT id, number, name, call_type, duration, timestamp, created_at
      FROM _call_log_table_old;
    ''');
    await customStatement('DROP TABLE _call_log_table_old;');

    // SMS log
    await customStatement(
        'ALTER TABLE sms_log_table RENAME TO _sms_log_table_old;');
    await m.createTable(smsLogTable);
    await customStatement('''
      INSERT OR IGNORE INTO sms_log_table
        (id, address, contact_name, body, kind, timestamp, created_at)
      SELECT id, address, contact_name, body, kind, timestamp, created_at
      FROM _sms_log_table_old;
    ''');
    await customStatement('DROP TABLE _sms_log_table_old;');
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'digital_wellbeing_db');
  }
}
