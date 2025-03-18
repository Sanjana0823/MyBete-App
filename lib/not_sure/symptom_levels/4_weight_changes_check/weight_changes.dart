import 'package:flutter/material.dart';

class Symptom4Screen extends StatefulWidget {
  @override
  _WeightLossTrackerState createState() => _WeightLossTrackerState();
}

class _WeightLossTrackerState extends State<Symptom4Screen> {
  final TextEditingController _weightController = TextEditingController();
  final List<Map<String, dynamic>> _weightLogs = [];
  double? _initialWeight;

  void _addWeightLog() {
    if (_weightController.text.isNotEmpty) {
      final double weight = double.parse(_weightController.text);
      final DateTime date = DateTime.now();

      if (_initialWeight == null) {
        _initialWeight = weight; // Set the initial weight
      }

      setState(() {
        _weightLogs.add({
          'weight': weight,
          'date': date,
        });
      });

      _weightController.clear();
    }
  }

  double calculateWeightLoss() {
    if (_weightLogs.isNotEmpty && _initialWeight != null) {
      final double latestWeight = _weightLogs.last['weight'];
      return _initialWeight! - latestWeight;
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weight Loss Tracker'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter your weight (kg)',
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addWeightLog,
              child: Text('Log Weight'),
            ),
            SizedBox(height: 20),
            if (_weightLogs.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _weightLogs.length,
                  itemBuilder: (context, index) {
                    final log = _weightLogs[index];
                    return ListTile(
                      title: Text('Weight: ${log['weight']} kg'),
                      subtitle:
                      Text('Date: ${log['date'].toLocal().toString()}'),
                    );
                  },
                ),
              ),
            if (_weightLogs.isNotEmpty)
              Text(
                'Total Weight Loss: ${calculateWeightLoss().toStringAsFixed(2)} kg',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}
