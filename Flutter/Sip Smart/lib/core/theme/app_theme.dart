import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  // ---------- Light Theme ----------
static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.lightBackground,

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightBackground,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.lightText),
      titleTextStyle: TextStyle(
        color: AppColors.lightText,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        fontSize: 16,
        color: AppColors.lightText,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        color: AppColors.lightText,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        color: AppColors.lightText,
        fontWeight: FontWeight.bold,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      prefixIconColor: AppColors.primary,
      filled: true,
     fillColor: AppColors.lightInput,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      hintStyle: const TextStyle(color: Colors.grey),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );

  // ---------- Dark Theme ----------
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.darkBackground,
    
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.darkText),
      titleTextStyle: TextStyle(
        color: AppColors.darkText,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        fontSize: 16,
        color: AppColors.darkText,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: AppColors.darkText,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        color: AppColors.darkText,
        fontWeight: FontWeight.bold,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      prefixIconColor: AppColors.primary,
      filled: true,
      fillColor: Colors.white24,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      hintStyle: const TextStyle(color: Colors.grey),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );
}
