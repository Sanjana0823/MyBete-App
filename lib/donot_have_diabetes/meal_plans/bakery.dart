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
        scaffoldBackgroundColor: const Color(0xFFFEE8E0),
      ),
      home: const BakeryItemsScreen(),
    );
  }
}

class BakeryItemsScreen extends StatelessWidget {
  const BakeryItemsScreen({Key? key}) : super(key: key);

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
      await userRef.collection('bakery_calories').add({
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

                      // Bakery Items Title
                      const Text(
                        'Bakery Items',
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
                                    hintText: 'Search bakery items',
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

                      // Low-Calorie Bakery Items Section
                      const Text(
                        'Low-Calorie Bakery Items',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Text(
                        '(Below 300 kcal per 100g)',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Low-Calorie Bakery Items Grid
                      SizedBox(
                        height: 217, // Set a fixed height for the horizontal scroll area
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                            BakeryItemCard(
                              name: 'White Bread',
                              calories: 265,
                              imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/white-bread.png',
                              onAdd: (name, calories) {
                                _addCalorieToFirebase(name, calories);
                              },
                            ),

                            const SizedBox(width: 12),
                            BakeryItemCard(
                                name: 'Whole Wheat Bread',
                                calories: 247,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/whole wheat bread.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),

                            const SizedBox(width: 12),
                            BakeryItemCard(
                                name: 'Multigrain Bread',
                                calories: 250,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/multigrain bread.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                               ),

                              const SizedBox(width: 12),
                              BakeryItemCard(
                                name: 'Rye Bread',
                                calories: 259,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/rye bread.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),

                              const SizedBox(width: 12),
                              BakeryItemCard(
                                name: 'Baguette',
                                calories: 270,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/baguette.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),

                              const SizedBox(width: 12),
                              BakeryItemCard(
                                name: 'Pita Bread',
                                calories: 275,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/pita bread.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),

                              const SizedBox(width: 12),
                              BakeryItemCard(
                                name: 'Bagel(Plain)',
                                calories: 250,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/bagel.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),
                             ],
                           ),
                          ),
                        ),

                            const SizedBox(height: 24),

                            // Moderate-Calorie Bakery Items Section
                            const Text(
                              'Moderate-Calorie Bakery Items',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,

                              ),
                            ),

                            const Text(
                              '(250-450 kcal per 100g)',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,

                              ),
                            ),

                            const SizedBox(height: 16),

                      // Moderate-Calorie Bakery Items Grid
                          SizedBox(
                            height: 217, // Set a fixed height for the horizontal scroll area
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  BakeryItemCard(
                                    name: 'Croissant',
                                    calories: 406,
                                    imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/croissant.png',
                                    onAdd: (name, calories) {
                                      _addCalorieToFirebase(name, calories);
                                    },
                                   ),

                                  const SizedBox(width: 12),
                                  BakeryItemCard(
                                      name: 'Cinnamon roll',
                                      calories: 450,
                                      imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/cinnamon-roll.png',
                                      onAdd: (name, calories) {
                                        _addCalorieToFirebase(name, calories);
                                      },
                                  ),
                                  const SizedBox(width: 12),
                                  BakeryItemCard(
                                      name: 'Chocolate Cake',
                                      calories: 371,
                                      imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/cake.png',
                                      onAdd: (name, calories) {
                                        _addCalorieToFirebase(name, calories);
                                      },
                                  ),

                                  const SizedBox(width: 12),
                                  BakeryItemCard(
                                    name: 'Cheese Cake',
                                    calories: 321,
                                    imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/cheese cake.png',
                                    onAdd: (name, calories) {
                                      _addCalorieToFirebase(name, calories);
                                    },
                                  ),

                                  const SizedBox(width: 12),
                                  BakeryItemCard(
                                    name: 'Banana Bread',
                                    calories: 326,
                                    imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/banana bread.png',
                                    onAdd: (name, calories) {
                                      _addCalorieToFirebase(name, calories);
                                    },
                                  ),

                                  const SizedBox(width: 12),
                                  BakeryItemCard(
                                    name: 'Cheese Bread',
                                    calories: 330,
                                    imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/cheese bread.png',
                                    onAdd: (name, calories) {
                                      _addCalorieToFirebase(name, calories);
                                    },
                                  ),

                                  const SizedBox(width: 12),
                                  BakeryItemCard(
                                    name: 'Pretzel',
                                    calories: 340,
                                    imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/pretzel.png',
                                    onAdd: (name, calories) {
                                      _addCalorieToFirebase(name, calories);
                                    },
                                  ),

                                  const SizedBox(width: 12),
                                  BakeryItemCard(
                                    name: 'Garlic Bread',
                                    calories: 360,
                                    imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/garlic bread.png',
                                    onAdd: (name, calories) {
                                      _addCalorieToFirebase(name, calories);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                            const SizedBox(height: 24),

                            // High-Calorie Bakery Items Section
                            const Text(
                              'High-Calorie Bakery Items',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,

                              ),
                            ),

                            const Text(
                              '(Above 450 kcal per 100g)',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,

                              ),
                            ),

                            const SizedBox(height: 16),

                            // High-Calorie Bakery Items Grid
                              SizedBox(
                                height: 217, // Set a fixed height for the horizontal scroll area
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      BakeryItemCard(
                                        name: 'Puff Pastry',
                                        calories: 558,
                                        imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/puff pastry.png',
                                        onAdd: (name, calories) {
                                          _addCalorieToFirebase(name, calories);
                                        },
                                      ),

                                    const SizedBox(width: 12),
                                      BakeryItemCard(
                                        name: 'Butter Cookies',
                                        calories: 520,
                                        imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/butter cookies.png',
                                        onAdd: (name, calories) {
                                          _addCalorieToFirebase(name, calories);
                                        },
                                      ),

                                    const SizedBox(width: 12),
                                      BakeryItemCard(
                                        name: 'Oatmeal Cookies',
                                        calories: 450,
                                        imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/oatmeal cookies.png',
                                        onAdd: (name, calories) {
                                        _addCalorieToFirebase(name, calories);
                                        },
                                      ),

                                      const SizedBox(width: 12),
                                      BakeryItemCard(
                                        name: 'Glazed Donut',
                                        calories: 452,
                                        imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/glazed donut.png',
                                        onAdd: (name, calories) {
                                          _addCalorieToFirebase(name, calories);
                                        },
                                      ),

                                      const SizedBox(width: 12),
                                      BakeryItemCard(
                                        name: 'Pound Cake',
                                        calories: 430,
                                        imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/pound cake.png',
                                        onAdd: (name, calories) {
                                          _addCalorieToFirebase(name, calories);
                                        },
                                      ),

                                      const SizedBox(width: 12),
                                      BakeryItemCard(
                                        name: 'Muffin',
                                        calories: 400,
                                        imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/muffin.png',
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

            // Bottom Navigation Bar


              ],
            ),
    ),
    );
  }
}


class BakeryItemCard extends StatelessWidget {
  final String name;
  final int calories;
  final String imagePath;
  final Function(String, int) onAdd;


  const BakeryItemCard({
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