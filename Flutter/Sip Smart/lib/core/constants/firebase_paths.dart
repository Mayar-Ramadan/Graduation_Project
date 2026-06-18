// core/constants/firebase_paths.dart
class FirebasePaths {
  static const String root = 'debug_users'; 

  static String userPath(String uid) => '$root/$uid';
  static String waterReadingsPath(String uid) => '$root/$uid/water_readings';
}