import 'package:ecom_app/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({super.key, required double fontSize}) : _fontSize = fontSize;

  final double _fontSize;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Shimmer.fromColors(
      period: const Duration(seconds: 10),
      baseColor: themeProvider.getIsDarkTheme ? Colors.white : Colors.black,
      highlightColor:
          themeProvider.getIsDarkTheme ? Colors.black45 : Colors.white,
      child: Text(
        "DealVerse",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: _fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
