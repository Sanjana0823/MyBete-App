import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class Symptom6Screen extends StatefulWidget {
  @override
  _BlurryVisionTestState createState() => _BlurryVisionTestState();
}

class _BlurryVisionTestState extends State<Symptom6Screen> {
  final List<String> directions = ['up', 'down', 'left', 'right'];
  final List<String> userResponses = [];
  final List<String> correctAnswers = [];
  final Random random = Random();

  String currentDirection = '';
  int testCount = 0;
  int correctCount = 0;

  double fontSize = 100; // Start big, reduce with each round

  @override
  void initState() {
    super.initState();
    generateNextE();
  }

  void generateNextE() {
    if (testCount >= 10) {
      // After 10 tests, show report
      generateReport();
      return;
    }

    // Randomly pick a direction
    currentDirection = directions[random.nextInt(directions.length)];
    correctAnswers.add(currentDirection);

    // Decrease font size to make the test harder
    fontSize = 100 - (testCount * 7); // Decrease by 7 each time

    setState(() {});
  }

  void handleUserInput(String direction) {
    if (testCount >= 10) return; // Prevent extra clicks

    String normalizedInput = direction.toLowerCase().trim();
    String correctResponse = calculateCorrectResponse();

    userResponses.add(normalizedInput);

    // Check if the user's response matches the correct answer
    if (normalizedInput == correctResponse) {
      correctCount++;
    }

    testCount++;
    generateNextE(); // Move to the next test or show the report
  }

  String calculateCorrectResponse() {
    // Determine the correct response based on the current orientation of "E"
    switch (currentDirection) {
      case 'up':
        return 'up'; // Upright "E" requires ↑
      case 'down':
        return 'down'; // Flipped "E" requires ↓
      case 'left':
        return 'right'; // Mirrored left "E" requires →
      case 'right':
        return 'left'; // Mirrored right "E" requires ←
      default:
        return ''; // Fallback
    }
  }

  void generateReport() {
    DateTime now = DateTime.now();

    String resultMessage;
    if (correctCount >= 8) {
      resultMessage = 'Your vision seems normal.';
    } else if (correctCount >= 5) {
      resultMessage = 'There may be slight blurry vision. Consider an eye checkup.';
    } else {
      resultMessage = 'Blurry vision detected. Please consult an eye specialist.';
    }

    String report = '''
Vision Test Report
Date: ${now.toLocal()}

Correct Answers: $correctCount / ${correctAnswers.length}

$resultMessage
    ''';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Test Report'),
          content: Text(report),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetTest();
              },
              child: Text('Restart Test'),
            ),
          ],
        );
      },
    );
  }

  void resetTest() {
    setState(() {
      testCount = 0;
      correctCount = 0;
      userResponses.clear();
      correctAnswers.clear();
      fontSize = 100;
      generateNextE();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blurry Vision Checker'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: testCount < 10
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LinearProgressIndicator(
              value: testCount / 10,
              minHeight: 8,
              color: Colors.green,
              backgroundColor: Colors.grey[300],
            ),
            SizedBox(height: 30),
            Text(
              'Which direction is the "E" facing?',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 30),
            ClipRect(
              child: ImageFiltered(
                imageFilter: testCount >= 7
                    ? ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5)
                    : ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
                child: RotatedBox(
                  quarterTurns: currentDirection == 'up'
                      ? 0
                      : currentDirection == 'right'
                      ? 1
                      : currentDirection == 'down'
                      ? 2
                      : 3,
                  child: Text(
                    'E',
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => handleUserInput('up'),
                  child: Text('↑'),
                ),
                ElevatedButton(
                  onPressed: () => handleUserInput('left'),
                  child: Text('←'),
                ),
                ElevatedButton(
                  onPressed: () => handleUserInput('down'),
                  child: Text('↓'),
                ),
                ElevatedButton(
                  onPressed: () => handleUserInput('right'),
                  child: Text('→'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Progress: $testCount / 10',
              style: TextStyle(fontSize: 16),
            ),
          ],
        )
            : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Test Completed!',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  resetTest();
                },
                child: Text('Restart Test'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
