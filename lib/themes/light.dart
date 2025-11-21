import 'package:flutter/material.dart';

final ColorScheme lightColorScheme = ColorScheme.light(
  surface: Colors.grey.shade300,
  primary: Colors.grey.shade600,
  secondary: Colors.grey.shade100,
  tertiary: Colors.white,
  inversePrimary: Colors.grey.shade900,
);

ThemeData lightMode = ThemeData(
  colorScheme: lightColorScheme,
  iconTheme: IconThemeData(color: lightColorScheme.inversePrimary),
);
