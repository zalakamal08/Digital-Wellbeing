import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../database/daos/sms_log_dao.dart';

class SmsService {
  final AppDatabase _db;

  SmsService(this._db);

  SmsLogDao get _dao => _db.smsLogDao;

  /// Fetch SMS inbox and sent messages and sync to DB
  Future<void> syncSms() async {
    try {
      final query = SmsQuery();
      final messages = await query.querySms(
        kinds: [SmsQueryKind.inbox, SmsQueryKind.sent],
      );

      for (final msg in messages) {
        if (msg.address == null) continue;

        final kind = msg.kind == SmsMessageKind.sent ? 'sent' : 'received';
        final timestamp = msg.date ?? DateTime.now();

        await _dao.upsertSms(SmsLogTableCompanion(
          address: Value(msg.address!),
          contactName: Value(msg.sender),
          body: Value(msg.body ?? ''),
          kind: Value(kind),
          timestamp: Value(timestamp),
        ));
      }
    } catch (e) {
      // Permission not granted
    }
  }

  Future<List<SmsLogTableData>> getAllSms() => _dao.getAllSms();
  Future<List<SmsLogTableData>> getTodaySms() => _dao.getTodaySms();
  Future<int> getTodayCount() => _dao.getTodayCount();
}
