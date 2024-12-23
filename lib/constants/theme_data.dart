import 'package:ecom_app/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles {
  static ThemeData themeData(
      {required bool isDarkTheme, required BuildContext context}) {
    return isDarkTheme
        ? ThemeData.dark().copyWith(
            navigationBarTheme: const NavigationBarThemeData(
              backgroundColor: Colors.black,
              elevation: 0,
            ),
            textTheme: GoogleFonts.ubuntuTextTheme().copyWith(
              titleSmall: GoogleFonts.ubuntu(
                color: Colors.white,
              ),
              bodyMedium: GoogleFonts.ubuntu(
                color: Colors.white,
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40), // Rounded corners
                ),
              ),
            ),
          )
        : ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.greenAccent,
            ),
            scaffoldBackgroundColor: AppColors.lightScaffoldColor,
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.lightScaffoldColor,
              elevation: 0,
            ),
            navigationBarTheme: const NavigationBarThemeData(
              backgroundColor: AppColors.lightScaffoldColor,
              elevation: 0,
            ),
            textTheme: GoogleFonts.ubuntuTextTheme().copyWith(
              titleSmall: GoogleFonts.ubuntu(
                color: Colors.black,
              ),
              bodyMedium: GoogleFonts.ubuntu(
                color: Colors.black,
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40), // Rounded corners
                ),
              ),
            ),
          );
  }
}
