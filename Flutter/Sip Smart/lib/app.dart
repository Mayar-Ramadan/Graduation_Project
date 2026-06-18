import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gradution_project_smart_sip/l10n/app_localizations.dart';
import 'package:gradution_project_smart_sip/presentation/splash/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:gradution_project_smart_sip/providers/app_provider.dart';
import 'package:gradution_project_smart_sip/routes/route_generator.dart';
import 'core/theme/app_theme.dart';


import 'main.dart' as main; 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smartsip',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: appProvider.themeMode,
     
      navigatorKey: main.navigatorKey,
      
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('ar', ''),
      ],
      locale: appProvider.locale,
      onGenerateRoute: AppRouter.generateRoute,
      home: const AnimatedSplashScreen(),
    );
  }
}
