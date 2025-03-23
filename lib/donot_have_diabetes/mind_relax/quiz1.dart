import 'package:flutter/material.dart';
import 'package:mybete_app/donot_have_diabetes/mind_relax/Quiz.dart';
import 'package:mybete_app/donot_have_diabetes/mind_relax/Quiz2.dart'; // Import Quiz2
import 'package:mybete_app/donot_have_diabetes/mind_relax/result_screen.dart';

void main() {
  runApp(const Quiz1());
}

class Quiz1 extends StatelessWidget {
  const Quiz1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFC5EDFF),
      ),
      home: const MoodCheckScreen(),
    );
  }
}

class MoodCheckScreen extends StatefulWidget {
  const MoodCheckScreen({Key? key}) : super(key: key);

  @override
  State<MoodCheckScreen> createState() => _MoodCheckScreenState();
}

class _MoodCheckScreenState extends State<MoodCheckScreen> {
  String? selectedMood;
  String? selectedStressLevel;
  String? selectedGratitude;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // Back & Skip Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Quiz()),
                            );
                          },
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Quiz2()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5EB7CF),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                          ),
                          child: const Text(
                            'Skip',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Title
                    const Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Text(
                        'Mood & Well-being Check',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Questions
                    QuestionCard(
                      question: '1. How are you feeling today?',
                      options: ['Happy', 'Stressed', 'Anxious', 'Calm'],
                      selectedValue: selectedMood,
                      onSelected: (value) =>
                          setState(() => selectedMood = value),
                    ),

                    const SizedBox(height: 24),

                    QuestionCard(
                      question: '2. What\'s your stress level right now?',
                      options: ['Low', 'Medium', 'High'],
                      selectedValue: selectedStressLevel,
                      onSelected: (value) =>
                          setState(() => selectedStressLevel = value),
                    ),

                    const SizedBox(height: 24),

                    QuestionCard(
                      question:
                          '3. What\'s one thing you\'re grateful for today?',
                      options: ['Family', 'Health', 'Friends', 'Work'],
                      selectedValue: selectedGratitude,
                      onSelected: (value) =>
                          setState(() => selectedGratitude = value),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Next Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Create a map of the answers
                    final quiz1Answers = {
                      'selectedMood': selectedMood,
                      'selectedStressLevel': selectedStressLevel,
                      'selectedGratitude': selectedGratitude,
                    };

                    // Navigate to Quiz2 with the answers
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Quiz2(),
                        settings: RouteSettings(arguments: quiz1Answers),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5EB7CF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuestionCard extends StatelessWidget {
  final String question;
  final List<String> options;
  final String? selectedValue;
  final Function(String) onSelected;

  const QuestionCard({
    Key? key,
    required this.question,
    required this.options,
    required this.selectedValue,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            question,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 16),
          ...options.map((option) => RadioListTile<String>(
                title: Text(option, style: const TextStyle(fontSize: 16)),
                value: option,
                groupValue: selectedValue,
                onChanged: (value) {
                  if (value != null) {
                    onSelected(value);
                  }
                },
              )),
        ],
      ),
    );
  }
}
