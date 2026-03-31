import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import '../../core/database/app_database.dart';
import '../../core/services/background_sync_service.dart';
import '../../core/services/notification_service.dart';
import '../../core/permissions/permission_manager.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _db = getIt<AppDatabase>();
  final _notifService = getIt<NotificationService>();

  int _syncIntervalMinutes = 15;
  bool _dailyNotifEnabled = true;

  bool _phoneGranted = false;
  bool _smsGranted = false;
  bool _notifGranted = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _checkPermissions();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _syncIntervalMinutes = prefs.getInt('sync_interval') ?? 15;
      _dailyNotifEnabled = prefs.getBool('daily_notif') ?? true;
    });
  }

  Future<void> _checkPermissions() async {
    final phone = await Permission.phone.isGranted;
    final sms = await Permission.sms.isGranted;
    final notif = await Permission.notification.isGranted;
    setState(() {
      _phoneGranted = phone;
      _smsGranted = sms;
      _notifGranted = notif;
    });
  }

  Future<void> _saveInterval(int minutes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('sync_interval', minutes);
    await BackgroundSyncService.schedulePeriodicSync(
        frequencyMinutes: minutes);
    setState(() => _syncIntervalMinutes = minutes);
  }

  Future<void> _toggleDailyNotif(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('daily_notif', enabled);
    if (enabled) {
      await _notifService.scheduleDailySummary();
    } else {
      await _notifService.cancelAll();
    }
    setState(() => _dailyNotifEnabled = enabled);
  }

  Future<void> _clearAllData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear All Data?'),
        content: const Text(
            'This will delete all tracked usage, call logs, and SMS data from the app. This cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _db.delete(_db.appUsageTable).go();
      await _db.delete(_db.callLogTable).go();
      await _db.delete(_db.smsLogTable).go();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All data cleared.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // Permissions section
          _SectionHeader(title: 'PERMISSIONS'),
          Card(
            child: Column(
              children: [
                _PermRow(
                    label: 'Call Log',
                    granted: _phoneGranted,
                    icon: Icons.call_rounded),
                const Divider(indent: 20, endIndent: 20, height: 1),
                _PermRow(
                    label: 'SMS',
                    granted: _smsGranted,
                    icon: Icons.sms_rounded),
                const Divider(indent: 20, endIndent: 20, height: 1),
                _PermRow(
                    label: 'Notifications',
                    granted: _notifGranted,
                    icon: Icons.notifications_rounded),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: OutlinedButton.icon(
              onPressed: () async {
                await PermissionManager.requestAllPermissions();
                _checkPermissions();
              },
              icon: const Icon(Icons.security_rounded),
              label: const Text('Re-check & Grant Permissions'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: OutlinedButton.icon(
              onPressed: () => openAppSettings(),
              icon: const Icon(Icons.settings_applications_rounded),
              label: const Text('Open System App Settings (Usage Access)'),
            ),
          ),

          // Sync interval
          _SectionHeader(title: 'BACKGROUND SYNC'),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Sync Interval',
                      style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [15, 30, 60].map((m) {
                      final label =
                          m == 60 ? '1 hour' : '$m min';
                      return ChoiceChip(
                        label: Text(label),
                        selected: _syncIntervalMinutes == m,
                        onSelected: (_) => _saveInterval(m),
                        selectedColor:
                            theme.colorScheme.primary.withOpacity(0.25),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),

          // Daily notification
          _SectionHeader(title: 'NOTIFICATIONS'),
          Card(
            child: SwitchListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              secondary: const Icon(Icons.notifications_active_rounded,
                  color: Colors.purpleAccent),
              title: const Text('Daily Summary at 9 PM',
                  style: TextStyle(color: Colors.white, fontSize: 14)),
              subtitle: const Text(
                  'Receive a summary of your screen time, calls, and SMS',
                  style: TextStyle(color: Colors.white38, fontSize: 12)),
              value: _dailyNotifEnabled,
              onChanged: _toggleDailyNotif,
              activeColor: theme.colorScheme.primary,
            ),
          ),

          // Danger zone
          _SectionHeader(title: 'DANGER ZONE'),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            child: OutlinedButton.icon(
              onPressed: _clearAllData,
              icon: const Icon(Icons.delete_forever_rounded,
                  color: Colors.redAccent),
              label: const Text('Clear All Data',
                  style: TextStyle(color: Colors.redAccent)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.redAccent),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white38,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _PermRow extends StatelessWidget {
  final String label;
  final bool granted;
  final IconData icon;
  const _PermRow(
      {required this.label, required this.granted, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      leading: Icon(icon,
          color: granted ? Colors.greenAccent : Colors.white38, size: 22),
      title: Text(label,
          style: const TextStyle(color: Colors.white, fontSize: 14)),
      trailing: Icon(
        granted
            ? Icons.check_circle_rounded
            : Icons.cancel_rounded,
        color: granted ? Colors.greenAccent : Colors.redAccent,
        size: 20,
      ),
    );
  }
}
