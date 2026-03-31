import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/database/app_database.dart';
import '../../../core/services/usage_stats_service.dart';

class TopAppsCard extends StatelessWidget {
  final List<AppUsageTableData> apps;
  final int totalMs;

  const TopAppsCard({super.key, required this.apps, required this.totalMs});

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

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Bar chart
                Expanded(
                  flex: 3,
                  child: Column(
                    children: apps.asMap().entries.map((entry) {
                      final i = entry.key;
                      final app = entry.value;
                      final pct = totalMs > 0
                          ? app.usageTimeMs / totalMs
                          : 0.0;
                      final name = app.appName.split('.').last;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    name,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12),
                                  ),
                                ),
                                Text(
                                  UsageStatsService.formatDuration(
                                      app.usageTimeMs),
                                  style: TextStyle(
                                    color: colors[i % colors.length],
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: pct,
                                backgroundColor:
                                    colors[i % colors.length].withOpacity(0.15),
                                valueColor: AlwaysStoppedAnimation(
                                    colors[i % colors.length]),
                                minHeight: 6,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 20),
                // Pie chart
                SizedBox(
                  width: 100,
                  height: 100,
                  child: PieChart(
                    PieChartData(
                      sections: apps.asMap().entries.map((entry) {
                        final i = entry.key;
                        final app = entry.value;
                        final pct = totalMs > 0
                            ? (app.usageTimeMs / totalMs) * 100
                            : 0.0;
                        return PieChartSectionData(
                          value: pct,
                          color: colors[i % colors.length],
                          radius: 36,
                          showTitle: false,
                        );
                      }).toList(),
                      centerSpaceRadius: 20,
                      sectionsSpace: 2,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
