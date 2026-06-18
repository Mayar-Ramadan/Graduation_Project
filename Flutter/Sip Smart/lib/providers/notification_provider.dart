import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class NotificationProvider extends ChangeNotifier {
  List<Map<String, String>> _notifications = [];
  int _unreadCount = 0;

  List<Map<String, String>> get notifications => _notifications;
  int get unreadCount => _unreadCount;

  NotificationProvider() {
    _loadNotifications();
  }

  void addNotification(String title, String body) {
    _notifications.insert(0, {
      'title': title,
      'body': body,
      'timestamp': DateTime.now().toString(),
    });
    _unreadCount++;
    notifyListeners();
    _saveNotifications(); 
  }
  void markAllAsRead() {
    _unreadCount = 0;
    notifyListeners();
    _saveNotifications();
  }

  // save in SharedPreferences
  Future<void> _saveNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(_notifications);
      await prefs.setString('notifications', jsonString);
      await prefs.setInt('unreadCount', _unreadCount);
    } catch (e) {
      print('⚠️ Error saving notifications: $e');
    }
  }

  // load from SharedPreferences
  Future<void> _loadNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString('notifications');
      if (jsonString != null) {
        final List<dynamic> decoded = jsonDecode(jsonString);
        _notifications = decoded.map((item) => Map<String, String>.from(item)).toList();
      }
      _unreadCount = prefs.getInt('unreadCount') ?? 0;
      notifyListeners();
    } catch (e) {
      print('⚠️ Error loading notifications: $e');
    }
  }

  Future<void> clearAll() async {
    _notifications.clear();
    _unreadCount = 0;
    notifyListeners();
    await _saveNotifications();
  }


  Future<void> removeNotification(int index) async {
    if (index >= 0 && index < _notifications.length) {
      _notifications.removeAt(index);
      if (_unreadCount > 0) _unreadCount--;
      notifyListeners();
      await _saveNotifications();
    }
  }

  Future<void> reset() async {
    _notifications.clear();
    _unreadCount = 0;
    notifyListeners();
    await _saveNotifications();
  }
}