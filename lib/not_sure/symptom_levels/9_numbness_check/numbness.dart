import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore package

class Symptom9Screen extends StatefulWidget {
  @override
  _NumbnessCheckerState createState() => _NumbnessCheckerState();
}

class _NumbnessCheckerState extends State<Symptom9Screen> {
  String? _selectedOption; // Stores user selection: Yes / No
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to submit the response and save it to Firestore
  Future<void> _submitChecker() async {
    if (_selectedOption == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an option!')),
      );
      return;
    }

    String currentDate = DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now());

    // Save data to Firestore
    await _firestore.collection('numbness_reports').add({
      'date': currentDate,
      'result': _selectedOption,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Numbness check recorded!')),
    );

    // Reset selection
    setState(() {
      _selectedOption = null;
    });
  }

  // Function to clear all records from Firestore
  Future<void> _clearReports() async {
    try {
      QuerySnapshot querySnapshot =
      await _firestore.collection('numbness_reports').get();
      for (var doc in querySnapshot.docs) {
        await _firestore.collection('numbness_reports').doc(doc.id).delete();
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All records cleared successfully!')),
      );
    } catch (e) {
      print('Error clearing records: $e');
    }
  }

  // Function to generate a report based on saved records
  Future<void> _generateReport() async {
    QuerySnapshot querySnapshot =
    await _firestore.collection('numbness_reports').get();
    final records = querySnapshot.docs.map((doc) {
      return doc['result'] as String;
    }).toList();

    int countYes = records.where((result) => result == 'Yes').length;
    int countNo = records.where((result) => result == 'No').length;

    String report = 'Numbness Report:\n\n';
    report += 'Yes: $countYes times\nNo: $countNo times';

    if (countYes > 0) {
      report += '\n\nPossible numbness or tingling detected. Please consult a healthcare provider.';
    } else {
      report += '\n\nNo signs of numbness or tingling detected.';
    }

    // Display report in a dialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Numbness Report'),
          content: Text(report),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Stream to get reports from Firestore
  Stream<QuerySnapshot> _getReportsStream() {
    return _firestore.collection('numbness_reports').snapshots();
  }

  // Widget to display the reports
  Widget _buildReportList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _getReportsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text('No records yet.', style: TextStyle(fontSize: 16));
        }

        final reports = snapshot.data!.docs;

        return ListView.builder(
          shrinkWrap: true,
          itemCount: reports.length,
          itemBuilder: (context, index) {
            final report = reports[index];
            final result = report['result'] as String;
            final date = report['date'] as String;

            return Card(
              elevation: 2,
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
              child: ListTile(
                leading: Icon(
                  result == 'Yes' ? Icons.warning : Icons.check_circle,
                  color: result == 'Yes' ? Colors.red : Colors.green,
                ),
                title: Text('Result: $result'),
                subtitle: Text('Date: $date'),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Numbness/Tingling Checker'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Are you experiencing numbness or tingling in your feet?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 20),
            // Image Section
            Container(
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/numbness_example.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: 20),
            RadioListTile<String>(
              title: const Text('Yes'),
              value: 'Yes',
              groupValue: _selectedOption,
              onChanged: (value) {
                setState(() {
                  _selectedOption = value;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('No'),
              value: 'No',
              groupValue: _selectedOption,
              onChanged: (value) {
                setState(() {
                  _selectedOption = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitChecker,
              child: Text('Submit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _clearReports,
              child: Text('Clear Data'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _generateReport,
              child: Text('Generate Report'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            ),
            SizedBox(height: 30),
            Divider(),
            Text(
              'Your Reports',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(child: _buildReportList()),
          ],
        ),
      ),
    );
  }
}
