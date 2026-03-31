import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/permissions/permission_manager.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool _phoneGranted = false;
  bool _smsGranted = false;
  bool _notifGranted = false;
  bool _usageGranted = false; // user must manually enable in settings

  @override
  void initState() {
    super.initState();
    _checkExistingPermissions();
  }

  Future<void> _checkExistingPermissions() async {
    final phone = await Permission.phone.isGranted;
    final sms = await Permission.SMS.isGranted;
    final notif = await Permission.notification.isGranted;
    if (mounted) {
      setState(() {
        _phoneGranted = phone;
        _smsGranted = sms;
        _notifGranted = notif;
      });
    }
    // If all granted, skip onboarding
    if (phone && sms && notif) {
      _proceedToDashboard();
    }
  }

  Future<void> _requestPermissions() async {
    final statuses = await PermissionManager.requestAllPermissions();
    setState(() {
      _phoneGranted = statuses[Permission.phone]?.isGranted ?? false;
      _smsGranted = statuses[Permission.SMS]?.isGranted ?? false;
      _notifGranted = statuses[Permission.notification]?.isGranted ?? false;
    });
  }

  void _proceedToDashboard() {
    if (mounted) context.go('/dashboard');
  }

  bool get _canProceed => _phoneGranted && _smsGranted && _notifGranted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF12121F),
              const Color(0xFF1A1A35),
              theme.colorScheme.primary.withOpacity(0.15),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                // Hero icon
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: theme.colorScheme.primary.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.shield_moon_rounded,
                    color: theme.colorScheme.primary,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Welcome to\nMyDigitalWellbeing',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'To track your digital habits, we need a few permissions. Your data stays on-device and is never shared.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white60,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),
                // Permission checklist
                Expanded(
                  child: Column(
                    children: [
                      _PermissionTile(
                        icon: Icons.phone_in_talk_rounded,
                        title: 'Call Log Access',
                        subtitle: 'Track incoming, outgoing & missed calls',
                        granted: _phoneGranted,
                        color: Colors.greenAccent,
                      ),
                      const SizedBox(height: 12),
                      _PermissionTile(
                        icon: Icons.message_rounded,
                        title: 'SMS Access',
                        subtitle: 'Monitor SMS activity by contact',
                        granted: _smsGranted,
                        color: Colors.blueAccent,
                      ),
                      const SizedBox(height: 12),
                      _PermissionTile(
                        icon: Icons.notifications_rounded,
                        title: 'Notifications',
                        subtitle: 'Daily 9 PM wellbeing summary',
                        granted: _notifGranted,
                        color: Colors.purpleAccent,
                      ),
                      const SizedBox(height: 12),
                      _UsageAccessTile(
                        granted: _usageGranted,
                        onOpen: () async {
                          await openAppSettings();
                          setState(() => _usageGranted = true);
                        },
                      ),
                    ],
                  ),
                ),
                // CTA buttons
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _requestPermissions,
                        icon: const Icon(Icons.security_rounded),
                        label: const Text('Grant Permissions'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _canProceed ? _proceedToDashboard : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _canProceed
                              ? Colors.greenAccent.shade700
                              : Colors.grey.shade800,
                        ),
                        child: const Text('Continue to Dashboard →'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PermissionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool granted;
  final Color color;

  const _PermissionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.granted,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: granted
            ? color.withOpacity(0.1)
            : const Color(0xFF1E1E2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: granted ? color.withOpacity(0.5) : const Color(0xFF2A2A3E),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: granted ? color : Colors.white38, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15)),
                Text(subtitle,
                    style: const TextStyle(
                        color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
          Icon(
            granted ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
            color: granted ? color : Colors.white30,
          ),
        ],
      ),
    );
  }
}

class _UsageAccessTile extends StatelessWidget {
  final bool granted;
  final VoidCallback onOpen;

  const _UsageAccessTile({required this.granted, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: granted
            ? Colors.orangeAccent.withOpacity(0.1)
            : const Color(0xFF1E1E2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: granted
              ? Colors.orangeAccent.withOpacity(0.5)
              : const Color(0xFF2A2A3E),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.bar_chart_rounded,
              color: granted ? Colors.orangeAccent : Colors.white38, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Usage Access',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15)),
                const Text(
                  'Required for screen time tracking\n(Opens System Settings)',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: granted ? null : onOpen,
            child: Text(granted ? '✓' : 'Open',
                style: TextStyle(
                    color: granted ? Colors.green : Colors.orangeAccent)),
          ),
        ],
      ),
    );
  }
}
