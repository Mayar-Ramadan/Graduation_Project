import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  
  static Position? _cachedPosition;
  static DateTime? _cachedTime;
  static const Duration _cacheMaxAge = Duration(minutes: 3);


  static LocationPermission? _cachedPermission;
  static DateTime? _permissionCacheTime;
  static const Duration _permissionCacheMaxAge = Duration(minutes: 5);


  static Future<Position?> getCurrentPosition({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _cachedPosition != null && _cachedTime != null) {
      final age = DateTime.now().difference(_cachedTime!);
      if (age < _cacheMaxAge) {        return _cachedPosition;
      }
    }


    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      _cachedPosition = position;
      _cachedTime = DateTime.now();
      return position;
    } catch (e) {
      return _cachedPosition;
    }
  }


  static Future<LocationPermission> getPermissionStatus({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _cachedPermission != null && _permissionCacheTime != null) {
      final age = DateTime.now().difference(_permissionCacheTime!);
      if (age < _permissionCacheMaxAge) {
        return _cachedPermission!;
      }
    }
    final permission = await Geolocator.checkPermission();
    _cachedPermission = permission;
    _permissionCacheTime = DateTime.now();
    return permission;
  }


  static Future<LocationPermission> requestLocationPermission() async {
    final permission = await Geolocator.requestPermission();
    _cachedPermission = permission;
    _permissionCacheTime = DateTime.now();
    return permission;
  }


  static Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }

static Future<String?> getCityFromPosition(Position position) async {
  try {

    final placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    if (placemarks.isNotEmpty) {
      return placemarks.first.locality ?? placemarks.first.administrativeArea;
    }
    return null;
  } catch (e) {
    print("⚠️ [LocationService] Failed to get city: $e");

    return null;
  }
}

  
  static void clearCache() {
    _cachedPosition = null;
    _cachedTime = null;
    _cachedPermission = null;
    _permissionCacheTime = null;
  }
}