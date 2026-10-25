import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nuqta/core/routes/app_router.dart';
import 'package:nuqta/core/routes/routes.dart';
import 'package:nuqta/generated/l10n.dart';
import 'package:sizer/sizer.dart';

class Nuqta extends StatelessWidget {
  final AppRouter appRouter;
  const Nuqta({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          theme: ThemeData(
            useMaterial3: true,
            fontFamily: GoogleFonts.notoSans().fontFamily,
            fontFamilyFallback: [
              GoogleFonts.notoSansArabic().fontFamily ?? 'Noto Sans Arabic',
            ],
          ),
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          debugShowCheckedModeBanner: false,
          title: 'Nuqta',
          onGenerateRoute: appRouter.generateRoute,
          initialRoute: Routes.onboarding,
        );
      },
    );
  }
}
