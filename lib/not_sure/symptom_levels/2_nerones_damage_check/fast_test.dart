import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'full_report.dart';

class FastTestScreen extends StatefulWidget {
  @override
  _FastTestScreenState createState() => _FastTestScreenState();
}

class _FastTestScreenState extends State<FastTestScreen> {
  bool faceCompleted = false;
  bool armsCompleted = false;
  bool speechCompleted = false;

  bool reportGenerated = false;

  void showFaceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Face Test'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Which face looks like yours?'),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        faceCompleted = true;
                      });
                      Navigator.of(context).pop();
                    },
                    child: Column(
                      children: [
                        Image.asset('assets/normal_face.png', width: 50, height: 50),
                        Text('Normal'),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        faceCompleted = true;
                      });
                      Navigator.of(context).pop();
                    },
                    child: Column(
                      children: [
                        Image.asset('assets/stroke_face.png', width: 50, height: 50),
                        Text('Stroke'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void showArmsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Arms Test'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Which arm position looks like yours?'),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        armsCompleted = true;
                      });
                      Navigator.of(context).pop();
                    },
                    child: Column(
                      children: [
                        Image.asset('assets/normal_arms.png', width: 50, height: 50),
                        Text('Normal'),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        armsCompleted = true;
                      });
                      Navigator.of(context).pop();
                    },
                    child: Column(
                      children: [
                        Image.asset('assets/stroke_arms.png', width: 50, height: 50),
                        Text('Stroke'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void showSpeechDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Speech Test'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Is your speech normal or slurred?'),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        speechCompleted = true;
                      });
                      Navigator.of(context).pop();
                    },
                    child: Column(
                      children: [
                        Image.asset('assets/normal_speech.png', width: 50, height: 50),
                        Text('Normal'),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        speechCompleted = true;
                      });
                      Navigator.of(context).pop();
                    },
                    child: Column(
                      children: [
                        Image.asset('assets/slurred_speech.png', width: 50, height: 50),
                        Text('Slurred'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void showReportDialog() {
    setState(() {
      reportGenerated = true;
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Your Report'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Stroke Risk Analysis'),
              SizedBox(height: 20),
              Container(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sections: _createSampleData(),
                    centerSpaceRadius: 40,
                    sectionsSpace: 2,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await saveReport();
                  Navigator.of(context).pop();
                },
                child: Text('Save'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FullReportScreen()),
                  );
                },
                child: Text('View Past Reports'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> saveReport() async {
    final prefs = await SharedPreferences.getInstance();
    final report = {
      'date': DateTime.now().toString(),
      'face': faceCompleted,
      'arms': armsCompleted,
      'speech': speechCompleted,
    };
    final reports = prefs.getStringList('reports') ?? [];
    reports.add(jsonEncode(report));
    await prefs.setStringList('reports', reports);
  }

  List<PieChartSectionData> _createSampleData() {
    return [
      PieChartSectionData(
        color: faceCompleted ? Colors.green : Colors.red,
        value: faceCompleted ? 1 : 0,
        title: 'Face',
        radius: 50,
      ),
      PieChartSectionData(
        color: armsCompleted ? Colors.green : Colors.red,
        value: armsCompleted ? 1 : 0,
        title: 'Arms',
        radius: 50,
      ),
      PieChartSectionData(
        color: speechCompleted ? Colors.green : Colors.red,
        value: speechCompleted ? 1 : 0,
        title: 'Speech',
        radius: 50,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAST Test for Stroke'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            buildTestStep(
              context,
              'Face',
              'Ask the person to smile. Does one side of the face droop?',
              Icons.face,
              Colors.redAccent,
              showFaceDialog,
              faceCompleted,
            ),
            buildTestStep(
              context,
              'Arms',
              'Ask the person to raise both arms. Does one drift downward?',
              Icons.accessibility,
              Colors.blueAccent,
              showArmsDialog,
              armsCompleted,
            ),
            buildTestStep(
              context,
              'Speech',
              'Ask the person to repeat a simple sentence. Is their speech slurred or strange?',
              Icons.record_voice_over,
              Colors.greenAccent,
              showSpeechDialog,
              speechCompleted,
            ),
            buildTestStep(
              context,
              'Your Report',
              'View your stroke risk analysis.',
              Icons.report,
              Colors.orangeAccent,
              showReportDialog,
              true,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTestStep(BuildContext context, String title, String description, IconData icon, Color color, Function onTap, bool completed) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 30),
                SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              description,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => onTap(),
              style: ElevatedButton.styleFrom(
                backgroundColor: completed ? Colors.green : null,
              ),
              child: Text(title == 'Your Report'
                  ? (completed ? 'View Report' : 'Start Test')
                  : (completed ? 'Completed' : 'Start Test')
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StrokeRisk {
  final String test;
  final int result;

  StrokeRisk(this.test, this.result);
}