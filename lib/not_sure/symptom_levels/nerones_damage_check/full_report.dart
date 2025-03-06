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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Full Report'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
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
    );
  }
}