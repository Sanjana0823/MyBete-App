import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class L1RecipeDetailScreen extends StatefulWidget {
  const L1RecipeDetailScreen({Key? key}) : super(key: key);

  @override
  _L1RecipeDetailScreenState createState() => _L1RecipeDetailScreenState();
}

class _L1RecipeDetailScreenState extends State<L1RecipeDetailScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isSaving = false;
  bool _isAddingCalories = false;
  bool _recipeSaved = false;

  final String recipeName = 'Grilled Chicken & Quinoa Salad';
  final int calories = 400;
  final String category = 'lunch';
  final String mealType = 'Lunch';

  String? get currentUserId => _auth.currentUser?.uid;

  Future<void> _saveRecipe() async {
    if (_recipeSaved || _isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }

      Map<String, dynamic> recipeData = {
        'name': recipeName,
        'calories': calories,
        'category': category,
        'mealType': mealType,
        'ingredients': [
          '1 grilled chicken breast (sliced)',
          '½ cup cooked quinoa',
          '1 cup mixed greens (spinach, arugula, or lettuce)',
          '¼ cup cherry tomatoes (halved)',
          '¼ cup cucumber (sliced)',
          '1 tbsp olive oil',
          '1 tbsp lemon juice',
          'Salt & pepper to taste',
        ],
        'instructions': [
          'In a large bowl, combine quinoa, mixed greens, cherry tomatoes, and cucumber.',
          'Add sliced grilled chicken on top.',
          'Drizzle with olive oil and lemon juice, then season with salt & pepper.',
          'Toss gently and serve!',
        ],
        'savedAt': FieldValue.serverTimestamp(),
        'imagePath': 'lib/donot_have_diabetes/meal_plans/meal_images/chicken_salad.jpg',
      };

      await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('saved_recipes')
          .add(recipeData);

      setState(() {
        _recipeSaved = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recipe saved successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving recipe: $e')),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  Future<void> _addCaloriesToDailyIntake() async {
    if (_isAddingCalories) return;

    setState(() {
      _isAddingCalories = true;
    });

    try {
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }

      final now = DateTime.now();

      await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('${category}_calories')
          .add({
        'name': recipeName,
        'calories': calories,
        'timestamp': Timestamp.fromDate(now),
        'mealType': mealType,
        'category': category,
      });

      final dateStr = DateFormat('yyyy-MM-dd').format(now);
      final dailyRef = _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('daily_meals')
          .doc(dateStr);

      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(dailyRef);

        if (snapshot.exists) {
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

          transaction.update(dailyRef, {
            'lunchCalories': (data['lunchCalories'] ?? 0) + calories,
            'totalCalories': (data['totalCalories'] ?? 0) + calories,
          });
        } else {
          Map<String, dynamic> initialData = {
            'date': dateStr,
            'totalCalories': calories,
            'breakfastCalories': 0,
            'lunchCalories': calories,
            'dinnerCalories': 0,
            'snackCalories': 0,
          };
          transaction.set(dailyRef, initialData);
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Calories added to your lunch!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding calories: $e')),
      );
    } finally {
      setState(() {
        _isAddingCalories = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'lib/donot_have_diabetes/meal_plans/meal_images/chicken_salad.jpg',
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.1),
                  Colors.black.withOpacity(0.5),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 180),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Grilled Chicken & Quinoa Salad',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Center(
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 8),
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.teal.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.teal),
                                    ),
                                    child: const Text(
                                      'Lunch',
                                      style: TextStyle(
                                        color: Colors.teal,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                const Text(
                                  'Ingredients:',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _buildBulletPoint('1 grilled chicken breast (sliced)'),
                                _buildBulletPoint('½ cup cooked quinoa'),
                                _buildBulletPoint('1 cup mixed greens (spinach, arugula, or lettuce)'),
                                _buildBulletPoint('¼ cup cherry tomatoes (halved)'),
                                _buildBulletPoint('¼ cup cucumber (sliced)'),
                                _buildBulletPoint('1 tbsp olive oil'),
                                _buildBulletPoint('1 tbsp lemon juice'),
                                _buildBulletPoint('Salt & pepper to taste'),
                                const SizedBox(height: 24),
                                const Text(
                                  'Instructions:',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _buildNumberedStep(1, 'In a large bowl, combine quinoa, mixed greens, cherry tomatoes, and cucumber.'),
                                const SizedBox(height: 8),
                                _buildNumberedStep(2, 'Add sliced grilled chicken on top.'),
                                const SizedBox(height: 8),
                                _buildNumberedStep(3, 'Drizzle with olive oil and lemon juice, then season with salt & pepper.'),
                                const SizedBox(height: 8),
                                _buildNumberedStep(4, 'Toss gently and serve!'),
                                const SizedBox(height: 32),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: _addCaloriesToDailyIntake,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF2E8B00),
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        child: _isAddingCalories
                                            ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                            : const Text(
                                          '400 kcal',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: _saveRecipe,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                        decoration: BoxDecoration(
                                          color: _recipeSaved ? Colors.grey : const Color(0xFF4A90E2),
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        child: _isSaving
                                            ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                            : Text(
                                          _recipeSaved ? 'Saved' : 'Save Recipe',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberedStep(int number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$number. ',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
