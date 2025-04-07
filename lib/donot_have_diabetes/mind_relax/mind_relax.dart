import 'package:flutter/material.dart';
import 'package:mybete_app/donot_have_diabetes/meal_plans/meal.dart';
import 'package:mybete_app/donot_have_diabetes/mind_relax/quiz.dart';
import 'package:mybete_app/donot_have_diabetes/Fitness/exercise.dart';
import 'package:mybete_app/donot_have_diabetes/mind_relax/sleep.dart';
import 'package:mybete_app/donot_have_diabetes/mind_relax/music.dart';
import 'package:mybete_app/donot_have_diabetes/donot_have_diabete.dart';// Import for back navigation

void main() {
  runApp(const MindRelaxDashboard());
}

class MindRelaxDashboard extends StatelessWidget {
  const MindRelaxDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mind Relax',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Poppins',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          elevation: 0,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MealPlannerScreen()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Exercise()),
      );
    }
  }

  // Function to handle back button press
  void _goBackToDiabetesDashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DonotHaveDiabeteDashboard()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mind Relax',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        // Add back button
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _goBackToDiabetesDashboard,
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const SizedBox(height: 16),
            
            // Welcome message
            const Text(
              'Welcome to Mind Relax',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            
            const SizedBox(height: 8),
            
            const Text(
              'Choose an activity to improve your mental wellbeing',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Mental Health Questionnaire Card
            ActivityCard(
              title: 'Mental Health Questionnaire',
              description: 'Take a quick assessment to understand your mental wellbeing',
              icon: Icons.psychology,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Quiz()),
                );
              },
            ),
            
            const SizedBox(height: 16),
            
            // Sleep Card
            ActivityCard(
              title: 'Sleep Better',
              description: 'Improve your sleep quality with guided relaxation techniques',
              icon: Icons.nightlight_round,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Sleep()),
                );
              },
            ),
            
            const SizedBox(height: 16),
            
            // Meditation Card
            ActivityCard(
              title: 'Meditation & Music',
              description: 'Calm your mind with soothing sounds and guided meditation',
              icon: Icons.self_improvement,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Music()),
                );
              },
            ),
            
            const SizedBox(height: 32),
            
            // Quick tip
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: Colors.blue.shade700,
                    size: 24,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Tip of the Day',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Take a few deep breaths when feeling stressed. Breathe in for 4 counts, hold for 4, exhale for 6.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Meal Plan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.self_improvement),
            label: 'Mind Relax',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Fitness',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const ActivityCard({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: Colors.blue,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

