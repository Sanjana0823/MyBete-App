import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Added import for FirebaseAuth
import 'total_screen.dart';

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
        scaffoldBackgroundColor: const Color(0xFFE5FFED),
      ),
      home: const VegetablesScreen(),
    );
  }
}

class VegetablesScreen extends StatelessWidget {
  const VegetablesScreen({Key? key}) : super(key: key);

  // Function to add calorie to Firestore
  void _addCalorieToFirebase(String name, int calories) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;

    // Check if user is signed in
    if (_auth.currentUser == null) {
      print("Error: No authenticated user found");
      return;
    }

    // Initialize userRef with the current user's document
    DocumentReference userRef = _firestore.collection('users').doc(_auth.currentUser!.uid);

    try {
      // Get the current total calorie count for the user
      final userDoc = await userRef.get();
      int totalCalories = 0;

      if (userDoc.exists) {
        // Cast the document data to Map to access fields
        final userData = userDoc.data() as Map<String, dynamic>?;
        // If user document exists, fetch total calories (or set to 0 if not present)
        totalCalories = userData?['total_calories'] ?? 0;
      }

      // Update the total calorie count by adding the vegetable's calories
      totalCalories += calories;

      // Save the updated total calorie count back to Firestore
      await userRef.set({
        'total_calories': totalCalories,
      }, SetOptions(merge: true));

      // Get current time to determine meal type
      final now = DateTime.now();
      final hour = now.hour;
      String mealType = 'Snack';

      if (hour >= 5 && hour < 11) {
        mealType = 'Breakfast';
      } else if (hour >= 11 && hour < 15) {
        mealType = 'Lunch';
      } else if (hour >= 17 && hour < 22) {
        mealType = 'Dinner';
      }

      // Optionally: You can also add a document in a subcollection for individual vegetables
      await userRef.collection('vegetable_calories').add({
        'name': name,
        'calories': calories,
        'timestamp': FieldValue.serverTimestamp(), // Adds a timestamp for the entry
        'mealType': mealType,
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
                      Navigator.pop(context); // Navigates back to the previous screen
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

                      // Vegetables Title
                      const Text(
                        'Vegetables',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
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
                                    hintText: 'Search vegetables',
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

                      // Low-Calorie Vegetables Section
                      const Text(
                        'Low-Calorie Vegetables',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,

                        ),
                      ),

                      const Text(
                        '(Below 30 kcal per 100g)',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,

                        ),
                      ),

                      const SizedBox(height: 16),

                      // Low-Calorie Vegetables - HORIZONTAL SCROLLING
                      SizedBox(
                        height: 217, // Set a fixed height for the horizontal scroll area
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              VegetableCard(
                                name: 'Tomato',
                                calories: 18,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/tomato.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),
                              const SizedBox(width: 12),
                              VegetableCard(
                                name: 'Cucumber',
                                calories: 15,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/cucumber.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),
                              const SizedBox(width: 12),
                              VegetableCard(
                                name: 'Spinach',
                                calories: 23,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/spinach.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),
                              const SizedBox(width: 12),
                              VegetableCard(
                                name: 'Zucchini',
                                calories: 17,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/zucchini.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),
                              const SizedBox(width: 12),
                              VegetableCard(
                                name: 'Radish',
                                calories: 16,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/radish.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),
                              const SizedBox(width: 12),
                              VegetableCard(
                                name: 'Cabbage',
                                calories: 25,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/cabbage.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),
                              const SizedBox(width: 12),
                              VegetableCard(
                                name: 'Celery',
                                calories: 16,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/celery.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),
                              const SizedBox(width: 12),
                              VegetableCard(
                                name: 'Cauliflower',
                                calories: 25,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/cauliflower.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),
                              const SizedBox(width: 12),
                              VegetableCard(
                                name: 'Bell Pepper',
                                calories: 20,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/bell_pepper.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),
                              const SizedBox(width: 12),
                              VegetableCard(
                                name: 'Lettuce',
                                calories: 15,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/lettuce.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),
                              const SizedBox(width: 12),
                              VegetableCard(
                                name: 'Asparagus',
                                calories: 15,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/asparagus.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),
                              const SizedBox(width: 12),
                              VegetableCard(
                                name: 'Mushroom',
                                calories: 22,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/mushroom.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),
                              const SizedBox(width: 12),
                              VegetableCard(
                                name: 'Bok Choy',
                                calories: 13,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/bok_choy.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),
                              const SizedBox(width: 12),
                              VegetableCard(
                                name: 'Watercress',
                                calories: 11,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/watercress.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Moderate-Calorie Vegetables Section
                      const Text(
                        'Moderate-Calorie Vegetables',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,

                        ),
                      ),

                      const Text(
                        '(Below 30 - 60kcal per 100g)',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,

                        ),
                      ),

                      const SizedBox(height: 16),

                      // Moderate-Calorie Vegetables - HORIZONTAL SCROLLING
                      SizedBox(
                        height: 217, // Set a fixed height for the horizontal scroll area
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              VegetableCard(
                                name: 'Carrot',
                                calories: 41,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/carrot.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),
                              const SizedBox(width: 12),
                              VegetableCard(
                                name: 'Green Peas',
                                calories: 42,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/green_peas.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),
                              const SizedBox(width: 12),
                              VegetableCard(
                                name: 'Beetroot',
                                calories: 43,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/beetroot.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),
                              const SizedBox(width: 12),
                              VegetableCard(
                                name: 'Eggplant',
                                calories: 35,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/eggplant.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),
                              const SizedBox(width: 12),
                              VegetableCard(
                                name: 'Pumpkin',
                                calories: 45,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/pumpkin.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),
                              const SizedBox(width: 12),
                              VegetableCard(
                                name: 'Sweet Corn',
                                calories: 86,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/sweetcorn.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),
                              const SizedBox(width: 12),
                              VegetableCard(
                                name: 'Onion',
                                calories: 40,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/onion.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),
                              const SizedBox(width: 12),
                              VegetableCard(
                                name: 'Shallots',
                                calories: 72,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/shallots.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),
                              const SizedBox(width: 12),
                              VegetableCard(
                                name: 'Leeks',
                                calories: 61,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/leeks.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // High-Calorie Vegetables Section
                      const Text(
                        'High-Calorie Vegetables',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,

                        ),
                      ),

                      const Text(
                        '(60 + kcal per 100g)',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,

                        ),
                      ),

                      const SizedBox(height: 16),

                      // High-Calorie Vegetables - HORIZONTAL SCROLLING
                      SizedBox(
                        height: 217, // Reduced height for consistency with other sections
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              VegetableCard(
                                name: 'Potatoes',
                                calories: 86,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/potatoes.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),
                              const SizedBox(width: 12),
                              VegetableCard(
                                name: 'Sweet potatoes',
                                calories: 87,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/sweet_potatoes.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),
                              const SizedBox(width: 12),
                              VegetableCard(
                                name: 'Cassava',
                                calories: 160,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/cassava.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Add View Total Calories Button
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const TotalScreen(category: 'Vegetables')), // Navigate to TotalScreen
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
          ],
        ),
      ),
    );
  }
}

class VegetableCard extends StatelessWidget {
  final String name;
  final int calories;
  final String imagePath;
  final Function(String, int) onAdd; // Updated callback type

  const VegetableCard({
    Key? key,
    required this.name,
    required this.calories,
    required this.imagePath,
    required this.onAdd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140, // Set a fixed width for each card in horizontal scroll
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
            // Vegetable Image
            SizedBox(
              height: 100,
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 80,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image, size: 80),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Vegetable Name
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
                    color: Color(0xFF009439),
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