import 'package:flutter/material.dart';
import '../../../core/services/usage_stats_service.dart';
import '../../../shared/widgets/stat_chip.dart';

class UsageSummaryCard extends StatelessWidget {
  final int totalMs;
  final int callCount;
  final int smsCount;

  const UsageSummaryCard({
    super.key,
    required this.totalMs,
    required this.callCount,
    required this.smsCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenTime = UsageStatsService.formatDuration(totalMs);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withOpacity(0.3),
            theme.colorScheme.primary.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TOTAL SCREEN TIME TODAY',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            screenTime,
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontSize: 48,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              StatChip(
                label: 'Calls today',
                value: callCount.toString(),
                icon: Icons.call_rounded,
                color: Colors.greenAccent,
              ),
              const SizedBox(width: 12),
              StatChip(
                label: 'SMS today',
                value: smsCount.toString(),
                icon: Icons.sms_rounded,
                color: Colors.blueAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
