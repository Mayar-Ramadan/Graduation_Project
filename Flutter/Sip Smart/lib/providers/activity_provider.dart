import 'package:flutter/material.dart';

class ActivityProvider extends ChangeNotifier {
  bool _isActivitySkipped = false;
  bool get isActivitySkipped => _isActivitySkipped;

  void setActivitySkipped(bool value) {
    _isActivitySkipped = value;
    notifyListeners();
  }
}