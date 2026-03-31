import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/database/app_database.dart';

class SmsLogTile extends StatelessWidget {
  final String contactName;
  final List<SmsLogTableData> messages;

  const SmsLogTile({
    super.key,
    required this.contactName,
    required this.messages,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lastMsg = messages.first;
    final lastTime = DateFormat('MMM d, h:mm a').format(lastMsg.timestamp);
    final initial =
        contactName.isNotEmpty ? contactName[0].toUpperCase() : '?';

    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
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
        contactName,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
      ),
      subtitle: Row(
        children: [
          Icon(
            lastMsg.kind == 'sent'
                ? Icons.upload_rounded
                : Icons.download_rounded,
            size: 13,
            color: lastMsg.kind == 'sent'
                ? Colors.blueAccent
                : Colors.greenAccent,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              lastMsg.body.length > 40
                  ? '${lastMsg.body.substring(0, 40)}…'
                  : lastMsg.body,
              style: const TextStyle(color: Colors.white54, fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            lastTime,
            style: const TextStyle(color: Colors.white38, fontSize: 11),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '${messages.length}',
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
