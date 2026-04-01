import 'package:call_log/call_log.dart';
import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../database/daos/call_log_dao.dart';
import 'usage_stats_service.dart'; // for kDataWindowDays

class CallLogService {
  final AppDatabase _db;

  CallLogService(this._db);

  CallLogDao get _dao => _db.callLogDao;

  /// Fetch call logs from the past [kDataWindowDays] days only and upsert.
  /// Older records are pruned after sync.
  Future<void> syncCallLogs() async {
    try {
      final sevenDaysAgo = DateTime.now()
          .subtract(Duration(days: kDataWindowDays))
          .millisecondsSinceEpoch;

      // call_log supports dateFrom filtering natively
      final entries = await CallLog.query(dateFrom: sevenDaysAgo);

      for (final entry in entries) {
        if (entry.number == null) continue;

        final callType = _mapCallType(entry.callType);
        final timestamp = entry.timestamp != null
            ? DateTime.fromMillisecondsSinceEpoch(entry.timestamp!)
            : DateTime.now();

        await _dao.upsertCall(CallLogTableCompanion(
          number: Value(entry.number!),
          name: Value(entry.name),
          callType: Value(callType),
          duration: Value(entry.duration ?? 0),
          timestamp: Value(timestamp),
        ));
      }

      // Prune records older than the window
      await _dao.deleteOlderThan(kDataWindowDays);
    } catch (e) {
      // Permission not granted
    }
  }

  String _mapCallType(CallType? type) {
    switch (type) {
      case CallType.incoming:
        return 'incoming';
      case CallType.outgoing:
        return 'outgoing';
      case CallType.missed:
        return 'missed';
      default:
        return 'unknown';
    }
  }

  Future<List<CallLogTableData>> getWeekCalls() => _dao.getWeekCalls();
  Future<List<CallLogTableData>> getTodayCalls() => _dao.getTodayCalls();
  Future<int> getTodayTotalDuration() => _dao.getTodayTotalDuration();
}
