import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({super.key, required double fontSize}) : _fontSize = fontSize;

  final double _fontSize;

  @override
  Widget build(BuildContext context) {
    final isDarkmodeOn = false;
    return Shimmer.fromColors(
      period: const Duration(seconds: 10),
      baseColor: isDarkmodeOn ? Colors.white : Colors.black,
      highlightColor: isDarkmodeOn ? Colors.black45 : Colors.white,
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
