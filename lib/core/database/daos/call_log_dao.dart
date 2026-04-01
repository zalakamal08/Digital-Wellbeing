import 'package:drift/drift.dart';
import '../tables/call_log_table.dart';
import '../app_database.dart';

part 'call_log_dao.g.dart';

@DriftAccessor(tables: [CallLogTable])
class CallLogDao extends DatabaseAccessor<AppDatabase>
    with _$CallLogDaoMixin {
  CallLogDao(super.db);

  static DateTime get _weekStart =>
      DateTime.now().subtract(const Duration(days: 6));

  /// All calls within the last 7 days
  Future<List<CallLogTableData>> getWeekCalls() {
    return (select(callLogTable)
          ..where((t) => t.timestamp.isBiggerOrEqualValue(_weekStart))
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
        .get();
  }

  /// All calls ever stored (used for internal DAO operations only)
  Future<List<CallLogTableData>> getAllCalls() {
    return (select(callLogTable)
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
        .get();
  }

  Future<List<CallLogTableData>> getTodayCalls() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    return (select(callLogTable)
          ..where((t) => t.timestamp.isBiggerOrEqualValue(startOfDay))
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
        .get();
  }

  Future<void> upsertCall(CallLogTableCompanion entry) async {
    await into(callLogTable).insertOnConflictUpdate(entry);
  }

  /// Delete records older than [days] days
  Future<int> deleteOlderThan(int days) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return (delete(callLogTable)
          ..where((t) => t.timestamp.isSmallerThanValue(cutoff)))
        .go();
  }

  Future<int> getTodayTotalDuration() async {
    final calls = await getTodayCalls();
    return calls.fold<int>(0, (sum, c) => sum + c.duration);
  }

  Future<int> getWeekTotalDuration() async {
    final calls = await getWeekCalls();
    return calls.fold<int>(0, (sum, c) => sum + c.duration);
  }
}
