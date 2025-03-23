import 'package:flutter/material.dart';
import 'package:mybete_app/diabete_options.dart';
import 'not_sure.dart';
import 'my_report.dart';
import 'profile.dart';

class NavigationBarWidget extends StatelessWidget {
  final int currentIndex;

  const NavigationBarWidget({Key? key, required this.currentIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => DiabeteOptions()), // Home
            );
            break;
          case 1:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => NotSureDashboard()), // Symptom Checker
            );
            break;
          case 2:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MyReportScreen()), // My Report
            );
            break;
          case 3:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()), // User Profile
            );
            break;
        }
      },
      selectedItemColor: Color(0xFF288994), // Highlighted color for selected tab
      unselectedItemColor: Colors.grey, // Color for unselected tabs
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home), // Home Icon
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search), // Symptom Checker Icon
          label: 'Symptom Checker',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.description), // My Report Icon
          label: 'My Report',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person), // User Icon
          label: 'User',
        ),
      ],
    );
  }
}
