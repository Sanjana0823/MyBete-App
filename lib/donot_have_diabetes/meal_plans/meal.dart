import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mybete_app/donot_have_diabetes/meal_plans/meal_category.dart';
import 'package:mybete_app/donot_have_diabetes/meal_plans/summary.dart';
import 'package:mybete_app/donot_have_diabetes/meal_plans/total_screen.dart';

class MealPlannerScreen extends StatefulWidget {
  const MealPlannerScreen({Key? key}) : super(key: key);

  @override
  State<MealPlannerScreen> createState() => _MealPlannerScreenState();
}

class _MealPlannerScreenState extends State<MealPlannerScreen> with SingleTickerProviderStateMixin {
  // Add these lines to define Firebase instances
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late DocumentReference userRef;

  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  late TabController _tabController;

  // Meal data
  double breakfastCalories = 0;
  double lunchCalories = 0;
  double dinnerCalories = 0;
  double snackCalories = 0;
  double totalCalories = 0;

  // Calorie goals
  double breakfastGoal = 500;
  double lunchGoal = 700;
  double dinnerGoal = 600;
  double snackGoal = 200;
  double calorieGoal = 2000;

  // Recent meals
  List<Map<String, dynamic>> recentMeals = [];

  // Food category data
  Map<String, double> categoryData = {
    'vegetables': 0,
    'fruits': 0,
    'grains': 0,
    'dairy': 0,
    'protein': 0,
    'bakery': 0,
    'beverages': 0,
  };

  // Weekly data for chart
  List<FlSpot> weeklyData = [];
  double maxY = 2000;

