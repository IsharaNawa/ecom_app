import 'package:ecom_app/constants/theme_data.dart';
import 'package:ecom_app/screens/auth_screens/forgot_password_screen.dart';
import 'package:ecom_app/screens/auth_screens/login_screen.dart';
import 'package:ecom_app/screens/auth_screens/signup_screen.dart';
import 'package:ecom_app/screens/root_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ECom App',
      theme: Styles.themeData(isDarkTheme: false, context: context),
      // home: const RootScreen(),
      // home: const LoginScreen(),
      // home: const SignupScreen(),
      home: const ForgotPasswordScreen(),
    );
  }
}
