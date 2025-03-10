import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class Symptom1Screen extends StatefulWidget {
  @override
  _Symptom1ScreenState createState() => _Symptom1ScreenState();
}

class _Symptom1ScreenState extends State<Symptom1Screen> {
  int smallGlasses = 0;
  int mediumGlasses = 0;
  int largeGlasses = 0;
  int smallBottles = 0;
  int mediumBottles = 0;
  int largeBottles = 0;
  DateTime? startTime;
  Timer? timer;
  Duration remainingTime = Duration(hours: 24);
  bool isTimerRunning = false;

  @override
  void initState() {
    super.initState();
    loadTimerState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> loadTimerState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool savedIsTimerRunning = prefs.getBool('isTimerRunning') ?? false;
    if (savedIsTimerRunning) {
      int? savedStartTime = prefs.getInt('startTime');
      if (savedStartTime != null) {
        startTime = DateTime.fromMillisecondsSinceEpoch(savedStartTime);
        setState(() {
          isTimerRunning = true;
        });
        startTimer();
      }
    }
  }

  Future<void> saveTimerState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isTimerRunning', isTimerRunning);
    if (isTimerRunning && startTime != null) {
      await prefs.setInt('startTime', startTime!.millisecondsSinceEpoch);
    } else {
      await prefs.remove('startTime');
    }
  }

  void startTimer() {
    setState(() {
      startTime = DateTime.now();
      isTimerRunning = true;
    });
    saveTimerState();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        remainingTime = Duration(hours: 24) - DateTime.now().difference(startTime!);
        if (remainingTime.isNegative) {
          remainingTime = Duration.zero;
          timer.cancel();
          showResultDialog();
        }
      });
    });
  }

  void stopTimer() {
    setState(() {
      isTimerRunning = false;
      timer?.cancel();
    });
    saveTimerState();
  }

  void resetTimer() {
    setState(() {
      smallGlasses = 0;
      mediumGlasses = 0;
      largeGlasses = 0;
      smallBottles = 0;
      mediumBottles = 0;
      largeBottles = 0;
      remainingTime = Duration(hours: 24);
      isTimerRunning = false;
      timer?.cancel();
    });
    saveTimerState();
  }

  double getTotalWaterIntake() {
    double total = (smallGlasses * 200 +
        mediumGlasses * 250 +
        largeGlasses * 300 +
        smallBottles * 500 +
        mediumBottles * 750 +
        largeBottles * 1000) /
        1000;
    return total;
  }

  void showResultDialog() {
    double totalIntake = getTotalWaterIntake();
    String message;

    if (totalIntake > 5) {
      message = "You might have extreme thirst. Monitor your intake and check for other symptoms.";
    } else if (totalIntake >= 2 && totalIntake <= 3) {
      message = "Your water intake is healthy!";
    } else {
      message = "Your water intake is within a normal range.";
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('24-Hour Water Intake Result'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feeling Extra Thirsty (Polydipsia)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Step 1: How many glasses of water did you drink today?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            buildWaterIntakeRow('Small (200ml)', smallGlasses, (value) {
              setState(() {
                smallGlasses = value;
              });
            }),
            buildWaterIntakeRow('Medium (250ml)', mediumGlasses, (value) {
              setState(() {
                mediumGlasses = value;
              });
            }),
            buildWaterIntakeRow('Large (300ml)', largeGlasses, (value) {
              setState(() {
                largeGlasses = value;
              });
            }),
            SizedBox(height: 20),
            Text(
              'Step 2: How many bottles of water did you drink today?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            buildWaterIntakeRow('Small (500ml)', smallBottles, (value) {
              setState(() {
                smallBottles = value;
              });
            }),
            buildWaterIntakeRow('Medium (750ml)', mediumBottles, (value) {
              setState(() {
                mediumBottles = value;
              });
            }),
            buildWaterIntakeRow('Large (1L)', largeBottles, (value) {
              setState(() {
                largeBottles = value;
              });
            }),
            SizedBox(height: 20),
            Text(
              'Step 3: Here’s your total water intake:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '${getTotalWaterIntake().toStringAsFixed(2)} liters',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            if (getTotalWaterIntake() > 5)
              Text(
                'You might have extreme thirst. Monitor your intake and check for other symptoms.',
                style: TextStyle(fontSize: 18, color: Colors.red),
              )
            else if (getTotalWaterIntake() >= 2 && getTotalWaterIntake() <= 3)
              Text(
                'Your water intake is healthy!',
                style: TextStyle(fontSize: 18, color: Colors.green),
              )
            else
              Text(
                'Your water intake is within a normal range.',
                style: TextStyle(fontSize: 18, color: Colors.orange),
              ),
            SizedBox(height: 20),
            Text(
              'Time remaining: ${remainingTime.inHours}:${(remainingTime.inMinutes % 60).toString().padLeft(2, '0')}:${(remainingTime.inSeconds % 60).toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: isTimerRunning ? null : startTimer,
                  child: Text('Start Timer'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: isTimerRunning ? stopTimer : null,
                  child: Text('Stop Timer'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: resetTimer,
                  child: Text('Reset Timer'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildWaterIntakeRow(String label, int count, Function(int) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () {
                if (count > 0) onChanged(count - 1);
              },
            ),
            Text('$count', style: TextStyle(fontSize: 16)),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                onChanged(count + 1);
              },
            ),
          ],
        ),
      ],
    );
  }
}