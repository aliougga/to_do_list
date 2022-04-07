import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:to_do_list/theme/colors/light_colors.dart';

//appliqué sur la list_task.dart
ThemeData theme1 = ThemeData(
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: LightColors.kGreen,
      systemNavigationBarColor:LightColors.kVGrey,
    ),
    color: LightColors.kGreen,
    centerTitle: false,
  ),
  scaffoldBackgroundColor: LightColors.kVGrey,
);
