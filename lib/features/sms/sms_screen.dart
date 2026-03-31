import 'package:flutter/material.dart';
import '../../main.dart';
import '../../core/database/app_database.dart';
import '../../core/services/sms_service.dart';
import '../../shared/widgets/stat_chip.dart';
import 'widgets/sms_log_tile.dart';

class SmsScreen extends StatefulWidget {
  const SmsScreen({super.key});

  @override
  State<SmsScreen> createState() => _SmsScreenState();
}

class _SmsScreenState extends State<SmsScreen> {
  final _db = getIt<AppDatabase>();
  late final _service = SmsService(_db);

  List<SmsLogTableData> _allSms = [];
  Map<String, List<SmsLogTableData>> _grouped = {};
  bool _loading = true;

  int get _sentCount =>
      _allSms.where((s) => s.kind == 'sent').length;
  int get _receivedCount =>
      _allSms.where((s) => s.kind == 'received').length;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    await _service.syncSms();
    final sms = await _service.getAllSms();

    // Group by contact
    final Map<String, List<SmsLogTableData>> grouped = {};
    for (final msg in sms) {
      final key =
          msg.contactName?.isNotEmpty == true ? msg.contactName! : msg.address;
      (grouped[key] ??= []).add(msg);
    }

    setState(() {
      _allSms = sms;
      _grouped = grouped;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todaySms = _allSms.where((s) => s.timestamp.isAfter(todayStart));
    final todaySent = todaySms.where((s) => s.kind == 'sent').length;
    final todayReceived = todaySms.where((s) => s.kind == 'received').length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SMS'),
        actions: [
          IconButton(
              onPressed: _load, icon: const Icon(Icons.refresh_rounded)),
          const SizedBox(width: 8),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                children: [
                  // Stats card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'TODAY\'S SMS SUMMARY',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.1,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              StatChip(
                                label: 'Sent today',
                                value: todaySent.toString(),
                                icon: Icons.upload_rounded,
                                color: Colors.blueAccent,
                              ),
                              StatChip(
                                label: 'Received today',
                                value: todayReceived.toString(),
                                icon: Icons.download_rounded,
                                color: Colors.greenAccent,
                              ),
                              StatChip(
                                label: 'Contacts',
                                value: _grouped.length.toString(),
                                icon: Icons.people_rounded,
                                color: Colors.purpleAccent,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Grouped list
                  ..._grouped.entries.map((entry) =>
                    SmsLogTile(
                      contactName: entry.key,
                      messages: entry.value,
                    )),

                  if (_grouped.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(40),
                      child: Center(
                        child: Text(
                          'No SMS logs found.\nEnsure SMS permission is granted.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white38),
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
