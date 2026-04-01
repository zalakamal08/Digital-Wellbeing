import 'package:flutter/material.dart';
import '../../main.dart';
import '../../core/database/app_database.dart';
import '../../core/services/call_log_service.dart';
import 'widgets/call_log_tile.dart';
import 'widgets/call_stats_card.dart';

class CallsScreen extends StatefulWidget {
  const CallsScreen({super.key});

  @override
  State<CallsScreen> createState() => _CallsScreenState();
}

class _CallsScreenState extends State<CallsScreen> {
  final _db = getIt<AppDatabase>();
  late final _service = CallLogService(_db);

  List<CallLogTableData> _calls = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    await _service.syncCallLogs();
    final calls = await _service.getWeekCalls();
    setState(() {
      _calls = calls;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Call Logs'),
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
                  CallStatsCard(calls: _calls),
                  ..._calls.map((c) => CallLogTile(call: c)),
                  if (_calls.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(40),
                      child: Center(
                        child: Text(
                          'No call logs found.\nEnsure Call Log permission is granted.',
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
