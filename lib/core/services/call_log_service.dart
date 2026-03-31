import 'package:call_log/call_log.dart';
import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../database/daos/call_log_dao.dart';

class CallLogService {
  final AppDatabase _db;

  CallLogService(this._db);

  CallLogDao get _dao => _db.callLogDao;

  /// Fetch last 7 days of call logs and upsert
  Future<void> syncCallLogs() async {
    try {
      final entries = await CallLog.get();
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

  Future<List<CallLogTableData>> getAllCalls() => _dao.getAllCalls();
  Future<List<CallLogTableData>> getTodayCalls() => _dao.getTodayCalls();
  Future<int> getTodayTotalDuration() => _dao.getTodayTotalDuration();
}
