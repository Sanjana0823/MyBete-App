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
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const FoodCategoryScreen(mealType: 'label',),
    );
  }
}

class FoodCategoryScreen extends StatelessWidget {
  const FoodCategoryScreen({Key? key, required String mealType}) : super(key: key);

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
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  const SizedBox(height: 10),

                  // Select food category Title
                  const Text(
                    'Select food category',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0048FF),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Food Categories Horizontal Scroller
                  SizedBox(
                    height: 120,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        CategoryItem(
                          title: 'Vegetables',
                          imagePath: 'assets/vegetables.png',
                          onTap: () {},
                        ),
                        CategoryItem(
                          title: 'Fruits',
                          imagePath: 'assets/fruits.png',
                          onTap: () {},
                        ),
                        CategoryItem(
                          title: 'Bakery\nItems',
                          imagePath: 'assets/bakery.png',
                          onTap: () {},
                        ),
                        CategoryItem(
                          title: 'Grains',
                          imagePath: 'assets/grains.png',
                          onTap: () {},
                        ),
                        CategoryItem(
                          title: 'Dairy\nProducts',
                          imagePath: 'assets/milk.png',
                          onTap: () {},
                        ),
                        CategoryItem(
                          title: 'Animal\nProtiens',
                          imagePath: 'assets/meat.png',
                          onTap: () {},
                        ),
                        CategoryItem(
                          title: 'Beverages',
                          imagePath: 'assets/wine.png',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Custom recipes Title
                  const Text(
                    'Custom recipes',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0048FF),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Breakfast Section
                  const Text(
                    'Breakfast',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Breakfast Recipes Horizontal Scroller
                  SizedBox(
                    height: 180,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        RecipeCard(
                          title: 'Oatmeal with Nuts & Fruits',
                          imagePath: 'assets/oatmeal.jpg',
                          isFavorite: true,
                          onTap: () {},
                        ),
                        RecipeCard(
                          title: 'Scrambled Eggs with Veggies',
                          imagePath: 'assets/scrambled_eggs.jpg',
                          isFavorite: false,
                          onTap: () {},
                        ),
                        RecipeCard(
                          title: 'Overnight Oats with Peanut Butter & Banana',
                          imagePath: 'assets/overnight_oats.jpg',
                          isFavorite: false,
                          onTap: () {},
                        ),
                        RecipeCard(
                          title: 'Chia Seed Pudding',
                          imagePath: 'assets/overnight_oats.jpg',
                          isFavorite: false,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Lunch Section
                  const Text(
                    'Lunch',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Lunch Recipes Horizontal Scroller
                  SizedBox(
                    height: 180,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        RecipeCard(
                          title: 'Grilled Chicken & Quinoa Salad',
                          imagePath: 'assets/chicken_salad.jpg',
                          isFavorite: false,
                          onTap: () {},
                        ),
                        RecipeCard(
                          title: 'Lentil & Vegetable Soup',
                          imagePath: 'assets/lentil_soup.jpg',
                          isFavorite: false,
                          onTap: () {},
                        ),
                        RecipeCard(
                          title: 'Chickpea & Avocado Sandwich',
                          imagePath: 'assets/chickpea_sandwich.jpg',
                          isFavorite: false,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Dinner Section
                  const Text(
                    'Dinner',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Dinner Recipes Horizontal Scroller
                  SizedBox(
                    height: 180,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        RecipeCard(
                          title: 'Stuffed Bell Peppers',
                          imagePath: 'assets/stuffed_peppers.jpg',
                          isFavorite: false,
                          onTap: () {},
                        ),
                        RecipeCard(
                          title: 'Baked Cod with Roasted Vegetables',
                          imagePath: 'assets/baked_cod.jpg',
                          isFavorite: false,
                          onTap: () {},
                        ),
                        RecipeCard(
                          title: 'Lemon Garlic Shrimp with Asparagus',
                          imagePath: 'assets/shrimp.jpg',
                          isFavorite: false,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Snacks Section
                  const Text(
                    'Snacks',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Snacks Recipes Horizontal Scroller
                  SizedBox(
                    height: 180,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        RecipeCard(
                          title: 'Banana with Peanut Butter',
                          imagePath: 'assets/banana_pb.jpg',
                          isFavorite: false,
                          onTap: () {},
                        ),
                        RecipeCard(
                          title: 'Greek Yogurt and Honey',
                          imagePath: 'assets/greek_yogurt.jpg',
                          isFavorite: false,
                          onTap: () {},
                        ),
                        RecipeCard(
                          title: 'Carrot Sticks with Hummus',
                          imagePath: 'assets/carrot_hummus.jpg',
                          isFavorite: false,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
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

class CategoryItem extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  const CategoryItem({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            // Category Image
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 80,
                  width: 80,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image, size: 40),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Category Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class RecipeCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final bool isFavorite;
  final VoidCallback onTap;

  const RecipeCard({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.isFavorite,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe Image with Favorite Icon
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    imagePath,
                    height: 120,
                    width: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 120,
                      width: 150,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image, size: 40),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Recipe Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
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