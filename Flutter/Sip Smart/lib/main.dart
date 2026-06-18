import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gradution_project_smart_sip/app.dart';
import 'package:gradution_project_smart_sip/providers/activity_provider.dart';
import 'package:gradution_project_smart_sip/providers/app_provider.dart';
import 'package:gradution_project_smart_sip/providers/auth_provider.dart';
import 'package:gradution_project_smart_sip/providers/hydration_provider.dart';
import 'package:gradution_project_smart_sip/core/services/notification_service.dart';
import 'package:gradution_project_smart_sip/providers/notification_provider.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationService.init();

  final appProvider = AppProvider();
  await appProvider.initializationFuture;

  runApp(
    MultiProvider(
      providers: [

        ChangeNotifierProvider.value(value: appProvider),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HydrationProvider()),
        ChangeNotifierProvider(create: (_) => ActivityProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
