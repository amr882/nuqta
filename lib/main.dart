import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nuqta/app.dart';
import 'package:nuqta/core/routes/app_router.dart';
import 'package:nuqta/core/routes/routes.dart';
import 'package:nuqta/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final bool isLoggedIn = FirebaseAuth.instance.currentUser != null;
  final String initialRoute =
      isLoggedIn ? Routes.homeScreen : Routes.onboarding;

  runApp(Nuqta(
    appRouter: AppRouter(),
    initialRoute: initialRoute,
  ));
}
