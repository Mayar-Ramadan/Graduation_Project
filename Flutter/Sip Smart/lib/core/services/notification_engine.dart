
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:gradution_project_smart_sip/providers/notification_provider.dart';
import 'package:provider/provider.dart';
import 'notification_service.dart';
import '../../main.dart';
import '../../l10n/app_localizations.dart';
import '../../core/utils/formatters.dart';

class NotificationEngine {
  NotificationEngine();

  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  StreamSubscription? _sub;
  Timer? _reminderTimer;

  DateTime? _lastSeenTime;
  bool _noDrinkNotified = false;
  DateTime? _lastDrinkTime;

  // ================= START =================

  Future<void> startListening(String uid) async {
    stop();

    final snapshot = await _db.child('debug_users/$uid').get();

    if (snapshot.exists && snapshot.value != null) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);

      final lastSeen = data['lastSeenTime'];

      if (lastSeen != null) {
        _lastSeenTime =
            DateTime.fromMillisecondsSinceEpoch(lastSeen);
      }
    }

    _lastSeenTime ??= DateTime.now();

    await _loadLastDrinkTime(uid);

    _startStream(uid);
    _startReminder(uid);
  }

  // ================= LOAD LAST DRINK TIME =================

  Future<void> _loadLastDrinkTime(String uid) async {
    try {
      final snapshot = await _db
          .child('debug_users/$uid/water_readings')
          .orderByChild('status')
          .equalTo('Drank water')
          .limitToLast(1)
          .get();

      if (snapshot.exists && snapshot.value != null) {
        final value = (snapshot.value as Map).values.first;
        if (value is Map) {
          final data = Map<String, dynamic>.from(value);
          final createdAt = data['createdAt'] ?? 0;
          _lastDrinkTime = DateTime.fromMillisecondsSinceEpoch(createdAt);
        }
      }
    } catch (e) {
      print('⚠️ Error loading last drink time: $e');
    }
  }

  // ================= STREAM =================

  void _startStream(String uid) {
    _sub = _db
        .child('debug_users/$uid/water_readings')
        .onChildAdded
        .listen((event) {
        
      final value = event.snapshot.value;

      if (value == null || value is! Map) return;

      final data = Map<String, dynamic>.from(value);
    

      final createdAt = data['createdAt'] ?? 0;
      
      final recordTime =
          DateTime.fromMillisecondsSinceEpoch(createdAt);

      if (_lastSeenTime != null &&
          recordTime.isBefore(_lastSeenTime!)) {
        return;
      }

      _handle(data);
    });
  }

  // ================= GET LOCALIZED TEXT =================

  String _getLocalizedText(String key, {Map<String, String>? args}) {
    final context = navigatorKey.currentContext;
    if (context == null) {
      // Fallback to English if context is not available
      switch (key) {
        case 'spillTitle':
          return '⚠️ Warning';
        case 'spillBody':
          return 'Water spill detected!';
        case 'drinkTitle':
          return '💙 Great Job!';
        case 'drinkBody':
          final amount = int.tryParse(args?['amount'] ?? '0') ?? 0;
          return 'You drank $amount ml water';
        case 'lowTitle':
          return '🚰 Low Water';
        case 'lowBody':
          return 'Please refill your bottle';
        case 'reminderTitle':
          return '💧 Stay Hydrated';
        case 'reminderBody':
          final hours = int.tryParse(args?['hours'] ?? '0') ?? 0;
          return 'You haven\'t drunk water for $hours hours';
        default:
          return '';
      }
    }

    final S = AppLocalizations.of(context)!;
    String result;
    switch (key) {
      case 'spillTitle':
        result = S.spillWarningTitle;
        break;
      case 'spillBody':
        result = S.spillWarningBody;
        break;
      case 'drinkTitle':
        result = S.drinkGreatTitle;
        break;
      case 'drinkBody':
        final amount = int.tryParse(args?['amount'] ?? '0') ?? 0;
        result = S.drinkGreatBody(amount);
        break;
      case 'lowTitle':
        result = S.lowWaterTitle;
        break;
      case 'lowBody':
        result = S.lowWaterBody;
        break;
      case 'reminderTitle':
        result = S.reminderTitle;
        break;
      case 'reminderBody':
        final hours = int.tryParse(args?['hours'] ?? '0') ?? 0;
        result = S.reminderBody(hours);
        break;
      default:
        result = '';
    }

    return AppFormatters.formatString(context, result);
  }

  // ================= HANDLE =================

 void _handle(Map<String, dynamic> data) {
  final status = data['status']?.toString() ?? '';
  final amount = (data['amount'] as num?)?.toDouble() ?? 0.0;

  String? title;
  String? body;

  if (status == "Spilling") {
    title = _getLocalizedText('spillTitle');
    body = _getLocalizedText('spillBody');
    NotificationService.showNotification(title: title, body: body);
  } 
  else if (status == "Drank water") {
    _noDrinkNotified = false;

    final createdAt = data['createdAt'] ?? 0;
    _lastDrinkTime = DateTime.fromMillisecondsSinceEpoch(createdAt);

    title = _getLocalizedText('drinkTitle');
    body = _getLocalizedText('drinkBody', args: {'amount': amount.toInt().toString()});
    NotificationService.showNotification(title: title, body: body);
  } 
  else if (status == "Remaining Water" && amount < 200) {
    title = _getLocalizedText('lowTitle');
    body = _getLocalizedText('lowBody');
    NotificationService.showNotification(title: title, body: body);
  }

  if (title != null && body != null) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      try {
        final provider = Provider.of<NotificationProvider>(context, listen: false);
        provider.addNotification(title, body);
      } catch (e) {
        print('⚠️ Could not add notification to provider: $e');
      }
    } else {
      print('⚠️ Context is null, cannot add notification to provider.');
    }
  }
}

  // ================= REMINDER =================

  void _startReminder(String uid) {
    _reminderTimer?.cancel();

    _reminderTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) async {
        if (_lastDrinkTime == null) {
          await _loadLastDrinkTime(uid);
          if (_lastDrinkTime == null) return;
        }

        final diff = DateTime.now().difference(_lastDrinkTime!);

        if (diff.inHours >= 2 && !_noDrinkNotified) {
          _noDrinkNotified = true;

          
          NotificationService.showNotification(
            title: _getLocalizedText('reminderTitle'),
            body: _getLocalizedText('reminderBody', args: {'hours': diff.inHours.toString()}),
          );
        }
      },
    );
  }

  // ================= STOP =================

  void stop() {
    _sub?.cancel();
    _reminderTimer?.cancel();
    _sub = null;
    _reminderTimer = null;
  }
}