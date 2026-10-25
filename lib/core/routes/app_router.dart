import 'package:flutter/material.dart';
import 'package:nuqta/core/routes/routes.dart';
import 'package:nuqta/feature/auth/presentation/login/login_screen.dart';
import 'package:nuqta/feature/auth/presentation/signup/signup_screen.dart';
import 'package:nuqta/feature/home/ui/home_screen.dart';
import 'package:nuqta/feature/onboarding/ui/onboarding.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.onboarding:
        return MaterialPageRoute(builder: (_) => const Onboarding());

      case Routes.homeScreen:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case Routes.loginScreen:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case Routes.signupScreen:
        return MaterialPageRoute(builder: (_) => const SignupScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
