import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'step_counter.dart';
import 'yoga_session_page.dart';
import 'strength_toning_page.dart';
import 'cardio_workout_page.dart';


class ExerciseDashboard extends StatelessWidget {
  ExerciseDashboard({Key? key}) : super(key: key);

  // Define our color scheme
  final Color primaryBlue = const Color(0xFF2196F3);
  final Color lightBlue = const Color(0xFF64B5F6);
  final Color darkBlue = const Color(0xFF1565C0);
  final Color backgroundColor = Colors.white;

  // Sample user stats - replace with actual user data
  final int totalWorkouts = 12;
  final int streakDays = 5;
  final int totalMinutes = 345;

  // Using network images temporarily until local assets are properly set up
  final List<ExerciseCategory> categories = [
    ExerciseCategory(
      title: 'Step Counter',
      icon: Icons.directions_walk,
      type: ExerciseType.steps,
      description: 'Track your daily steps',
      imageUrl: 'https://images.unsplash.com/photo-1476480862126-209bfaa8edc8?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80',
      color: const Color(0xFF2196F3),
    ),
    ExerciseCategory(
      title: 'Cardio Workout',
      icon: Icons.directions_run,
      type: ExerciseType.cardio,
      description: 'Boost your heart rate',
      imageUrl: 'https://images.unsplash.com/photo-1538805060514-97d9cc17730c?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80',
      color: const Color(0xFFFF5722),
    ),
    ExerciseCategory(
      title: 'Yoga Session',
      icon: Icons.self_improvement,
      type: ExerciseType.yoga,
      description: 'Find your inner balance',
      imageUrl: 'https://images.unsplash.com/photo-1575052814086-f385e2e2ad1b?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80',
      color: const Color(0xFF9C27B0),
    ),
    ExerciseCategory(
      title: 'Strength & Toning',
      icon: Icons.fitness_center,
      type: ExerciseType.strength,
      description: 'Build muscle & definition',
      imageUrl: 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80',
      color: const Color(0xFF4CAF50),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Set system overlay style for status bar
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildStatistics(),
                  _buildCategoriesSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      title: Padding(
        padding: const EdgeInsets.only(left: 50.5),
        child: Text(
          'Fitness Tracker',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 30,
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.person_outline, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildHeader() {
  return Container(
    height: 250,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [primaryBlue, darkBlue],
      ),
      boxShadow: [
        BoxShadow(
          color: darkBlue.withOpacity(0.4),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Welcome to Fitness Tracker!',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your journey to a healthier, stronger, and more active life starts here.',
            textAlign: TextAlign.center, 
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,

            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Track your workouts, stay motivated, and achieve your fitness goals — one step at a time!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
              
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildStatistics() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      padding: const EdgeInsets.symmetric(vertical:20 , horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(totalWorkouts.toString(), 'Workouts', Icons.fitness_center),
          _buildDivider(),
          _buildStatItem('$streakDays days', 'Streak', Icons.local_fire_department),
          _buildDivider(),
          _buildStatItem('$totalMinutes min', 'Total Time', Icons.timer),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: primaryBlue),
            const SizedBox(width: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: darkBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 50,
      width: 5,
      color: Colors.grey[300],
    );
  }

  Widget _buildCategoriesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 20,
                decoration: BoxDecoration(
                  color: primaryBlue,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Workout Categories',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: darkBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) => ExerciseCategoryCard(
              category: categories[index],
              onTap: () => _navigateToExercise(context, categories[index]),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  void _navigateToExercise(BuildContext context, ExerciseCategory category) {
    if (category.type == ExerciseType.steps) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const StepCounterPage()),
      );
    } else if (category.type == ExerciseType.cardio) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CardioWorkoutPage()),
      );
    } else if (category.type == ExerciseType.yoga) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const YogaSessionPage()),
      );
    } else if (category.type == ExerciseType.strength) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const StrengthToningPage()),
      );
    }
  }
}

class ExerciseCategory {
  final String title;
  final IconData icon;
  final ExerciseType type;
  final String description;
  final String imageUrl;
  final Color color;

  ExerciseCategory({
    required this.title,
    required this.icon,
    required this.type,
    this.description = '',
    required this.imageUrl,
    required this.color,
  });
}

enum ExerciseType { steps, cardio, yoga, strength }

class ExerciseCategoryCard extends StatelessWidget {
  final ExerciseCategory category;
  final VoidCallback onTap;

  const ExerciseCategoryCard({
    Key? key,
    required this.category,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: category.color.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Background image
              Positioned.fill(
                child: Image.network(
                  category.imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey[200],
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / 
                                  loadingProgress.expectedTotalBytes!
                              : null,
                          valueColor: AlwaysStoppedAnimation<Color>(category.color),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: category.color.withOpacity(0.1),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              category.icon,
                              size: 40,
                              color: category.color,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              category.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: category.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Gradient overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        category.color.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
              ),
              // Content
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              category.icon,
                              size: 20,
                              color: category.color,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              category.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (category.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          category.description,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.9),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              // Arrow button
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: category.color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom painter for wave effect at the bottom of the header
class WavePainter extends CustomPainter {
  final Color color;

  WavePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.5);
    
    // First wave
    path.quadraticBezierTo(
      size.width * 0.25, 
      size.height * 0.25, 
      size.width * 0.5, 
      size.height * 0.5
    );
    
    // Second wave
    path.quadraticBezierTo(
      size.width * 0.75, 
      size.height * 0.75, 
      size.width, 
      size.height * 0.5
    );
    
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom painter for pattern in header background
class PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw some circles
    for (int i = 0; i < 10; i++) {
      final radius = (i + 1) * 20.0;
      canvas.drawCircle(
        Offset(size.width * 0.8, size.height * 0.3),
        radius,
        paint,
      );
    }

    // Draw some lines
    for (int i = 0; i < 5; i++) {
      final y = i * 30.0;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width * 0.3, y + 50),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}