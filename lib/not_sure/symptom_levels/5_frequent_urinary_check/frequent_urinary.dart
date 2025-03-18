import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class Symptom5Screen extends StatefulWidget {
  @override
  _FrequentUrinaryCheckerState createState() => _FrequentUrinaryCheckerState();
}

class _FrequentUrinaryCheckerState extends State<Symptom5Screen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _records = [];
  Timer? _timer;
  int _remainingSeconds = 24 * 60 * 60; // 24 hours in seconds
  bool _isTimerRunning = false;
  String _urinaryResult = "";

  @override
  void initState() {
    super.initState();
    _fetchRecords();
    _loadTimerState();
  }

  Future<void> _fetchRecords() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('urinary_records')
          .orderBy('timestamp', descending: true)
          .get();
      setState(() {
        _records = querySnapshot.docs.map((doc) {
          return {
            'id': doc.id,
            'date': doc['timestamp'],
          };
        }).toList();
      });
    } catch (e) {
      print('Error fetching records: $e');
    }
  }

  Future<void> _addRecord() async {
    try {
      final timestamp = DateTime.now().toIso8601String();
      await _firestore.collection('urinary_records').add({
        'timestamp': timestamp,
      });
      _fetchRecords();
    } catch (e) {
      print('Error adding record: $e');
    }
  }

  Future<void> _clearRecords() async {
    try {
      QuerySnapshot querySnapshot =
      await _firestore.collection('urinary_records').get();
      for (var doc in querySnapshot.docs) {
        await _firestore.collection('urinary_records').doc(doc.id).delete();
      }
      _fetchRecords();
    } catch (e) {
      print('Error clearing records: $e');
    }
  }

  Future<void> _loadTimerState() async {
    try {
      // Check if there's a stored timer state in Firestore
      DocumentSnapshot timerDoc =
      await _firestore.collection('timer_state').doc('state').get();

      if (timerDoc.exists) {
        final startTime = DateTime.parse(timerDoc['startTime']);
        final now = DateTime.now();
        final elapsedSeconds = now.difference(startTime).inSeconds;

        if (elapsedSeconds < 24 * 60 * 60) {
          setState(() {
            _remainingSeconds = (24 * 60 * 60) - elapsedSeconds;
            _isTimerRunning = true;
          });

          _startTimer(isResuming: true);
        } else {
          // Timer already expired, evaluate urinary frequency
          _evaluateUrinaryFrequency();
        }
      }
    } catch (e) {
      print('Error loading timer state: $e');
    }
  }

  Future<void> _saveTimerState() async {
    final startTime = DateTime.now().toIso8601String();
    try {
      await _firestore.collection('timer_state').doc('state').set({
        'startTime': startTime,
      });
    } catch (e) {
      print('Error saving timer state: $e');
    }
  }

  void _startTimer({bool isResuming = false}) {
    if (_isTimerRunning && !isResuming) return;

    if (!isResuming) {
      _saveTimerState(); // Save the timer state only on a fresh start
    }

    setState(() {
      _isTimerRunning = true;
      _urinaryResult = "";
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 0) {
        timer.cancel();
        _evaluateUrinaryFrequency();
        setState(() {
          _isTimerRunning = false;
        });
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  Future<void> _resetTimer() async {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = 24 * 60 * 60; // Reset to 24 hours
      _isTimerRunning = false;
      _urinaryResult = "";
    });

    // Remove saved timer state from Firestore
    try {
      await _firestore.collection('timer_state').doc('state').delete();
    } catch (e) {
      print('Error resetting timer state: $e');
    }
  }

  void _evaluateUrinaryFrequency() {
    final int count = _records.length; // Get the total number of urination logs
    if (count > 7) {
      setState(() {
        _urinaryResult = "Frequent Urination Detected: $count times in 24 hours";
      });
    } else {
      setState(() {
        _urinaryResult =
        "Normal Urination Frequency: $count times in 24 hours";
      });
    }
  }

  void _generateReport() {
    _evaluateUrinaryFrequency();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Urination Report'),
          content: Text(
            _urinaryResult.isNotEmpty
                ? _urinaryResult
                : "No data available to generate a report.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  String _formatTime(int seconds) {
    final int hours = seconds ~/ 3600;
    final int minutes = (seconds % 3600) ~/ 60;
    final int secs = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Frequent Urinary Checker'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _addRecord,
            child: Text('Log Urination'),
          ),
          ElevatedButton(
            onPressed: _clearRecords,
            child: Text('Clear Data'),
          ),
          ElevatedButton(
            onPressed: _generateReport,
            child: Text('Generate Report'),
          ),
          SizedBox(height: 20),
          Text(
            'Timer: ${_formatTime(_remainingSeconds)}',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _startTimer(),
                child: Text('Start Timer'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: _resetTimer,
                child: Text('Reset Timer'),
              ),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: _records.isEmpty
                ? Center(
              child: Text(
                'No records yet. Log your first urination event!',
                style: TextStyle(fontSize: 16),
              ),
            )
                : ListView.builder(
              itemCount: _records.length,
              itemBuilder: (context, index) {
                final record = _records[index];
                return ListTile(
                  title: Text('Date: ${record['date']}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
