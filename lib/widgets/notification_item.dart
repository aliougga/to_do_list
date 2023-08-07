import 'package:flutter/material.dart';
import '../models/notification.dart' as app_notification;

class NotificationItem extends StatelessWidget {
  final app_notification.TNotification notification;

  const NotificationItem({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(notification.dateTime.toString()),
    );
  }
}
