import 'package:flutter/material.dart';

class StrengthToningPage extends StatefulWidget {
  const StrengthToningPage({super.key});

  @override
  State<StrengthToningPage> createState() => _StrengthToningPageState();
}

class _StrengthToningPageState extends State<StrengthToningPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Strength & Toning')),
      body: const Center(child: Text('Strength Training Page')),
    );
  }
}
Widget _buildIntroductionCard() {
  return Card(
    elevation: 4,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Build Strength & Tone Muscles',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Develop lean muscle mass and improve muscular endurance.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    ),
  );
}

Widget _buildWorkoutGuidelines() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Training Principles:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 16),
      _buildGuidelineItem(Icons.repeat, '3-4 sets of 8-12 reps'),
      _buildGuidelineItem(Icons.timer, '60-90 seconds rest between sets'),
      _buildGuidelineItem(Icons.speed, 'Controlled movement tempo'),
      _buildGuidelineItem(Icons.warning, 'Maintain proper form'),
    ],
  );
}



Widget _buildGuidelineItem(IconData icon, String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Icon(icon, color: Colors.lightBlue),
        const SizedBox(width: 16),
        Expanded(child: Text(text)),
      ],
    ),
  );
}

