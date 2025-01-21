// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:traceagri_app/main.dart';
import 'package:traceagri_app/services/api_service.dart';
import 'package:traceagri_app/services/database_service.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    WidgetsFlutterBinding.ensureInitialized();

    // Initialisation de la base de données
    await DatabaseService().database;

    // Vérifier l'état de connexion
    final ApiService apiService = ApiService();
    final isLoggedIn = await apiService.isUserLoggedIn();
    await tester.pumpWidget(MyApp(initialRoute: isLoggedIn ? '/home' : '/login'));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
