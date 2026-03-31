import 'package:flutter/material.dart';
import '../../main.dart';
import '../../core/database/app_database.dart';
import '../../core/services/usage_stats_service.dart';
import 'widgets/app_usage_list_tile.dart';
import 'widgets/usage_bar_chart.dart';

enum _DateFilter { today, week, month }

class AppUsageScreen extends StatefulWidget {
  const AppUsageScreen({super.key});

  @override
  State<AppUsageScreen> createState() => _AppUsageScreenState();
}

class _AppUsageScreenState extends State<AppUsageScreen> {
  final _db = getIt<AppDatabase>();
  late final _service = UsageStatsService(_db);

  _DateFilter _filter = _DateFilter.today;
  List<AppUsageTableData> _apps = [];
  int _totalMs = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    await _service.syncTodayUsage();

    final now = DateTime.now();
    DateTime start;
    switch (_filter) {
      case _DateFilter.today:
        start = DateTime(now.year, now.month, now.day);
        break;
      case _DateFilter.week:
        start = now.subtract(const Duration(days: 7));
        break;
      case _DateFilter.month:
        start = now.subtract(const Duration(days: 30));
        break;
    }

    final apps = await _service.getUsageForRange(start, now);
    final total = apps.fold(0, (s, a) => s + a.usageTimeMs);

    setState(() {
      _apps = apps;
      _totalMs = total;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Usage'),
        actions: [
          IconButton(
              onPressed: _load, icon: const Icon(Icons.refresh_rounded)),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: _DateFilter.values.map((f) {
                final labels = {
                  _DateFilter.today: 'Today',
                  _DateFilter.week: 'This Week',
                  _DateFilter.month: 'This Month',
                };
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(labels[f]!),
                    selected: _filter == f,
                    onSelected: (_) {
                      setState(() => _filter = f);
                      _load();
                    },
                    selectedColor:
                        theme.colorScheme.primary.withOpacity(0.25),
                  ),
                );
              }).toList(),
            ),
          ),

          if (_loading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else
            Expanded(
              child: ListView(
                children: [
                  if (_apps.isNotEmpty)
                    UsageBarChart(apps: _apps.take(5).toList(), totalMs: _totalMs),
                  ...(_apps.map((a) => AppUsageListTileWidget(
                        app: a,
                        totalMs: _totalMs,
                      ))),
                  if (_apps.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(40),
                      child: Center(
                        child: Text(
                          'No usage data yet.\nEnsure Usage Access permission is granted.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white38),
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
