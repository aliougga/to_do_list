import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:to_do_list/screens/create_new_task.dart';
import 'package:to_do_list/screens/list_tasks.dart';
import 'package:to_do_list/theme/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  return runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme1,
      title: 'Liste de tâches',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('fr', "FR")],
      initialRoute: '/',
      routes: {
        '/list': (context) => const ListTasks(),
        '/form': (context) => const CreateNewTask(),
      },
      home: const ListTasks(),
      debugShowCheckedModeBanner: false,
    );
  }
}

RateMyApp rateMyApp = RateMyApp(
  preferencesPrefix: 'Nous noter',
  minDays: 0, // Show rate popup on first day of install.
  minLaunches: 5, // Show rate popup after 5 launches of app after minDays is passed.
);
