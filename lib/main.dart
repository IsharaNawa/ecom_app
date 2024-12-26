import 'package:ecom_app/constants/theme_data.dart';
import 'package:ecom_app/providers/theme_provider.dart';
import 'package:ecom_app/screens/auth_screens/forgot_password_screen.dart';
import 'package:ecom_app/screens/auth_screens/login_screen.dart';
import 'package:ecom_app/screens/auth_screens/signup_screen.dart';
import 'package:ecom_app/screens/root_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDarkmodeOn = ref.watch(darkModeThemeStatusProvider);

    return MaterialApp(
      title: 'ECom App',
      theme: Styles.themeData(isDarkTheme: isDarkmodeOn, context: context),
      home: const RootScreen(),
      // home: const LoginScreen(),
      // home: const SignupScreen(),
      // home: const ForgotPasswordScreen(),
    );
  }
}
