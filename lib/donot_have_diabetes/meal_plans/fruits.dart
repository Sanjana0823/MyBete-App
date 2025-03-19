import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'total_screen.dart'; // Add this line

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        scaffoldBackgroundColor: const Color(0xFFFEE5E5),
      ),
      home: const FruitsScreen(),
    );
  }
}

class FruitsScreen extends StatelessWidget {
  const FruitsScreen({Key? key}) : super(key: key);

  // Function to add calorie to Firestore
  void _addCalorieToFirebase(String name, int calories) async {
    final userId = 'user123'; // Replace with actual user ID
    final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

    try {
      // Get the current total calorie count for the user
      final userDoc = await userRef.get();
      int totalCalories = 0;

      if (userDoc.exists) {
        // If user document exists, fetch total calories (or set to 0 if not present)
        totalCalories = userDoc.data()?['total_calories'] ?? 0;
      }

      // Update the total calorie count by adding the vegetable's calories
      totalCalories += calories;

      // Save the updated total calorie count back to Firestore
      await userRef.set({
        'total_calories': totalCalories,
      }, SetOptions(merge: true));

      // Optionally: You can also add a document in a subcollection for individual vegetables
      await userRef.collection('fruit_calories').add({
        'name': name,
        'calories': calories,
        'timestamp': FieldValue.serverTimestamp(), // Adds a timestamp for the entry
      });

      print("Calories added successfully!");
    } catch (e) {
      print("Error adding calories: $e");
    }
  }

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
                children: [
                  // Back Button
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),

                      // Fruits Title
                      const Text(
                        'Fruits',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Search Bar
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3EDF7),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.search,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Search fruits',
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Low-Calorie Fruits Section
                      const Text(
                        'Low-Calorie Fruits',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const Text(
                        '(Below 50 kcal per 100g)',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Low-Calorie Fruits Grid
                      Row(
                        children: [
                          Expanded(
                            child: FruitCard(
                              name: 'Watermelon',
                              calories: 30,
                              imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/watermelon.png',
                              onAdd: (name, calories) {
                                _addCalorieToFirebase(name, calories);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FruitCard(
                              name: 'Strawberry',
                              calories: 32,
                              imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/strawberry.png',
                              onAdd: (name, calories) {
                                _addCalorieToFirebase(name, calories);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FruitCard(
                              name: 'Cantaloupe',
                              calories: 34,
                              imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/cantaloupe.png',
                              onAdd: (name, calories) {
                                _addCalorieToFirebase(name, calories);
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Moderate-Calorie Fruits Section
                      const Text(
                        'Moderate-Calorie Fruits',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const Text(
                        '(Below 50 - 100kcal per 100g)',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Moderate-Calorie Fruits Grid
                      Row(
                        children: [
                          Expanded(
                            child: FruitCard(
                              name: 'Apple',
                              calories: 52,
                              imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/apple.png',
                              onAdd: (name, calories) {
                                _addCalorieToFirebase(name, calories);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FruitCard(
                              name: 'Pear',
                              calories: 57,
                              imagePath: 'alib/donot_have_diabetes/meal_plans/meal_images/pear.png',
                              onAdd: (name, calories) {
                                _addCalorieToFirebase(name, calories);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FruitCard(
                              name: 'Mango',
                              calories: 60,
                              imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/mango.png',
                              onAdd: (name, calories) {
                                _addCalorieToFirebase(name, calories);
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // High-Calorie Fruits Section
                      const Text(
                        'High-Calorie Fruits',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const Text(
                        '(Above 100 kcal per 100g)',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // High-Calorie Fruits Grid
                      Row(
                        children: [
                          Expanded(
                            child: FruitCard(
                              name: 'Avocado',
                              calories: 160,
                              imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/avacado.png',
                              onAdd: (name, calories) {
                                _addCalorieToFirebase(name, calories);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FruitCard(
                              name: 'Dates(dried)',
                              calories: 282,
                              imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/dates.png',
                              onAdd: (name, calories) {
                                _addCalorieToFirebase(name, calories);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FruitCard(
                              name: 'Figs(dried)',
                              calories: 249,
                              imagePath: 'assets/figs.png',
                              onAdd: (name, calories) {
                                _addCalorieToFirebase(name, calories);
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                      // Add View Total Calories Button
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const TotalScreen(category: 'Fruits')), // Navigate to TotalScreen
                              );
                            },
                            child: const Text(
                              'View Total Calories',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
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
}

class FruitCard extends StatelessWidget {
  final String name;
  final int calories;
  final String imagePath;
  final void Function(String, int) onAdd;

  const FruitCard({
    Key? key,
    required this.name,
    required this.calories,
    required this.imagePath,
    required this.onAdd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Fruit Image
            SizedBox(
              height: 80,
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 80,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image, size: 40),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Fruit Name
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 4),

            // Calorie Info and Add Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$calories kcal',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00C853),
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    onAdd(name, calories);  // Trigger the onAdd callback with proper parameters

                    // Show a snackbar to confirm addition
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Added $name ($calories kcal)'),
                        duration: const Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00FF62),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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