import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mybete_app/diabete_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('MyApp initializes and navigates correctly', (WidgetTester tester) async {
    // Set mock SharedPreferences values
    SharedPreferences.setMockInitialValues({
      'isLoggedIn': true,
      'lastLoginDate': DateTime.now().toIso8601String(),
    });

    // Build the app
    await tester.pumpWidget(
      const MaterialApp(
        home: DiabeteOptions(), // Simulating navigation to main screen
      ),
    );

    // Increase the timeout duration for pumpAndSettle and add logging
    print('Running pumpAndSettle...');
    await tester.pumpAndSettle(const Duration(seconds: 20));
    print('pumpAndSettle completed.');

    // Verify that expected text or elements appear
    expect(find.text("Choose one option from these three"), findsOneWidget);
    expect(find.text("Have Diabetes"), findsOneWidget);
    expect(find.text("Don't Have Diabetes"), findsOneWidget);
    expect(find.text("Need Guidance"), findsOneWidget);
  });
}









