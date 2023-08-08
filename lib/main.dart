import 'package:flutter/material.dart';
import 'package:to_do_list/screens/home_screen.dart';
import 'package:to_do_list/services/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() {
  // to ensure all the widgets are initialized.
  WidgetsFlutterBinding.ensureInitialized();

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

// Thème clair
  final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.white,
    //accentColor: Colors.black,
  );

// Thème sombre
  final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.black,

    //accentColor: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Tracker App',
      theme: lightTheme,
      themeMode: ThemeMode.dark,
      home: const HomeScreen(),
    );
  }
}
