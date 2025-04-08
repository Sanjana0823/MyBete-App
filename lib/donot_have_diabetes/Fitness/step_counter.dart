import 'package:flutter/material.dart';
import 'dart:math' as math;

class StepCounterPage extends StatefulWidget {
  const StepCounterPage({super.key});

  @override
  State<StepCounterPage> createState() => _StepCounterPageState();
}

class _StepCounterPageState extends State<StepCounterPage>
    with SingleTickerProviderStateMixin {
  int _steps = 0;
  final int _dailyGoal = 10000;
  late AnimationController _controller;
  
  // Calories calculation - approximately 0.04 calories per step for an average person
  double get _caloriesBurned => _steps * 0.04;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Step Counter',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showInfoDialog,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.blue.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _buildHeaderCard(),
                const SizedBox(height: 32),
                _buildProgressIndicator(),
                const SizedBox(height: 32),
                _buildCaloriesCard(),
                const SizedBox(height: 32),
                _buildIntroductionSection(),
                const SizedBox(height: 32),
                _buildStartButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatColumn('TODAY\'S STEPS', _steps.toString(), 32),
              VerticalDivider(
                thickness: 1,
                width: 40,
                color: Colors.grey.withOpacity(0.3),
              ),
              _buildStatColumn('DAILY GOAL', _dailyGoal.toString(), 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, double fontSize) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1A73E8),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    final double progress = _steps / _dailyGoal;
    final String percentage = '${(progress * 100).toStringAsFixed(0)}%';
    
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: progress),
                duration: const Duration(milliseconds: 1500),
                curve: Curves.easeOutCubic,
                builder: (context, value, _) {
                  return SizedBox(
                    width: 180,
                    height: 180,
                    child: CircularProgressIndicator(
                      value: value,
                      strokeWidth: 15,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF1A73E8)),
                      semanticsLabel: 'Step progress',
                      semanticsValue: percentage,
                    ),
                  );
                },
              );
            },
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                percentage,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A73E8),
                ),
              ),
              Text(
                'Complete',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCaloriesCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.local_fire_department,
                  color: Color(0xFF1A73E8),
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Text(
                  'CALORIES BURNED',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5F6368),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _caloriesBurned.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A73E8),
              ),
            ),
            const Text(
              'kcal',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF5F6368),
              ),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: _caloriesBurned / 400, // Assuming 400 calories is a good daily goal
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF1A73E8)),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroductionSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.directions_walk_rounded,
                  color: Color(0xFF1A73E8),
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Walk Your Way to Health',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A73E8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Tracking your daily steps helps maintain an active lifestyle '
              'and reduces health risks. Aim for at least 10,000 steps daily '
              'to boost cardiovascular health and improve overall fitness.',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF5F6368),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Every step counts! Walking 10,000 steps burns approximately 400-500 calories, depending on your weight and walking pace.',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF5F6368),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStartButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(
          Icons.directions_walk,
          size: 24,
        ),
        label: const Text(
          'Start Tracking',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        onPressed: _startTracking,
      ),
    );
  }

  void _startTracking() {
    // Implement actual step counting logic
    setState(() => _steps += 1000);
    
    // Animate the progress indicator
    _controller.reset();
    _controller.forward();
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'How to Use',
          style: TextStyle(
            color: Color(0xFF1A73E8),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoItem(1, 'Carry your phone in your pocket or bag'),
            const SizedBox(height: 16),
            _buildInfoItem(2, 'Walk normally throughout the day'),
            const SizedBox(height: 16),
            _buildInfoItem(3, 'Check progress periodically'),
            const SizedBox(height: 16),
            _buildInfoItem(4, 'Aim for your daily goal'),
            const SizedBox(height: 16),
            _buildInfoItem(5, 'Track calories burned for fitness goals'),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF1A73E8),
            ),
            child: const Text(
              'Close',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoItem(int number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF1A73E8),
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF5F6368),
            ),
          ),
        ),
      ],
    );
  }
}
