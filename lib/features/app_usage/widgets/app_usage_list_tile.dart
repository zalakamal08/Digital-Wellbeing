import 'package:flutter/material.dart';
import '../../../core/database/app_database.dart';
import '../../../core/services/usage_stats_service.dart';

class AppUsageListTileWidget extends StatelessWidget {
  final AppUsageTableData app;
  final int totalMs;

  const AppUsageListTileWidget({
    super.key,
    required this.app,
    required this.totalMs,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pct = totalMs > 0 ? app.usageTimeMs / totalMs : 0.0;
    final name = app.appName.split('.').last;
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
        child: Text(
          initial,
          style: TextStyle(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      title: Text(
        name,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
              valueColor:
                  AlwaysStoppedAnimation(theme.colorScheme.primary),
              minHeight: 4,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Last used: ${_formatTime(app.lastUsed)}',
            style: const TextStyle(color: Colors.white38, fontSize: 11),
          ),
        ],
      ),
      trailing: Text(
        UsageStatsService.formatDuration(app.usageTimeMs),
        style: TextStyle(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour;
    final min = dt.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$min $period';
  }
}
