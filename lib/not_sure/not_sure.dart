import 'package:flutter/material.dart';
import 'package:mybete_app/not_sure/navigation.dart';
import 'symptom_levels/6_blurry_vision_check/blurry_vision.dart';
import 'symptom_levels/5_frequent_urinary_check/frequent_urinary.dart';
import 'symptom_levels/7_feel_tired_check/more_tired.dart';
import 'symptom_levels/2_nerones_damage_check/neurons_damage.dart';
import 'symptom_levels/9_numbness_check/numbness.dart';
import 'symptom_levels/10_period_check/period_changes.dart';
import 'symptom_levels/1_polydipsia_check/polydipsia.dart';
import 'symptom_levels/3_polyphagia_check/polyphagia.dart';
import 'symptom_levels/8_skin_changes_check/skin_changes.dart';
import 'symptom_levels/4_weight_changes_check/weight_changes.dart';

class NotSureDashboard extends StatelessWidget {
  final List<String> symptoms = [
    'Feeling Extra Thirsty (Polydipsia)',
    'Neurons damage and stroke',
    'Extreme Hunger (Polyphagia)',
    'Weight changes',
    'Frequent urinary tract infections or yeast infections (Polyuria)',
    'Blurry vision',
    'Feeling more tired than usual',
    'Skin changes',
    'Numbness or tingling in the feet',
    'Changes to your periods',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Diabetes Dashboard"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          // BouncingCircles(), // Bouncing circles in the background
          ListView.builder(
            itemCount: symptoms.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.withOpacity(0.2),
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Color(0xFF288994), // Blue number
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  symptoms[index],
                  style: const TextStyle(
                    color: Color(0xFF288994), // Blue text
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LevelDetailScreen(
                        level: index + 1,
                        symptom: symptoms[index],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: NavigationBarWidget(currentIndex: 1),
    );
  }
}

class LevelDetailScreen extends StatelessWidget {
  final int level;
  final String symptom;

  LevelDetailScreen({required this.level, required this.symptom});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Level $level'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Level $level: $symptom',
              style: const TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      switch (level) {
                        case 1:
                          return Symptom1Screen();
                        case 2:
                          return Symptom2Screen();
                        case 3:
                          return Symptom3Screen();
                        case 4:
                          return Symptom4Screen();
                        case 5:
                          return Symptom5Screen();
                        case 6:
                          return Symptom6Screen();
                        case 7:
                          return Symptom7Screen();
                        case 8:
                          return Symptom8Screen();
                        case 9:
                          return Symptom9Screen();
                        case 10:
                          return Symptom10Screen();
                        default:
                          return Symptom1Screen();
                      }
                    },
                  ),
                );
              },
              child: Text(
                "Check Symptom",
                style: TextStyle(
                  color: Color(0xFF288994),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class BouncingCircles extends StatefulWidget {
//   @override
//   _BouncingCirclesState createState() => _BouncingCirclesState();
// }
//
// class _BouncingCirclesState extends State<BouncingCircles> with SingleTickerProviderStateMixin {
//   AnimationController? _controller;
//   List<Offset> positions = [Offset(0, 0), Offset(200, 200), Offset(100, 100)];
//   List<Offset> directions = [Offset(2, 2), Offset(-2, 2), Offset(2, -2)];
//   List<double> sizes = [60, 80, 100];
//   Size? screenSize;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(seconds: 5),
//       vsync: this,
//     )..addListener(() {
//       setState(() {
//         for (int i = 0; i < positions.length; i++) {
//           positions[i] += directions[i];
//
//           if (positions[i].dx <= 0 || positions[i].dx >= (screenSize!.width - sizes[i])) {
//             directions[i] = Offset(-directions[i].dx, directions[i].dy);
//           }
//           if (positions[i].dy <= 0 || positions[i].dy >= (screenSize!.height - sizes[i])) {
//             directions[i] = Offset(directions[i].dx, -directions[i].dy);
//           }
//         }
//       });
//     })..repeat();
//   }
//
//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     screenSize = MediaQuery.of(context).size;
//
//     return Stack(
//       children: positions
//           .asMap()
//           .entries
//           .map((entry) => Positioned(
//         left: entry.value.dx,
//         top: entry.value.dy,
//         child: Container(
//           width: sizes[entry.key],
//           height: sizes[entry.key],
//           decoration: BoxDecoration(
//             color: Color(0xFF06333B),
//             shape: BoxShape.circle,
//           ),
//         ),
//       ))
//           .toList(),
//     );
//   }
// }
