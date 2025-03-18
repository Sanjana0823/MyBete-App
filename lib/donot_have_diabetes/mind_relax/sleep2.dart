import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: SleepTimerScreen()));
}

class SleepTimerScreen extends StatefulWidget {
  const SleepTimerScreen({super.key});

  @override
  _SleepTimerScreenState createState() => _SleepTimerScreenState();
}

class _SleepTimerScreenState extends State<SleepTimerScreen> {
  int hour = 12;
  int minute = 30;
  bool isAM = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background with stars
          const StarryBackground(),

          // Main content
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  // Title
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Text(
                      'Sleep Time',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Time Picker Card
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Select time',
                          style: TextStyle(color: Color(0xFF49454F), fontSize: 18),
                        ),
                        const SizedBox(height: 20),

                        // Time Selection
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildTimeBox(hour.toString().padLeft(2, '0')),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(':', style: TextStyle(fontSize: 60)),
                            ),
                            buildTimeBox(minute.toString().padLeft(2, '0')),
                            buildAMPMSelector(),
                          ],
                        ),

                        const SizedBox(height: 30),

                        // Clock Face
                        SizedBox(
                          height: 280,
                          width: 280,
                          child: Stack(
                            alignment: Alignment.center,
                            children: buildClockFace(),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Bottom Buttons
                        buildBottomButtons(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Next Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5A9BD4),
                        minimumSize: const Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),

                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTimeBox(String text) {
    return Container(
      width: 100,
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFFE1D1FF),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(fontSize: 60, fontWeight: FontWeight.w500, color: Color(0xFF554872)),
      ),
    );
  }

  Widget buildAMPMSelector() {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Container(
        width: 60,
        height: 80,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFC5C6D0), width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            buildAMPMButton('AM', isAM),
            const Divider(height: 1, color: Color(0xFFC5C6D0)),
            buildAMPMButton('PM', !isAM),
          ],
        ),
      ),
    );
  }

  Widget buildAMPMButton(String text, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            isAM = text == 'AM';
          });
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFFD8E4) : Colors.transparent,
            borderRadius: text == 'AM'
                ? const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))
                : const BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: isSelected ? const Color(0xFF633B48) : const Color(0xFF79747E),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildClockFace() {
    return List.generate(12, (index) {
      final number = index == 0 ? 12 : index;
      final angle = (index * 30) * (math.pi / 180);
      final radius = 110.0;
      final x = radius * math.sin(angle);
      final y = -radius * math.cos(angle);

      return Positioned(
        left: 140 + x - 15,
        top: 140 + y - 15,
        child: Text(
          '$number',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      );
    });
  }

  Widget buildBottomButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.keyboard, color: Colors.grey),
        ),
        Row(
          children: [
            TextButton(
                onPressed: () {},
                child: const Text('Cancel', style: TextStyle(color: Color(0xFF554872), fontSize: 16))),
            const SizedBox(width: 20),
            TextButton(
                onPressed: () {},
                child: const Text('OK', style: TextStyle(color: Color(0xFF554872), fontSize: 16))),
          ],
        ),
      ],
    );
  }
}

class StarryBackground extends StatelessWidget {
  const StarryBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0D1F2D), Color(0xFF23395D)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}
