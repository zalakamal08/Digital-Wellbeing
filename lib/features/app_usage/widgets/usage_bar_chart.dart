import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/database/app_database.dart';
import '../../../core/services/usage_stats_service.dart';

class UsageBarChart extends StatelessWidget {
  final List<AppUsageTableData> apps;
  final int totalMs;

  const UsageBarChart({super.key, required this.apps, required this.totalMs});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = [
      theme.colorScheme.primary,
      Colors.pinkAccent,
      Colors.orangeAccent,
      Colors.greenAccent.shade400,
      Colors.cyanAccent,
    ];

    final sections = apps.asMap().entries.map((e) {
      final pct =
          totalMs > 0 ? (e.value.usageTimeMs / totalMs) * 100 : 0.0;
      final name = e.value.appName.split('.').last;
      return PieChartSectionData(
        value: pct,
        color: colors[e.key % colors.length],
        title: pct > 8 ? '${pct.toStringAsFixed(0)}%' : '',
        radius: 70,
        titleStyle: const TextStyle(
            fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
        badgeWidget: pct > 5
            ? _Badge(
                name: name,
                color: colors[e.key % colors.length],
              )
            : null,
        badgePositionPercentageOffset: 1.3,
      );
    }).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Top 5 Apps — Share of Screen Time',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: sections,
                  centerSpaceRadius: 40,
                  sectionsSpace: 3,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: apps.asMap().entries.map((e) {
                final name = e.value.appName.split('.').last;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: colors[e.key % colors.length],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$name · ${UsageStatsService.formatDuration(e.value.usageTimeMs)}',
                      style: const TextStyle(
                          color: Colors.white60, fontSize: 12),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String name;
  final Color color;
  const _Badge({required this.name, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        name.length > 8 ? '${name.substring(0, 8)}…' : name,
        style: const TextStyle(fontSize: 9, color: Colors.white70),
      ),
    );
  }
}
