import 'package:flutter/material.dart';

class Symptom8Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Skin changes'),
      ),
      body: Center(
        child: Text(
          'Details and method to check Skin changes',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}