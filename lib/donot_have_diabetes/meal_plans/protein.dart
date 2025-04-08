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
        scaffoldBackgroundColor: const Color(0xFFFCE4EC),
      ),
      home: const AnimalProteinsScreen(),
    );
  }
}

class AnimalProteinsScreen extends StatelessWidget {
  const AnimalProteinsScreen({Key? key}) : super(key: key);

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
      await userRef.collection('protein_calories').add({
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

                      // Animal Proteins Title
                      const Text(
                        'Animal Proteins',
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
                          color: const Color(0xFFF3E5F5),
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
                                    hintText: 'Search animal proteins',
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

                      // Low-Calorie Animal Proteins Section
                      const Text(
                        'Low-Calorie Animal Proteins',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,

                        ),
                      ),

                      const Text(
                        '(Below 100 kcal per 100g)',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,

                        ),
                      ),

                      const SizedBox(height: 16),

                      // Low-Calorie Animal Proteins Grid
                      SizedBox(
                        height: 217, // Set a fixed height for the horizontal scroll area
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              ProteinCard(
                                name: 'Egg Whites',
                                calories: 52,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/egg_whites.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),

                              const SizedBox(width: 12),
                              ProteinCard(
                                name: 'Shrimp',
                                calories: 85,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/shrimp.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),

                              const SizedBox(width: 12),
                              ProteinCard(
                                name: 'Crab',
                                calories: 82,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/crab.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),

                              const SizedBox(width: 12),
                              ProteinCard(
                                name: 'Cod',
                                calories: 82,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/cod.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),

                              const SizedBox(width: 12),
                              ProteinCard(
                                name: 'Tilapia',
                                calories: 96,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/tilapia.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),

                              const SizedBox(width: 12),
                              ProteinCard(
                                name: 'Scallops',
                                calories: 69,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/scallops.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),

                              const SizedBox(width: 12),
                              ProteinCard(
                                name: 'Clams',
                                calories: 79,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/shellfish.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Moderate-Calorie Animal Proteins Section
                      const Text(
                        'Moderate-Calorie Animal Proteins',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,

                        ),
                      ),

                      const Text(
                        '(100-350 kcal per 100g)',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,

                        ),
                      ),

                      const SizedBox(height: 16),

                      // Moderate-Calorie Animal Proteins Grid
                      SizedBox(
                        height: 240, // Set a fixed height for the horizontal scroll area
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              ProteinCard(
                                name: 'Chicken Breast (Skinless, Cooked)',
                                calories: 165,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/chicken-breast.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),

                              const SizedBox(width: 12),
                              ProteinCard(
                                name: 'Turkey Breast (Cooked)',
                                calories: 135,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/thanksgiving.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),

                              const SizedBox(width: 12),
                              ProteinCard(
                                name: 'Lean Beef (Sirloin, Cooked)',
                                calories: 250,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/protein.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),

                              const SizedBox(width: 12),
                              ProteinCard(
                                name: 'Pork Tenderloin',
                                calories: 143,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/tenderloin.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),

                              const SizedBox(width: 12),
                              ProteinCard(
                                name: 'Salmon(Cooked)',
                                calories: 206,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/tenderloin.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),

                              const SizedBox(width: 12),
                              ProteinCard(
                                name: 'Tuna (Canned in water, drained)',
                                calories: 116,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/tuna.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),

                              const SizedBox(width: 12),
                              ProteinCard(
                                name: 'Lamb (Cooked, lean Cuts)',
                                calories: 294,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/lamb.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),

                              const SizedBox(width: 12),
                              ProteinCard(
                                name: 'Duck (Without Skin, Cooked)',
                                calories: 250,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/duck.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // High-Calorie Animal Proteins Section
                      const Text(
                        'High-Calorie Animal Proteins',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,

                        ),
                      ),

                      const Text(
                        '(Above 350 kcal per 100g)',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,

                        ),
                      ),

                      const SizedBox(height: 16),

                      // High-Calorie Animal Proteins Grid
                      SizedBox(
                        height: 217, // Reduced height for consistency with other sections
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              ProteinCard(
                                name: 'Bacon',
                                calories: 541,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/bacon.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),

                              const SizedBox(width: 12),
                              ProteinCard(
                                name: 'Salami',
                                calories: 425,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/salami.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),

                              const SizedBox(width: 12),
                              ProteinCard(
                                name: 'Pepperoni',
                                calories: 494,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/pepperoni.png',
                                onAdd: (name, calories) {
                                  _addCalorieToFirebase(name, calories);
                                },
                              ),

                              const SizedBox(width: 12),
                              ProteinCard(
                                name: 'Pork Belly',
                                calories: 518,
                                imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/pork.png',
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

class ProteinCard extends StatelessWidget {
  final String name;
  final int calories;
  final String imagePath;
  final void Function(String, int) onAdd;


  const ProteinCard({
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
            //  Image
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

            //  Name
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