  // Get reference to the current user's document
  DocumentReference getUserRef() {
    final userId = _getCurrentUserId();
    return FirebaseFirestore.instance.collection('users').doc(userId);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Initialize userRef
    userRef = getUserRef();
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
      hasError = false;
      errorMessage = '';
    });

    try {
      await Future.wait([
        _loadMealData(),
        _loadRecentMeals(),
        _loadCategoryData(),
        _loadWeeklyData(),
      ]);

      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error loading dashboard data: $e');
      if (!mounted) return;
      setState(() {
        isLoading = false;
        hasError = true;
        errorMessage = e.toString();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading data: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Retry',
            onPressed: _loadData,
            textColor: Colors.white,
          ),
        ),
      );
    }
  }

  Future<void> _loadMealData() async {
    // Get today's date
    final now = DateTime.now();
    final dateStr = DateFormat('yyyy-MM-dd').format(now);

    try {
      // Try to load from daily_meals collection
      final dailyMealsRef = userRef.collection('daily_meals').doc(dateStr);
      final docSnapshot = await dailyMealsRef.get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>?;
        if (data != null) {
          if (!mounted) return;
          setState(() {
            breakfastCalories = (data['breakfastCalories'] as num?)?.toDouble() ?? 0;
            lunchCalories = (data['lunchCalories'] as num?)?.toDouble() ?? 0;
            dinnerCalories = (data['dinnerCalories'] as num?)?.toDouble() ?? 0;
            snackCalories = (data['snackCalories'] as num?)?.toDouble() ?? 0;
            totalCalories = breakfastCalories + lunchCalories + dinnerCalories + snackCalories;
          });
        }
      }

      // Load user preferences
      final userDoc = await userRef.get();
      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>?;
        if (data != null && data['preferences'] != null) {
          final prefs = data['preferences'] as Map<String, dynamic>;
          if (!mounted) return;
          setState(() {
            calorieGoal = (prefs['calorieGoal'] as num?)?.toDouble() ?? 2000;
            breakfastGoal = (prefs['breakfastGoal'] as num?)?.toDouble() ?? 500;
            lunchGoal = (prefs['lunchGoal'] as num?)?.toDouble() ?? 700;
            dinnerGoal = (prefs['dinnerGoal'] as num?)?.toDouble() ?? 600;
            snackGoal = (prefs['snackGoal'] as num?)?.toDouble() ?? 200;
          });
        }
      }
    } catch (e) {
      print('Error loading meal data: $e');
      throw Exception('Failed to load meal data');
    }
  }

  Future<void> _loadRecentMeals() async {
    try {
      // Get today's date
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);

      // Query food collection for recent meals
      final querySnapshot = await userRef.collection('food')
          .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .orderBy('timestamp', descending: true)
          .limit(5)
          .get();

      List<Map<String, dynamic>> meals = [];
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        meals.add({
          'id': doc.id,
          'name': data['name'] ?? 'Food Item',
          'calories': data['calories'] ?? 0,
          'timestamp': data['timestamp'] ?? Timestamp.now(),
          'mealType': data['mealType'] ?? 'Snack',
        });
      }

      if (!mounted) return;
      setState(() {
        recentMeals = meals;
      });
    } catch (e) {
      print('Error loading recent meals: $e');
      throw Exception('Failed to load recent meals');
    }
  }

  Future<void> _loadCategoryData() async {
    try {
      // Get today's date
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

      // Categories to query
      final categories = [
        'vegetable_calories',
        'fruit_calories',
        'grain_calories',
        'dairy_calories',
        'protein_calories',
        'bakery_calories',
        'beverage_calories',
      ];

      Map<String, double> data = {
        'vegetables': 0,
        'fruits': 0,
        'grains': 0,
        'dairy': 0,
        'protein': 0,
        'bakery': 0,
        'beverages': 0,
      };

      for (int i = 0; i < categories.length; i++) {
        final category = categories[i];
        final key = data.keys.elementAt(i);

        final querySnapshot = await userRef.collection(category)
            .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
            .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
            .get();

        double total = 0;
        for (var doc in querySnapshot.docs) {
          final calories = doc.data()['calories'] ?? 0;
          if (calories is num) {
            total += calories.toDouble();
          }
        }

        data[key] = total;
      }

      if (!mounted) return;
      setState(() {
        categoryData = data;
      });
    } catch (e) {
      print('Error loading category data: $e');
      throw Exception('Failed to load food category data');
    }
  }

  Future<void> _loadWeeklyData() async {
    try {
      // Get dates for the past week
      final now = DateTime.now();
      final weekAgo = now.subtract(const Duration(days: 6));

      List<FlSpot> spots = [];
      double highest = 0;

      for (int i = 0; i <= 6; i++) {
        final date = weekAgo.add(Duration(days: i));
        final dateStr = DateFormat('yyyy-MM-dd').format(date);

        // Try to load from daily_meals collection
        final dailyMealsRef = userRef.collection('daily_meals').doc(dateStr);
        final docSnapshot = await dailyMealsRef.get();

        double dayTotal = 0;
        if (docSnapshot.exists) {
          final data = docSnapshot.data() as Map<String, dynamic>?;
          if (data != null) {
            dayTotal = (data['totalCalories'] as num?)?.toDouble() ?? 0;
            if (dayTotal == 0) {
              // If totalCalories is not set, calculate from individual meal types
              final breakfast = (data['breakfastCalories'] as num?)?.toDouble() ?? 0;
              final lunch = (data['lunchCalories'] as num?)?.toDouble() ?? 0;
              final dinner = (data['dinnerCalories'] as num?)?.toDouble() ?? 0;
              final snack = (data['snackCalories'] as num?)?.toDouble() ?? 0;
              dayTotal = breakfast + lunch + dinner + snack;
            }
          }
        }

        if (dayTotal > highest) {
          highest = dayTotal;
        }

        spots.add(FlSpot(i.toDouble(), dayTotal));
      }

      if (!mounted) return;
      setState(() {
        weeklyData = spots;
        maxY = highest > 0 ? (highest * 1.2) : 2000;
      });
    } catch (e) {
      print('Error loading weekly data: $e');
      throw Exception('Failed to load weekly progress data');
    }
  }

  Future<void> _updateCalorieGoal(double newGoal) async {
    try {
      // Update the calorie goal in Firestore
      await userRef.update({
        'preferences.calorieGoal': newGoal,
      });

      // Update local state
      setState(() {
        calorieGoal = newGoal;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Calorie goal updated to ${newGoal.toInt()} kcal'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Error updating calorie goal: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update calorie goal: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _showCalorieGoalDialog() {
    final TextEditingController controller = TextEditingController(text: calorieGoal.toInt().toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Set Daily Calorie Goal'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Daily Calorie Goal',
                  hintText: 'Enter your daily calorie goal',
                  border: OutlineInputBorder(),
                  suffixText: 'kcal',
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Recommended daily calorie intake:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('• Women: 1,600 to 2,400 kcal'),
              const Text('• Men: 2,000 to 3,000 kcal'),
              const SizedBox(height: 8),
              const Text(
                'Note: Actual needs vary based on age, weight, height, and activity level.',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final String value = controller.text.trim();
                if (value.isNotEmpty) {
                  try {
                    final double newGoal = double.parse(value);
                    if (newGoal > 0) {
                      _updateCalorieGoal(newGoal);
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a value greater than 0'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a valid number'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  String _getCurrentUserId() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('Warning: No current user found, using default user ID');
    }
    return user?.uid ?? 'user123';
  }

  String _getCurrentMealType() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour >= 5 && hour < 11) {
      return 'Breakfast';
    } else if (hour >= 11 && hour < 15) {
      return 'Lunch';
    } else if (hour >= 17 && hour < 22) {
      return 'Dinner';
    } else {
      return 'Snack';
    }
  }

  Color _getMealTypeColor(String mealType) {
    switch (mealType) {
      case 'Breakfast':
        return Colors.amber;
      case 'Lunch':
        return Colors.green;
      case 'Dinner':
        return Colors.purple;
      case 'Snack':
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : hasError
            ? _buildErrorView()
            : Column(
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, size: 24),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Meal Planner',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('h:mm a').format(DateTime.now()),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadData,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  children: [
                    const SizedBox(height: 8),

                    // Daily Progress Card
                    _buildDailyProgressCard(),

                    const SizedBox(height: 20),

                    // Current Meal Suggestion
                    _buildCurrentMealSuggestion(),

                    const SizedBox(height: 20),

                    // Meal Progress Circles
                    _buildMealProgressCircles(),

                    const SizedBox(height: 20),

                    // Weekly Progress Chart
                    _buildWeeklyProgressChart(),

                    const SizedBox(height: 20),

                    // Recent Meals
                    _buildRecentMeals(),

                    const SizedBox(height: 20),

                    // Food Category Distribution
                    _buildFoodCategoryDistribution(),

                    const SizedBox(height: 20),

                    // Quick Actions
                    _buildQuickActions(),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Bottom Navigation
            Container(
              height: 70,
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
                  _buildNavItem(Icons.dashboard, 'Dashboard', true),
                  _buildNavItem(Icons.restaurant_menu, 'Meals', false),
                  _buildNavItem(Icons.pie_chart, 'Summary', false),
                  _buildNavItem(Icons.person, 'Profile', false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            const SizedBox(height: 16),
            const Text(
              'Failed to load data',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadData,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        if (label == 'Meals') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FoodCategoryScreen(mealType: 'All')),
          ).then((_) => _loadData());
        } else if (label == 'Summary') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SummaryScreen()),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? Colors.blue : Colors.grey.shade700,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.blue : Colors.grey.shade700,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyProgressCard() {
    final double progress = (totalCalories / calorieGoal).clamp(0.0, 1.0);
    final bool isOverLimit = totalCalories > calorieGoal;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isOverLimit
              ? [Colors.red.shade400, Colors.red.shade600]
              : [Colors.blue.shade400, Colors.blue.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isOverLimit ? Colors.red.withOpacity(0.3) : Colors.blue.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Today\'s Progress',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  DateFormat('MMM d, yyyy').format(DateTime.now()),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.local_fire_department,
                color: Colors.white,
                size: 40,
              ),
              const SizedBox(width: 10),
              Text(
                '${totalCalories.toInt()}',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Text(
                ' kcal',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Stack(
            children: [
              // Background
              Container(
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              // Progress
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                height: 12,
                width: MediaQuery.of(context).size.width * progress * 0.8, // Adjust for padding
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isOverLimit ? 'Over limit!' : 'Remaining: ${(calorieGoal - totalCalories).toInt()} kcal',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onTap: _showCalorieGoalDialog,
                child: Row(
                  children: [
                    Text(
                      'Goal: ${calorieGoal.toInt()} kcal',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.edit,
                      color: Colors.white70,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentMealSuggestion() {
    final currentMealType = _getCurrentMealType();
    final Color bgColor = _getMealTypeColor(currentMealType).withOpacity(0.1);
    final Color textColor = _getMealTypeColor(currentMealType);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: textColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            currentMealType == 'Breakfast' ? Icons.wb_sunny :
            currentMealType == 'Lunch' ? Icons.restaurant :
            currentMealType == 'Dinner' ? Icons.nightlight :
            Icons.cookie,
            size: 40,
            color: textColor,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'It\'s $currentMealType time!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Track your $currentMealType to stay on top of your nutrition goals.',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FoodCategoryScreen(mealType: currentMealType),
                ),
              ).then((_) => _loadData());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: textColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: const Text('Add Now'),
          ),
        ],
      ),
    );
  }

  Widget _buildMealProgressCircles() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.donut_large,
                    color: Colors.blue,
                    size: 22,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Meal Progress',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildProgressCircle('Breakfast', breakfastCalories, breakfastGoal, Colors.amber),
              _buildProgressCircle('Lunch', lunchCalories, lunchGoal, Colors.green),
              _buildProgressCircle('Dinner', dinnerCalories, dinnerGoal, Colors.purple),
              _buildProgressCircle('Snacks', snackCalories, snackGoal, Colors.orange),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCircle(String label, double calories, double goal, Color color) {
    final double percentage = goal > 0 ? (calories / goal).clamp(0.0, 1.0) : 0.0;
    final bool isOverLimit = calories > goal;

    return Column(
      children: [
        SizedBox(
          height: 80,
          width: 80,
          child: Stack(
            children: [
              // Background circle
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
              // Progress circle
              Center(
                child: SizedBox(
                  height: 80,
                  width: 80,
                  child: CircularProgressIndicator(
                    value: percentage,
                    strokeWidth: 8,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isOverLimit ? Colors.red : color,
                    ),
                  ),
                ),
              ),
              // Calories text
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${calories.toInt()}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isOverLimit ? Colors.red : Colors.black87,
                      ),
                    ),
                    Text(
                      'kcal',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyProgressChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.insert_chart,
                color: Colors.blue,
                size: 22,
              ),
              SizedBox(width: 8),
              Text(
                'Weekly Progress',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 500,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.shade200,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final now = DateTime.now();
                        final weekday = now.subtract(Duration(days: 6 - value.toInt())).weekday;
                        String text = '';
                        switch (weekday) {
                          case 1: text = 'M'; break;
                          case 2: text = 'T'; break;
                          case 3: text = 'W'; break;
                          case 4: text = 'T'; break;
                          case 5: text = 'F'; break;
                          case 6: text = 'S'; break;
                          case 7: text = 'S'; break;
                        }

                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            text,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: value.toInt() == 6 ? FontWeight.bold : FontWeight.normal,
                              fontSize: 14,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 500,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        );
                      },
                      reservedSize: 40,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: maxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: weeklyData,
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.white,
                          strokeWidth: 2,
                          strokeColor: Colors.blue,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.blue.withOpacity(0.1),
                    ),
                  ),
                  // Goal line
                  LineChartBarData(
                    spots: [
                      FlSpot(0, calorieGoal),
                      FlSpot(6, calorieGoal),
                    ],
                    isCurved: false,
                    color: Colors.red.withOpacity(0.5),
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    dashArray: [5, 5],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 2,
                    color: Colors.red.withOpacity(0.5),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Daily Goal: ${calorieGoal.toInt()} kcal',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentMeals() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.history,
                    color: Colors.blue,
                    size: 22,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Recent Meals',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TotalScreen(category: 'all'),
                    ),
                  ).then((_) => _loadData());
                },
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          recentMeals.isEmpty
              ? const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'No meals recorded today',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          )
              : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recentMeals.length,
            itemBuilder: (context, index) {
              final meal = recentMeals[index];
              final timestamp = meal['timestamp'] as Timestamp;
              final mealType = meal['mealType'] as String;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _getMealTypeColor(mealType).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        mealType == 'Breakfast' ? Icons.wb_sunny :
                        mealType == 'Lunch' ? Icons.restaurant :
                        mealType == 'Dinner' ? Icons.nightlight :
                        Icons.cookie,
                        color: _getMealTypeColor(mealType),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            meal['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${DateFormat('h:mm a').format(timestamp.toDate())} • $mealType',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${meal['calories']} kcal',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF009439),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFoodCategoryDistribution() {
    // Filter out categories with 0 calories
    final nonZeroCategories = categoryData.entries
        .where((entry) => entry.value > 0)
        .toList();

    // Calculate total for percentage
    final totalCategoryCalories = nonZeroCategories
        .fold(0.0, (sum, entry) => sum + entry.value);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.pie_chart,
                color: Colors.blue,
                size: 22,
              ),
              SizedBox(width: 8),
              Text(
                'Food Categories',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          nonZeroCategories.isEmpty
              ? const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'No food categories recorded today',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          )
              : Column(
            children: nonZeroCategories.map((entry) {
              final category = entry.key;
              final calories = entry.value;
              final percentage = totalCategoryCalories > 0
                  ? calories / totalCategoryCalories
                  : 0.0;

              Color color;
              IconData icon;

              switch (category) {
                case 'vegetables':
                  color = Colors.green;
                  icon = Icons.eco;
                  break;
                case 'fruits':
                  color = Colors.red;
                  icon = Icons.apple;
                  break;
                case 'grains':
                  color = Colors.amber;
                  icon = Icons.grain;
                  break;
                case 'dairy':
                  color = Colors.blue;
                  icon = Icons.egg;
                  break;
                case 'protein':
                  color = Colors.purple;
                  icon = Icons.set_meal;
                  break;
                case 'bakery':
                  color = Colors.brown;
                  icon = Icons.bakery_dining;
                  break;
                case 'beverages':
                  color = Colors.cyan;
                  icon = Icons.local_drink;
                  break;
                default:
                  color = Colors.grey;
                  icon = Icons.food_bank;
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        icon,
                        color: color,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category.substring(0, 1).toUpperCase() + category.substring(1),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Stack(
                            children: [
                              Container(
                                height: 6,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              Container(
                                height: 6,
                                width: MediaQuery.of(context).size.width * percentage * 0.6,
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${calories.toInt()} kcal',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF009439),
                          ),
                        ),
                        Text(
                          '${(percentage * 100).toInt()}%',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.flash_on,
                color: Colors.blue,
                size: 22,
              ),
              SizedBox(width: 8),
              Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildQuickActionButton(
                'Add Meal',
                Icons.restaurant,
                Colors.green,
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FoodCategoryScreen(mealType: _getCurrentMealType()),
                    ),
                  ).then((_) => _loadData());
                },
              ),
              _buildQuickActionButton(
                'Set Goals',
                Icons.track_changes,
                Colors.orange,
                _showCalorieGoalDialog,
              ),
              _buildQuickActionButton(
                'View Summary',
                Icons.pie_chart,
                Colors.purple,
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SummaryScreen()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 30,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
