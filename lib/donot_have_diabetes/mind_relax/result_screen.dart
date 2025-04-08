import 'package:flutter/material.dart';
import 'package:mybete_app/donot_have_diabetes/mind_relax/Quiz1.dart';
import 'package:mybete_app/donot_have_diabetes/mind_relax/Quiz2.dart';
import 'package:mybete_app/donot_have_diabetes/mind_relax/resources_screen.dart';

class ResultScreen extends StatelessWidget {
  final Map<String, String?> quiz1Answers;
  final Map<String, String?> quiz2Answers;

  const ResultScreen({
    Key? key,
    required this.quiz1Answers,
    required this.quiz2Answers,
  }) : super(key: key);

  // Calculate depression level based on answers
  String _calculateDepressionLevel() {
    int score = 0;

    // Analyze mood from Quiz1
    if (quiz1Answers['mood'] == 'Stressed' ||
        quiz1Answers['mood'] == 'Anxious') {
      score += 2;
    }

    // Analyze stress level from Quiz1
    if (quiz1Answers['stressLevel'] == 'High') {
      score += 3;
    } else if (quiz1Answers['stressLevel'] == 'Medium') {
      score += 1;
    }

    // Analyze sleep from Quiz2
    if (quiz2Answers['sleepHours'] == 'Less than 4 ') {
      score += 3;
    } else if (quiz2Answers['sleepHours'] == '4-6 ') {
      score += 2;
    }

    // Analyze sleep quality from Quiz2
    if (quiz2Answers['wakeUpNight'] == 'Yes') {
      score += 2;
    }

    // Determine level based on score
    if (score >= 6) {
      return 'High';
    } else if (score >= 3) {
      return 'Medium';
    } else {
      return 'Low';
    }
  }

  // Get color based on depression level
  Color _getLevelColor(String level) {
    switch (level) {
      case 'High':
        return Colors.red.shade400;
      case 'Medium':
        return Colors.orange.shade400;
      case 'Low':
        return Colors.green.shade400;
      default:
        return Colors.blue;
    }
  }

  // Get recommendations based on depression level
  List<String> _getRecommendations(String level) {
    switch (level) {
      case 'High':
        return [
          'Consider speaking with a mental health professional',
          'Practice daily mindfulness meditation',
          'Maintain a regular sleep schedule',
          'Engage in light physical activity',
          'Connect with supportive friends or family'
        ];
      case 'Medium':
        return [
          'Try guided relaxation exercises',
          'Establish a consistent sleep routine',
          'Spend time in nature regularly',
          'Practice deep breathing exercises',
          'Consider journaling your thoughts'
        ];
      case 'Low':
        return [
          'Continue your healthy habits',
          'Practice gratitude daily',
          'Stay physically active',
          'Maintain social connections',
          'Monitor your mood changes'
        ];
      default:
        return ['Take care of your mental health'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final depressionLevel = _calculateDepressionLevel();
    final levelColor = _getLevelColor(depressionLevel);
    final recommendations = _getRecommendations(depressionLevel);

    return Scaffold(
      backgroundColor: const Color(0xFFC5EDFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5EB7CF),
        title: const Text('Your Results'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Result Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Depression Level Assessment',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Level Indicator
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 24),
                        decoration: BoxDecoration(
                          color: levelColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: levelColor, width: 2),
                        ),
                        child: Text(
                          depressionLevel,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: levelColor.darker(),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Level Description
                      Text(
                        _getLevelDescription(depressionLevel),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Recommendations Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Recommendations',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...recommendations.map((recommendation) => Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.check_circle,
                                    color: levelColor, size: 20),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    recommendation,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Disclaimer
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Text(
                    'Disclaimer: This assessment is not a clinical diagnosis. If you\'re concerned about your mental health, please consult with a healthcare professional.',
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Quiz1()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF5EB7CF),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: const BorderSide(color: Color(0xFF5EB7CF)),
                          ),
                        ),
                        child: const Text(
                          'Retake Quiz',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    

// With this updated version:
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResourcesScreen(
                                depressionLevel: depressionLevel,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5EB7CF),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'View Resources',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getLevelDescription(String level) {
    switch (level) {
      case 'High':
        return 'Your responses indicate a high level of depression symptoms. This suggests you may be experiencing significant emotional distress.';
      case 'Medium':
        return 'Your responses indicate a moderate level of depression symptoms. You may be experiencing some emotional challenges that could benefit from attention.';
      case 'Low':
        return 'Your responses indicate a low level of depression symptoms. You appear to be managing your emotional wellbeing effectively.';
      default:
        return '';
    }
  }
}

// Extension to get darker color
extension ColorExtension on Color {
  Color darker() {
    return Color.fromARGB(
      alpha,
      (red * 0.7).round(),
      (green * 0.7).round(),
      (blue * 0.7).round(),
    );
  }
}
