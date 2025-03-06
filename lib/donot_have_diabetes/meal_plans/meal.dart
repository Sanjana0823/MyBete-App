import 'package:flutter/material.dart';

void main() {
  runApp(MealPlannerApp());
}

class MealPlannerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MealPlannerScreen(),
    );
  }
}

class MealPlannerScreen extends StatelessWidget {
  final List<Map<String, dynamic>> nutrients = [
    {'name': 'Carbs', 'value': 29, 'color': Colors.yellow},
    {'name': 'Protein', 'value': 65, 'color': Colors.red},
    {'name': 'Vitamins', 'value': 25, 'color': Colors.green},
    {'name': 'Sugar', 'value': 20, 'color': Colors.purple},
    {'name': 'Fat', 'value': 5, 'color': Colors.orange},
  ];

  final List<String> meals = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Meal Planner", style: TextStyle(color: Colors.blue, fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProgressCard(),
            SizedBox(height: 20),
            Text("Select Your Meal", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            _buildMealScroller(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Today's Progress", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text("1200kcal", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: nutrients.map((nutrient) => _buildNutrientIndicator(nutrient)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientIndicator(Map<String, dynamic> nutrient) {
    return Column(
      children: [
        Text("${nutrient['value']}%", style: TextStyle(color: nutrient['color'], fontWeight: FontWeight.bold)),
        Text(nutrient['name'], style: TextStyle(fontSize: 12, color: Colors.black54)),
      ],
    );
  }

  Widget _buildMealScroller() {
    return Container(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: meals.length,
        itemBuilder: (context, index) {
          return _buildMealCard(meals[index]);
        },
      ),
    );
  }

  Widget _buildMealCard(String meal) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.grey.shade300, blurRadius: 5, spreadRadius: 2)
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/$meal.png', height: 50, width: 50, fit: BoxFit.cover), // Placeholder image path
          SizedBox(height: 10),
          Text(meal, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
