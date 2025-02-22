import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/color.dart';
import 'donot_have_diabetes/donot_have_diabete.dart';
import 'have_diabetes/have_diabete.dart';
import 'not_sure/not_sure.dart';

class DiabeteOptions extends StatelessWidget {
  const DiabeteOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Diabetes Options")), // Add an app bar
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.setBool("onboarding", false);
              },
              child: Text("Choose one option from these three"),
            ),
            SizedBox(height: 20), // Space between elements
            haveDiabetes(context),
            SizedBox(height: 20),
            doNotHaveDiabetes(context),
            SizedBox(height: 20),
            notSure(context),// Correctly use the button here
          ],
        ),
      ),
    );
  }
}

Widget haveDiabetes(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Colors.red, // Replace with primaryColor if needed
    ),
    width: 200, // Give it a fixed width
    height: 55,
    child: TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HaveDiabeteDashboard()),
        );
      },
      child: const Text(
        "I have diabetes",
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    ),
  );
}

Widget doNotHaveDiabetes(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Colors.blue, // Replace with primaryColor if needed
    ),
    width: 200, // Give it a fixed width
    height: 55,
    child: TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DonotHaveDiabeteDashboard()),
        );
      },
      child: const Text(
        "I don't have diabetes",
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    ),
  );
}

Widget notSure(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Colors.blue, // Replace with primaryColor if needed
    ),
    width: 200, // Give it a fixed width
    height: 55,
    child: TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NotSureDashboard()),
        );
      },
      child: const Text(
        "I'm not sure",
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    ),
  );
}
