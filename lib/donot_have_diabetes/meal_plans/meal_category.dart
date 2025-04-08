import 'package:flutter/material.dart';
import 'package:mybete_app/donot_have_diabetes/meal_plans/recipies/oatmeal.dart';
import 'package:mybete_app/donot_have_diabetes/meal_plans/recipies/scrambled_eggs.dart';
import 'package:mybete_app/donot_have_diabetes/meal_plans/recipies/Overnight_Oats_with_Peanut_Butter_&_Banana.dart';
import 'package:mybete_app/donot_have_diabetes/meal_plans/recipies/Quinoa_Breakfast_Bowl.dart';
import 'package:mybete_app/donot_have_diabetes/meal_plans/recipies/Chia_Seed_Pudding.dart';
import 'package:mybete_app/donot_have_diabetes/meal_plans/recipies/Green_Smoothie.dart';
import 'package:mybete_app/donot_have_diabetes/meal_plans/recipies/Whole_Grain_Avocado_Toast.dart';
import 'package:mybete_app/donot_have_diabetes/meal_plans/recipies/Tofu_Scramble _Vegan Egg Alternative).dart';
import 'package:mybete_app/donot_have_diabetes/meal_plans/recipies/Banana_Smoothie_Bowl.dart';
import 'package:mybete_app/donot_have_diabetes/meal_plans/recipies/Grilled Chicken & Quinoa Salad.dart';
import 'package:mybete_app/donot_have_diabetes/meal_plans/recipies/Lentil & Vegetable Soup.dart';
import 'package:mybete_app/donot_have_diabetes/meal_plans/recipies/Chickpea & Avocado Sandwich.dart';
import 'package:mybete_app/donot_have_diabetes/meal_plans/recipies/Baked Salmon with Steamed Vegetables.dart';
import 'package:mybete_app/donot_have_diabetes/meal_plans/recipies/Veggie Stir-Fry with Brown Rice.dart';
import 'package:mybete_app/donot_have_diabetes/meal_plans/recipies/Tuna & Avocado Salad.dart';
import 'package:mybete_app/donot_have_diabetes/meal_plans/recipies/Mediterranean Chickpea Salad.dart';
import 'package:mybete_app/donot_have_diabetes/meal_plans/recipies/Baked Sweet Potato with Black Beans.dart';
import 'package:mybete_app/donot_have_diabetes/meal_plans/recipies/Shrimp & Avocado Salad.dart';
import 'package:mybete_app/donot_have_diabetes/meal_plans/recipies/Spaghetti Squash with Tomato Sauce.dart';
import 'package:mybete_app/donot_have_diabetes/meal_plans/recipies/Stuffed Bell Peppers.dart';
import 'package:mybete_app/donot_have_diabetes/meal_plans/recipies/Baked Cod with Roasted Vegetables.dart';
import 'package:mybete_app/donot_have_diabetes/meal_plans/recipies/Lemon Garlic Shrimp with Asparagus.dart';
import 'package:mybete_app/donot_have_diabetes/meal_plans/recipies/Grilled Veggie Skewers with Quinoa.dart';
import 'package:mybete_app/donot_have_diabetes/meal_plans/recipies/Cauliflower Fried Rice.dart';
import 'package:mybete_app/donot_have_diabetes/meal_plans/recipies/Grilled Chicken with Mango Salsa.dart';
import 'package:mybete_app/donot_have_diabetes/meal_plans/recipies/Spaghetti Squash Primavera.dart';
import 'package:mybete_app/donot_have_diabetes/meal_plans/recipies/Baked Lemon Herb Chicken with Broccoli.dart';
import 'package:mybete_app/donot_have_diabetes/meal_plans/recipies/Quinoa and Roasted Vegetable Bowl.dart';
import 'package:mybete_app/donot_have_diabetes/meal_plans/recipies/Veggie-Packed Cauliflower Crust Pizza.dart';
import 'package:mybete_app/donot_have_diabetes/meal_plans/recipies/Banana with Peanut Butter.dart';
import 'package:mybete_app/donot_have_diabetes/meal_plans/recipies/Greek Yogurt and Honey.dart';
import 'package:mybete_app/donot_have_diabetes/meal_plans/recipies/Carrot Sticks with Hummus.dart';
import 'package:mybete_app/donot_have_diabetes/meal_plans/recipies/Cucumber with Lemon and Salt.dart';
import 'package:mybete_app/donot_have_diabetes/meal_plans/recipies/Rice Cake with Nut Butter.dart';
import 'package:mybete_app/donot_have_diabetes/meal_plans/recipies/Mixed Nuts.dart';
import 'package:mybete_app/donot_have_diabetes/meal_plans/recipies/Cheese and Crackers.dart';
import 'vegetables.dart';
import 'fruits.dart';
import 'bakery.dart';
import 'grains.dart';
import 'protein.dart';
import 'dairy.dart';
import 'beverages.dart';
import 'package:mybete_app/donot_have_diabetes/meal_plans/meal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



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
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const FoodCategoryScreen(mealType: 'label',),
    );
  }
}

