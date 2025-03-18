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
        scaffoldBackgroundColor: const Color(0xFFFCE4EC),
      ),
      home: const AnimalProteinsScreen(),
    );
  }
}

class AnimalProteinsScreen extends StatelessWidget {
  const AnimalProteinsScreen({Key? key}) : super(key: key);

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

                      // Animal Proteins Title
                      const Text(
                        'Animal Proteins',
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
                          color: const Color(0xFFF3E5F5),
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
                                    hintText: 'Search animal proteins',
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

                      // Low-Calorie Animal Proteins Section
                      const Text(
                        'Low-Calorie Animal Proteins',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const Text(
                        '(Below 100 kcal per 100g)',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Low-Calorie Animal Proteins Grid
                      Row(
                        children: [
                          Expanded(
                            child: ProteinCard(
                              name: 'Egg Whites',
                              calories: 52,
                              imagePath: 'assets/egg_whites.png',
                              onAdd: () {},
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ProteinCard(
                              name: 'Shrimp',
                              calories: 85,
                              imagePath: 'assets/shrimp.png',
                              onAdd: () {},
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ProteinCard(
                              name: 'Crab',
                              calories: 82,
                              imagePath: 'assets/crab.png',
                              onAdd: () {},
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Moderate-Calorie Animal Proteins Section
                      const Text(
                        'Moderate-Calorie Animal Proteins',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const Text(
                        '(100-350 kcal per 100g)',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Moderate-Calorie Animal Proteins Grid
                      Row(
                        children: [
                          Expanded(
                            child: ProteinCard(
                              name: 'Chicken Breast (Skinless, Cooked)',
                              calories: 165,
                              imagePath: 'assets/chicken_breast.png',
                              onAdd: () {},
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ProteinCard(
                              name: 'Turkey Breast (Cooked)',
                              calories: 135,
                              imagePath: 'assets/turkey_breast.png',
                              onAdd: () {},
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ProteinCard(
                              name: 'Lean Beef (Sirloin, Cooked)',
                              calories: 250,
                              imagePath: 'assets/lean_beef.png',
                              onAdd: () {},
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // High-Calorie Animal Proteins Section
                      const Text(
                        'High-Calorie Animal Proteins',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const Text(
                        '(Above 350 kcal per 100g)',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // High-Calorie Animal Proteins Grid
                      Row(
                        children: [
                          Expanded(
                            child: ProteinCard(
                              name: 'Bacon',
                              calories: 541,
                              imagePath: 'assets/bacon.png',
                              onAdd: () {},
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ProteinCard(
                              name: 'Salami',
                              calories: 425,
                              imagePath: 'assets/salami.png',
                              onAdd: () {},
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ProteinCard(
                              name: 'Pepperoni',
                              calories: 494,
                              imagePath: 'assets/pepperoni.png',
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

class ProteinCard extends StatelessWidget {
  final String name;
  final int calories;
  final String imagePath;
  final VoidCallback onAdd;

  const ProteinCard({
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
            // Protein Image
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

            // Protein Name
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
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