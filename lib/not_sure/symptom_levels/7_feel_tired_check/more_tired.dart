import 'package:flutter/material.dart';

class Symptom7Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feeling more tired than usual'),
      ),
      body: Center(
        child: Text(
          'Details and method to check Feeling more tired than usual',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}