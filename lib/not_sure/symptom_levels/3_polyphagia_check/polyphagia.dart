import 'package:flutter/material.dart';

class Symptom3Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Extreme Hunger (Polyphagia)'),
      ),
      body: Center(
        child: Text(
          'Details and method to check Extreme Hunger (Polyphagia)',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}