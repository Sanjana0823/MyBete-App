import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        scaffoldBackgroundColor: const Color(0xFFF0E6FF), // Light purple background
      ),
      home: const BeveragesScreen(),
    );
  }
}

class BeveragesScreen extends StatelessWidget {
  const BeveragesScreen({Key? key}) : super(key: key);

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
      await userRef.collection('beverage_calories').add({
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

                      // Beverages Title
                      const Text(
                        'Beverages',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
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
                                    hintText: 'Search beverages',
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

                      // Low-Calorie Beverages Section
                      const Text(
                        'Low-Calorie Beverages',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,

                        ),
                      ),

                      const Text(
                        '(Below 10 kcal per 100ml)',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,

                        ),
                      ),

                      const SizedBox(height: 16),

                      // Low-Calorie Beverages Grid
                      SizedBox(
                        height: 217, // Set a fixed height for the horizontal scroll area
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              BeverageCard(
                                name: 'Water',
                                calories: 0,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/water-bottle.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),

                              const SizedBox(width: 12),
                              BeverageCard(
                                name: 'Black Coffee (Unsweetened)',
                                calories: 2,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/black_coffee.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),

                              const SizedBox(width: 12),
                              BeverageCard(
                                name: 'Black Tea (Unsweetened)',
                                calories: 1,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/black-tea.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),

                              const SizedBox(width: 12),
                              BeverageCard(
                                name: 'Green Tea (Unsweetened)',
                                calories: 1,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/green-tea.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),

                              const SizedBox(width: 12),
                              BeverageCard(
                                name: 'Herbal Tea (Unsweetened)',
                                calories: 2,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/herbal-tea.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),

                              const SizedBox(width: 12),
                              BeverageCard(
                                name: 'Diet Soda (Artificially Sweetened)',
                                calories: 5,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/soda.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Moderate-Calorie Beverages Section
                      const Text(
                        'Moderate-Calorie Beverages',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,

                        ),
                      ),

                      const Text(
                        '(10-50 kcal per 100ml)',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,

                        ),
                      ),

                      const SizedBox(height: 16),

                      // Moderate-Calorie Beverages Grid
                      SizedBox(
                        height: 217, // Set a fixed height for the horizontal scroll area
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              BeverageCard(
                                name: 'Coconut Water (Unsweetened)',
                                calories: 19,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/coconut.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),

                              const SizedBox(width: 12),
                              BeverageCard(
                                name: 'Soy Milk (Unsweetened)',
                                calories: 33,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/soy-milk.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),

                              const SizedBox(width: 12),
                              BeverageCard(
                                name: 'Almond Milk (Unsweetened)',
                                calories: 15,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/almond-milk.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),

                              const SizedBox(width: 12),
                              BeverageCard(
                                name: 'Orange Juice (Fresh)',
                                calories: 45,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/orange-juice.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // High-Calorie Beverages Section
                      const Text(
                        'High-Calorie Beverages',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,

                        ),
                      ),

                      const Text(
                        '(Above 50 kcal per 100ml)',
                        style: TextStyle(
                          fontSize: 20,

                        ),
                      ),

                      const SizedBox(height: 16),

                      // High-Calorie Beverages Grid
                      SizedBox(
                        height: 217, // Set a fixed height for the horizontal scroll area
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              BeverageCard(
                                name: 'Papaya Fruit Juice (Sweetened)',
                                calories: 70,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/papaya (1).png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),

                              const SizedBox(width: 12),
                              BeverageCard(
                                name: 'Chocolate Milk',
                                calories: 85,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/chocolate-milk.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),

                              const SizedBox(width: 12),
                              BeverageCard(
                                name: 'Strawberry Milkshake',
                                calories: 150,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/strawberry_milkshake.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),

                              const SizedBox(width: 12),
                              BeverageCard(
                                name: 'Banana Smoothie',
                                calories: 120,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/banana_smoothie.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),

                              const SizedBox(width: 12),
                              BeverageCard(
                                name: 'Mango Lassi',
                                calories: 150,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/mango_lassi.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),

                              const SizedBox(width: 12),
                              BeverageCard(
                                name: 'Beer',
                                calories: 43,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/beer.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),

                              const SizedBox(width: 12),
                              BeverageCard(
                                name: 'Wine (Red/White)',
                                calories: 85,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/wine.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),

                              const SizedBox(width: 12),
                              BeverageCard(
                                name: 'Whiskey',
                                calories: 231,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/whisky.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),

                              const SizedBox(width: 12),
                              BeverageCard(
                                name: 'Vodka',
                                calories: 231,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/vodka.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),

                              const SizedBox(width: 12),
                              BeverageCard(
                                name: 'Margarita',
                                calories: 250,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/margarita.png',
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
                                MaterialPageRoute(builder: (context) => const TotalScreen(category: 'Beverages')),
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


          ],
        ),
      ),
    );
  }
}

class BeverageCard extends StatelessWidget {
  final String name;
  final int calories;
  final String imagePath;
  final void Function(String, int) onAdd;


  const BeverageCard({
    Key? key,
    required this.name,
    required this.calories,
    required this.imagePath,
    required this.onAdd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
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
            // Beverage Image
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

            // Beverage Name
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
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