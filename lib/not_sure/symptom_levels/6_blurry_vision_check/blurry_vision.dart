import 'package:flutter/material.dart';

class Symptom6Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blurry vision'),
      ),
      body: Center(
        child: Text(
          'Details and method to check Blurry vision',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}