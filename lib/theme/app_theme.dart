import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Colors.pink;
  static const Color secondaryColor = Colors.pink;
  static const Color backgroundColor = Colors.white;
  static const Color scaffoldBackgroundColor = Color(0xFFF5F5F5);
  static const Color errorColor = Colors.red;
  static const Color successColor = Colors.green;
  static const Color textColor = Colors.black87;
  static const Color subtitleColor = Colors.black54;

  static ThemeData theme() {
    return ThemeData(
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        error: errorColor,
        background: backgroundColor,
      ),
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 28,
        ),
        displayMedium: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        displaySmall: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        headlineMedium: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        titleLarge: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        bodyLarge: TextStyle(
          color: textColor,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: textColor,
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          color: subtitleColor,
          fontSize: 12,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      useMaterial3: true,
    );
  }
}