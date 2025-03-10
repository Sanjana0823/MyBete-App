import 'package:flutter/material.dart';

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
        scaffoldBackgroundColor: const Color(0xFFE5FFED),
      ),
      home: const VegetablesScreen(),
    );
  }
}

class VegetablesScreen extends StatelessWidget {
  const VegetablesScreen({Key? key}) : super(key: key);

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
                    onTap: () {},
                    child: const Icon(
                      Icons.arrow_back,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
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

                      // Vegetables Title
                      const Text(
                        'Vegetables',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
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
                                    hintText: 'Search vegetables',
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

                      // Low-Calorie Vegetables Section
                      const Text(
                        'Low-Calorie Vegetables',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const Text(
                        '(Below 30 kcal per 100g)',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Low-Calorie Vegetables Grid
                      Row(
                        children: [
                          Expanded(
                            child: VegetableCard(
                              name: 'Tomato',
                              calories: 18,
                              imagePath: 'assets/tomato.png',
                              onAdd: () {},
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: VegetableCard(
                              name: 'Cucumber',
                              calories: 15,
                              imagePath: 'assets/cucumber.png',
                              onAdd: () {},
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: VegetableCard(
                              name: 'Spinach',
                              calories: 23,
                              imagePath: 'assets/spinach.png',
                              onAdd: () {},
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Moderate-Calorie Vegetables Section
                      const Text(
                        'Moderate-Calorie Vegetables',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const Text(
                        '(Below 30 - 60kcal per 100g)',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Moderate-Calorie Vegetables Grid
                      Row(
                        children: [
                          Expanded(
                            child: VegetableCard(
                              name: 'Carrot',
                              calories: 41,
                              imagePath: 'assets/carrot.png',
                              onAdd: () {},
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: VegetableCard(
                              name: 'Green Peas',
                              calories: 42,
                              imagePath: 'assets/peas.png',
                              onAdd: () {},
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: VegetableCard(
                              name: 'Beetroot',
                              calories: 43,
                              imagePath: 'assets/beetroot.png',
                              onAdd: () {},
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // High-Calorie Vegetables Section
                      const Text(
                        'High-Calorie Vegetables',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const Text(
                        '(60 + kcal per 100g)',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // High-Calorie Vegetables Grid
                      Row(
                        children: [
                          Expanded(
                            child: VegetableCard(
                              name: 'Potatoes',
                              calories: 86,
                              imagePath: 'assets/potato.png',
                              onAdd: () {},
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: VegetableCard(
                              name: 'Sweet\npotatoes',
                              calories: 87,
                              imagePath: 'assets/sweet_potato.png',
                              onAdd: () {},
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: VegetableCard(
                              name: 'Cassava',
                              calories: 160,
                              imagePath: 'assets/cassava.png',
                              onAdd: () {},
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Navigation Bar
            Container(
              height: 60,
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
                  NavBarItem(
                    icon: Icons.menu_book,
                    color: Colors.blue,
                    isSelected: true,
                  ),
                  NavBarItem(
                    icon: Icons.favorite,
                    color: Colors.black,
                    isSelected: false,
                  ),
                  NavBarItem(
                    icon: Icons.fitness_center,
                    color: Colors.black,
                    isSelected: false,
                  ),
                  NavBarItem(
                    icon: Icons.person,
                    color: Colors.black,
                    isSelected: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VegetableCard extends StatelessWidget {
  final String name;
  final int calories;
  final String imagePath;
  final VoidCallback onAdd;

  const VegetableCard({
    Key? key,
    required this.name,
    required this.calories,
    required this.imagePath,
    required this.onAdd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
            // Vegetable Image
            SizedBox(
              height: 80,
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 80,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image, size: 40),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Vegetable Name
            Text(
              name,
              style: const TextStyle(
                fontSize: 18,
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
                    color: Color(0xFF00C853),
                  ),
                ),

                GestureDetector(
                  onTap: onAdd,
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