import 'package:flutter/material.dart';
import '../../../data/models/notification_model.dart';
import '../../../core/utils/formatters.dart';

class NotificationItem extends StatelessWidget {
  final NotificationModel notification;

  const NotificationItem({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: notification.isRead ? Colors.black : Colors.grey[900],
        border: Border(
          bottom: BorderSide(color: Colors.grey[800]!),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: _getIconColor(),
            child: Icon(
              _getIcon(),
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notification.message,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  Formatters.formatDate(notification.createdAt),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon() {
    if (notification.isLike) return Icons.favorite;
    if (notification.isComment) return Icons.comment;
    if (notification.isFollow) return Icons.person_add;
    if (notification.isGift) return Icons.card_giftcard;
    if (notification.isLive) return Icons.live_tv;
    return Icons.notifications;
  }

  Color _getIconColor() {
    if (notification.isLike) return Colors.red;
    if (notification.isComment) return Colors.blue;
    if (notification.isFollow) return Colors.green;
    if (notification.isGift) return Colors.purple;
    if (notification.isLive) return Colors.orange;
    return Colors.grey;
  }
}