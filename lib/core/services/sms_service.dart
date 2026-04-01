import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../database/daos/sms_log_dao.dart';
import 'usage_stats_service.dart'; // for kDataWindowDays

class SmsService {
  final AppDatabase _db;

  SmsService(this._db);

  SmsLogDao get _dao => _db.smsLogDao;

  /// Fetch SMS inbox + sent from the past [kDataWindowDays] days only.
  /// Older records are pruned after sync.
  Future<void> syncSms() async {
    try {
      final weekStart = DateTime.now()
          .subtract(Duration(days: kDataWindowDays));

      final query = SmsQuery();
      final messages = await query.querySms(
        kinds: [SmsQueryKind.inbox, SmsQueryKind.sent],
      );

      for (final msg in messages) {
        if (msg.address == null) continue;

        final timestamp = msg.date ?? DateTime.now();

        // Only process messages within the 7-day window
        if (timestamp.isBefore(weekStart)) continue;

        final kind = msg.kind == SmsMessageKind.sent ? 'sent' : 'received';

        await _dao.upsertSms(SmsLogTableCompanion(
          address: Value(msg.address!),
          contactName: Value(msg.sender),
          body: Value(msg.body ?? ''),
          kind: Value(kind),
          timestamp: Value(timestamp),
        ));
      }

      // Prune records older than the window
      await _dao.deleteOlderThan(kDataWindowDays);
    } catch (e) {
      // Permission not granted
    }
  }

  Future<List<SmsLogTableData>> getWeekSms() => _dao.getWeekSms();
  Future<List<SmsLogTableData>> getAllSms() => _dao.getAllSms();
  Future<List<SmsLogTableData>> getTodaySms() => _dao.getTodaySms();
  Future<int> getTodayCount() => _dao.getTodayCount();
}