class FoodCategoryScreen extends StatefulWidget {
  final String mealType;

  const FoodCategoryScreen({Key? key, required this.mealType}) : super(key: key);

  @override
  _FoodCategoryScreenState createState() => _FoodCategoryScreenState();
}

class _FoodCategoryScreenState extends State<FoodCategoryScreen> {
  int dailyCalorieGoal = 2000;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCalorieGoal();
  }

  Future<void> _fetchCalorieGoal() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid ?? 'user123';
      final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

      final userDoc = await userRef.get();
      if (userDoc.exists) {
        final data = userDoc.data();
        if (data != null && data['preferences'] != null) {
          final prefs = data['preferences'];
          setState(() {
            dailyCalorieGoal = (prefs['calorieGoal'] as num?)?.toInt() ?? 2000;
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching calorie goal: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _navigateToMealPlanner(BuildContext context) {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MealPlannerScreen()),
      ).then((_) {
        // Refresh the current screen when returning from MealPlannerScreen
        if (mounted) {
          setState(() {
            // This will trigger a rebuild of the screen
          });
        }
      });
    } catch (e) {
      // Fallback if MealPlannerScreen is not available
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Meal Planner is not available')),
      );
      print('Error navigating to MealPlannerScreen: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
        child: Column(
          children: [
            // Status Bar and Back Button
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
              child: Row(
                children: [
                  // Back Button - FIXED to actually go back
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      size: 30,

                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                          'Select your Meal',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.local_fire_department, color: Colors.orange),
                            const SizedBox(width: 4),
                            Text(
                              'Goal: $dailyCalorieGoal kcal',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Food Categories Horizontal Scroller
                  SizedBox(
                    height: 150,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        CategoryItem(
                          title: 'Vegetables',
                          imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/vegetable.png',
                          onTap: () {
                            // Navigate to VegetableScreen when tapped
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const VegetablesScreen()),
                            );
                          },
                        ),
                        CategoryItem(
                          title: 'Fruits',
                          imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/fruits.png',
                          onTap: () {
                            // Navigate to FruitScreen when tapped
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const FruitsScreen()),
                            );
                          },
                        ),
                        CategoryItem(
                          title: 'Bakery Items',
                          imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/cake.png',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const BakeryItemsScreen()),
                            );

                          },
                        ),
                        CategoryItem(
                          title: 'Grains',
                          imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/grains.png',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const GrainsScreen()),
                            );

                          },
                        ),
                        CategoryItem(
                          title: 'Dairy Products',
                          imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/milk.png',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const  DairyProductsScreen()),
                            );

                          },
                        ),
                        CategoryItem(
                          title: 'Animal\nProtiens',
                          imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/protein.png',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AnimalProteinsScreen()),
                            );

                          },
                        ),
                        CategoryItem(
                          title: 'Beverages',
                          imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/wine.png',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const BeveragesScreen()),
                            );

                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

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
                      'Custom Recipies',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Breakfast Section
                  const Text(
                    'Breakfast',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,

                    ),
                  ),

                  const SizedBox(height: 12),

                  // Breakfast Recipes Horizontal Scroller
                  SizedBox(
                    height: 280,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        RecipeCard(
                          title: 'Oatmeal with Nuts & Fruits',
                          imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/Oatmeal with Toppings.jpeg',
                          isFavorite: true,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const RecipeDetailScreen()),
                            );
                          },
                        ),
                        RecipeCard(
                          title: 'Scrambled Eggs with Veggies',
                          imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/scramble.png',
                          isFavorite: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const B2RecipeDetailScreen()),
                            );
                          },
                        ),
                        RecipeCard(
                          title: 'Overnight Oats with Peanut Butter & Banana',
                          imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/oats.png',
                          isFavorite: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const B3RecipeDetailScreen()),
                            );
                          },
                        ),
                        RecipeCard(
                          title: 'Chia Seed Pudding',
                          imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/Chia Seed Pudding Recipe - Belly Full.jpeg',
                          isFavorite: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const B4RecipeDetailScreen()),
                            );
                          },
                        ),
                        RecipeCard(
                          title: 'Green Smoothie',
                          imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/Spinach Smoothie.jpeg',
                          isFavorite: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const B5RecipeDetailScreen()),
                            );
                          },
                        ),
                        RecipeCard(
                          title: 'Whole Grain Avocado Toast',
                          imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/Creamy Avocado Toast with a Twist.jpeg',
                          isFavorite: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const B6RecipeDetailScreen()),
                            );
                          },
                        ),
                        RecipeCard(
                          title: 'Quinoa Breakfast Bowl',
                          imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/Summer Quinoa Breakfast Bowls.jpeg',
                          isFavorite: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const B7RecipeDetailScreen()),
                            );
                          },
                        ),
                        RecipeCard(
                          title: 'Banana Pancakes (No Flour!)',
                          imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/banana_pancake.png',
                          isFavorite: false,
                          onTap: () {
                            // Show a message instead of navigating to a missing screen
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Recipe details coming soon')),
                            );
                            // Original navigation code commented out
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => const B8RecipeDetailScreen()),
                            // );
                          },
                        ),
                        RecipeCard(
                          title: 'Tofu Scramble(Vegan Egg Alternative)',
                          imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/Tofu Scramble.jpeg',
                          isFavorite: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const B9RecipeDetailScreen()),
                            );
                          },
                        ),
                        RecipeCard(
                          title: 'Banana Smoothie Bowl',
                          imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/Banana Smoothie Bowl.jpeg',
                          isFavorite: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const B10RecipeDetailScreen()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Lunch Section
                  const Text(
                    'Lunch',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,

                    ),
                  ),

                  const SizedBox(height: 12),

                  // Lunch Recipes Horizontal Scroller
                  SizedBox(
                    height: 280,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        RecipeCard(
                          title: 'Grilled Chicken & Quinoa Salad',
                          imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/chicken_salad.jpg',
                          isFavorite: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const L1RecipeDetailScreen()),
                            );
                          },
                        ),
                        RecipeCard(
                          title: 'Lentil & Vegetable Soup',
                          imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/lentil_soup.png',
                          isFavorite: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const L2RecipeDetailScreen()),
                            );
                          },
                        ),
                        RecipeCard(
                          title: 'Chickpea & Avocado Sandwich',
                          imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/chickpea_sandwich.png',
                          isFavorite: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const L3RecipeDetailScreen()),
                            );
                          },
                        ),
                        RecipeCard(
                          title: 'Baked Salmon with Steamed Vegetables',
                          imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/baked_salmon_vege.png',
                          isFavorite: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const L4RecipeDetailScreen()),
                            );
                          },
                        ),
                        RecipeCard(
                          title: 'Veggie Stir-Fry with Brown Rice',
                          imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/Quick and easy veggie stir-fry with brown rice for a healthy 30-minute lunch.jpeg',
                          isFavorite: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const L5RecipeDetailScreen()),
                            );
                          },
                        ),
                        RecipeCard(
                          title: 'Tuna & Avocado Salad',
                          imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/Chicago-Style Tuna Salad.jpeg',
                          isFavorite: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const L6RecipeDetailScreen()),
                            );
                          },
                        ),
                        RecipeCard(
                          title: ' Mediterranean Chickpea Salad',
                          imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/Mediterranean Chickpea Salad (15 minute recipe!) _ Choosing Chia.jpeg',
                          isFavorite: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const L7RecipeDetailScreen()),
                            );
                          },
                        ),
                        RecipeCard(
                          title: 'Baked Sweet Potato with Black Beans',
                          imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/Baked Sweet Potato with Black Beans.png',
                          isFavorite: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const L8RecipeDetailScreen()),
                            );
                          },
                        ),

                        RecipeCard(
                          title: 'Shrimp & Avocado Salad',
                          imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/Shrimp & Avocado Salad.png',
                          isFavorite: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const L9RecipeDetailScreen()),
                            );
                          },
                        ),
                        RecipeCard(
                          title: 'Spaghetti Squash with Tomato Sauce',
                          imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/Spaghetti Squash with Tomato Sauce.png',
                          isFavorite: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const L10RecipeDetailScreen()),
                            );
                          },
                        ),

                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Dinner Section
                  const Text(
                    'Dinner',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,

                    ),
                  ),

                  const SizedBox(height: 12),

                  // Dinner Recipes Horizontal Scroller
                  SizedBox(
                    height: 280,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        RecipeCard(
                          title: 'Stuffed Bell Peppers',
                          imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/stuffed_peppers.png',
                          isFavorite: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const D1RecipeDetailScreen()),
                            );
                          },
                        ),
                        RecipeCard(
                          title: 'Baked Cod with Roasted Vegetables',
                          imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/Baked Cod with Quinoa and Vegetables.jpeg',
                          isFavorite: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const D2RecipeDetailScreen()),
                            );
                          },
                        ),
                        RecipeCard(
                          title: 'Lemon Garlic Shrimp with Asparagus',
                          imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/Lemon Garlic Shrimp Pasta Recipe with Asparagus.jpeg',
                          isFavorite: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const D3RecipeDetailScreen()),
                            );
                          },
                        ),
                        RecipeCard(
                          title: 'Grilled Veggie Skewers with Quinoa',
                          imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/Easy Tofu Skewers (Grill or Oven!) - Two Spoons.jpeg',
                          isFavorite: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const D4RecipeDetailScreen()),
                            );
                          },
                        ),
                        RecipeCard(
                          title: 'Cauliflower Fried Rice',
                          imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/Cauliflower Fried Rice.jpeg',
                          isFavorite: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const D5RecipeDetailScreen()),
                            );
                          },
                        ),
                        RecipeCard(
                          title: 'Grilled Chicken with Mango Salsa',
                          imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/Refreshing grilled chicken with sweet mango salsa.jpeg',
                          isFavorite: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const D6RecipeDetailScreen()),
                            );
                          },
                        ),
                        RecipeCard(
                          title: 'Spaghetti Squash Primavera',
                          imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/Spaghetti Squash Primavera_ Healthy Pasta Recipe Idea.jpeg',
                          isFavorite: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const D7RecipeDetailScreen()),
                            );
                          },
                        ),
                        RecipeCard(
                          title: 'Baked Lemon Herb Chicken with Broccoli',
                          imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/baked_lemon.jpeg',
                          isFavorite: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const D8RecipeDetailScreen()),
                            );
                          },
                        ),
                        RecipeCard(
                          title: 'Quinoa and Roasted Vegetable Bowl',
                          imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/Healthy Quinoa Salad with Roasted Vegetables - Gluten-Free & Delicious Recipe!.jpeg',
                          isFavorite: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const D9RecipeDetailScreen()),
                            );
                          },
                        ),
                        RecipeCard(
                          title: 'Veggie-Packed Cauliflower Crust Pizza',
                          imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/Cauliflower Crust Pizza.jpeg',
                          isFavorite: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const D10RecipeDetailScreen()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Snacks Section
                  const Text(
                    'Snacks',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,

                    ),
                  ),

                  const SizedBox(height: 12),

                  // Snacks Recipes Horizontal Scroller
                  SizedBox(
                    height: 280,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        RecipeCard(
                          title: 'Banana with Peanut Butter',
                          imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/Peanut Butter Banana Bites.jpeg',
                          isFavorite: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const S1RecipeDetailScreen()),
                            );
                          },
                        ),
                        RecipeCard(
                          title: 'Greek Yogurt and Honey',
                          imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/Greek Yogurt and Berries.jpeg',
                          isFavorite: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const S2RecipeDetailScreen()),
                            );
                          },
                        ),
                        RecipeCard(
                          title: 'Carrot Sticks with Hummus',
                          imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/Veggie Sticks & Hummus.jpeg',
                          isFavorite: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const S3RecipeDetailScreen()),
                            );
                          },
                        ),
                        RecipeCard(
                          title: 'Cucumber with Lemon and Salt',
                          imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/Easy Simple Green Salad.jpeg',
                          isFavorite: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const S4RecipeDetailScreen()),
                            );
                          },
                        ),
                        RecipeCard(
                          title: 'Rice Cake with Nut Butter',
                          imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/Rice Cake .png',
                          isFavorite: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const S5RecipeDetailScreen()),
                            );
                          },
                        ),
                        RecipeCard(
                          title: 'Mixed Nuts',
                          imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/Healthy Trail Mix.jpeg',
                          isFavorite: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const S6RecipeDetailScreen()),
                            );
                          },
                        ),
                        RecipeCard(
                          title: 'Cheese and Crackers',
                          imagePath: 'lib/donot_have_diabetes/meal_plans/meal_images/cheese crackers.png',
                          isFavorite: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const S7RecipeDetailScreen()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),

            // Bottom Navigation Bar




          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToMealPlanner(context),
        backgroundColor: const Color(0xFF00B8FF),
        child: const Icon(Icons.dashboard),
        tooltip: 'Meal Dashboard',
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  const CategoryItem({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            // Category Image - FIXED to use Image.asset
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  print('Error loading image: $imagePath - $error'); // Added for debugging
                  return Container(
                    height: 80,
                    width: 80,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image, size: 40),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),

            // Category Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w500,

              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class RecipeCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final bool isFavorite;
  final VoidCallback onTap;

  const RecipeCard({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.isFavorite,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe Image with Favorite Icon
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(  // FIXED to use Image.asset
                    imagePath,
                    height: 200,
                    width: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      print('Error loading image: $imagePath - $error'); // Added for debugging
                      return Container(
                        height: 120,
                        width: 150,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image, size: 40),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Recipe Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,

              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
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

