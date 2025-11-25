import 'package:flutter/material.dart';

class ThemeException implements Exception {
  final String message;
  ThemeException(this.message);

  @override
  String toString() => "ThemeException: $message";
}

class ThemeService extends ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
