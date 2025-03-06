import 'dart:ui';
import 'package:flutter/material.dart';

final class AppFontCollection {
  const AppFontCollection._();

  /// fontFamily = Bold
  static const String bold = 'Bold';

  /// fontFamily = Regular
  static const String regular = 'Regular';

  static List<Map<String, String>> get map => [
    {'fontFamily': bold},
    {'fontFamily': regular},
  ];
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Font Collection Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontFamily: AppFontCollection.bold, fontSize: 18),
          bodyMedium: TextStyle(fontFamily: AppFontCollection.regular, fontSize: 16),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Font Collection Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('This is Bold Font', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 20),
            Text('This is Regular Font', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
