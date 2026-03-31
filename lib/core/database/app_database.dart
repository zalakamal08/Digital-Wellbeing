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
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'digital_wellbeing_db');
  }
}
