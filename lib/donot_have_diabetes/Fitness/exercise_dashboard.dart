import 'package:flutter/material.dart';
import 'step_counter.dart'; // Import StepCounterPage
import 'yoga_session_page.dart'; // Import YogaSessionPage
import 'strength_toning_page.dart'; // Import StrengthToningPage
import 'cardio_workout_page.dart'; // Import CardioWorkoutPage

class ExerciseDashboard extends StatelessWidget {
  final List<ExerciseCategory> categories = [
    ExerciseCategory(
      title: 'Step Counter',
      icon: Icons.directions_walk,
      type: ExerciseType.steps,
    ),
    ExerciseCategory(
      title: 'Cardio Workout',
      icon: Icons.directions_run,
      type: ExerciseType.cardio,
    ),
    ExerciseCategory(
      title: 'Yoga Session',
      icon: Icons.self_improvement,
      type: ExerciseType.yoga,
    ),
    ExerciseCategory(
      title: 'Strength & Toning',
      icon: Icons.fitness_center,
      type: ExerciseType.strength,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fitness Program')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) => ExerciseCategoryCard(
          category: categories[index],
          onTap: () => _navigateToExercise(context, categories[index]),
        ),
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

  ExerciseCategory({
    required this.title,
    required this.icon,
    required this.type,
  });
}

enum ExerciseType { steps, cardio, yoga, strength }

class ExerciseCategoryCard extends StatelessWidget {
  final ExerciseCategory category;
  final VoidCallback onTap;

  const ExerciseCategoryCard({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(category.icon, size: 48, color: Colors.blue),
            const SizedBox(height: 16),
            Text(
              category.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
