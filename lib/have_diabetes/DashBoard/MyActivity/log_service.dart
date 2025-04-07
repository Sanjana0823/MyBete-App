import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'log_entry.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // Collection reference
  CollectionReference get _logsCollection => _firestore.collection('logEntries');

  // Stream of log entries for current user
  Stream<List<LogEntry>> getLogEntriesStream() {
    if (currentUserId == null) {
      return Stream.value([]);
    }

    return _logsCollection
        .where('userId', isEqualTo: currentUserId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => LogEntry.fromFirestore(doc)).toList();
    });
  }

  // Get all log entries for current user
  Future<List<LogEntry>> getLogEntries() async {
    if (currentUserId == null) {
      return [];
    }

    final snapshot = await _logsCollection
        .where('userId', isEqualTo: currentUserId)
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs.map((doc) => LogEntry.fromFirestore(doc)).toList();
  }

  // Add a new log entry
  Future<String> addLogEntry(LogEntry logEntry) async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }

    final docRef = await _logsCollection.add(logEntry.toFirestore());
    return docRef.id;
  }

  // Update an existing log entry
  Future<void> updateLogEntry(LogEntry logEntry) async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }

    if (logEntry.id == null) {
      throw Exception('Log entry ID is required for update');
    }

    await _logsCollection.doc(logEntry.id).update(logEntry.toFirestore());
  }

  // Delete a log entry
  Future<void> deleteLogEntry(String id) async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }

    await _logsCollection.doc(id).delete();
    }
}