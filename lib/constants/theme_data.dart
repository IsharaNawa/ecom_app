import 'package:ecom_app/constants/app_colors.dart';
import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(
      {required bool isDarkTheme, required BuildContext context}) {
    return isDarkTheme
        ? ThemeData.dark()
        : ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            scaffoldBackgroundColor: AppColors.lightScaffoldColor,
            useMaterial3: true,
          );
  }
}
