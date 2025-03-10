import 'package:flutter/material.dart';
import 'meal_category.dart'; // Make sure to create this page

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'SF Pro Display',
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      home: const MealPlannerScreen(),
    );
  }
}

class MealPlannerScreen extends StatelessWidget {
  const MealPlannerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Status Bar and Back Button
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
              child: Row(
                children: [],
              ),
            ),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      // Meal Planner Title
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            Color(0xFF0066FF),
                            Color(0xFF00CCFF),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: const Text(
                          'Meal Planner',
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Today's Progress Title
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            Color(0xFF07234B),
                            Color(0xFF00CCFF),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: const Text(
                          'Today\'s Progress',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Nutrition Progress Indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          NutritionProgressIndicator(
                            value: 0.29,
                            label: 'Carbs',
                            color: Color(0xFFFFDD00),
                          ),
                          NutritionProgressIndicator(
                            value: 0.65,
                            label: 'Protein',
                            color: Color(0xFFFF6600),
                          ),
                          NutritionProgressIndicator(
                            value: 0.25,
                            label: 'Vitamins',
                            color: Color(0xFF00FF00),
                          ),
                          NutritionProgressIndicator(
                            value: 0.20,
                            label: 'Sugar',
                            color: Color(0xFFFF0000),
                          ),
                          NutritionProgressIndicator(
                            value: 0.05,
                            label: 'Fat',
                            color: Color(0xFFFF0000),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      // Eaten Section
                      const Text(
                        'Eaten',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Calories Display
                      Row(
                        children: [
                          // Calorie Pill
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF00FFB2),
                                  Color(0xFF0099FF),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Text(
                              '1200kcal',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),

                          const SizedBox(width: 24),

                          // Food and Calorie Icon
                          Image.network(
                            'https://i.imgur.com/JHy6oQw.png',
                            width: 100,
                            height: 100,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.grey.shade200,
                                  child: const Icon(Icons.fastfood, size: 40),
                                ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      // Select Your Meal Section
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            Color(0xFF0066FF),
                            Color(0xFF00CCFF),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: const Text(
                          'Select Your Meal',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),


                      // Horizontal Meal Cards
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            // Breakfast Card
                            _mealCard(
                              context,
                              imageUrl: 'lib/donot_have_diabetes/meal_plans/meal images/breakfast.jpg',
                              label: 'Breakfast',
                            ),
                            const SizedBox(width: 16),
                            // Lunch Card
                            _mealCard(
                              context,
                              imageUrl: 'donot_have_diabetes/meal_plans/meal images/lunch.jpg',
                              label: 'Lunch',
                            ),
                            const SizedBox(width: 16),
                            // Dinner Card
                            _mealCard(
                              context,
                              imageUrl: 'donot_have_diabetes/meal_plans/meal images/dinner.jpg',
                              label: 'Dinner',
                            ),
                            const SizedBox(width: 16),
                            // Snack Card
                            _mealCard(
                              context,
                              imageUrl: 'donot_have_diabetes/meal_plans/meal images/snack.jpg',
                              label: 'Snack',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                ],
                  ),
                ),
              ),
            ),
            // Bottom Navigation Bar
            Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  NavBarItem(
                    icon: Icons.menu_book,
                    color: Colors.blue,
                    isSelected: true,
                  ),
                  NavBarItem(
                    icon: Icons.favorite,
                    color: Colors.black,
                    isSelected: false,
                  ),
                  NavBarItem(
                    icon: Icons.fitness_center,
                    color: Colors.black,
                    isSelected: false,
                  ),
                  NavBarItem(
                    icon: Icons.person,
                    color: Colors.black,
                    isSelected: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to generate meal cards
  Widget _mealCard(BuildContext context, {required String imageUrl, required String label}) {
    return GestureDetector(
      onTap: () {
        // Navigate to the MealCategoryPage
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FoodCategoryScreen(mealType: label)),
        );
      },
      child: Container(
        height: 180,
        width: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            // Meal Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                bottomLeft: Radius.circular(24),
              ),
              child: Image.network(
                imageUrl,
                width: 180,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 180,
                  height: 180,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image, size: 40),
                ),
              ),
            ),
            // Meal Label
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NutritionProgressIndicator extends StatelessWidget {
  final double value;
  final String label;
  final Color color;

  const NutritionProgressIndicator({
    Key? key,
    required this.value,
    required this.label,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Background Circle
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
            // Progress Circle
            SizedBox(
              width: 64,
              height: 64,
              child: CircularProgressIndicator(
                value: value,
                strokeWidth: 6,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            // Percentage Text
            Text(
              '${(value * 100).toInt()}%',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Label
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

class NavBarItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final bool isSelected;

  const NavBarItem({
    Key? key,
    required this.icon,
    required this.color,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Icon(
        icon,
        size: 28,
        color: color,
      ),
    );
  }
}
