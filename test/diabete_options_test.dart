import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mybete_app/log_in_screen.dart'; // Update with your actual file paths
import 'package:mybete_app/diabete_options.dart';
import 'diabete_options_test.mocks.dart';
import 'firebase_mocks.mocks.dart'; // Import the generated mock file

@GenerateMocks([SharedPreferences])
void main() {
  group('Logout Functionality Tests', () {
    late MockSharedPreferences mockSharedPreferences;

    setUp(() {
      // Mock SharedPreferences
      mockSharedPreferences = MockSharedPreferences();
      SharedPreferences.setMockInitialValues({}); // Set up mock initial values
    });

    testWidgets('Logout menu appears and logs out user', (WidgetTester tester) async {
      // Pump the widget for testing
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DiabeteOptions(),
          ),
        ),
      );

      // Tap the account icon to show the logout menu
      await tester.tap(find.byIcon(Icons.account_circle));
      await tester.pumpAndSettle(); // Wait for the menu animation to complete

      // Verify the logout menu appears
      expect(find.text('Log Out'), findsOneWidget);

      // Mock SharedPreferences behavior for logging out
      when(mockSharedPreferences.setBool('isLoggedIn', false)).thenAnswer((_) async => true);
      when(mockSharedPreferences.remove('lastLoginDate')).thenAnswer((_) async => true);

      // Tap on the 'Log Out' option
      await tester.tap(find.text('Log Out'));
      await tester.pumpAndSettle(); // Wait for the navigation animation to complete

      // Verify navigation to LoginPage
      expect(find.byType(LoginPage), findsOneWidget);
    });
  });
}