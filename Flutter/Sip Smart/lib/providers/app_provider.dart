import 'package:flutter/material.dart';
import 'package:gradution_project_smart_sip/core/preferences/app_preferences.dart';

class AppProvider extends ChangeNotifier {

  bool get isInitialized => _isInitialized;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isSystemTheme => _themeMode == ThemeMode.system;

  late final Future<void> initializationFuture;

  bool _isInitialized = false;
  Locale _locale = const Locale('en');
  ThemeMode _themeMode = ThemeMode.system;

  // Constructor
  AppProvider() {
    initializationFuture = _initializePreferences();
  }

  Future<void> _initializePreferences() async {
    try {
      _themeMode = await AppPreferences.loadThemeMode();
      _locale = await AppPreferences.loadLocale();
    } catch (e) {
     _themeMode = ThemeMode.system;
    _locale = const Locale('en');
     debugPrint("AppProvider init error: $e");
     
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  // Locale
  Locale get locale => _locale;

  Future<void> setLocale(Locale newLocale) async {
    if (_locale == newLocale) return;
    _locale = newLocale;
    await AppPreferences.saveLocale(newLocale);
    notifyListeners();
  }

  // Theme Mode
  ThemeMode get themeMode => _themeMode;

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    await AppPreferences.saveThemeMode(mode);
    notifyListeners();
  }
}



