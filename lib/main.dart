import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:to_do_list/screens/home_screen.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:to_do_list/services/notification_service.dart';

Future<void> main() async {
  // to ensure all the widgets are initialized.
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  // to initialize the notificationservice.
  NotificationService().initNotification();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
  }

  ThemeData lightTheme = ThemeData.light().copyWith(
    colorScheme: const ColorScheme.light(
      primary: Colors.blue,
      secondary: Colors.blueAccent,
    ),
    appBarTheme: const AppBarTheme(
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white)),
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.blue,
      textTheme: ButtonTextTheme.primary,
    ),
    iconTheme: const IconThemeData(
      color: Colors.blue,
    ),
  );

  ThemeData darkTheme = ThemeData.dark().copyWith(
    colorScheme: ColorScheme.dark(
      primary: Colors.blue.shade500,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey.shade900,
      elevation: 0,
    ),
    scaffoldBackgroundColor: Colors.grey.shade900,
    iconTheme: IconThemeData(color: Colors.blue.shade400),
    buttonTheme: ButtonThemeData(
      colorScheme: ColorScheme.dark(primary: Colors.grey.shade900),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Tracker App',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,
      home: const HomeScreen(),
    );
  }
}
