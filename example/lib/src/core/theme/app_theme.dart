import 'package:flutter/material.dart';

/// Centralized theme definitions for Light and Dark modes.
class AppTheme {
  AppTheme._();

  /// Light theme configuration using Material 3.
  static ThemeData get lightTheme => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF1A73E8),
      brightness: Brightness.light,
    ),
    useMaterial3: true,
    fontFamily: 'Roboto',
  );

  /// Dark theme configuration using Material 3.
  static ThemeData get darkTheme => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF8AB4F8),
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
    fontFamily: 'Roboto',
  );
}
