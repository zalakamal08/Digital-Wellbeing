import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
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
  bool _permissionDenied = false;
  bool _permanentlyDenied = false;

  int get _sentCount => _allSms.where((s) => s.kind == 'sent').length;
  int get _receivedCount => _allSms.where((s) => s.kind == 'received').length;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _permissionDenied = false;
      _permanentlyDenied = false;
    });

    // Check SMS permission first
    final status = await Permission.sms.status;

    if (status.isDenied) {
      // Try requesting
      final result = await Permission.sms.request();
      if (result.isDenied || result.isPermanentlyDenied) {
        setState(() {
          _loading = false;
          _permissionDenied = true;
          _permanentlyDenied = result.isPermanentlyDenied;
        });
        return;
      }
    } else if (status.isPermanentlyDenied) {
      setState(() {
        _loading = false;
        _permissionDenied = true;
        _permanentlyDenied = true;
      });
      return;
    }

    // Permission granted — load data
    await _service.syncSms();
    final sms = await _service.getAllSms();

    final Map<String, List<SmsLogTableData>> grouped = {};
    for (final msg in sms) {
      final key =
          msg.contactName?.isNotEmpty == true ? msg.contactName! : msg.address;
      (grouped[key] ??= []).add(msg);
    }

    if (mounted) {
      setState(() {
        _allSms = sms;
        _grouped = grouped;
        _loading = false;
        _permissionDenied = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('SMS'),
        actions: [
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh_rounded)),
          const SizedBox(width: 8),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _permissionDenied
              ? _PermissionDeniedView(
                  permanentlyDenied: _permanentlyDenied,
                  onGrant: _load,
                )
              : _SmsDataView(
                  allSms: _allSms,
                  grouped: _grouped,
                  onRefresh: _load,
                ),
    );
  }
}

// ── Permission Denied View ─────────────────────────────────────────────────

class _PermissionDeniedView extends StatelessWidget {
  final bool permanentlyDenied;
  final VoidCallback onGrant;

  const _PermissionDeniedView({
    required this.permanentlyDenied,
    required this.onGrant,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(36),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.12),
                shape: BoxShape.circle,
                border: Border.all(
                    color: Colors.blueAccent.withOpacity(0.4), width: 2),
              ),
              child: const Icon(Icons.sms_rounded,
                  color: Colors.blueAccent, size: 38),
            ),
            const SizedBox(height: 24),
            Text(
              permanentlyDenied
                  ? 'SMS Access Blocked'
                  : 'SMS Permission Required',
              style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              permanentlyDenied
                  ? 'You previously denied SMS access permanently.\nOpen system settings to enable it.'
                  : 'Grant SMS permission to track your\nmessaging activity and contacts.',
              style: const TextStyle(color: Colors.white54, height: 1.6),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent.withOpacity(0.2),
                  foregroundColor: Colors.blueAccent,
                  side:
                      const BorderSide(color: Colors.blueAccent, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: permanentlyDenied
                    ? () async {
                        await openAppSettings();
                      }
                    : onGrant,
                icon: Icon(permanentlyDenied
                    ? Icons.settings_rounded
                    : Icons.lock_open_rounded),
                label: Text(permanentlyDenied
                    ? 'Open System Settings'
                    : 'Grant SMS Permission'),
              ),
            ),
            if (!permanentlyDenied) ...[
              const SizedBox(height: 12),
              TextButton(
                onPressed: onGrant,
                child: const Text('Retry', style: TextStyle(color: Colors.white38)),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

// ── SMSData View ──────────────────────────────────────────────────────────

class _SmsDataView extends StatelessWidget {
  final List<SmsLogTableData> allSms;
  final Map<String, List<SmsLogTableData>> grouped;
  final Future<void> Function() onRefresh;

  const _SmsDataView({
    required this.allSms,
    required this.grouped,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todaySms = allSms.where((s) => s.timestamp.isAfter(todayStart));
    final todaySent = todaySms.where((s) => s.kind == 'sent').length;
    final todayReceived = todaySms.where((s) => s.kind == 'received').length;

    return RefreshIndicator(
      onRefresh: onRefresh,
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
                    "TODAY'S SMS SUMMARY",
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
                        value: grouped.length.toString(),
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
          ...grouped.entries.map((entry) => SmsLogTile(
                contactName: entry.key,
                messages: entry.value,
              )),

          if (grouped.isEmpty)
            const Padding(
              padding: EdgeInsets.all(48),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.inbox_rounded, size: 48, color: Colors.white12),
                    SizedBox(height: 12),
                    Text(
                      'No SMS records yet.\nTry syncing again.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white38),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
