import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LogEntry {
  final String? id;
  final String userId;
  final DateTime date;
  final double? bloodSugar;
  final String? pills;
  final String? bloodPressure;
  final double? bodyWeight;
  final String? trackingMoment;
  final String? mealTime;
  final String? foodType;
  final DateTime createdAt;
  final DateTime updatedAt;

  LogEntry({
    this.id,
    required this.userId,
    required this.date,
    this.bloodSugar,
    this.pills,
    this.bloodPressure,
    this.bodyWeight,
    this.trackingMoment,
    this.mealTime,
    this.foodType,
    required this.createdAt,
    required this.updatedAt,
  });

  // Create LogEntry from Firestore document
  factory LogEntry.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LogEntry(
      id: doc.id,
      userId: data['userId'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      bloodSugar: data['bloodSugar']?.toDouble(),
      pills: data['pills'],
      bloodPressure: data['bloodPressure'],
      bodyWeight: data['bodyWeight']?.toDouble(),
      trackingMoment: data['trackingMoment'],
      mealTime: data['mealTime'],
      foodType: data['foodType'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  // Convert LogEntry to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'id': id, // Include the id field
      'userId': userId,
      'date': Timestamp.fromDate(date),
      'bloodSugar': bloodSugar,
      'pills': pills,
      'bloodPressure': bloodPressure,
      'bodyWeight': bodyWeight,
      'trackingMoment': trackingMoment,
      'mealTime': mealTime,
      'foodType': foodType,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}

class LogProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<LogEntry> _logs = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<LogEntry> get logs => _logs;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // Collection reference
  CollectionReference get _logsCollection => _firestore.collection('logEntries');

  // Grouped logs by date
  Map<String, List<LogEntry>> get groupedByDate {
    final grouped = <String, List<LogEntry>>{};

    for (var log in _logs) {
      final dateString = DateFormat('yyyy-MM-dd').format(log.date);

      if (!grouped.containsKey(dateString)) {
        grouped[dateString] = [];
      }

      grouped[dateString]!.add(log);
    }

    return grouped;
  }

  // Today's logs
  List<LogEntry> get todayLogs {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return groupedByDate[today] ?? [];
  }

  // Today's average blood sugar
  double get todayAverage {
    if (todayLogs.isEmpty) {
      return 0;
    }

    final bloodSugarLogs = todayLogs.where((log) => log.bloodSugar != null);
    if (bloodSugarLogs.isEmpty) {
      return 0;
    }

    final sum = bloodSugarLogs.fold<double>(
        0, (sum, log) => sum + (log.bloodSugar ?? 0));
    return sum / bloodSugarLogs.length;
  }

  // Initialize provider and load logs
  Future<void> initialize() async {
    await fetchLogs();
  }

  // Fetch logs from Firestore
  Future<void> fetchLogs() async {
    _setLoading(true);

    try {
      if (currentUserId == null) {
        _logs = [];
        _error = "User not authenticated";
        _setLoading(false);
        return;
      }
      print(">> fetchLogs 1");
      final snapshot = await _logsCollection
          .where('userId', isEqualTo: currentUserId)
          .orderBy('date', descending: true)
          .get();

      print(">> fetchLogs 2");
      _logs = snapshot.docs.map((doc) => LogEntry.fromFirestore(doc)).toList();
      _error = null;
      print(">> _logs ${_logs.length}");
    } catch (e) {
      _setLoading(false);
      if (e is FirebaseException) {
        print(">> Firebase Error: ${e.message}");
      } else {
        print(">> Update Error: $e");
      }
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Add a new log
  Future<void> addLog(LogEntry log) async {
    _setLoading(true);

    try {
      final docRef = await _logsCollection.add(log.toFirestore());
      final newLog = LogEntry(
        id: docRef.id,
        userId: log.userId,
        date: log.date,
        bloodSugar: log.bloodSugar,
        pills: log.pills,
        bloodPressure: log.bloodPressure,
        bodyWeight: log.bodyWeight,
        trackingMoment: log.trackingMoment,
        mealTime: log.mealTime,
        foodType: log.foodType,
        createdAt: log.createdAt,
        updatedAt: log.updatedAt,
      );

      _logs.add(newLog);
      _logs.sort((a, b) => b.date.compareTo(a.date));
      _error = null;
    } catch (e) {
      _setLoading(false);
      if (e is FirebaseException) {
        print(">> Firebase Error: ${e.message}");
      } else {
        print(">> Update Error: $e");
      }
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Update an existing log
  Future<void> updateLog(LogEntry log) async {
    _setLoading(true);
    try {
      print(">> log id: ${log.id}");
      if (log.id == null) {
        throw Exception('Log entry ID is required for update');
      }
      final docRef = _logsCollection.doc(log.id);
      final docSnap = await docRef.get();

      if (!docSnap.exists) {
        throw Exception("Log entry with ID ${log.id} does not exist.");
      }
      print(">> Preparing to update: ${log.toFirestore()}");
      await docRef.update(log.toFirestore()).timeout(Duration(seconds: 5));

      final index = _logs.indexWhere((l) => l.id == log.id);
      print(">> index : ${log.id}");
      if (index != -1) {
        _logs[index] = log;
      }

      _error = null;
      print(">> Updating log: ${log.id}, Data: ${log.toFirestore()}");
    } catch (e) {
      _setLoading(false);
      if (e is FirebaseException) {
        print(">> Firebase Error: ${e.message}");
      } else {
        print(">> Update Error: $e");
      }
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Delete a log
  Future<void> deleteLog(String id) async {
    _setLoading(true);

    try {
      await _logsCollection.doc(id).delete();
      _logs.removeWhere((log) => log.id == id);
      _error = null;
    } catch (e) {
      _setLoading(false);
      if (e is FirebaseException) {
        print(">> Firebase Error: ${e.message}");
      } else {
        print(">> Update Error: $e");
      }
    } finally {
      _setLoading(false);
    }
  }

  // Helper method to set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
    }
}