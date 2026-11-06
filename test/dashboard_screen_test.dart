import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trainer_pro/features/auth/models/trainer.dart';
import 'package:trainer_pro/features/dashboard/dashboard_screen.dart';
import 'package:trainer_pro/features/dashboard/widgets/remark_tile.dart';
import 'package:trainer_pro/features/dashboard/widgets/sport_card.dart';

/// Sizes the test surface so the layout is exercised at realistic
/// proportions rather than the 800x600 default. [height] is stretched past a
/// real phone for the tests that assert on the whole page at once, because a
/// ListView only builds the children inside its viewport.
Future<void> _pumpDashboard(
  WidgetTester tester, {
  Size size = const Size(400, 880),
}) async {
  tester.view.physicalSize = size * tester.view.devicePixelRatio;
  addTearDown(tester.view.resetPhysicalSize);

  await tester.pumpWidget(const MaterialApp(home: DashboardScreen()));
  await tester.pumpAndSettle();
}

const _fullPage = Size(400, 2600);

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({
      AuthStorageKeys.refreshToken: 'refresh-token-value',
      AuthStorageKeys.trainerName: 'Trainer A',
      AuthStorageKeys.trainerEmail: 'trainer.a@example.com',
      AuthStorageKeys.trainerRole: 'trainer',
    });
  });

  testWidgets('Dashboard renders the trainer from the stored session',
      (WidgetTester tester) async {
    await _pumpDashboard(tester);

    expect(find.text('Trainer Pro'), findsOneWidget);
    expect(find.text('Trainer A'), findsOneWidget);
    expect(find.text('Sports & Games'), findsOneWidget);
    // Initials stand in until the backend serves a photograph.
    expect(find.text('TA'), findsOneWidget);
    expect(find.text('New Events'), findsOneWidget);
    expect(find.text('Gallery'), findsOneWidget);
  });

  testWidgets('Dashboard lists every coaching category',
      (WidgetTester tester) async {
    await _pumpDashboard(tester, size: _fullPage);

    expect(find.byType(SportCard), findsNWidgets(5));
    for (final name in const [
      'Cricket',
      'Athletics',
      'Swimming',
      'Gymnastics',
      'Badminton',
    ]) {
      expect(find.text(name), findsOneWidget, reason: '$name card is missing');
    }
    expect(find.text('45 Students'), findsOneWidget);
    expect(find.text('04:00 PM - 06:00 PM'), findsOneWidget);
  });

  testWidgets('Remarks grid shows all four shortcuts',
      (WidgetTester tester) async {
    await _pumpDashboard(tester, size: _fullPage);

    expect(find.byType(RemarkTile), findsNWidgets(4));
    expect(find.text('Highlights'), findsOneWidget);
    expect(find.text('Performances'), findsOneWidget);
    expect(find.text('Suggestions'), findsOneWidget);
    // Once as the section heading, once as the fourth tile.
    expect(find.text('Remarks'), findsNWidgets(2));
  });

  testWidgets('Footer reports the app version', (WidgetTester tester) async {
    await _pumpDashboard(tester, size: _fullPage);

    expect(
      find.textContaining('App Version 2.1'),
      findsOneWidget,
    );
  });

  testWidgets('Drawer opens from the app bar and offers logout',
      (WidgetTester tester) async {
    await _pumpDashboard(tester);

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();

    expect(find.text('Logout'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
    // Name and department are repeated in the drawer header.
    expect(find.text('Trainer A'), findsNWidgets(2));
  });
}
