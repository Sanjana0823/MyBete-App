import 'package:flutter/material.dart';

class Symptom3Screen extends StatefulWidget {
  @override
  _ExtremeHungerCheckerState createState() => _ExtremeHungerCheckerState();
}

class _ExtremeHungerCheckerState extends State<Symptom3Screen> {
  int _totalCalories = 0;
  List<Map<String, dynamic>> _hungerLogs = [];

  final List<Map<String, dynamic>> _foodItems = [
    {'name': 'Apple', 'calories': 95, 'image': 'assets/images/apple.png'},
    {'name': 'Burger', 'calories': 354, 'image': 'assets/images/burger.png'},
    {'name': 'Pizza Slice', 'calories': 285, 'image': 'assets/images/pizza.png'},
    {'name': 'Salad', 'calories': 150, 'image': 'assets/images/salad.png'},
    {'name': 'Fries', 'calories': 365, 'image': 'assets/images/fries.png'},
    {'name': 'Ice Cream', 'calories': 207, 'image': 'assets/images/ice_cream.png'},
  ];

  void _addCalories(int calories) {
    setState(() {
      _totalCalories += calories;
    });
  }

  void _checkExtremeHunger() {
    if (_totalCalories > 2000) { // Extreme hunger threshold
      setState(() {
        _hungerLogs.add({
          'date': DateTime.now().toString(),
          'status': 'Extreme Eating Detected'
        });
      });
      _showDialog("Extreme Eating Detected!", "This total calorie intake qualifies as extreme eating.");
    } else {
      setState(() {
        _hungerLogs.add({
          'date': DateTime.now().toString(),
          'status': 'Normal Eating'
        });
      });
      _showDialog("Normal Eating", "This total calorie intake is within a normal range.");
    }
    // Reset total calories
    setState(() {
      _totalCalories = 0;
    });
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Extreme Hunger Checker"),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _foodItems.length,
              itemBuilder: (context, index) {
                final food = _foodItems[index];
                return GestureDetector(
                  onTap: () => _addCalories(food['calories']),
                  child: Card(
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.asset(
                            food['image'],
                            fit: BoxFit.cover,
                          ),
                        ),
                        Text(
                          food['name'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text("${food['calories']} cal"),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  "Total Calories: $_totalCalories",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _checkExtremeHunger,
                  child: Text("Check Hunger"),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _hungerLogs.length,
              itemBuilder: (context, index) {
                final log = _hungerLogs[index];
                return ListTile(
                  title: Text(log['status'] ?? ''),
                  subtitle: Text(log['date'] ?? ''),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
