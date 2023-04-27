import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:to_do_list/theme/colors/light_colors.dart';

ThemeData theme1 = ThemeData(
  primaryColor: LightColors.kGreen,
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
      )),
  scaffoldBackgroundColor: LightColors.kVGrey,
);
