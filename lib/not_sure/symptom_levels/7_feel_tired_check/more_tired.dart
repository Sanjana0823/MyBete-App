import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Symptom7Screen extends StatefulWidget {
  @override
  _TiredCheckState createState() => _TiredCheckState();
}

class _TiredCheckState extends State<Symptom7Screen> {
  final List<Map<String, dynamic>> _tirednessReport = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save the tiredness entry to Firestore and local list
  void _saveTirednessEntry(bool isTired) async {
    final entry = {
      'date': DateTime.now().toString(),
      'tired': isTired,
    };

    // Save locally
    setState(() {
      _tirednessReport.add(entry);
    });

    // Save to Firestore
    try {
      await _firestore.collection('urinary_records').add(entry);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Entry saved to Firestore: Feeling ${isTired ? "tired" : "normal"}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving to Firestore: $e')),
      );
    }
  }

  // Clear all local entries
  void _clearTirednessData() {
    setState(() {
      _tirednessReport.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('All local entries cleared')),
    );
  }

  Widget _buildReport() {
    return _tirednessReport.isNotEmpty
        ? ListView.builder(
      itemCount: _tirednessReport.length,
      itemBuilder: (context, index) {
        final entry = _tirednessReport[index];
        return ListTile(
          title: Text('Date: ${entry['date']}'),
          subtitle: Text('Feeling: ${entry['tired'] ? "Tired" : "Normal"}'),
        );
      },
    )
        : Center(child: Text('No entries yet.'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tiredness Checker'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Are you feeling more tired than usual?',
              style: TextStyle(fontSize: 18),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _saveTirednessEntry(true),
                child: Text('Yes'),
              ),
              ElevatedButton(
                onPressed: () => _saveTirednessEntry(false),
                child: Text('No'),
              ),
              ElevatedButton(
                onPressed: _clearTirednessData,
                child: Text('Clear Data'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Clear button color
                ),
              ),
            ],
          ),
          Expanded(child: _buildReport()),
        ],
      ),
    );
  }
}
