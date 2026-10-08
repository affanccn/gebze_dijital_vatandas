import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gebze_dijital_vatandas/features/parking/presentation/parking_screen.dart';

import 'package:gebze_dijital_vatandas/features/services/presentation/services_screen.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('Navigate to ParkingScreen', (WidgetTester tester) async {
    final router = GoRouter(
      initialLocation: '/services',
      routes: [
        GoRoute(
          path: '/services',
          builder: (context, state) => const ServicesScreen(),
          routes: [
            GoRoute(
              path: 'parking',
              builder: (context, state) => const ParkingScreen(),
            ),
          ],
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));

    expect(find.byType(ServicesScreen), findsOneWidget);

    // Tap the 'Akıllı Otopark' card
    await tester.tap(find.text('Akıllı Otopark'));
    await tester.pumpAndSettle();

    expect(find.byType(ParkingScreen), findsOneWidget);
  });
}
