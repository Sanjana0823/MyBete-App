// step_counter_page.dart
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
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
        title: const Text('Step Counter'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showInfoDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildHeaderCard(),
            const SizedBox(height: 32),
            _buildProgressIndicator(),
            const SizedBox(height: 32),
            _buildIntroductionSection(),
            const SizedBox(height: 32),
            _buildStartButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                const Text('TODAY\'S STEPS',
                    style: TextStyle(color: Colors.grey)),
                Text(_steps.toString(),
                    style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            const VerticalDivider(),
            Column(
              children: [
                const Text('DAILY GOAL',
                    style: TextStyle(color: Colors.grey)),
                Text(_dailyGoal.toString(),
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CircularProgressIndicator(
          value: _steps / _dailyGoal,
          strokeWidth: 12,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor),
          semanticsLabel: 'Step progress',
          semanticsValue: '${(_steps / _dailyGoal * 100).toStringAsFixed(1)}%',
        );
      },
    );
  }

  Widget _buildIntroductionSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Walk Your Way to Health',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        SizedBox(height: 16),
        Text(
            'Tracking your daily steps helps maintain an active lifestyle '
                'and reduces health risks. Aim for at least 10,000 steps daily '
                'to boost cardiovascular health and improve overall fitness.',
            style: TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildStartButton() {
    return ElevatedButton.icon(
      icon: const Icon(Icons.directions_walk),
      label: const Text('Start Tracking'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      onPressed: _startTracking,
    );
  }

  void _startTracking() {
    // Implement actual step counting logic
    setState(() => _steps += 1000);
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('How to Use'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('1. Carry your phone in your pocket or bag'),
            Text('2. Walk normally throughout the day'),
            Text('3. Check progress periodically'),
            Text('4. Aim for your daily goal'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}