import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FullReportScreen extends StatefulWidget {
  @override
  _FullReportScreenState createState() => _FullReportScreenState();
}

class _FullReportScreenState extends State<FullReportScreen> {
  List<Map<String, dynamic>> reports = [];

  @override
  void initState() {
    super.initState();
    loadReports();
  }

  Future<void> loadReports() async {
    final prefs = await SharedPreferences.getInstance();
    final reportsData = prefs.getStringList('reports') ?? [];
    setState(() {
      reports = reportsData.map((report) => jsonDecode(report) as Map<String, dynamic>).toList();
    });
  }

  Future<void> clearReports() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('reports'); // Remove reports from SharedPreferences
    setState(() {
      reports.clear(); // Clear reports from UI
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Full Report'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: clearReports, //Clears the reports when clicked
            tooltip: 'Clear Reports',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: reports.isEmpty
            ? Center(child: Text('No reports available', style: TextStyle(fontSize: 16)))
            : ListView.builder(
          itemCount: reports.length,
          itemBuilder: (context, index) {
            final report = reports[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date: ${report['date']}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text('Face: ${report['face'] ? 'Normal' : 'Stroke'}'),
                    Text('Arms: ${report['arms'] ? 'Normal' : 'Stroke'}'),
                    Text('Speech: ${report['speech'] ? 'Normal' : 'Slurred'}'),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: clearReports,
        child: Icon(Icons.delete),
        backgroundColor: Colors.red,
        tooltip: 'Clear All Reports',
      ),
    );
  }
}
