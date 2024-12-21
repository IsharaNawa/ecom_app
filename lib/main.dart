import 'package:ecom_app/constants/theme_data.dart';
import 'package:ecom_app/providers/theme_provider.dart';
import 'package:ecom_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            return ThemeProvider();
          },
        )
      ],
      child: Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'ECom App',
          theme: Styles.themeData(
              isDarkTheme: themeProvider.getIsDarkTheme, context: context),
          home: const HomeScreen(),
        );
      }),
    );
  }
}
