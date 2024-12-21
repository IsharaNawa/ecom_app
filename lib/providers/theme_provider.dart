import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const String THEME_STATUS = "THEME_STATUS";
  bool _darkTheme = false;

  bool get getIsDarkTheme => _darkTheme;

  ThemeProvider() {
    getTheme();
  }

  setDarkTheme(bool value) async {
    SharedPreferences perfs = await SharedPreferences.getInstance();
    perfs.setBool(THEME_STATUS, value);
    _darkTheme = value;
    notifyListeners();
  }

  Future<bool> getTheme() async {
    SharedPreferences perfs = await SharedPreferences.getInstance();
    _darkTheme = perfs.getBool(THEME_STATUS) ?? false;
    notifyListeners();
    return _darkTheme;
  }
}
