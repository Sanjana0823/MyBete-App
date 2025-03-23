import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Add this to verify your Firestore rules are properly configured

class FirestoreRulesCheck extends StatefulWidget {
  const FirestoreRulesCheck({Key? key}) : super(key: key);

  @override
  _FirestoreRulesCheckState createState() => _FirestoreRulesCheckState();
}

class _FirestoreRulesCheckState extends State<FirestoreRulesCheck> {
  String _status = 'Checking Firestore permissions...';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkFirestorePermissions();
  }

  Future<void> _checkFirestorePermissions() async {
    try {
      // Try to write a test document
      final testDoc = await FirebaseFirestore.instance
          .collection('logEntries')
          .add({
        'test': true,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // If successful, delete the test document
      await testDoc.delete();

      setState(() {
        _status = 'Firestore write permissions are correctly configured.';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _status = 'Firestore permission error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isLoading)
              const CircularProgressIndicator()
            else
              Icon(
                _status.contains('error') ? Icons.error : Icons.check_circle,
                color: _status.contains('error') ? Colors.red : Colors.green,
                size: 48,
              ),
            const SizedBox(height: 16),
            Text(
              _status,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _status.contains('error') ? Colors.red : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

