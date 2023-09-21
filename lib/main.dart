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

// Thème clair
  final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.white,
    fontFamily: 'Poppins',
    //accentColor: Colors.black,
  );

// Thème sombre
  final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.black,
    fontFamily: 'Poppins',

    //accentColor: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Tracker App',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
