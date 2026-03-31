import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/database/app_database.dart';

class CallLogTile extends StatelessWidget {
  final CallLogTableData call;

  const CallLogTile({super.key, required this.call});

  @override
  Widget build(BuildContext context) {
    final info = _callTypeInfo(call.callType);
    final name = (call.name?.isNotEmpty == true) ? call.name! : call.number;
    final duration = _formatDuration(call.duration);
    final time = DateFormat('MMM d, h:mm a').format(call.timestamp);

    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: info.color.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(info.icon, color: info.color, size: 22),
      ),
      title: Text(
        name,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
      ),
      subtitle: Text(
        time,
        style: const TextStyle(color: Colors.white38, fontSize: 12),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            duration,
            style: TextStyle(
              color: info.color,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            info.label,
            style: const TextStyle(color: Colors.white38, fontSize: 11),
          ),
        ],
      ),
    );
  }

  _CallTypeInfo _callTypeInfo(String type) {
    switch (type) {
      case 'incoming':
        return _CallTypeInfo(
            Icons.call_received_rounded, Colors.greenAccent, 'Incoming');
      case 'outgoing':
        return _CallTypeInfo(
            Icons.call_made_rounded, Colors.blueAccent, 'Outgoing');
      case 'missed':
        return _CallTypeInfo(
            Icons.call_missed_rounded, Colors.redAccent, 'Missed');
      default:
        return _CallTypeInfo(Icons.call_rounded, Colors.grey, 'Unknown');
    }
  }

  String _formatDuration(int seconds) {
    if (seconds <= 0) return '—';
    final d = Duration(seconds: seconds);
    if (d.inHours > 0) return '${d.inHours}h ${d.inMinutes.remainder(60)}m';
    if (d.inMinutes > 0)
      return '${d.inMinutes}m ${d.inSeconds.remainder(60)}s';
    return '${d.inSeconds}s';
  }
}

class _CallTypeInfo {
  final IconData icon;
  final Color color;
  final String label;
  const _CallTypeInfo(this.icon, this.color, this.label);
}
