import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

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
    this.totalCalories = 0,
    List<Map<String, dynamic>>? items,
  }) : this.items = items ?? [];
}


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

  // For the delete functionality
  List<Map<String, dynamic>> clickedItems = [];
  int totalCalories = 0;
  int breakfastCalories = 0;
  int lunchCalories = 0;
  int dinnerCalories = 0;
  int snackCalories = 0;

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
    // Use the current user ID if available, otherwise fallback to 'user123'
    final String userId = _auth.currentUser?.uid ?? 'user123';
    return _firestore.collection('users').doc(userId);
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
      final endOfDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 23, 59, 59, 999);

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
            breakfastCalories = (data['breakfastCalories'] as num).toInt();
          }
          if (data['lunchCalories'] != null) {
            categoriesData['lunch']!.totalCalories = (data['lunchCalories'] as num).toInt();
            lunchCalories = (data['lunchCalories'] as num).toInt();
          }
          if (data['dinnerCalories'] != null) {
            categoriesData['dinner']!.totalCalories = (data['dinnerCalories'] as num).toInt();
            dinnerCalories = (data['dinnerCalories'] as num).toInt();
          }
          if (data['snackCalories'] != null) {
            categoriesData['snack']!.totalCalories = (data['snackCalories'] as num).toInt();
            snackCalories = (data['snackCalories'] as num).toInt();
          }

          // Set grand total from daily document if available
          if (data['totalCalories'] != null) {
            grandTotalCalories = (data['totalCalories'] as num).toInt();
            totalCalories = grandTotalCalories;
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

      // Also check for recipes added to regular category collections
      categoryToCollection.forEach((category, collectionName) {
        additionalCollections.add('${category}_recipe_calories');
      });

      // Fetch data for each food category
      for (final entry in categoryToCollection.entries) {
        final category = entry.key;
        final collectionName = entry.value;

        try {
          final querySnapshot = await userRef
              .collection(collectionName)
              .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
              .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
              .get();

          print("Found ${querySnapshot.docs.length} items in $collectionName");

          for (final doc in querySnapshot.docs) {
            final data = doc.data();
            final name = data['name'] ?? 'Unknown';
            final calories = data['calories'] ?? 0;
            final mealType = data['mealType'] as String? ?? 'Snack';

            // Add to category items
            categoriesData[category]!.items.add({
              'id': doc.id,
              'name': name,
              'calories': calories,
              'mealType': mealType,
              'category': collectionName,
            });

            // Fix: Explicitly convert num to int
            if (calories is num) {
              int caloriesInt = calories.toInt();
              categoriesData[category]!.totalCalories += caloriesInt;

              // Also add to the appropriate meal type category
              if (mealType.toLowerCase() == 'breakfast') {
                categoriesData['breakfast']!.items.add({
                  'id': doc.id,
                  'name': name,
                  'calories': calories,
                  'category': category,
                });
                if (dailyMealDoc.exists == false) {
                  categoriesData['breakfast']!.totalCalories += caloriesInt;
                  breakfastCalories += caloriesInt;
                }
              } else if (mealType.toLowerCase() == 'lunch') {
                categoriesData['lunch']!.items.add({
                  'id': doc.id,
                  'name': name,
                  'calories': calories,
                  'category': category,
                });
                if (dailyMealDoc.exists == false) {
                  categoriesData['lunch']!.totalCalories += caloriesInt;
                  lunchCalories += caloriesInt;
                }
              } else if (mealType.toLowerCase() == 'dinner') {
                categoriesData['dinner']!.items.add({
                  'id': doc.id,
                  'name': name,
                  'calories': calories,
                  'category': category,
                });
                if (dailyMealDoc.exists == false) {
                  categoriesData['dinner']!.totalCalories += caloriesInt;
                  dinnerCalories += caloriesInt;
                }
              } else {
                categoriesData['snack']!.items.add({
                  'id': doc.id,
                  'name': name,
                  'calories': calories,
                  'category': category,
                });
                if (dailyMealDoc.exists == false) {
                  categoriesData['snack']!.totalCalories += caloriesInt;
                  snackCalories += caloriesInt;
                }
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
              .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
              .get();

          print("Found ${querySnapshot.docs.length} items in $collectionName");

          for (final doc in querySnapshot.docs) {
            final data = doc.data();
            final name = data['name'] ?? 'Unknown Recipe';
            final calories = data['calories'] ?? 0;

            // First check if the document has a mealType field
            String? mealTypeNullable = data['mealType'] as String?;
            String mealType;

            // If no mealType field, determine from collection name
            if (mealTypeNullable == null) {
              if (collectionName.startsWith('breakfast')) {
                mealType = 'Breakfast';
              } else if (collectionName.startsWith('lunch')) {
                mealType = 'Lunch';
              } else if (collectionName.startsWith('dinner')) {
                mealType = 'Dinner';
              } else {
                mealType = 'Snack';
              }
            } else {
              mealType = mealTypeNullable;
            }

            // Add to appropriate meal category
            if (mealType.toLowerCase() == 'breakfast') {
              categoriesData['breakfast']!.items.add({
                'id': doc.id,
                'name': name,
                'calories': calories,
                'category': 'recipe',
                'collectionName': collectionName,
              });
              if (dailyMealDoc.exists == false) {
                categoriesData['breakfast']!.totalCalories += calories is num ? calories.toInt() : 0;
                breakfastCalories += calories is num ? calories.toInt() : 0;
              }
            } else if (mealType.toLowerCase() == 'lunch') {
              categoriesData['lunch']!.items.add({
                'id': doc.id,
                'name': name,
                'calories': calories,
                'category': 'recipe',
                'collectionName': collectionName,
              });
              if (dailyMealDoc.exists == false) {
                categoriesData['lunch']!.totalCalories += calories is num ? calories.toInt() : 0;
                lunchCalories += calories is num ? calories.toInt() : 0;
              }
            } else if (mealType.toLowerCase() == 'dinner') {
              categoriesData['dinner']!.items.add({
                'id': doc.id,
                'name': name,
                'calories': calories,
                'category': 'recipe',
                'collectionName': collectionName,
              });
              if (dailyMealDoc.exists == false) {
                categoriesData['dinner']!.totalCalories += calories is num ? calories.toInt() : 0;
                dinnerCalories += calories is num ? calories.toInt() : 0;
              }
            } else {
              categoriesData['snack']!.items.add({
                'id': doc.id,
                'name': name,
                'calories': calories,
                'category': 'recipe',
                'collectionName': collectionName,
              });
              if (dailyMealDoc.exists == false) {
                categoriesData['snack']!.totalCalories += calories is num ? calories.toInt() : 0;
                snackCalories += calories is num ? calories.toInt() : 0;
              }
            }
          }
        } catch (e) {
          print("Error fetching $collectionName: $e");
        }
      }

      // Calculate grand total if not already set from daily_meals
      if (dailyMealDoc.exists == false) {
        // Calculate from meal types
        grandTotalCalories = breakfastCalories + lunchCalories + dinnerCalories + snackCalories;
        totalCalories = grandTotalCalories;

        // Update daily_meals document for future reference
        await _updateDailyTotals();
      }

      setState(() {
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

  // Helper method for determining meal type by time
  String _determineMealTypeByTime(DateTime dateTime) {
    final hour = dateTime.hour;

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

  // Method to update daily totals
  Future<void> _updateDailyTotals() async {
    // Logic for updating daily totals
    final dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
    final dailyMealsRef = userRef.collection('daily_meals').doc(dateStr);

    await dailyMealsRef.set({
      'totalCalories': totalCalories,
      'breakfastCalories': breakfastCalories,
      'lunchCalories': lunchCalories,
      'dinnerCalories': dinnerCalories,
      'snackCalories': snackCalories,
      'lastUpdated': Timestamp.now(),
    }, SetOptions(merge: true));
  }

  Future<void> _deleteItem(String id, String category) async {
    try {
      final docSnapshot = await userRef.collection(category).doc(id).get();
      final data = docSnapshot.data() as Map<String, dynamic>?;
      final calories = data?['calories'] ?? 0;
      final timestamp = data?['timestamp'] as Timestamp?;
      final mealType = data?['mealType'] as String? ??
          (timestamp != null ? _determineMealTypeByTime(timestamp.toDate()) : 'Snack');

      await userRef.collection(category).doc(id).delete();

      // Update the UI
      setState(() {
        clickedItems.removeWhere((item) => item['id'] == id && item['category'] == category);
        // Convert calories to int before subtracting
        final caloriesInt = (calories is num) ? calories.toInt() : 0;
        totalCalories -= caloriesInt;
        grandTotalCalories -= caloriesInt;

        // Update meal-specific calories
        final lowerCaseMealType = mealType.toLowerCase();
        switch(lowerCaseMealType) {
          case 'breakfast':
            breakfastCalories -= caloriesInt;
            categoriesData['breakfast']!.totalCalories -= caloriesInt;
            break;
          case 'lunch':
            lunchCalories -= caloriesInt;
            categoriesData['lunch']!.totalCalories -= caloriesInt;
            break;
          case 'dinner':
            dinnerCalories -= caloriesInt;
            categoriesData['dinner']!.totalCalories -= caloriesInt;
            break;
          case 'snack':
            snackCalories -= caloriesInt;
            categoriesData['snack']!.totalCalories -= caloriesInt;
            break;
        }
      });

      // Update daily totals
      await _updateDailyTotals();

      // Refresh data
      fetchAllCategoriesData();
    } catch (e) {
      print("Error deleting item: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting item: $e'),
          backgroundColor: Colors.red,
        ),
      );
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
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchAllCategoriesData,
            tooltip: 'Refresh data',
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: fetchAllCategoriesData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                        value: (grandTotalCalories / dailyCalorieGoal).clamp(0.0, 1.0),
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
      ),
    );
  }

  // Fixed: Improved pie chart sections calculation to avoid issues
  List<PieChartSectionData> _createPieChartSections() {
    final List<PieChartSectionData> sections = [];

    // Only include meal type categories to keep the chart simple
    final mealCategories = ['breakfast', 'lunch', 'dinner', 'snack'];

    // Get active categories with calories greater than zero
    final activeCategories = categoriesData.entries
        .where((entry) => mealCategories.contains(entry.key) && entry.value.totalCalories > 0)
        .map((entry) => entry.value)
        .toList();

    // If no categories have calories, return empty list
    if (activeCategories.isEmpty) {
      return sections;
    }

    // Calculate total calories for percentage calculation
    final totalCalories = activeCategories
        .fold(0, (sum, category) => sum + category.totalCalories);

    // Make sure we have a non-zero total to avoid division by zero
    if (totalCalories <= 0) {
      return sections;
    }

    // Create a section for each active category
    for (final category in activeCategories) {
      // Calculate percentage with safe division
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
                  child: category.items.isEmpty
                      ? const Center(
                    child: Text(
                      'No items in this category',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  )
                      : ListView.builder(
                    controller: scrollController,
                    itemCount: category.items.length,
                    itemBuilder: (context, index) {
                      final item = category.items[index];
                      return ListTile(
                        title: Text(item['name'] as String),
                        subtitle: item['category'] != null
                            ? Text('Category: ${item['category']}')
                            : null,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${item['calories']} kcal',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF009439),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Add delete button for items
                            if (item['category'] != null && item['id'] != null)
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  final category = item['collectionName'] ?? item['category'];
                                  _deleteItem(item['id'] as String, category as String);
                                  Navigator.pop(context); // Close bottom sheet after delete
                                },
                              ),
                          ],
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
