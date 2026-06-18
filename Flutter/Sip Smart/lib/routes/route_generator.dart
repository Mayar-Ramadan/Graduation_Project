
import 'package:flutter/material.dart';
import 'package:gradution_project_smart_sip/presentation/auth/reset_password.dart';
import 'package:gradution_project_smart_sip/presentation/onboarding/onboarding_screen.dart';
import 'package:gradution_project_smart_sip/presentation/settings/appearance_screen.dart';
import 'package:gradution_project_smart_sip/presentation/settings/localization_screen.dart';
import 'package:gradution_project_smart_sip/presentation/splash/splash_screen.dart';
import '../presentation/auth/login_screen.dart';
import 'package:gradution_project_smart_sip/presentation/auth/register_screen.dart';
import 'package:gradution_project_smart_sip/presentation/home/home_screen.dart';
import 'package:gradution_project_smart_sip/routes/app_routes.dart'; 




class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    print('ROUTE REQUESTED => ${settings.name}');
    switch (settings.name) {

  // case '/':
  //   return MaterialPageRoute(
  //     builder: (_) => const LoginScreen(),
  //   );

  case RoutesNames.splash:
    return MaterialPageRoute(
      builder: (_) => const AnimatedSplashScreen(),
    );

 
      case RoutesNames.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());

      case RoutesNames.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
        
      case RoutesNames.register:
        return MaterialPageRoute(builder: (_) =>  CreateAccountScreen());

      case RoutesNames.resetPassword:
        return MaterialPageRoute(builder: (_) => const ResetPasswordScreen());
 
      case RoutesNames.dailyTracking:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      
      case RoutesNames.appearance:
        return MaterialPageRoute(builder: (_) => const AppearanceScreen());
      
      case RoutesNames.localization:
        return MaterialPageRoute(builder: (_) => const LocalizationScreen());

default:
  print('ROUTE NOT FOUND => ${settings.name}');

  return MaterialPageRoute(
    builder: (_) => Scaffold(
      body: Center(
        child: Text(
          'Route not found: ${settings.name}',
        ),
      ),
    ),
  );
    }
  }
}

