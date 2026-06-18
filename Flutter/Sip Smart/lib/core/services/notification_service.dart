import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../main.dart';
import '../../l10n/app_localizations.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  
  static Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();
    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _plugin.initialize(settings);
  }

  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'hydration_channel',
      'Hydration Notifications',
      importance: Importance.high,
      priority: Priority.high,
      enableVibration: true,
      enableLights: true,
    );
    const DarwinNotificationDetails iosDetails =
        DarwinNotificationDetails();
    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final id = DateTime.now().millisecondsSinceEpoch % 100000;
    await _plugin.show(id, title, body, details);
  }


  static Future<void> showGoalAchieved(double total) async {
    final context = navigatorKey.currentContext;
    if (context != null) {
      final S = AppLocalizations.of(context)!;
      await showNotification(
        title: S.goalAchievedTitle,
        body: S.goalAchievedBody(total.toInt()),
      );
    } else {
      // Fallback to English
      await showNotification(
        title: '🎉 Well Done!',
        body: 'You reached your daily goal of ${total.toInt()} ml',
      );
    }
  }


  static Future<void> scheduleReminder() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'reminder_channel',
      'Hydration Reminder',
      importance: Importance.high,
      priority: Priority.high,
      enableVibration: true,
      enableLights: true,
    );
    const DarwinNotificationDetails iosDetails =
        DarwinNotificationDetails();
    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.periodicallyShow(
      999,
      '⏰ Time to drink water!',
      'Drink a glass of water to stay hydrated',
      RepeatInterval.hourly,
      details,
    );
  }
}