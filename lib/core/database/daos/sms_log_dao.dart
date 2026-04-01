import 'package:drift/drift.dart';
import '../tables/sms_log_table.dart';
import '../app_database.dart';

part 'sms_log_dao.g.dart';

@DriftAccessor(tables: [SmsLogTable])
class SmsLogDao extends DatabaseAccessor<AppDatabase>
    with _$SmsLogDaoMixin {
  SmsLogDao(super.db);

  static DateTime get _weekStart =>
      DateTime.now().subtract(const Duration(days: 6));

  /// All SMS from the last 7 days
  Future<List<SmsLogTableData>> getWeekSms() {
    return (select(smsLogTable)
          ..where((t) => t.timestamp.isBiggerOrEqualValue(_weekStart))
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
        .get();
  }

  /// All SMS logs ever stored
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

  /// Delete records older than [days] days
  Future<int> deleteOlderThan(int days) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return (delete(smsLogTable)
          ..where((t) => t.timestamp.isSmallerThanValue(cutoff)))
        .go();
  }

  Future<int> getTodayCount() async {
    final sms = await getTodaySms();
    return sms.length;
  }
}
