import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gradution_project_smart_sip/core/services/location_service.dart';
import 'package:gradution_project_smart_sip/core/services/weather_service.dart';
import 'package:gradution_project_smart_sip/data/datasources/ai/ai_service.dart';
import 'package:gradution_project_smart_sip/data/models/ai_prediction_summary_model.dart';
import 'package:gradution_project_smart_sip/data/repositories/ai_repository.dart';

class AiHelper {
  static Position? _cachedPosition;
  static DateTime? _cachedTime;
  static const Duration _cacheMaxAge = Duration(minutes: 3);

 
  static AiPredictionSummaryModel? _cachedResult;
  static DateTime? _resultCacheTime;
  static const Duration _resultCacheMaxAge = Duration(seconds: 30);


  static Future<AiPredictionSummaryModel?>? _pendingFuture;

  static String formatActivity(String activity) {
    final value = activity.trim();
    if (value.isEmpty) return '';
    return value[0].toUpperCase() + value.substring(1).toLowerCase();
  }

  static String formatGender(String gender) {
    final value = gender.trim();
    if (value.isEmpty) return '';
    return value[0].toUpperCase() + value.substring(1).toLowerCase();
  }

  static Future<AiPredictionSummaryModel?> getPrediction({
    required String fallbackActivity,
    bool forceRefresh = false,
  }) async {

    if (!forceRefresh && _cachedResult != null && _resultCacheTime != null) {
      final age = DateTime.now().difference(_resultCacheTime!);
      if (age < _resultCacheMaxAge) {
        return _cachedResult;
      }
    }

  
    if (_pendingFuture != null) {

      return _pendingFuture;
    }

    _pendingFuture = _fetchPrediction(fallbackActivity, forceRefresh);
    final result = await _pendingFuture;
    _pendingFuture = null;

    if (result != null) {
      _cachedResult = result;
      _resultCacheTime = DateTime.now();
    }
    return result;
  }

  static Future<AiPredictionSummaryModel?> _fetchPrediction(
    String fallbackActivity,
    bool forceRefresh,
  ) async {
    double temperature = 30.0;
    String activityText = fallbackActivity;
    bool usedSavedCoordinates = false;

    try {
     
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) throw Exception('No logged in user');

      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(currentUser.uid);
      final doc = await userDoc.get().timeout(const Duration(seconds: 5));
      if (!doc.exists || doc.data() == null) {
        throw Exception('User data not found in Firestore');
      }
      final data = doc.data()!;

     
      final age = int.tryParse(data['age']?.toString() ?? '');
      if (age == null || age <= 0) throw Exception('Invalid age');

      final genderText = formatGender(data['gender']?.toString() ?? '');
      if (genderText.isEmpty) throw Exception('Gender is missing');

      final firestoreActivity = data['activityLevel']?.toString().trim() ?? '';
      final safeFallbackActivity = fallbackActivity.trim();
      final rawActivity = safeFallbackActivity.isNotEmpty
          ? safeFallbackActivity
          : firestoreActivity;
      activityText = formatActivity(rawActivity);
      if (activityText.isEmpty) throw Exception('Activity level is missing');

      
      double? latitude;
      double? longitude;

      if (!forceRefresh && _cachedPosition != null && _cachedTime != null) {
        final ageOfCache = DateTime.now().difference(_cachedTime!);
        if (ageOfCache < _cacheMaxAge) {
          latitude = _cachedPosition!.latitude;
          longitude = _cachedPosition!.longitude;
          usedSavedCoordinates = false;
        
        }
      }

      if (latitude == null || longitude == null) {
        try {
          final permission = await LocationService.getPermissionStatus()
              .timeout(const Duration(seconds: 3));
          if (permission == LocationPermission.always ||
              permission == LocationPermission.whileInUse) {
            final Position? position = await LocationService
                .getCurrentPosition()
                .timeout(const Duration(seconds: 8));
            if (position != null) {
              _cachedPosition = position;
              _cachedTime = DateTime.now();
              latitude = position.latitude;
              longitude = position.longitude;
              usedSavedCoordinates = false;
              
            }
          }
        } catch (e) {
          print("⚠️ GPS/Position failed: $e");
        }
      }

      if (latitude == null || longitude == null) {
        final lat = (data['latitude'] as num?)?.toDouble();
        final lon = (data['longitude'] as num?)?.toDouble();
        if (lat != null && lon != null) {
          latitude = lat;
          longitude = lon;
          usedSavedCoordinates = true;
        }
      }

      if (latitude != null && longitude != null) {
        try {
          temperature = await WeatherService
              .getCurrentTemperatureByCoordinates(
                latitude: latitude,
                longitude: longitude,
              )
              .timeout(const Duration(seconds: 8));
            } catch (e) {
          print("⚠️ Weather fetch failed: $e");
        }
      } else {
        print("⚠️ No coordinates, using fallback temperature");
      }


      final repo = AiRepository(AiService());
      dynamic result;
      int retries = 3;
      while (retries > 0) {
        try {
          result = await repo
              .getPrediction([
                age,
                genderText,
                temperature,
                activityText,
              ])
              .timeout(const Duration(seconds: 15)); 
          break;
        } on TimeoutException {
          retries--;
          if (retries == 0) rethrow;
          print("⏳ Retrying AI call... ($retries attempts left)");
          await Future.delayed(const Duration(seconds: 2));
        }
      }

  
      double prediction;
      try {
        prediction = (result.prediction as num).toDouble();
      } catch (e) {
        prediction = double.tryParse(result.prediction.toString()) ?? 2.5;
        print("⚠️ Prediction conversion fallback: $prediction");
      }

      return AiPredictionSummaryModel(
        prediction: prediction,
        temperature: temperature,
        activity: activityText,
        usedSavedCoordinates: usedSavedCoordinates,
      );
    } catch (e) {
      print('❌ AI Error: $e');
      return AiPredictionSummaryModel(
        prediction: 2.5,
        temperature: temperature,
        activity: activityText,
        usedSavedCoordinates: usedSavedCoordinates,
      );
    }
  }
}