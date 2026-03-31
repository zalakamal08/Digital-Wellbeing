import 'package:drift/drift.dart';
import '../tables/sms_log_table.dart';
import '../app_database.dart';

part 'sms_log_dao.g.dart';

@DriftAccessor(tables: [SmsLogTable])
class SmsLogDao extends DatabaseAccessor<AppDatabase>
    with _$SmsLogDaoMixin {
  SmsLogDao(super.db);

  Future<List<SmsLogTableData>> getAllSms() {
    return (select(smsLogTable)
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
        .get();
  }

  Future<List<SmsLogTableData>> getTodaySms() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    return (select(smsLogTable)
          ..where((t) => t.timestamp.isBiggerOrEqualValue(startOfDay))
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
        .get();
  }

  Future<void> upsertSms(SmsLogTableCompanion entry) async {
    await into(smsLogTable).insertOnConflictUpdate(entry);
  }

  Future<int> getTodayCount() async {
    final sms = await getTodaySms();
    return sms.length;
  }
}
