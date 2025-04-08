import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Get current user ID
String getCurrentUserId() {
  final User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    print('Warning: No current user found, using default user ID');
  }
  return user?.uid ?? 'user123';
}

// Get reference to the current user's document
DocumentReference getUserRef() {
  final userId = getCurrentUserId();
  return FirebaseFirestore.instance.collection('users').doc(userId);
}
