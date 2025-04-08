import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mybete_app/donot_have_diabetes/mind_relax/mind_relax.dart';
import 'package:mybete_app/donot_have_diabetes/meal_plans/meal.dart';
import 'package:mybete_app/donot_have_diabetes/Fitness/exercise.dart';
import 'package:mybete_app/donot_have_diabetes/mind_relax/quiz1.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const Quiz());
}

class Quiz extends StatelessWidget {
  const Quiz({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'SF Pro Display',
        scaffoldBackgroundColor: const Color(0xFFF0F4FA),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1;
  final PageController _pageController = PageController(initialPage: 1);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          MealPlannerScreen(),
          MindRelaxQuestionnairePage(),
          Exercise(),
          Center(child: Text("Profile")),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.book_outlined), label: 'Meal Plan'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Mind Relax'),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Fitness'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
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

class MindRelaxQuestionnairePage extends StatefulWidget {
  const MindRelaxQuestionnairePage({Key? key}) : super(key: key);

  @override
  State<MindRelaxQuestionnairePage> createState() => _MindRelaxQuestionnairePageState();
}

class _MindRelaxQuestionnairePageState extends State<MindRelaxQuestionnairePage> {
  bool _isSelected = false; // Initial state is not selected
  bool _showError = false; // Show error message if not selected

  // Function to proceed to Quiz1 page
  void _proceedToQuiz() {
    if (!_isSelected) {
      setState(() {
        _showError = true; // Show error message if not selected
      });
      return;
    }

    // Navigate to Quiz1 page only if the radio button is selected
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Quiz1()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView( // Ensuring scrollability to avoid overflow
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, size: 28),
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MindRelaxDashboard()),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Column(
                  children: const [
                    Text(
                      'Mind Relax',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Questionnaire',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFD6E1F3),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 24),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'lib/donot_have_diabetes/mind_relax/mind images/quiz1.png',
                        width: 250,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'To get started, confirm your age:',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _isSelected = !_isSelected; // Toggle the selection
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey.shade400, width: 2),
                            ),
                            child: _isSelected
                                ? const Center(
                                    child: CircleAvatar(
                                      radius: 6,
                                      backgroundColor: Colors.grey,
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            '16 Years or Older',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Display error message if not selected
                    if (_showError)
                      const Text(
                        "Please confirm that you are 16 years or older to proceed.",
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _proceedToQuiz,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF45B3D0),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 90),
                      ),
                      child: const Text(
                        'Get Start',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
