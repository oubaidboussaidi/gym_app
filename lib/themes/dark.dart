import 'package:flutter/material.dart';

final ColorScheme darkColorScheme = ColorScheme.dark(
  surface: const Color(0xFF121212),
  primary: Colors.deepOrange,
  secondary: const Color(0xFF1E1E1E),
  tertiary: const Color(0xFF2C2C2C),
  inversePrimary: Colors.white,
  onPrimary: Colors.white,
);

ThemeData darkMode = ThemeData(
  colorScheme: darkColorScheme,
  scaffoldBackgroundColor: darkColorScheme.surface,
  iconTheme: IconThemeData(color: darkColorScheme.inversePrimary),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: darkColorScheme.primary,
      foregroundColor: darkColorScheme.onPrimary,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: darkColorScheme.secondary,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: darkColorScheme.primary, width: 2),
    ),
  ),
);
