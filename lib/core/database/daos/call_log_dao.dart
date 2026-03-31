import 'package:drift/drift.dart';
import '../tables/call_log_table.dart';
import '../app_database.dart';

part 'call_log_dao.g.dart';

@DriftAccessor(tables: [CallLogTable])
class CallLogDao extends DatabaseAccessor<AppDatabase>
    with _$CallLogDaoMixin {
  CallLogDao(super.db);

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

  Future<int> getTodayTotalDuration() async {
    final calls = await getTodayCalls();
    return calls.fold(0, (sum, c) => sum + c.duration);
  }
}
