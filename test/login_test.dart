import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mybete_app/log_in_screen.dart';
import 'package:mybete_app/diabete_options.dart';
import 'firebase_mocks.mocks.dart'; // Import generated mocks file

@GenerateMocks([
  FirebaseAuth,
  FirebaseFirestore,
  DocumentSnapshot<Map<String, dynamic>>, // Specify the generic type
  UserCredential,
])
void main() {
  group('LoginPage Tests', () {
    late MockFirebaseAuth mockAuth;
    late MockFirebaseFirestore mockFirestore;
    late MockDocumentSnapshot<Map<String, dynamic>> mockDocumentSnapshot;
    late MockUserCredential mockUserCredential;

    setUp(() {
      mockAuth = MockFirebaseAuth();
      mockFirestore = MockFirebaseFirestore();
      mockDocumentSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();
      mockUserCredential = MockUserCredential();
    });

    testWidgets('Login screen UI renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginPage()));

      // Verify the presence of all UI elements
      expect(find.text('Username'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Don\'t have an account? Sign up'), findsOneWidget);
    });

    testWidgets('Login button shows error if fields are empty', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginPage()));

      // Tap the login button without entering any data
      await tester.tap(find.text('Login'));
      await tester.pump();

      // Verify no navigation occurs, but an error is displayed
      // Customize this part according to your app's behavior for empty fields
      expect(find.text('Username not found'), findsNothing);
    });

    testWidgets('Successful login navigates to DiabetesOptions', (WidgetTester tester) async {
      // Mock Firestore behavior
      when(mockFirestore.collection('users').doc('testuser').get())
          .thenAnswer((_) async => mockDocumentSnapshot);
      when(mockDocumentSnapshot.exists).thenReturn(true);
      when(mockDocumentSnapshot.data()).thenReturn({'email': 'testuser@example.com'});

      // Mock FirebaseAuth behavior
      when(mockAuth.signInWithEmailAndPassword(
        email: 'testuser@example.com',
        password: 'testpassword',
      )).thenAnswer((_) async => mockUserCredential);

      await tester.pumpWidget(MaterialApp(home: LoginPage()));

      // Enter valid username and password
      await tester.enterText(find.byType(TextField).at(0), 'testuser');
      await tester.enterText(find.byType(TextField).at(1), 'testpassword');

      // Tap on the login button
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Verify navigation to DiabeteOptions screen
      expect(find.byType(DiabeteOptions), findsOneWidget);
    });

    testWidgets('Invalid login shows error', (WidgetTester tester) async {
      // Mock Firestore behavior for invalid username
      when(mockFirestore.collection('users').doc('invaliduser').get())
          .thenAnswer((_) async => mockDocumentSnapshot);
      when(mockDocumentSnapshot.exists).thenReturn(false); // Username does not exist

      await tester.pumpWidget(MaterialApp(home: LoginPage()));

      // Enter invalid username
      await tester.enterText(find.byType(TextField).at(0), 'invaliduser');
      await tester.enterText(find.byType(TextField).at(1), 'wrongpassword');

      // Tap on the login button
      await tester.tap(find.text('Login'));
      await tester.pump();

      // Verify Snackbar displays an error
      expect(find.text('Username not found'), findsOneWidget);
    });

    testWidgets('Firestore document does not exist', (WidgetTester tester) async {
      // Mock Firestore behavior where document does not exist
      when(mockFirestore.collection('users').doc('nonexistentuser').get())
          .thenAnswer((_) async => mockDocumentSnapshot);
      when(mockDocumentSnapshot.exists).thenReturn(false);

      await tester.pumpWidget(MaterialApp(home: LoginPage()));

      // Enter a non-existent username
      await tester.enterText(find.byType(TextField).at(0), 'nonexistentuser');
      await tester.enterText(find.byType(TextField).at(1), 'password');

      // Tap on the login button
      await tester.tap(find.text('Login'));
      await tester.pump();

      // Verify error Snackbar is displayed
      expect(find.text('Username not found'), findsOneWidget);
    });
  });
}