import 'package:flutter/material.dart';
import './symptom_levels/blurry_vision.dart';
import './symptom_levels/frequent_urinary.dart';
import './symptom_levels/more_tired.dart';
import './symptom_levels/neurons_damage.dart';
import './symptom_levels/numbness.dart';
import './symptom_levels/period_changes.dart';
import './symptom_levels/polydipsia.dart';
import './symptom_levels/polyphagia.dart';
import './symptom_levels/skin_changes.dart';
import './symptom_levels/weight_changes.dart';

class NotSureDashboard extends StatelessWidget {
  final List<String> symptoms = [
    'Feeling Extra Thirsty (Polydipsia)',
    'Neurons damage and stroke',
    'Extreme Hunger (Polyphagia)',
    'Weight changes',
    'Frequent urinary tract infections or yeast infections (Polyuria)',
    'Blurry vision',
    'Feeling more tired than usual',
    'Skin changes',
    'Numbness or tingling in the feet',
    'Changes to your periods',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Diabetes Dashboard"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Back arrow icon
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: ListView.builder(
        itemCount: symptoms.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              child: Text('${index + 1}'),
            ),
            title: Text(symptoms[index]),
            onTap: () {
              // Navigate to the level details screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LevelDetailScreen(level: index + 1, symptom: symptoms[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class LevelDetailScreen extends StatelessWidget {
  final int level;
  final String symptom;

  LevelDetailScreen({required this.level, required this.symptom});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Level $level'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Level $level: $symptom',
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the method or game page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      switch (level) {
                        case 1:
                          return Symptom1Screen();
                        case 2:
                          return Symptom2Screen();
                        case 3:
                          return Symptom3Screen();
                        case 4:
                          return Symptom4Screen();
                        case 5:
                          return Symptom5Screen();
                        case 6:
                          return Symptom6Screen();
                        case 7:
                          return Symptom7Screen();
                        case 8:
                          return Symptom8Screen();
                        case 9:
                          return Symptom9Screen();
                        case 10:
                          return Symptom10Screen();
                        default:
                          return Symptom1Screen();
                      }
                    },
                  ),
                );
              },
              child: Text('Check Symptom'),
            ),
          ],
        ),
      ),
    );
  }
}