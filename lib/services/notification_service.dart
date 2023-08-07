// //import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:to_do_list/models/notification.dart';

// class NotificationService {
//   static final NotificationService _notificationService =
//       NotificationService._internal();

//   factory NotificationService() {
//     return _notificationService;
//   }

//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   NotificationService._internal();

//   Future<void> initNotification() async {
//     // Android initialization
//     AndroidInitializationSettings initializationSettingsAndroid =
//         const AndroidInitializationSettings('@mipmap/ic_launcher');

//     // ios initialization
//     final InitializationSettings initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);

//     // the initialization settings are initialized after they are setted
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

//   Future<void> showNotification(TNotification notification) async {
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       notification.taskId!,
//       notification.title!,
//       notification.description!,
//       // tz.TZDateTime.from(notification.dateTime!,
//       //  tz.local), //schedule the notification to show after 2 seconds.
//       tz.TZDateTime.now(tz.local).add(const Duration(seconds: 1)),
//       // const NotificationDetails(

//       //     // Android details
//       //     android: AndroidNotificationDetails('main_channel', 'Main Channel',
//       //         channelDescription: "ashwin",
//       //         importance: Importance.max,
//       //         priority: Priority.max),
//       //     // iOS details
//       //     iOS: null),
//       // // Type of time interpretation
//       // uiLocalNotificationDateInterpretation:
//       //     UILocalNotificationDateInterpretation
//       //         .absoluteTime, // To show notification even when the app is closed
//       //         androidAllowWhileIdle: true
//     );
//   }
// }
