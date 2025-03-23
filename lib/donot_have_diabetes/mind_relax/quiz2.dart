import 'package:flutter/material.dart';
import 'package:mybete_app/donot_have_diabetes/mind_relax/Quiz1.dart';
import 'package:mybete_app/donot_have_diabetes/mind_relax/result_screen.dart'; // Import Quiz1

void main() {
  runApp(const Quiz2());
}

class Quiz2 extends StatelessWidget {
  const Quiz2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Georgia',
        scaffoldBackgroundColor: const Color.fromARGB(255, 201, 233, 250),
      ),
      home: const RelaxationPreferencesScreen(),
    );
  }
}

class RelaxationPreferencesScreen extends StatefulWidget {
  const RelaxationPreferencesScreen({Key? key}) : super(key: key);

  @override
  State<RelaxationPreferencesScreen> createState() =>
      _RelaxationPreferencesScreenState();
}

class _RelaxationPreferencesScreenState
    extends State<RelaxationPreferencesScreen> {
  String? relaxationType;
  String? sessionType;
  String? breathingExercise;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              // Top navigation
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        // Navigate back to Quiz1
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Quiz1()),
                        );
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Handle skip action
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5EB7CF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 12),
                      ),
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

              // Title
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Relaxation Preferences',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Question 4
                      QuestionCard(
                        questionNumber: 4,
                        question: 'How many hours did you sleep last night?',
                        options: const [
                          'Less than 4 ',
                          '4-6 ',
                          '6-8',
                          'More than 8'
                        ],
                        selectedValue: relaxationType,
                        onChanged: (value) {
                          setState(() {
                            relaxationType = value;
                          });
                        },
                      ),

                      const SizedBox(height: 16),

                      // Question 5
                      QuestionCard(
                        questionNumber: 5,
                        question:
                            'Do you often wake up in the middle of the night?',
                        options: const ['Yes', 'No'],
                        selectedValue: sessionType,
                        onChanged: (value) {
                          setState(() {
                            sessionType = value;
                          });
                        },
                      ),

                      const SizedBox(height: 16),

                      // Question 6
                      QuestionCard(
                        questionNumber: 6,
                        question: 'Does music help you feel relaxed?',
                        options: const ['Yes', 'No', 'Maybe later'],
                        selectedValue: breathingExercise,
                        onChanged: (value) {
                          setState(() {
                            breathingExercise = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Next button
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0, top: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, String?>? ?? {};

                            final quiz1Answers = {
                              'mood': arguments['selectedMood'],
                              'stressLevel': arguments['selectedStressLevel'],
                              'gratitude': arguments['selectedGratitude'],
                            };

                            final quiz2Answers = {
                              'sleepHours': relaxationType,
                              'wakeUpNight': sessionType,
                              'musicHelps': breathingExercise,
                            };

                            // Navigate to results screen with the answers
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ResultScreen(
                                  quiz1Answers: quiz1Answers,
                                  quiz2Answers: quiz2Answers,
                                ),
                              ),
                            );
                    }, // Handle next action

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5EB7CF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Submit',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuestionCard extends StatelessWidget {
  final int questionNumber;
  final String question;
  final List<String> options;
  final String? selectedValue;
  final Function(String) onChanged;

  const QuestionCard({
    Key? key,
    required this.questionNumber,
    required this.question,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize:
            MainAxisSize.min, // Ensures the card takes only required space
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              '$questionNumber. $question',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          ...options.map((option) => RadioListTile<String>(
                title: Text(
                  option,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                value: option,
                groupValue: selectedValue,
                onChanged: (value) {
                  if (value != null) {
                    onChanged(value);
                  }
                },
                activeColor: const Color.fromARGB(255, 113, 180, 200),
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              )),
        ],
      ),
    );
  }
}
