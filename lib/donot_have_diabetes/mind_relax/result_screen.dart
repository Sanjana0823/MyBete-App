import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mybete_app/donot_have_diabetes/mind_relax/Quiz1.dart';
import 'package:mybete_app/donot_have_diabetes/mind_relax/Quiz2.dart';
import 'package:mybete_app/donot_have_diabetes/mind_relax/resources_screen.dart';

class ResultModel {
  final String level;
  final String date;

  ResultModel({required this.level, required this.date});

  Map<String, dynamic> toJson() => {
        'level': level,
        'date': date,
      };

  factory ResultModel.fromJson(Map<String, dynamic> json) {
    return ResultModel(
      level: json['level'],
      date: json['date'],
    );
  }
}

class ResultHistoryScreen extends StatefulWidget {
  const ResultHistoryScreen({Key? key}) : super(key: key);

  @override
  State<ResultHistoryScreen> createState() => _ResultHistoryScreenState();
}

class _ResultHistoryScreenState extends State<ResultHistoryScreen> {
  List<ResultModel> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> resultList = prefs.getStringList('result_history') ?? [];
    setState(() {
      _history = resultList
          .map((e) => ResultModel.fromJson(json.decode(e)))
          .toList();
    });
  }

  Future<void> _deleteHistory(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _history.removeAt(index);
      final updated = _history.map((e) => json.encode(e.toJson())).toList();
      prefs.setStringList('result_history', updated);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result History'),
        backgroundColor: const Color(0xFF5EB7CF),
      ),
      body: _history.isEmpty
          ? const Center(child: Text("No history yet."))
          : ListView.builder(
              itemCount: _history.length,
              itemBuilder: (context, index) {
                final item = _history[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text("Depression Level: ${item.level}"),
                    subtitle: Text("Date: ${item.date}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteHistory(index),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final Map<String, String?> quiz1Answers;
  final Map<String, String?> quiz2Answers;

  const ResultScreen({
    Key? key,
    required this.quiz1Answers,
    required this.quiz2Answers,
  }) : super(key: key);

  String _calculateDepressionLevel() {
    int score = 0;
    if (quiz1Answers['mood'] == 'Stressed' || quiz1Answers['mood'] == 'Anxious') {
      score += 2;
    }
    if (quiz1Answers['stressLevel'] == 'High') {
      score += 3;
    } else if (quiz1Answers['stressLevel'] == 'Medium') {
      score += 1;
    }
    if (quiz2Answers['sleepHours'] == 'Less than 4 ') {
      score += 3;
    } else if (quiz2Answers['sleepHours'] == '4-6 ') {
      score += 2;
    }
    if (quiz2Answers['wakeUpNight'] == 'Yes') {
      score += 2;
    }
    if (score >= 6) {
      return 'High';
    } else if (score >= 3) {
      return 'Medium';
    } else {
      return 'Low';
    }
  }

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

  Future<void> _saveResultToHistory(String level) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('result_history') ?? [];
    final result = ResultModel(
      level: level,
      date: DateTime.now().toLocal().toString().split('.').first,
    );
    history.add(json.encode(result.toJson()));
    await prefs.setStringList('result_history', history);
  }

  @override
  Widget build(BuildContext context) {
    final depressionLevel = _calculateDepressionLevel();
    final levelColor = _getLevelColor(depressionLevel);
    final recommendations = _getRecommendations(depressionLevel);

    _saveResultToHistory(depressionLevel);

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
                      Container(
                        padding:
                            const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
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
                    const SizedBox(width: 20),
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
                    const SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ResultHistoryScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade300,
                          foregroundColor: Colors.black87,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'History',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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