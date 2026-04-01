import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../main.dart';
import '../../core/database/app_database.dart';
import '../../core/services/usage_stats_service.dart';
import '../../core/services/call_log_service.dart';
import '../../core/services/sms_service.dart';
import 'widgets/usage_summary_card.dart';
import 'widgets/top_apps_card.dart';
import 'widgets/hourly_chart_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _db = getIt<AppDatabase>();
  late final _usageService = UsageStatsService(_db);
  late final _callService = CallLogService(_db);
  late final _smsService = SmsService(_db);

  int _totalMs = 0;
  List<AppUsageTableData> _topApps = [];
  int _callCount = 0;
  int _smsCount = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    await _usageService.syncWeekUsage();
    await _callService.syncCallLogs();
    await _smsService.syncSms();

    final totalMs = await _usageService.getTodayTotalMs();
    final apps = await _usageService.getTodayUsage();
    final calls = await _callService.getTodayCalls();
    final sms = await _smsService.getTodaySms();

    setState(() {
      _totalMs = totalMs;
      _topApps = apps.take(5).toList();
      _callCount = calls.length;
      _smsCount = sms.length;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final today = DateFormat('EEEE, MMM d').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Dashboard',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
            Text(today,
                style:
                    const TextStyle(fontSize: 13, color: Colors.white54)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _load,
            icon: _loading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.colorScheme.primary,
                    ),
                  )
                : const Icon(Icons.refresh_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.only(bottom: 24),
                children: [
                  // Screen time hero card
                  UsageSummaryCard(
                    totalMs: _totalMs,
                    callCount: _callCount,
                    smsCount: _smsCount,
                  ),

                  // Top apps
                  if (_topApps.isNotEmpty) ...[
                    _SectionHeader(title: 'Top Apps Today'),
                    TopAppsCard(apps: _topApps, totalMs: _totalMs),
                  ],

                  // Hourly chart
                  _SectionHeader(title: 'Hourly Activity'),
                  HourlyChartWidget(apps: _topApps),
                ],
              ),
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
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
