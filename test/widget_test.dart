import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nuqta/app.dart';
import 'package:nuqta/core/routes/app_router.dart';
import 'package:nuqta/feature/onboarding/component/onboarding_dot_indicator.dart';

void main() {
  testWidgets('Onboarding screen renders all pages with Noto fonts, SVGs, and dot indicator',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(Nuqta(appRouter: AppRouter()));
    await tester.pumpAndSettle();

    expect(find.text('Skip'), findsOneWidget);
    expect(find.text('عربي | EN'), findsOneWidget);

    expect(find.text("See what's open now"), findsOneWidget);
    expect(
      find.text('Find pharmacies, hospitals, bakeries and\npolice near you.'),
      findsOneWidget,
    );

    expect(find.byType(OnboardingDotIndicator), findsOneWidget);

    expect(find.text('Next'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Pick any hour'), findsOneWidget);
    expect(
      find.text('Slide the clock and see what will be open\nwhen you get there.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Help keep it true'), findsOneWidget);
    expect(
      find.text('Confirm hours or report changes so\neveryone gets the right answer.'),
      findsOneWidget,
    );
    expect(find.text('Get Started'), findsOneWidget);
  });
}

