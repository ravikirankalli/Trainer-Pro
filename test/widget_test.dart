import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:trainer_pro/features/auth/login_screen.dart';
import 'package:trainer_pro/features/auth/widgets/brand_wave.dart';
import 'package:trainer_pro/features/auth/widgets/trust_branding.dart';

/// Sizes the test surface like an average phone so the layout is exercised at
/// realistic proportions rather than the 800x600 default.
void _usePhoneSurface(WidgetTester tester, {Size size = const Size(400, 880)}) {
  tester.view.physicalSize = size * tester.view.devicePixelRatio;
  tester.view.devicePixelRatio = tester.view.devicePixelRatio;
  addTearDown(tester.view.resetPhysicalSize);
}

void main() {
  testWidgets('Login screen shows the form fields and trust branding',
      (WidgetTester tester) async {
    _usePhoneSurface(tester);
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    expect(find.text('Login'), findsWidgets);
    expect(find.text('Trainer ID'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Forgot Password?'), findsOneWidget);
    expect(find.text('Andhra Educational Trust'), findsOneWidget);
  });

  testWidgets('Wave and trust branding stay on screen without scrolling',
      (WidgetTester tester) async {
    _usePhoneSurface(tester);
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    final screenHeight = tester.view.physicalSize.height /
        tester.view.devicePixelRatio;

    // Both sit outside the scroll view, pinned to the bottom of the panel.
    expect(
      find.descendant(
        of: find.byType(Scrollable),
        matching: find.byType(TrustBranding),
      ),
      findsNothing,
    );

    final branding = tester.getRect(find.byType(TrustBranding));
    final wave = tester.getRect(find.byType(BrandWave));

    expect(branding.bottom, lessThanOrEqualTo(screenHeight));
    expect(branding.top, greaterThan(wave.top));
    expect(wave.bottom, lessThanOrEqualTo(branding.top));
  });

  testWidgets('Login validates empty fields', (WidgetTester tester) async {
    _usePhoneSurface(tester);
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pump();

    expect(find.text('Please enter your Trainer ID'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
  });
}
