import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mybete_app/donot_have_diabetes/mind_relax/mind_relax.dart';
//import 'package:mybete_app/donot_have_diabetes/mind_relax/sleep2.dart';
import 'package:mybete_app/donot_have_diabetes/mind_relax/sleep_dashboard.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(0, 209, 207, 207),
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const Sleep());
}

class Sleep extends StatelessWidget {
  const Sleep({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: const Color(0xFF03174C),
      ),
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background with wave patterns
          ...buildBackgroundWaves(),

          // Stars
          ...buildStars(),

          // Main content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, size: 28),
                    onPressed: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context); // Go back if possible
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MindRelaxDashboard()), // Replace with actual previous screen
                        );
                      }
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),

                // Moon icon
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.nightlight_round,
                        color: Color(0xFFE6E7F2),
                        size: 50,
                      ),
                    ),
                  ),
                ),

                const Spacer(flex: 1),

                // Welcome text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Welcome to Sleep',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Discover the DreamWave. It harmonizes soothing frequencies with gentle visual rhythms to guide your mind into a state of deep relaxation, creating the perfect atmosphere for rejuvenating sleep.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const Spacer(flex: 2),

                // Get Started button
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 32.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                 SleepApp()), // Navigate to Sleep2 screen
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8E97FD),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(38),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'GET STARTED',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),

                // Bottom navigation
                Container(
                  height: 70,
                  decoration: const BoxDecoration(
                    color: Color(0xFF03174C),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildNavItem(Icons.book_outlined),
                      buildNavItem(Icons.favorite_border),
                      buildNavItem(Icons.fitness_center),
                      buildNavItem(Icons.person_outline),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNavItem(IconData icon) {
    return IconButton(
      icon: Icon(
        icon,
        color: Colors.white,
        size: 24,
      ),
      onPressed: () {},
    );
  }

  List<Widget> buildBackgroundWaves() {
    return [
      Positioned(
        top: 100,
        right: -100,
        child: Container(
          width: 300,
          height: 600,
          decoration: BoxDecoration(
            color: const Color(0xFF03174C).withOpacity(0.3),
            borderRadius: BorderRadius.circular(300),
          ),
        ),
      ),
      Positioned(
        top: 300,
        left: -150,
        child: Container(
          width: 300,
          height: 600,
          decoration: BoxDecoration(
            color: const Color(0xFF03174C).withOpacity(0.3),
            borderRadius: BorderRadius.circular(300),
          ),
        ),
      ),
    ];
  }

  List<Widget> buildStars() {
    return [
      buildStar(top: 150, left: 50, size: 2),
      buildStar(top: 100, right: 80, size: 3),
      buildStar(top: 250, right: 40, size: 2),
      buildStar(top: 400, left: 30, size: 2),
      buildStar(top: 350, right: 60, size: 3),
      buildStar(top: 500, left: 80, size: 2),
      buildStar(top: 550, right: 100, size: 3),
    ];
  }

  Widget buildStar(
      {double? top, double? left, double? right, required double size}) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      child: Icon(
        Icons.star,
        color: Colors.white.withOpacity(0.7),
        size: size,
      ),
    );
  }
}
