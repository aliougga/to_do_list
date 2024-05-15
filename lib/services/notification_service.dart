import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:to_do_list/models/notification.dart';
import 'package:to_do_list/utils/date_utils.dart';

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  Future<void> initNotification() async {
    // Android initialization
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    // ios initialization
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    // the initialization settings are initialized after they are setted
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(TNotification notification) async {
    var granted = await Permission.notification.isGranted;

    if (!granted) {
      Permission.notification.request();
    } else {
      await flutterLocalNotificationsPlugin.zonedSchedule(
          notification.taskId!,
          "Reminder",
          "You have ${notification.title!} at ${DateUtils.formatDateTime(notification.dateTime!)}",
          tz.TZDateTime.from(notification.dateTime!, tz.local),
          // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 1)),
          const NotificationDetails(
            android: AndroidNotificationDetails('channel id', 'channel name'),
          ),
          // androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time);
    }
  }

  Future<void> remokeNotification(int notificationId) async {
    await flutterLocalNotificationsPlugin.cancel(notificationId);
  }
}
