import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gradution_project_smart_sip/core/constants/app_assets.dart';
import 'package:gradution_project_smart_sip/core/services/notification_engine.dart';
import 'package:gradution_project_smart_sip/l10n/app_localizations.dart';

import 'package:gradution_project_smart_sip/providers/app_provider.dart';
import 'package:provider/provider.dart';
import '../../routes/app_routes.dart';

class AnimatedSplashScreen extends StatefulWidget {
  const AnimatedSplashScreen({super.key});

  @override
  State<AnimatedSplashScreen> createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();
    _startLoadingAndNavigation();
  }

  void _startLoadingAndNavigation() async {
    if (_isNavigating) return;
    _isNavigating = true;

    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final startTime = DateTime.now();

    try {
      await appProvider.initializationFuture;
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final dbRef = FirebaseDatabase.instance.ref();
        final now = DateTime.now().millisecondsSinceEpoch;

        
        await dbRef.child('debug_users/${user.uid}').update({
          'email': user.email,
          'uid': user.uid,
          // 'time': now,
          'lastSeenTime': now, 
        });

        NotificationEngine().startListening(user.uid);
      }

      final route = user != null
          ? RoutesNames.dailyTracking
          : RoutesNames.onboarding;

      final elapsed = DateTime.now().difference(startTime);
      if (elapsed < const Duration(seconds: 2)) {
        await Future.delayed(const Duration(seconds: 2) - elapsed);
      }

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, route);
    } catch (e) {
      _isNavigating = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showInitializationErrorDialog();
      });
    }
  }

  void _showInitializationErrorDialog() {
    final s = AppLocalizations.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(s?.errorTitle ?? 'Error'),
        content: Text(s?.initializationFailed ??
            'Unable to initialize the app. Please check your connection and try again.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startLoadingAndNavigation();
            },
            child: Text(s?.retry ?? 'Retry'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (s == null) {
      return Scaffold(
        backgroundColor: theme.primaryColor,
        body: const Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              isDark ? Colors.black87 : const Color.fromARGB(255, 232, 235, 238),
              theme.primaryColor,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.8), width: 2),
                ),
                child: ClipOval(
                  child: Transform.scale(
                    scale: 1.5,
                    child: Image.asset(
                      AppAssets.logo,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                s.appName,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                s.appSubtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 70),
              AnimatedLoadingDots(controller: _controller),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedLoadingDots extends StatelessWidget {
  final AnimationController controller;
  const AnimatedLoadingDots({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LoadingDot(controller: controller, delay: 0),
        const SizedBox(width: 8),
        LoadingDot(controller: controller, delay: 100),
        const SizedBox(width: 8),
        LoadingDot(controller: controller, delay: 200),
      ],
    );
  }
}

class LoadingDot extends StatelessWidget {
  final AnimationController controller;
  final int delay;

  const LoadingDot({super.key, required this.controller, required this.delay});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final phaseShift = (delay / 1000) * (2 * pi);
        final pulseValue = (0.5 * sin(controller.value * 1.2 * pi + phaseShift)) + 0.5;
        final scaleFactor = 0.8 + (pulseValue * 0.4);
        return Transform.scale(
          scale: scaleFactor,
          child: Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}