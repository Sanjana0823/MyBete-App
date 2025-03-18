import 'package:flutter/material.dart';
import 'package:mybete_app/donot_have_diabetes/meal_plans/meal.dart';
import 'package:mybete_app/donot_have_diabetes/mind_relax/quiz.dart';
import 'package:mybete_app/donot_have_diabetes/Fitness/exercise.dart';
import 'package:mybete_app/donot_have_diabetes/mind_relax/sleep.dart';
import 'package:mybete_app/donot_have_diabetes/meal_plans/meal.dart';
import 'package:mybete_app/donot_have_diabetes/mind_relax/music.dart';

void main() {
  runApp(const MindRelaxDashboard());
}

class MindRelaxDashboard extends StatelessWidget {
  const MindRelaxDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mental Health App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
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

  //navigation bar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      // Meal Plan Page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MealPlannerScreen()),
      );
    } else if (index == 2) {
      // Fitness Page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Exercise()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Mental Health Questionnaire Card
              FeatureCard(
                title: 'Mental Health Questionnaire',
                description:
                    'Regular mental health check-ins help you stay proactive, identify risks, and maintain balance in daily life.',
                buttonText: 'Take Questionnaire',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Quiz()), // Navigate to QuizPage
                  );
                },
              ),

              const SizedBox(height: 20),

              // Sleep Card
              FeatureCard(
                title: 'Sleep',
                description:
                    'Quality sleep is essential for mental and physical well-being. Prioritize rest to improve mood, focus, and overall health.',
                buttonText: 'Get Start',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Sleep()), // Navigate to Sleep screen
                  );
                },
              ),

              const SizedBox(height: 20),

              const SizedBox(height: 20),
              // Meditate Card
              FeatureCard(
                title: 'Meditate and relax music',
                description:
                    'Meditation and relaxing music can help reduce stress, improve focus, and promote a sense of calm for better well-being.',
                buttonText: 'Get Start',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            music()), // Navigate to Sleep screen
                  );
                },
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            label: 'Meal Plan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Mind_relax',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center), // Fitness Page
            label: 'Fitness',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
        showSelectedLabels: true,
        showUnselectedLabels: false,
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback? onTap; // New parameter for button action

  const FeatureCard({
    Key? key,
    required this.title,
    required this.description,
    required this.buttonText,
    this.onTap, // Receive function for navigation
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: const Color(0xFF8DD3F2),
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              shadows: [
                Shadow(
                  offset: Offset(1.0, 1.0),
                  blurRadius: 3.0,
                  color: Color.fromRGBO(0, 0, 0, 0.3),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onTap, // Use the function passed as an argument
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4BAED1),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 5,
              shadowColor: Colors.black.withOpacity(0.3),
            ),
            child: Text(
              buttonText,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
