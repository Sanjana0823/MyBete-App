import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:table_calendar/table_calendar.dart';
import 'summary.dart';

class TotalScreen extends StatefulWidget {
  final String category;
  const TotalScreen({Key? key, required this.category}) : super(key: key);

  @override
  _TotalScreenState createState() => _TotalScreenState();
}

class _TotalScreenState extends State<TotalScreen> {
  // Use the same Firebase instances as in the recipe detail screen
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late DocumentReference userRef;

  List<Map<String, dynamic>> clickedItems = [];
  num totalCalories = 0;
  bool isLoading = true;
  DateTime selectedDate = DateTime.now();
  bool showCalendar = false;
  Map<DateTime, num> dailyTotals = {};

  // Meal-specific calories
  num breakfastCalories = 0;
  num lunchCalories = 0;
  num dinnerCalories = 0;
  num snackCalories = 0;

  // Time ranges for meal types
  final TimeOfDay breakfastStart = TimeOfDay(hour: 5, minute: 0);
  final TimeOfDay breakfastEnd = TimeOfDay(hour: 10, minute: 59);
  final TimeOfDay lunchStart = TimeOfDay(hour: 11, minute: 0);
  final TimeOfDay lunchEnd = TimeOfDay(hour: 14, minute: 59);
  final TimeOfDay dinnerStart = TimeOfDay(hour: 17, minute: 0);
  final TimeOfDay dinnerEnd = TimeOfDay(hour: 21, minute: 59);
  // Snacks are anything outside these ranges

