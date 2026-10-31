import 'package:firebase_auth/firebase_auth.dart';
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
      case Routes.loginScreen:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case Routes.signupScreen:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case Routes.homeScreen:
        final args = settings.arguments as String?;
        final currentUser = FirebaseAuth.instance.currentUser;
        final userId = (args != null && args.isNotEmpty)
            ? args
            : (currentUser?.email ??
                  currentUser?.displayName ??
                  currentUser?.uid ??
                  'User');
        return MaterialPageRoute(builder: (_) => HomeScreen(userId: userId));

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
