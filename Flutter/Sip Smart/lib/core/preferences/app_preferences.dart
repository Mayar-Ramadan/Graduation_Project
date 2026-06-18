import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static const String _themeModeKey = 'theme_mode';
  static const String _localeKey = 'app_locale';


  // Manage (Theme Mode)
 
  static Future<ThemeMode> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final modeString = prefs.getString(_themeModeKey);

    if (modeString == null) {
      return ThemeMode.system;  
    }
    
 
    if (modeString == ThemeMode.light.toString()) {
      return ThemeMode.light;
    } else if (modeString == ThemeMode.dark.toString()) {
      return ThemeMode.dark;
    } else {
      return ThemeMode.system;
    }
  }


  static Future<void> saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, mode.toString());
  }

 
  // Manage (Locale)

  static Future<Locale> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_localeKey);

    if (languageCode == null) {
      return const Locale('en');
    }

    return Locale(languageCode);
  }

  
  static Future<void> saveLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }
}