  int dailyCalorieGoal = 2000; // Default goal

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
    _fetchClickedItems();
    _fetchDailyTotals();
    _fetchCalorieGoal();
  }

  void _fetchClickedItems() async {
    setState(() {
      isLoading = true;
    });

    try {
      num caloriesSum = 0;
      List<Map<String, dynamic>> items = [];

      // Include all meal type collections
      List<String> categories = [
        'vegetable_calories',
        'fruit_calories',
        'grain_calories',
        'dairy_calories',
        'bakery_calories',
        'protein_calories',
        'beverage_calories',
        'breakfast_calories',
        'lunch_calories',
        'dinner_calories',
        'snack_calories'
      ];

      // Reset meal-specific calories
      breakfastCalories = 0;
      lunchCalories = 0;
      dinnerCalories = 0;
      snackCalories = 0;

      // Format date for comparison (start and end of selected day)
      final startOfDay = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
      );

      final endOfDay = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          23, 59, 59, 999
      );

      print("Fetching items from ${startOfDay.toString()} to ${endOfDay.toString()}");
      print("Using userRef: ${userRef.path}");

      for (String category in categories) {
        print("Checking category: $category");
        final querySnapshot = await userRef.collection(category)
            .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
            .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
            .get();

        print("Found ${querySnapshot.docs.length} items in $category");

        for (var doc in querySnapshot.docs) {
          final data = doc.data();
          final timestamp = data['timestamp'] as Timestamp?;

          if (timestamp == null) {
            print("Warning: Item in $category has no timestamp");
            continue;
          }

          final itemDate = timestamp.toDate();
          print("Item date: ${itemDate.toString()}");

          // Determine meal type based on time of day or use the one from data
          String mealType = data['mealType'] as String? ?? _determineMealTypeByTime(itemDate);

          items.add({
            'id': doc.id,
            'name': data['name'] ?? 'Food Item',
            'calories': data['calories'],
            'timestamp': timestamp,
            'category': category,
            'mealType': mealType,
          });

          if (data['calories'] is num) {
            caloriesSum += data['calories'];

            // Track calories by meal type (determined by time)
            switch(mealType) {
              case 'Breakfast':
              case 'breakfast':
                breakfastCalories += data['calories'];
                break;
              case 'Lunch':
              case 'lunch':
                lunchCalories += data['calories'];
                break;
              case 'Dinner':
              case 'dinner':
                dinnerCalories += data['calories'];
                break;
              case 'Snack':
              case 'snack':
                snackCalories += data['calories'];
                break;
            }
          }
        }
      }

      // Sort items by timestamp (newest first)
      items.sort((a, b) {
        final aTimestamp = a['timestamp'];
        final bTimestamp = b['timestamp'];
        if (aTimestamp == null || bTimestamp == null) return 0;
        return bTimestamp.compareTo(aTimestamp);
      });

      setState(() {
        clickedItems = items;
        totalCalories = caloriesSum;
        isLoading = false;
      });

      print("Total calories: $totalCalories");
      print("Breakfast: $breakfastCalories, Lunch: $lunchCalories, Dinner: $dinnerCalories, Snack: $snackCalories");
      print("Total items found: ${items.length}");
    } catch (e) {
      print("Error fetching items: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // Determine meal type based on time of day
  String _determineMealTypeByTime(DateTime dateTime) {
    final TimeOfDay timeOfDay = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
    final double timeValue = timeOfDay.hour + timeOfDay.minute / 60.0;

    final double breakfastStartValue = breakfastStart.hour + breakfastStart.minute / 60.0;
    final double breakfastEndValue = breakfastEnd.hour + breakfastEnd.minute / 60.0;
    final double lunchStartValue = lunchStart.hour + lunchStart.minute / 60.0;
    final double lunchEndValue = lunchEnd.hour + lunchEnd.minute / 60.0;
    final double dinnerStartValue = dinnerStart.hour + dinnerStart.minute / 60.0;
    final double dinnerEndValue = dinnerEnd.hour + dinnerEnd.minute / 60.0;

    if (timeValue >= breakfastStartValue && timeValue <= breakfastEndValue) {
      return 'Breakfast';
    } else if (timeValue >= lunchStartValue && timeValue <= lunchEndValue) {
      return 'Lunch';
    } else if (timeValue >= dinnerStartValue && timeValue <= dinnerEndValue) {
      return 'Dinner';
    } else {
      return 'Snack';
    }
  }

  void _fetchDailyTotals() async {
    // Get the first day of the month
    final firstDay = DateTime(selectedDate.year, selectedDate.month, 1);
    // Get the last day of the month
    final lastDay = DateTime(selectedDate.year, selectedDate.month + 1, 0);

    try {
      Map<DateTime, num> totals = {};
      List<String> categories = [
        'vegetable_calories',
        'fruit_calories',
        'grain_calories',
        'dairy_calories',
        'bakery_calories',
        'protein_calories',
        'beverage_calories',
        'breakfast_calories',
        'lunch_calories',
        'dinner_calories',
        'snack_calories'
      ];

      for (String category in categories) {
        final querySnapshot = await userRef.collection(category)
            .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(firstDay))
            .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(lastDay))
            .get();

        for (var doc in querySnapshot.docs) {
          final data = doc.data();
          if (data['timestamp'] != null && data['calories'] is num) {
            final timestamp = data['timestamp'] as Timestamp;
            final date = timestamp.toDate();
            final dayDate = DateTime(date.year, date.month, date.day);

            if (totals.containsKey(dayDate)) {
              totals[dayDate] = totals[dayDate]! + data['calories'];
            } else {
              totals[dayDate] = data['calories'];
            }
          }
        }
      }

      setState(() {
        dailyTotals = totals;
      });
    } catch (e) {
      print("Error fetching daily totals: $e");
    }
  }

  Future<void> _fetchCalorieGoal() async {
    try {
      final userDoc = await userRef.get();
      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>?;
        if (data != null && data['preferences'] != null) {
          final prefs = data['preferences'] as Map<String, dynamic>;
          setState(() {
            dailyCalorieGoal = (prefs['calorieGoal'] as num?)?.toInt() ?? 2000;
          });
        }
      }
    } catch (e) {
      print("Error fetching calorie goal: $e");
    }
  }

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      selectedDate = day;
      showCalendar = false;
    });
    _fetchClickedItems();
  }

  @override
  Widget build(BuildContext context) {
    final isToday = selectedDate.year == DateTime.now().year &&
        selectedDate.month == DateTime.now().month &&
        selectedDate.day == DateTime.now().day;

    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Calories'),
        backgroundColor: const Color(0x0065F3FF),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_month),
            onPressed: () {
              setState(() {
                showCalendar = !showCalendar;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (showCalendar)
              TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: selectedDate,
                selectedDayPredicate: (day) {
                  return isSameDay(selectedDate, day);
                },
                onDaySelected: _onDaySelected,
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, events) {
                    final dayDate = DateTime(date.year, date.month, date.day);
                    if (dailyTotals.containsKey(dayDate)) {
                      return Positioned(
                        bottom: 1,
                        child: Container(
                          width: 35,
                          height: 15,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${dailyTotals[dayDate]!.toInt()}',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }
                    return null;
                  },
                ),
              ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF00B8D4), Color(0xFF00E5FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
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
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isToday
                        ? 'Today\'s Calories'
                        : 'Calories for ${DateFormat('MMM d, yyyy').format(selectedDate)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.local_fire_department,
                        color: Colors.orangeAccent,
                        size: 28,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${totalCalories.toStringAsFixed(0)} kcal',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Daily Goal:',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '$dailyCalorieGoal kcal',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: (totalCalories / dailyCalorieGoal).clamp(0.0, 1.0),
                            minHeight: 8,
                            backgroundColor: Colors.white.withOpacity(0.3),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              totalCalories > dailyCalorieGoal
                                  ? Colors.red
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Meal breakdown section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Meal Breakdown',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'By Time of Day',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildMealProgressBar('Breakfast', breakfastCalories.toDouble(), Colors.amber),
                  _buildMealProgressBar('Lunch', lunchCalories.toDouble(), Colors.green),
                  _buildMealProgressBar('Dinner', dinnerCalories.toDouble(), Colors.purple),
                  _buildMealProgressBar('Snacks', snackCalories.toDouble(), Colors.orange),
                ],
              ),
            ),

            // Time distribution chart
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Meal Times',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildTimeIndicator('5-11 AM', 'Breakfast', Colors.amber),
                      _buildTimeIndicator('11-3 PM', 'Lunch', Colors.green),
                      _buildTimeIndicator('5-10 PM', 'Dinner', Colors.purple),
                      _buildTimeIndicator('Other', 'Snacks', Colors.orange),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : clickedItems.isEmpty
                  ? Center(
                child: Text(
                  isToday
                      ? 'No items added today'
                      : 'No items added on this day',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              )
                  : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: clickedItems.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final item = clickedItems[index];
                  final timestamp = item['timestamp'] as Timestamp;
                  final itemDate = timestamp.toDate();
                  final mealType = item['mealType'] as String;

                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: _getMealTypeColor(mealType).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Time indicator
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _getMealTypeColor(mealType).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  DateFormat('h:mm').format(itemDate),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: _getMealTypeColor(mealType),
                                  ),
                                ),
                                Text(
                                  DateFormat('a').format(itemDate),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _getMealTypeColor(mealType),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: _getMealTypeColor(mealType),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    mealType.substring(0, 1).toUpperCase() + mealType.substring(1).toLowerCase(),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Food details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat('EEEE, MMMM d').format(itemDate),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Calories and delete
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${item['calories']} kcal',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF009439),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                onPressed: () => _deleteItem(item['id'], item['category']),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SummaryScreen()),
          );
        },
        backgroundColor: const Color(0xFF00FF62),
        child: const Icon(Icons.pie_chart),
        tooltip: 'View Summary',
      ),
    );
  }

  Widget _buildTimeIndicator(String timeRange, String mealType, Color color) {
    return Column(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          timeRange,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade700,
          ),
        ),
        Text(
          mealType,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Color _getMealTypeColor(String mealType) {
    final lowerCaseMealType = mealType.toLowerCase();
    switch(lowerCaseMealType) {
      case 'breakfast':
        return Colors.amber;
      case 'lunch':
        return Colors.green;
      case 'dinner':
        return Colors.purple;
      case 'snack':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Widget _buildMealProgressBar(String mealType, double calories, Color color) {
    // Calculate percentage of total calories
    final double percentage = totalCalories > 0 ? (calories / totalCalories).clamp(0.0, 1.0) : 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                mealType,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                '${calories.toInt()} kcal (${(percentage * 100).toInt()}%)',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Stack(
            children: [
              // Background
              Container(
                height: 8,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              // Progress
              Container(
                height: 8,
                width: MediaQuery.of(context).size.width * percentage * 0.8, // Adjust for padding
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _deleteItem(String id, String category) async {
    try {
      final docSnapshot = await userRef.collection(category).doc(id).get();
      final data = docSnapshot.data() as Map<String, dynamic>?;
      final calories = data?['calories'] ?? 0;
      final timestamp = data?['timestamp'] as Timestamp?;
      await userRef.collection(category).doc(id).delete();

      // Update the UI
      setState(() {
        clickedItems.removeWhere((item) => item['id'] == id && item['category'] == category);
        totalCalories -= calories;

        // Update meal-specific calories based on time of day
        if (timestamp != null) {
          final itemDate = timestamp.toDate();
          final mealType = data?['mealType'] as String? ?? _determineMealTypeByTime(itemDate);
          final lowerCaseMealType = mealType.toLowerCase();

          switch(lowerCaseMealType) {
            case 'breakfast':
              breakfastCalories -= calories;
              break;
            case 'lunch':
              lunchCalories -= calories;
              break;
            case 'dinner':
              dinnerCalories -= calories;
              break;
            case 'snack':
              snackCalories -= calories;
              break;
          }
        }
      });

      // Update daily totals
      _fetchDailyTotals();
    } catch (e) {
      print("Error deleting item: $e");
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}".trim();
  }
}
