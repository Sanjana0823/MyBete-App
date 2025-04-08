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
  late Animation<double> _progressAnimation;

  // Define our color scheme
  final Color primaryBlue = const Color(0xFF1E88E5);
  final Color lightBlue = const Color(0xFF64B5F6);
  final Color darkBlue = const Color(0xFF0D47A1);
  final Color backgroundColor = Colors.white;
  final Color accentColor = const Color(0xFF42A5F5);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _progressAnimation = Tween<double>(
      begin: 0,
      end: _steps / _dailyGoal,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryBlue,
        title: const Text(
          'Step Counter',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: _showInfoDialog,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTopCurve(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildProgressCircle(),
                    const SizedBox(height: 30),
                    _buildStatsCards(),
                    const SizedBox(height: 30),
                    _buildIntroductionSection(),
                    const SizedBox(height: 30),
                    _buildStartButton(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopCurve() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: primaryBlue,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
    );
  }

  Widget _buildProgressCircle() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          height: 220,
          width: 220,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: lightBlue.withOpacity(0.2),
                blurRadius: 15,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background circle
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey.shade200,
                    width: 10,
                  ),
                ),
              ),
              // Progress circle
              SizedBox(
                height: 200,
                width: 200,
                child: CustomPaint(
                  painter: ProgressArcPainter(
                    progress: _progressAnimation.value,
                    color: primaryBlue,
                    strokeWidth: 10,
                  ),
                ),
              ),
              // Steps count
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _steps.toString(),
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: darkBlue,
                    ),
                  ),
                  Text(
                    'STEPS',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${(_steps / _dailyGoal * 100).toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 14,
                      color: lightBlue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'DAILY GOAL',
            value: '$_dailyGoal',
            icon: Icons.flag,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            title: 'CALORIES',
            value: '${(_steps * 0.04).toStringAsFixed(0)}',
            icon: Icons.local_fire_department,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: primaryBlue, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: darkBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroductionSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: lightBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.directions_walk, color: primaryBlue),
              const SizedBox(width: 8),
              Text(
                'Walk Your Way to Health',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: darkBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Tracking your daily steps helps maintain an active lifestyle '
            'and reduces health risks. Aim for at least 10,000 steps daily '
            'to boost cardiovascular health and improve overall fitness.',
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryBlue, accentColor],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: _startTracking,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.directions_walk,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Text(
                  'START TRACKING',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _startTracking() {
    setState(() {
      _steps += 1000;
      // Update the animation to reflect the new step count
      _progressAnimation = Tween<double>(
        begin: _progressAnimation.value,
        end: _steps / _dailyGoal,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ));
      _controller.forward(from: 0);
    });
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.info, color: primaryBlue),
            const SizedBox(width: 8),
            const Text('How to Use'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoItem(1, 'Carry your phone in your pocket or bag'),
            const SizedBox(height: 8),
            _buildInfoItem(2, 'Walk normally throughout the day'),
            const SizedBox(height: 8),
            _buildInfoItem(3, 'Check progress periodically'),
            const SizedBox(height: 8),
            _buildInfoItem(4, 'Aim for your daily goal'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'CLOSE',
              style: TextStyle(color: primaryBlue),
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
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: primaryBlue,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
        ),
      ],
    );
  }
}

// Custom painter for the progress arc
class ProgressArcPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  ProgressArcPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;
    
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    
    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(ProgressArcPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}