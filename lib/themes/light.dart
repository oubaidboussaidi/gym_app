import 'package:flutter/material.dart';

final ColorScheme lightColorScheme = ColorScheme.light(
  surface: Colors.grey.shade100,
  primary: Colors.deepOrange,
  secondary: Colors.grey.shade200,
  tertiary: Colors.white,
  inversePrimary: Colors.grey.shade900,
  onPrimary: Colors.white,
);

ThemeData lightMode = ThemeData(
  colorScheme: lightColorScheme,
  scaffoldBackgroundColor: lightColorScheme.surface,
  iconTheme: IconThemeData(color: lightColorScheme.inversePrimary),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: lightColorScheme.primary,
      foregroundColor: lightColorScheme.onPrimary,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: lightColorScheme.secondary,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: lightColorScheme.primary, width: 2),
    ),
  ),
);
