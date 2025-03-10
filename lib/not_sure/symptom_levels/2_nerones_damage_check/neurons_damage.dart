import 'package:flutter/material.dart';
import 'package:mybete_app/not_sure/symptom_levels/2_nerones_damage_check/fast_test.dart';

class Symptom2Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Neurons Damage and Stroke'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FastTestScreen()),
                );
              },
              child: buildTestSection(
                context,
                'FAST Test for Stroke',
                [
                  'F - Face: Ask the person to smile. Does one side of the face droop?',
                  'A - Arms: Ask the person to raise both arms. Does one drift downward?',
                  'S - Speech: Ask the person to repeat a simple sentence. Is their speech slurred or strange?',
                  'T - Time: If any of these symptoms appear, call emergency services immediately.',
                ],
              ),
            ),
            buildTestSection(
              context,
              'Grip Strength & Hand Coordination',
              [
                'Test: Ask the person to squeeze your hands with equal force.',
                'Sign of Issue: If one hand is much weaker or unresponsive, it could indicate nerve damage or a stroke.',
                'Finger-to-Nose Test: Ask the person to touch their nose, then touch your finger multiple times.',
                'Sign of Issue: If they miss or struggle with coordination, there may be brain or nerve impairment.',
              ],
            ),
            buildTestSection(
              context,
              'Walking & Balance Test',
              [
                'Test: Ask the person to walk in a straight line or stand on one leg.',
                'Sign of Issue: If they are stumbling, dragging one foot, or swaying excessively, there may be a neurological problem.',
              ],
            ),
            buildTestSection(
              context,
              'Vision Test',
              [
                'Test: Ask the person to look straight ahead and move your fingers in different areas of their visual field.',
                'Sign of Issue: If they cannot see properly on one side or have blurred vision, it may be a sign of stroke or nerve damage.',
              ],
            ),
            buildTestSection(
              context,
              'Temperature & Sensation Test',
              [
                'Test: Use a warm or cold object and lightly touch both sides of the body.',
                'Sign of Issue: If one side of the body feels less or no sensation, it could indicate nerve damage.',
              ],
            ),
            buildTestSection(
              context,
              'Reflex Test (Using a Spoon or Pen)',
              [
                'Test: Lightly tap the knee or elbow with a spoon and observe the response.',
                'Sign of Issue: No reaction or extreme overreaction could indicate nerve or spinal cord damage.',
              ],
            ),
            buildTestSection(
              context,
              'Cognitive & Memory Test',
              [
                'Test: Ask simple questions:',
                'What’s your name?',
                'What day is today?',
                'Count backward from 10.',
                'Sign of Issue: If they struggle to answer or seem confused, this could indicate brain impairment.',
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTestSection(BuildContext context, String title, List<String> steps) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ...steps.map((step) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(step, style: TextStyle(fontSize: 16)),
            )),
          ],
        ),
      ),
    );
  }
}