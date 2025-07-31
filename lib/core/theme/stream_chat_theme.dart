import 'package:flutter/material.dart';

class StreamChatAppTheme {
  // Stream Chat's default color scheme
  static const Color primaryColor = Color(0xFF0052CC);
  static const Color secondaryColor = Color(0xFF42526E);
  static const Color backgroundColor = Color(0xFFF4F5F7);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color errorColor = Color(0xFFDE350B);
  static const Color successColor = Color(0xFF36B37E);
  static const Color warningColor = Color(0xFFFF8B00);
  
  // Text colors
  static const Color primaryTextColor = Color(0xFF172B4D);
  static const Color secondaryTextColor = Color(0xFF42526E);
  static const Color disabledTextColor = Color(0xFF97A0AF);
  
  // Border colors
  static const Color borderColor = Color(0xFFDFE1E6);
  static const Color dividerColor = Color(0xFFE3E5E8);
  
  // Stream Chat header colors (based on their default theme)
  static const Color headerBackgroundColor = Color(0xFF0052CC);
  static const Color headerForegroundColor = Color(0xFFFFFFFF);
  
  // Floating action button colors
  static const Color fabBackgroundColor = Color(0xFF0052CC);
  static const Color fabForegroundColor = Color(0xFFFFFFFF);
  
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: headerBackgroundColor,
        foregroundColor: headerForegroundColor,
        elevation: 1,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: headerForegroundColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: fabBackgroundColor,
        foregroundColor: fabForegroundColor,
        elevation: 4,
        shape: CircleBorder(),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        filled: true,
        fillColor: surfaceColor,
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: dividerColor,
        thickness: 1,
      ),
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: primaryTextColor,
        onError: Colors.white,
      ),
    );
  }
} 