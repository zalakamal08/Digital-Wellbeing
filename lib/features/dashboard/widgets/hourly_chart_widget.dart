import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/database/app_database.dart';

class HourlyChartWidget extends StatelessWidget {
  final List<AppUsageTableData> apps;

  const HourlyChartWidget({super.key, required this.apps});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Build synthetic hourly data from usage (spread across day hours)
    final Map<int, double> hourlyData = {};
    for (int h = 0; h < 24; h++) {
      hourlyData[h] = 0;
    }
    // Distribute top app usage across typical usage hours as demo
    final totalMs = apps.fold(0, (sum, a) => sum + a.usageTimeMs);
    if (totalMs > 0) {
      final peakHours = [9, 10, 12, 14, 16, 18, 20, 21, 22];
      for (final app in apps) {
        final perHour = app.usageTimeMs / peakHours.length;
        for (final h in peakHours) {
          final jitter = (app.usageTimeMs % (h + 1)) / 60000;
          hourlyData[h] = (hourlyData[h]! + perHour / 60000) + jitter;
        }
      }
    }

    final bars = hourlyData.entries
        .map((e) => BarChartGroupData(
              x: e.key,
              barRods: [
                BarChartRodData(
                  toY: e.value.clamp(0, 60),
                  color: theme.colorScheme.primary.withOpacity(0.8),
                  width: 8,
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(4)),
                ),
              ],
            ))
        .toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Screen time by hour (minutes)',
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 160,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barGroups: bars,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 15,
                    getDrawingHorizontalLine: (v) => FlLine(
                      color: Colors.white12,
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 15,
                        getTitlesWidget: (v, m) => Text(
                          '${v.toInt()}m',
                          style: const TextStyle(
                              color: Colors.white38, fontSize: 9),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        interval: 4,
                        getTitlesWidget: (v, m) {
                          final h = v.toInt();
                          final label = h == 0
                              ? '12a'
                              : h == 12
                                  ? '12p'
                                  : h > 12
                                      ? '${h - 12}p'
                                      : '${h}a';
                          return Text(label,
                              style: const TextStyle(
                                  color: Colors.white38, fontSize: 9));
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
