import 'dart:async';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gradution_project_smart_sip/core/services/notification_service.dart';
import 'package:gradution_project_smart_sip/data/models/water_reading_model.dart';

class HydrationProvider with ChangeNotifier {
  double _currentAmount = 0.0;
  double _dailyGoal = 0.0;
  List<WaterReadingModel> _waterReadings = [];
  StreamSubscription<DatabaseEvent>? _waterReadingsSubscription;
  bool _isGoalNotifiedToday = false;

  // Getters
  double get currentAmount => _currentAmount;
  double get dailyGoal => _dailyGoal;
  List<WaterReadingModel> get waterReadings => _waterReadings;

  List<WaterReadingModel> get todayWaterReadings {
    final now = DateTime.now();
    return _waterReadings.where((reading) {
      final date = DateTime.fromMillisecondsSinceEpoch(reading.createdAt).toLocal();
      return date.year == now.year &&
          date.month == now.month &&
          date.day == now.day &&
          reading.status != "Spilling";
    }).toList();
  }

  bool get isEmpty => todayWaterReadings.isEmpty;
  double get remainingAmount => (_dailyGoal - _currentAmount).clamp(0, double.infinity);
  double get progress => (_dailyGoal <= 0) ? 0.0 : (_currentAmount / _dailyGoal).clamp(0.0, 1.0);
  double get progressPercentage => progress * 100;

  List<double> get weeklyConsumption => _calculateWeeklyConsumption();
  List<double> get monthlyTrend => weeklyConsumption;
  double get totalWeeklyAmount => weeklyConsumption.fold(0.0, (s, v) => s + v);
  double get weeklyAverage {
    final active = weeklyConsumption.where((v) => v > 0).length;
    return active == 0 ? 0.0 : totalWeeklyAmount / active;
  }
  double get bestDayValue => weeklyConsumption.isEmpty ? 0.0 : weeklyConsumption.reduce(max);
  double get lowestDayValue {
    final data = weeklyConsumption.where((v) => v > 0).toList();
    return data.isEmpty ? 0.0 : data.reduce(min);
  }
  String get bestDayName => _getDayLabel(weeklyConsumption.indexOf(bestDayValue));
  String get lowestDayName => _getDayLabel(weeklyConsumption.indexOf(lowestDayValue));
  int get streakDays => _calculateStreakDays();

  void setDailyGoalFromAi(double aiPredictionMl) {
    if (aiPredictionMl <= 0) return;
    _dailyGoal = aiPredictionMl;
    notifyListeners();
  }

 
  Future<void> addWaterReading({
    required double amount,
    required double remainingAmount,
    required String status,
    required String time,
    required String date,
    required String uid,
  }) async {
    try {
      final newReading = WaterReadingModel(
        amount: amount,
        remainingAmount: remainingAmount,
        status: status,
        time: time,
        date: date,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );

    
      final ref = FirebaseDatabase.instance
          .ref('debug_users/$uid/water_readings')
          .push();

      await ref.set(newReading.toMap());
      await _updateLastSeenTime(uid);
      
    } catch (e) {

      rethrow;
    }
  }


  Future<void> _updateLastSeenTime(String uid) async {
    final now = DateTime.now().millisecondsSinceEpoch;

    await FirebaseDatabase.instance
        .ref('debug_users/$uid')
        .update({'lastSeenTime': now});
  }

 
  void listenToWaterReadings({required String uid}) {
    _waterReadingsSubscription?.cancel();

    
    final ref = FirebaseDatabase.instance.ref('debug_users/$uid/water_readings');

    _waterReadingsSubscription = ref.onValue.listen(
      (event) async {
        try {
          final snapshot = event.snapshot;
          if (!snapshot.exists || snapshot.value == null) {
            _waterReadings = [];
            _currentAmount = 0.0;
            _isGoalNotifiedToday = false;
            notifyListeners();
            return;
          }

          final data = Map<dynamic, dynamic>.from(snapshot.value as Map);
          _waterReadings = data.values.map((value) {
            return WaterReadingModel.fromMap(Map<String, dynamic>.from(value as Map));
          }).toList();

          _waterReadings.sort((a, b) => b.createdAt.compareTo(a.createdAt));

          _currentAmount = _calculateTodayAmount();

          await _updateLastSeenTime(uid);

    
          await _checkAndNotifyGoal();

          notifyListeners();
         
        } catch (e) {
          print('⚠️ error $e');
        }
      },
      onError: (error) {
        print('⚠️ خطأ في Stream: $error');
      },
    );
  }

  Future<void> _checkAndNotifyGoal() async {
    final todayTotal = _calculateTodayAmount();
    if (_dailyGoal > 0 && todayTotal >= _dailyGoal && !_isGoalNotifiedToday) {
      _isGoalNotifiedToday = true;
      await NotificationService.showGoalAchieved(todayTotal);
    }
  }

 double _calculateTodayAmount() {
  return todayWaterReadings
      .where((reading) => reading.status == "Drank water") 
      .fold(0.0, (sum, item) => sum + item.amount);
}

List<double> _calculateWeeklyConsumption() {
  final now = DateTime.now();
  final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
  return List.generate(7, (index) {
    final day = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day + index);
    final readingsForDay = _waterReadings.where((reading) {
      final date = DateTime.fromMillisecondsSinceEpoch(reading.createdAt).toLocal();
   
      return date.year == day.year &&
          date.month == day.month &&
          date.day == day.day &&
          reading.status == "Drank water"; 
    });
    return readingsForDay.fold(0.0, (sum, item) => sum + item.amount);
  });
}

  int _calculateStreakDays() {
  int streak = 0;
  final now = DateTime.now();
  for (int i = 0; i < 30; i++) {
    final day = now.subtract(Duration(days: i));
    final totalForDay = _waterReadings.where((reading) {
      final date = DateTime.fromMillisecondsSinceEpoch(reading.createdAt).toLocal();
      return date.year == day.year &&
          date.month == day.month &&
          date.day == day.day &&
          reading.status == "Drank water"; 
    }).fold(0.0, (sum, item) => sum + item.amount);

    if (_dailyGoal > 0 && totalForDay >= _dailyGoal) {
      streak++;
    } else {
      break;
    }
  }
  return streak;
}

  String _getDayLabel(int index) {
    if (index == -1) return 'No Data';
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[index];
  }

  void resetProvider() {
    _currentAmount = 0.0;
    _dailyGoal = 0.0;
    _waterReadings = [];
    _isGoalNotifiedToday = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _waterReadingsSubscription?.cancel();
    super.dispose();
  }
}