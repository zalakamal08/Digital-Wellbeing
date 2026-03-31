import 'package:flutter/material.dart';
import '../../../core/database/app_database.dart';
import '../../../shared/widgets/stat_chip.dart';

class CallStatsCard extends StatelessWidget {
  final List<CallLogTableData> calls;

  const CallStatsCard({super.key, required this.calls});

  @override
  Widget build(BuildContext context) {
    // Today's calls
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayCalls =
        calls.where((c) => c.timestamp.isAfter(todayStart)).toList();

    final incoming =
        todayCalls.where((c) => c.callType == 'incoming').length;
    final outgoing =
        todayCalls.where((c) => c.callType == 'outgoing').length;
    final missed =
        todayCalls.where((c) => c.callType == 'missed').length;
    final totalSecs =
        todayCalls.fold(0, (s, c) => s + c.duration);
    final avgSecs =
        todayCalls.isNotEmpty ? totalSecs ~/ todayCalls.length : 0;

    // Most called contact
    final countMap = <String, int>{};
    for (final c in calls) {
      final key = c.name?.isNotEmpty == true ? c.name! : c.number;
      countMap[key] = (countMap[key] ?? 0) + 1;
    }
    String mostCalled = '—';
    if (countMap.isNotEmpty) {
      mostCalled =
          countMap.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'TODAY\'S CALL SUMMARY',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                StatChip(
                  label: 'Incoming',
                  value: incoming.toString(),
                  icon: Icons.call_received_rounded,
                  color: Colors.greenAccent,
                ),
                StatChip(
                  label: 'Outgoing',
                  value: outgoing.toString(),
                  icon: Icons.call_made_rounded,
                  color: Colors.blueAccent,
                ),
                StatChip(
                  label: 'Missed',
                  value: missed.toString(),
                  icon: Icons.call_missed_rounded,
                  color: Colors.redAccent,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _InfoRow(
                    label: 'Avg Duration',
                    value: _formatSecs(avgSecs),
                  ),
                ),
                Expanded(
                  child: _InfoRow(
                    label: 'Most Called',
                    value: mostCalled.length > 12
                        ? '${mostCalled.substring(0, 12)}…'
                        : mostCalled,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatSecs(int secs) {
    if (secs <= 0) return '—';
    final d = Duration(seconds: secs);
    if (d.inMinutes > 0)
      return '${d.inMinutes}m ${d.inSeconds.remainder(60)}s';
    return '${secs}s';
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(color: Colors.white38, fontSize: 11)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14)),
      ],
    );
  }
}
