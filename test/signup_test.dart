import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mybete_app/sign_up_screen.dart'; // Update path based on your project
import 'firebase_mocks.mocks.dart';

@GenerateMocks([
  FirebaseAuth,
  FirebaseFirestore,
  CollectionReference<Map<String, dynamic>>,
  DocumentReference<Map<String, dynamic>>,
  DocumentSnapshot<Map<String, dynamic>>,
  UserCredential,
])
void main() {
  group('SignupPage Tests', () {
    late MockFirebaseAuth mockAuth;
    late MockFirebaseFirestore mockFirestore;
    late MockCollectionReference<Map<String, dynamic>> mockUsersCollection;
    late MockCollectionReference<Map<String, dynamic>> mockUsernamesCollection;
    late MockDocumentReference<Map<String, dynamic>> mockUserDocument;
    late MockDocumentReference<Map<String, dynamic>> mockUsernameDocument;
    late MockDocumentSnapshot<Map<String, dynamic>> mockDocumentSnapshot;
    late MockUserCredential mockUserCredential;

    setUp(() {
      mockAuth = MockFirebaseAuth();
      mockFirestore = MockFirebaseFirestore();
      mockUsersCollection = MockCollectionReference<Map<String, dynamic>>();
      mockUsernamesCollection = MockCollectionReference<Map<String, dynamic>>();
      mockUserDocument = MockDocumentReference<Map<String, dynamic>>();
      mockUsernameDocument = MockDocumentReference<Map<String, dynamic>>();
      mockDocumentSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();
      mockUserCredential = MockUserCredential();

      // Mock Firestore collections and documents
      when(mockFirestore.collection('users')).thenReturn(mockUsersCollection);
      when(mockFirestore.collection('usernames')).thenReturn(mockUsernamesCollection);
      when(mockUsersCollection.doc(any)).thenReturn(mockUserDocument);
      when(mockUsernamesCollection.doc(any)).thenReturn(mockUsernameDocument);
    });

    testWidgets('SignupPage UI renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: SignupPage()));

      expect(find.byType(TextField), findsNWidgets(4)); // Username, email, password, age
      expect(find.byType(DropdownButton), findsOneWidget); // Gender dropdown
      expect(find.text('Sign Up'), findsOneWidget);
    });

    testWidgets('Signup button shows error for taken username', (WidgetTester tester) async {
      when(mockUsernameDocument.get()).thenAnswer((_) async => mockDocumentSnapshot);
      when(mockDocumentSnapshot.exists).thenReturn(true); // Username already exists

      await tester.pumpWidget(MaterialApp(home: SignupPage()));

      await tester.enterText(find.byType(TextField).at(0), 'testuser'); // Username
      await tester.tap(find.text('Sign Up'));
      await tester.pump();

      expect(find.text('Username is already taken.'), findsOneWidget);
    });

    testWidgets('Successful signup stores user data and navigates', (WidgetTester tester) async {
      when(mockUsernameDocument.get()).thenAnswer((_) async => mockDocumentSnapshot);
      when(mockDocumentSnapshot.exists).thenReturn(false); // Username does not exist
      when(mockAuth.createUserWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123',
      )).thenAnswer((_) async => mockUserCredential);
      when(mockUserDocument.set(any)).thenAnswer((_) async {});
      when(mockUsernameDocument.set(any)).thenAnswer((_) async {});

      await tester.pumpWidget(MaterialApp(home: SignupPage()));

      await tester.enterText(find.byType(TextField).at(0), 'testuser');
      await tester.enterText(find.byType(TextField).at(1), 'test@example.com');
      await tester.enterText(find.byType(TextField).at(2), 'password123');
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      verify(mockUserDocument.set({
        "username": "testuser",
        "email": "test@example.com",
        "age": "25",
        "gender": "Male",
      })).called(1);
    });
  });
}