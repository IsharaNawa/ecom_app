import 'package:ecom_app/providers/cart_provider.dart';
import 'package:ecom_app/providers/wishlist_provider.dart';
import 'package:ecom_app/screens/auth_screens/login_screen.dart';
import 'package:ecom_app/screens/auth_screens/signup_screen.dart';
import 'package:ecom_app/screens/navigator_screens/root_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecom_app/constants/theme_data.dart';
import 'package:ecom_app/providers/theme_provider.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDarkmodeOn = ref.watch(darkModeThemeStatusProvider);

    return FutureBuilder<FirebaseApp>(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(
              title: 'ECom App[Firebase Loading]',
              theme:
                  Styles.themeData(isDarkTheme: isDarkmodeOn, context: context),
              home: const Scaffold(
                body: Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              ),
            );
          }

          if (snapshot.hasError) {
            return MaterialApp(
              title: 'ECom App[Firebase Error]',
              theme:
                  Styles.themeData(isDarkTheme: isDarkmodeOn, context: context),
              home: Scaffold(
                body: Center(
                  child: Column(
                    children: [
                      Text(
                        snapshot.error.toString(),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return MaterialApp(
            title: 'ECom App',
            theme:
                Styles.themeData(isDarkTheme: isDarkmodeOn, context: context),
            home: const RootScreen(),
            // home: const LoginScreen(),
            // home: const SignupScreen(),
            // home: const ForgotPasswordScreen(),
          );
        });
  }
}
