import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActivityPromptService {
  static const String _promptKeyPrefix = 'activity_prompt_shown_';

  String _todayKey() {
    final now = DateTime.now();
    return '$_promptKeyPrefix${now.year}-${now.month}-${now.day}';
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<bool> shouldShowPromptToday() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return false;

    final prefs = await SharedPreferences.getInstance();
    final alreadyShownToday = prefs.getBool(_todayKey()) ?? false;

    if (alreadyShownToday) {
      return false;
      // return true;
    }

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();

    if (!doc.exists || doc.data() == null) {
      return true;
    }

    final data = doc.data()!;
    final activityDateRaw = data['activityDate'];

    if (activityDateRaw == null) {
      return true;
    }

    DateTime? activityDate;

    if (activityDateRaw is Timestamp) {
      activityDate = activityDateRaw.toDate();
    } else {
      activityDate = DateTime.tryParse(activityDateRaw.toString());
    }

    if (activityDate == null) {
      return true;
    }

    final today = DateTime.now();

    if (_isSameDay(activityDate, today)) {
      return false;
    }

    return true;
  }

  Future<void> markPromptShownToday() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_todayKey(), true);
  }

  Future<void> saveTodayActivity(String activityLevel) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .update({
      'activityDate': FieldValue.serverTimestamp(),
    });
  }
}