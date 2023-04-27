import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:to_do_list/screens/create_task/create_new_task.dart';
import 'package:to_do_list/screens/list_task/list_tasks.dart';
import 'package:to_do_list/theme/colors/light_colors.dart';
import 'package:to_do_list/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:to_do_list/utils/custom_material_color.dart';
import 'package:to_do_list/utils/navigator_context.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // MobileAds.instance.initialize();
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
    CustomMaterialColor materialColor = CustomMaterialColor(42, 107, 92);
    return MaterialApp(
      theme: ThemeData(
        primaryColor: LightColors.kGreen,
        primarySwatch: materialColor.mdColor,
        fontFamily: 'Poppins',
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: LightColors.kGreen,
            systemNavigationBarColor: LightColors.kVGrey,
          ),
          color: LightColors.kGreen,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontFamily: 'Poppins',
          ),
        ),
        scaffoldBackgroundColor: LightColors.kVGrey,
      ),
      navigatorKey: NavigationService.navigatorKey,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: '/',
      routes: {
        '/list': (context) => const ListTasks(),
        '/form': (context) => const CreateNewTask(),
      },
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,
      home: const ListTasks(),
      debugShowCheckedModeBanner: false,
    );
  }
}

RateMyApp rateMyApp = RateMyApp(
  preferencesPrefix: 'Nous noter',
  minDays: 0, // Show rate popup on first day of install.
  minLaunches:
      5, // Show rate popup after 5 launches of app after minDays is passed.
);
