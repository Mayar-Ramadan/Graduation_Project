import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gradution_project_smart_sip/core/constants/app_colors.dart';
import 'package:gradution_project_smart_sip/l10n/app_localizations.dart';
import 'package:gradution_project_smart_sip/presentation/profile/screen/profile_screen.dart';
import 'package:provider/provider.dart';

import 'package:gradution_project_smart_sip/core/services/activity_dailog_service.dart';
import 'package:gradution_project_smart_sip/core/services/location_service.dart';
import 'package:gradution_project_smart_sip/presentation/bottle/screens/connect_bottle_screen.dart';
import 'package:gradution_project_smart_sip/presentation/history/history_screen.dart';
import 'package:gradution_project_smart_sip/presentation/home/daily_tracking_view.dart';
import 'package:gradution_project_smart_sip/presentation/home/dialogs/activity_dialog.dart';
import 'package:gradution_project_smart_sip/presentation/home/dialogs/location_permission_dialog.dart';
import 'package:gradution_project_smart_sip/presentation/home/widgets/layout/bottom_nav_bar.dart';
import 'package:gradution_project_smart_sip/presentation/settings/settings_screen.dart';
import 'package:gradution_project_smart_sip/providers/hydration_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  int refreshKey = 0;
  bool _isLocationInitialized = false;
  bool _isActivityDialogShown = false;
  bool _isInitialized = false;
  final ActivityPromptService _activityPromptService = ActivityPromptService();

  bool _locationResult = false;       
  bool? _activityResult;              
  bool _locationFlowDone = false;
  bool _activityFlowDone = false;

  List<Widget> get _pages => [
        DailyTrackingView(key: ValueKey(refreshKey)),
        const HistoryScreen(),
        const SettingsScreen(),
        const ProfileScreen(),
        const ConnectBottleScreen(),
      ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_isInitialized) return;
      _isInitialized = true;

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

  
      Provider.of<HydrationProvider>(
        context,
        listen: false,
      ).listenToWaterReadings(
        uid: currentUser.uid,
      );

      await handleLocationPermissionFlow();
      await _checkTodayActivityPrompt();

      
    });
  }

  // ================= ACTIVITY DIALOG =================

  Future<void> _checkTodayActivityPrompt() async {
    if (_isActivityDialogShown) return;

    try {
      final shouldShow = await _shouldShowActivityDialog();
      if (!mounted || !shouldShow) {
        _activityResult = null; 
        _activityFlowDone = true;
        _checkAndShowFinalMessage();
        return;
      }

      _isActivityDialogShown = true;
      final selectedActivity = await showActivityDialog(context);

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(currentUser.uid);

      if (selectedActivity != null && selectedActivity.trim().isNotEmpty) {
        final activityValue = selectedActivity.trim().toLowerCase();
        await userDoc.set({
          'activityClosed': false,
          'activityLevel': activityValue,
          'activityDialogStatus': 'selected',
          'lastActivityDate': DateTime.now().toIso8601String().substring(0, 10),
        }, SetOptions(merge: true));

        await _activityPromptService.saveTodayActivity(activityValue);
        _activityResult = true;
      } else {
        await userDoc.set({
          'activityClosed': true,
          'activityDialogStatus': 'closed',
          'lastActivityDate': DateTime.now().toIso8601String().substring(0, 10),
        }, SetOptions(merge: true));
        _activityResult = false; 
      }

      if (!mounted) return;
      setState(() => refreshKey++);
    } catch (e) {
      print('DEBUG: _checkTodayActivityPrompt Error: $e');
      _activityResult = false;
    } finally {
      _activityFlowDone = true;
      _checkAndShowFinalMessage();
    }
  }

  Future<bool> _shouldShowActivityDialog() async {
  try {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return false;

    final userDoc =
        FirebaseFirestore.instance.collection('users').doc(currentUser.uid);
    final doc = await userDoc.get();

    if (!doc.exists) return true;

    final data = doc.data()!;
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final lastActivityDate = data['lastActivityDate'] as String?;
    final activityLevel = data['activityLevel'] as String?;

 
    if (activityLevel != null && activityLevel.isNotEmpty) {
      return false;
    }

    
    if (lastActivityDate == today) {
      return false;
    }


    return true;
  } catch (e) {
    return true;
  }
}

  // ================= LOCATION PERMISSION =================

  Future<void> handleLocationPermissionFlow() async {

    if (_isLocationInitialized) {
      _locationResult = true; 
      _locationFlowDone = true;
      _checkAndShowFinalMessage();
      return;
    }

    try {
      final permission = await LocationService.getPermissionStatus();

      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        await setupLocationIfNeeded();
        _locationResult = true;
      } else if (permission == LocationPermission.deniedForever) {
        _showSettingsSnackBar();
        _locationResult = false;
      } else if (permission == LocationPermission.denied) {
        final userAgreed = await showLocationPermissionDialog(context);

        if (userAgreed == true) {
          final requestedPermission =
              await LocationService.requestLocationPermission();

          if (requestedPermission == LocationPermission.always ||
              requestedPermission == LocationPermission.whileInUse) {
            await setupLocationIfNeeded();
            _locationResult = true;
          } else if (requestedPermission == LocationPermission.deniedForever) {
            _showSettingsSnackBar();
            _locationResult = false;
          } else {
            _locationResult = false;
          }
        } else {
          _locationResult = false;
        }
      }
    } catch (e) {

      _locationResult = false;
    } finally {
      _locationFlowDone = true;
      _checkAndShowFinalMessage();
    }
  }

  Future<void> setupLocationIfNeeded() async {
    if (_isLocationInitialized) return;
    _isLocationInitialized = true;

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        _isLocationInitialized = false;
        return;
      }

      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(currentUser.uid);

      final position = await LocationService.getCurrentPosition();

      if (position != null) {
        final city = await LocationService.getCityFromPosition(position);

        if (city != null) {
          await userDoc.set({
            'location': city,
            'latitude': position.latitude,
            'longitude': position.longitude,
          }, SetOptions(merge: true));

          if (!mounted) return;
          setState(() => refreshKey++);
        }
      }
    } catch (e) {

      _isLocationInitialized = false;
    }
  }

  void _showSettingsSnackBar() {
    if (!mounted) return;
    final S = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(S.locationDenied),
        action: SnackBarAction(
          label: S.settings,
          onPressed: () async {
            await LocationService.openAppSettings();
          },
        ),
      ),
    );
  }

  // ================= FINAL MESSAGE =================

  void _checkAndShowFinalMessage() {
   
    if (!_locationFlowDone || !_activityFlowDone) return;

    
    if (_activityResult == null) return;

    final S = AppLocalizations.of(context)!;
    String message;
    Color? backgroundColor;

    if (_locationResult && _activityResult == true) {
   
      message = S.onboarding_complete_message;
      backgroundColor = AppColors.success;
    } else if (_locationResult && _activityResult == false) {
      
      message = S.activity_skipped_message;
      backgroundColor = AppColors.warning;
    } else if (!_locationResult && _activityResult == true) {
      
      message = S.location_skipped_message;
      backgroundColor = AppColors.warning;
    } else {
      
      message = S.both_skipped_message;
      backgroundColor = AppColors.danger;
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 4),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  // ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}