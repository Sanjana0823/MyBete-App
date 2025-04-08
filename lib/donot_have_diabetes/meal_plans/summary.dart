import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({Key? key}) : super(key: key);

  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  // Use the same Firebase instances as in the food category screens
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = true;
  DateTime selectedDate = DateTime.now();

  // Add this line to define userRef
  late DocumentReference userRef;

  // Category data
  Map<String, CategoryData> categoriesData = {
    'vegetables': CategoryData(
      name: 'Vegetables',
      icon: Icons.eco,
      color: Colors.green,
      totalCalories: 0,
      items: [],
    ),
    'fruits': CategoryData(
      name: 'Fruits',
      icon: Icons.apple,
      color: Colors.red,
      totalCalories: 0,
      items: [],
    ),
    'dairy': CategoryData(
      name: 'Dairy',
      icon: Icons.egg,
      color: Colors.blue,
      totalCalories: 0,
      items: [],
    ),
    'bakery': CategoryData(
      name: 'Bakery',
      icon: Icons.bakery_dining,
      color: Colors.brown,
      totalCalories: 0,
      items: [],
    ),
    'animal_proteins': CategoryData(
      name: 'Animal Proteins',
      icon: Icons.set_meal,
      color: Colors.purple,
      totalCalories: 0,
      items: [],
    ),
    'beverages': CategoryData(
      name: 'Beverages',
      icon: Icons.local_drink,
      color: Colors.cyan,
      totalCalories: 0,
      items: [],
    ),
    'grains': CategoryData(
      name: 'Grains',
      icon: Icons.grain,
      color: Colors.amber,
      totalCalories: 0,
      items: [],
    ),
    'breakfast': CategoryData(
      name: 'Breakfast',
      icon: Icons.free_breakfast,
      color: Colors.orange,
      totalCalories: 0,
      items: [],
    ),
    'lunch': CategoryData(
      name: 'Lunch',
      icon: Icons.lunch_dining,
      color: Colors.teal,
      totalCalories: 0,
      items: [],
    ),
    'dinner': CategoryData(
      name: 'Dinner',
      icon: Icons.dinner_dining,
      color: Colors.indigo,
      totalCalories: 0,
      items: [],
    ),
    'snack': CategoryData(
      name: 'Snack',
      icon: Icons.cookie,
      color: Colors.pink,
      totalCalories: 0,
      items: [],
    ),
  };

  int grandTotalCalories = 0;
  int dailyCalorieGoal = 2000; // Default goal, can be customized

  // Get reference to the current user's document
  DocumentReference getUserRef() {
    // Always use 'user123' to match the ID used in the food category screens
    return _firestore.collection('users').doc('user123');
  }

  @override
  void initState() {
    super.initState();
    // Initialize userRef
    userRef = getUserRef();
    fetchAllCategoriesData();
    _fetchCalorieGoal();
  }

  Future<void> _fetchCalorieGoal() async {
    try {
      final userDoc = await userRef.get();
      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>?;
        if (data != null) {
          // Try to get from preferences first
          if (data['preferences'] != null) {
            final prefs = data['preferences'] as Map<String, dynamic>;
            if (prefs.containsKey('calorieGoal')) {
              setState(() {
                dailyCalorieGoal = (prefs['calorieGoal'] as num?)?.toInt() ?? 2000;
              });
              return;
            }
          }

          // Fallback to direct calorieGoal field
          if (data.containsKey('calorieGoal')) {
            setState(() {
              dailyCalorieGoal = (data['calorieGoal'] as num?)?.toInt() ?? 2000;
            });
          }
        }
      }
    } catch (e) {
      print("Error fetching calorie goal: $e");
    }
  }

  Future<void> fetchAllCategoriesData() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Reset all category data
      categoriesData.forEach((key, value) {
        value.totalCalories = 0;
        value.items = [];
      });

      // Format date for Firestore query
      final startOfDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      // Check if we have daily totals first
      final dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
      final dailyMealsRef = userRef.collection('daily_meals').doc(dateStr);
      final dailyMealDoc = await dailyMealsRef.get();

      if (dailyMealDoc.exists) {
        final data = dailyMealDoc.data() as Map<String, dynamic>?;
        if (data != null) {
          // Use the pre-calculated totals if available
          if (data['breakfastCalories'] != null) {
            categoriesData['breakfast']!.totalCalories = (data['breakfastCalories'] as num).toInt();
          }
          if (data['lunchCalories'] != null) {
            categoriesData['lunch']!.totalCalories = (data['lunchCalories'] as num).toInt();
          }
          if (data['dinnerCalories'] != null) {
            categoriesData['dinner']!.totalCalories = (data['dinnerCalories'] as num).toInt();
          }
          if (data['snackCalories'] != null) {
            categoriesData['snack']!.totalCalories = (data['snackCalories'] as num).toInt();
          }

          // Set grand total from daily document if available
          if (data['totalCalories'] != null) {
            grandTotalCalories = (data['totalCalories'] as num).toInt();
            setState(() {
              isLoading = false;
            });
            return; // Exit early if we have complete data from daily document
          }
        }
      }

      // Map of category keys to their collection names
      Map<String, String> categoryToCollection = {
        'vegetables': 'vegetable_calories',
        'fruits': 'fruit_calories',
        'grains': 'grain_calories',
        'dairy': 'dairy_calories',
        'animal_proteins': 'protein_calories',
        'beverages': 'beverage_calories',
        'bakery': 'bakery_calories',
        'breakfast': 'breakfast_calories',
        'lunch': 'lunch_calories',
        'dinner': 'dinner_calories',
        'snack': 'snack_calories',
      };

      // Add recipe calories collections to check
      List<String> additionalCollections = [
        'breakfast_recipe_calories',
        'lunch_recipe_calories',
        'dinner_recipe_calories',
        'snack_recipe_calories'
      ];

      // Fetch data for each food category
      for (final entry in categoryToCollection.entries) {
        final category = entry.key;
        final collectionName = entry.value;

        try {
          final querySnapshot = await userRef
              .collection(collectionName)
              .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
              .where('timestamp', isLessThan: Timestamp.fromDate(endOfDay))
              .get();

          print("Found ${querySnapshot.docs.length} items in $collectionName");

          for (final doc in querySnapshot.docs) {
            final data = doc.data();
            final name = data['name'] ?? 'Unknown';
            final calories = data['calories'] ?? 0;
            final mealType = data['mealType'] as String? ?? 'Snack';

            categoriesData[category]!.items.add({
              'id': doc.id,
              'name': name,
              'calories': calories,
              'mealType': mealType,
            });

            // Fix: Explicitly convert num to int
            if (calories is num) {
              int caloriesInt = calories.toInt();
              categoriesData[category]!.totalCalories += caloriesInt;

              // Also add to the appropriate meal type category
              if (mealType == 'Breakfast') {
                categoriesData['breakfast']!.items.add({
                  'id': doc.id,
                  'name': name,
                  'calories': calories,
                  'category': category,
                });
              } else if (mealType == 'Lunch') {
                categoriesData['lunch']!.items.add({
                  'id': doc.id,
                  'name': name,
                  'calories': calories,
                  'category': category,
                });
              } else if (mealType == 'Dinner') {
                categoriesData['dinner']!.items.add({
                  'id': doc.id,
                  'name': name,
                  'calories': calories,
                  'category': category,
                });
              } else {
                categoriesData['snack']!.items.add({
                  'id': doc.id,
                  'name': name,
                  'calories': calories,
                  'category': category,
                });
              }
            }
          }
        } catch (e) {
          print("Error fetching $collectionName: $e");
        }
      }

      // Check additional recipe-specific collections
      for (final collectionName in additionalCollections) {
        try {
          final querySnapshot = await userRef
              .collection(collectionName)
              .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
              .where('timestamp', isLessThan: Timestamp.fromDate(endOfDay))
              .get();

          print("Found ${querySnapshot.docs.length} items in $collectionName");

          for (final doc in querySnapshot.docs) {
            final data = doc.data();
            final name = data['name'] ?? 'Unknown Recipe';
            final calories = data['calories'] ?? 0;

            // Determine meal type from collection name
            String mealType = 'Snack';
            if (collectionName.startsWith('breakfast')) {
              mealType = 'Breakfast';
            } else if (collectionName.startsWith('lunch')) {
              mealType = 'Lunch';
            } else if (collectionName.startsWith('dinner')) {
              mealType = 'Dinner';
            }

            // Add to appropriate meal category
            if (mealType == 'Breakfast') {
              categoriesData['breakfast']!.items.add({
                'id': doc.id,
                'name': name,
                'calories': calories,
                'category': 'recipe',
              });
              categoriesData['breakfast']!.totalCalories += calories is num ? calories.toInt() : 0;
            } else if (mealType == 'Lunch') {
              categoriesData['lunch']!.items.add({
                'id': doc.id,
                'name': name,
                'calories': calories,
                'category': 'recipe',
              });
              categoriesData['lunch']!.totalCalories += calories is num ? calories.toInt() : 0;
            } else if (mealType == 'Dinner') {
              categoriesData['dinner']!.items.add({
                'id': doc.id,
                'name': name,
                'calories': calories,
                'category': 'recipe',
              });
              categoriesData['dinner']!.totalCalories += calories is num ? calories.toInt() : 0;
            } else {
              categoriesData['snack']!.items.add({
                'id': doc.id,
                'name': name,
                'calories': calories,
                'category': 'recipe',
              });
              categoriesData['snack']!.totalCalories += calories is num ? calories.toInt() : 0;
            }
          }
        } catch (e) {
          print("Error fetching $collectionName: $e");
        }
      }

      // Calculate grand total
      int total = 0;
      // First add all food categories (excluding meal types to avoid double counting)
      for (final key in categoriesData.keys) {
        if (!['breakfast', 'lunch', 'dinner', 'snack'].contains(key)) {
          total += categoriesData[key]!.totalCalories;
        }
      }

      // If no food categories have data, use meal type totals instead
      if (total == 0) {
        total = categoriesData['breakfast']!.totalCalories +
            categoriesData['lunch']!.totalCalories +
            categoriesData['dinner']!.totalCalories +
            categoriesData['snack']!.totalCalories;
      }

      setState(() {
        grandTotalCalories = total;
        isLoading = false;
      });

    } catch (e) {
      print("Error fetching summary data: $e");
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0x00B8FFFF),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      fetchAllCategoriesData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition Summary'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date and Total Calories Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    DateFormat('EEEE, MMMM d, yyyy').format(selectedDate),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.local_fire_department,
                        color: Color(0xFF009439),
                        size: 32,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$grandTotalCalories',
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF009439),
                        ),
                      ),
                      const Text(
                        ' kcal',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF009439),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'of $dailyCalorieGoal kcal goal',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: grandTotalCalories / dailyCalorieGoal,
                      minHeight: 15,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        grandTotalCalories > dailyCalorieGoal
                            ? Colors.red
                            : const Color(0xFF00FF62),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Pie Chart
            if (grandTotalCalories > 0) ...[
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Calorie Distribution',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 250,
                child: PieChart(
                  PieChartData(
                    sections: _createPieChartSections(),
                    centerSpaceRadius: 40,
                    sectionsSpace: 2,
                  ),
                ),
              ),
            ],

            // Category Breakdown
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Category Breakdown',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // List of categories
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: categoriesData.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final category = categoriesData.values.elementAt(index);
                final hasItems = category.totalCalories > 0;

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: hasItems
                        ? category.color
                        : Colors.grey[300],
                    child: Icon(
                      category.icon,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    category.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${category.totalCalories} kcal',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: hasItems
                              ? const Color(0xFF009439)
                              : Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                  onTap: hasItems
                      ? () => _showCategoryDetails(category)
                      : null,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _createPieChartSections() {
    final List<PieChartSectionData> sections = [];

    // Only include categories with calories > 0
    final activeCategories = categoriesData.values
        .where((category) => category.totalCalories > 0)
        .toList();

    // If no categories have calories, return empty list
    if (activeCategories.isEmpty) {
      return sections;
    }

    // Calculate total calories for percentage calculation
    final totalCalories = activeCategories
        .fold(0, (sum, category) => sum + category.totalCalories);

    // Create a section for each active category
    for (final category in activeCategories) {
      // Calculate percentage
      final percentage = (category.totalCalories / totalCalories) * 100;

      sections.add(
        PieChartSectionData(
          color: category.color,
          value: category.totalCalories.toDouble(),
          title: percentage >= 5 ? '${percentage.toInt()}%' : '',
          radius: 100,
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }

    return sections;
  }

  void _showCategoryDetails(CategoryData category) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                // Handle
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                // Header
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: category.color,
                        child: Icon(
                          category.icon,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        category.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${category.totalCalories} kcal',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF009439),
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(),

                // Items list
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: category.items.length,
                    itemBuilder: (context, index) {
                      final item = category.items[index];
                      return ListTile(
                        title: Text(item['name']),
                        trailing: Text(
                          '${item['calories']} kcal',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF009439),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class CategoryData {
  final String name;
  final IconData icon;
  final Color color;
  int totalCalories;
  List<Map<String, dynamic>> items;

  CategoryData({
    required this.name,
    required this.icon,
    required this.color,
    required this.totalCalories,
    required this.items,
  });
}
