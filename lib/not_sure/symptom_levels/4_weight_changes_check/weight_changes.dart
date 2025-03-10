import 'package:flutter/material.dart';

class Symptom4Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weight changes'),
      ),
      body: Center(
        child: Text(
          'Details and method to check Weight changes',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}