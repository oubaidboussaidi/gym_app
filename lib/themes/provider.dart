import 'package:flutter/material.dart';
import 'package:gym_app/themes/dark.dart';
import 'package:gym_app/themes/light.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themedata = darkMode;
  ThemeData get themeData => _themedata;
  bool get isDarkMode => _themedata == darkMode;

  set themeData(ThemeData td) {
    _themedata = td;
    notifyListeners();
  }

  void toggleThemeData() {
    if (isDarkMode) {
      themeData = lightMode;
      return;
    }
    themeData = darkMode;
  }
}