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
        scaffoldBackgroundColor: const Color(0xFFFEE8E0),
      ),
      home: const BakeryItemsScreen(),
    );
  }
}

class BakeryItemsScreen extends StatelessWidget {
  const BakeryItemsScreen({Key? key}) : super(key: key);

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

                      // Bakery Items Title
                      const Text(
                        'Bakery Items',
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
                                    hintText: 'Search bakery items',
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

                      // Low-Calorie Bakery Items Section
                      const Text(
                        'Low-Calorie Bakery Items',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const Text(
                        '(Below 300 kcal per 100g)',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Low-Calorie Bakery Items Grid
                      Row(
                        children: [
                          Expanded(
                            child: BakeryItemCard(
                              name: 'White Bread',
                              calories: 265,
                              imagePath: 'assets/white_bread.png',
                              onAdd: () {},
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: BakeryItemCard(
                              name: 'Whole Wheat Bread',
                              calories: 247,
                              imagePath: 'assets/whole_wheat_bread.png',
                              onAdd: () {},
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: BakeryItemCard(
                              name: 'Multigrain Bread',
                              calories: 250,
                              imagePath: 'assets/multigrain_bread.png',
                              onAdd: () {},
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Moderate-Calorie Bakery Items Section
                      const Text(
                        'Moderate-Calorie Bakery Items',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const Text(
                        '(250-450 kcal per 100g)',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Moderate-Calorie Bakery Items Grid
                      Row(
                        children: [
                          Expanded(
                            child: BakeryItemCard(
                              name: 'Croissant',
                              calories: 406,
                              imagePath: 'assets/croissant.png',
                              onAdd: () {},
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: BakeryItemCard(
                              name: 'Cinnamon roll',
                              calories: 450,
                              imagePath: 'assets/cinnamon_roll.png',
                              onAdd: () {},
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: BakeryItemCard(
                              name: 'Chocolate Cake',
                              calories: 371,
                              imagePath: 'assets/chocolate_cake.png',
                              onAdd: () {},
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // High-Calorie Bakery Items Section
                      const Text(
                        'High-Calorie Bakery Items',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const Text(
                        '(Above 450 kcal per 100g)',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // High-Calorie Bakery Items Grid
                      Row(
                        children: [
                          Expanded(
                            child: BakeryItemCard(
                              name: 'Puff Pastry',
                              calories: 558,
                              imagePath: 'assets/puff_pastry.png',
                              onAdd: () {},
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: BakeryItemCard(
                              name: 'Butter Cookies',
                              calories: 520,
                              imagePath: 'assets/butter_cookies.png',
                              onAdd: () {},
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: BakeryItemCard(
                              name: 'Oatmeal Cookies',
                              calories: 450,
                              imagePath: 'assets/oatmeal_cookies.png',
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

class BakeryItemCard extends StatelessWidget {
  final String name;
  final int calories;
  final String imagePath;
  final VoidCallback onAdd;

  const BakeryItemCard({
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
            // Bakery Item Image
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

            // Bakery Item Name
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
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