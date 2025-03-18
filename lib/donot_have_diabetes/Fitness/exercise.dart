import 'package:flutter/material.dart';
import 'package:mybete_app/donot_have_diabetes/Fitness/exercise_dashboard.dart';


class Exercise extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ExerciseDashboard(),
    );
  }
}

