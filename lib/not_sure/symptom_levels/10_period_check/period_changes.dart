import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting dates

class Symptom10Screen extends StatefulWidget {
  @override
  _Symptom10ScreenState createState() => _Symptom10ScreenState();
}

class _Symptom10ScreenState extends State<Symptom10Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Period Checker"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PeriodLoggerScreen()),
                );
              },
              child: const Text("Log Period"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CycleReportScreen()),
                );
              },
              child: const Text("View Report"),
            ),
          ],
        ),
      ),
    );
  }
}

class PeriodLoggerScreen extends StatefulWidget {
  @override
  _PeriodLoggerScreenState createState() => _PeriodLoggerScreenState();
}

class _PeriodLoggerScreenState extends State<PeriodLoggerScreen> {
  DateTime? startDate;
  DateTime? endDate;
  int? cycleLength;

  Future<void> selectDate(BuildContext context, bool isStart) async {
    DateTime initialDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != initialDate) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
          if (startDate != null) {
            cycleLength = endDate!.difference(startDate!).inDays;
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Log Period"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                selectDate(context, true);
              },
              child: Text(
                startDate == null
                    ? "Select Start Date"
                    : "Start Date: ${DateFormat('dd/MM/yyyy').format(startDate!)}",
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                selectDate(context, false);
              },
              child: Text(
                endDate == null
                    ? "Select End Date"
                    : "End Date: ${DateFormat('dd/MM/yyyy').format(endDate!)}",
              ),
            ),
            const SizedBox(height: 16),
            Text(
              cycleLength == null
                  ? "Cycle Length: Not Calculated"
                  : "Cycle Length: $cycleLength days",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (startDate != null && endDate != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Period data logged!")),
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Please select both dates first.")),
                  );
                }
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}

class CycleReportScreen extends StatelessWidget {
  final List<Map<String, dynamic>> periodLogs = [
    {"startDate": "01/03/2025", "endDate": "06/03/2025", "cycleLength": 30, "flow": "Normal"},
    {"startDate": "01/02/2025", "endDate": "05/02/2025", "cycleLength": 28, "flow": "Heavy"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cycle Report"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Logged Data:", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: periodLogs.length,
                itemBuilder: (context, index) {
                  final log = periodLogs[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Start Date: ${log['startDate']}"),
                          Text("End Date: ${log['endDate']}"),
                          Text("Cycle Length: ${log['cycleLength']} days"),
                          Text("Flow Level: ${log['flow']}"),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(),
            const SizedBox(height: 10),
            Text("Suggestions:", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            Text(getHealthSuggestion(30, 5, "Normal")),
          ],
        ),
      ),
    );
  }

  // Dummy suggestion function (can use real data instead)
  String getHealthSuggestion(int cycleLength, int periodDuration, String flowLevel) {
    if (cycleLength < 21 || cycleLength > 35) {
      return "Your cycle length is irregular. Consider monitoring further or consulting a doctor.";
    }
    if (periodDuration < 2 || periodDuration > 7) {
      return "Your period duration is outside the normal range. Please consult a healthcare professional.";
    }
    if (flowLevel == "Heavy") {
      return "Your flow level is heavy. Make sure to stay hydrated and consult a doctor if needed.";
    }
    return "Your cycles appear normal. Keep tracking for consistent insights.";
  }
}

