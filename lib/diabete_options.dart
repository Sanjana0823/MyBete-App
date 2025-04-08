import 'package:flutter/material.dart';
import 'package:mybete_app/log_in_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'components/color.dart';
import 'donot_have_diabetes/donot_have_diabete.dart';
import 'have_diabetes/have_diabete_quiz.dart';
import 'not_sure/not_sure.dart';

class DiabeteOptions extends StatelessWidget {
  const DiabeteOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightBlue[50], // Light blue background color
      child: Scaffold(
        backgroundColor: Colors.transparent, // Make Scaffold background transparent
        appBar: AppBar(
          title: Text("Diabetes Options"),
          actions: [
            IconButton(
              icon: Icon(Icons.account_circle, size: 30),
              onPressed: () {
                _showLogoutMenu(context);
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            BouncingCircles(),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      prefs.setBool("onboarding", false);
                    },
                    child: Text(
                      "Choose one option from these three",
                      style: TextStyle(
                        color: Color(0xFF288994), // Change 'blue' to any color you like
                        fontSize: 24, // Optional: adjust the font size
                        fontWeight: FontWeight.bold, // Optional: adjust the weight
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  userFriendlyButton(
                    context,
                    "Have Diabetes",
                    Color(0xFFE28869),
                    Icons.favorite,
                    HaveDiabetesDashboard(),
                  ),
                  SizedBox(height: 20),
                  userFriendlyButton(
                    context,
                    "Don't Have Diabetes",
                    Color(0xFF288994),
                    Icons.no_food,
                    DonotHaveDiabeteDashboard(),
                  ),
                  SizedBox(height: 20),
                  userFriendlyButton(
                    context,
                    "Need Guidance",
                    Color(0xFFF1FAEE),
                    Icons.help,
                    NotSureDashboard(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutMenu(BuildContext context) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(1000, 80, 0, 0),
      items: [
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.logout),
            title: Text('Log Out'),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isLoggedIn', false);
              await prefs.remove('lastLoginDate');
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false,
              );
            },
          ),
        ),
      ],
    );
  }
}

Widget userFriendlyButton(BuildContext context, String text, Color color,
    IconData icon, Widget nextPage) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => nextPage),
      );
    },
    child: ConstrainedBox(
      constraints: BoxConstraints(minWidth: 200, maxWidth: 300),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 4),
              blurRadius: 10,
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 12),
        height: 60,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.black38),
              SizedBox(width: 10),
              Flexible(
                child: Text(
                  text,
                  style: TextStyle(color: Colors.black87, fontSize: 18),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class BouncingCircles extends StatefulWidget {
  @override
  _BouncingCirclesState createState() => _BouncingCirclesState();
}

class _BouncingCirclesState extends State<BouncingCircles>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  List<Offset> positions = [Offset(0, 0), Offset(100, 100), Offset(200, 200)];
  List<Offset> directions = [Offset(2, 2), Offset(-2, 2), Offset(2, -2)];
  List<double> sizes = [50, 75, 100];
  late List<Size> screenSize;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )
      ..addListener(() {
        setState(() {
          for (int i = 0; i < positions.length; i++) {
            positions[i] += directions[i];

            if (positions[i].dx <= 0 ||
                positions[i].dx >= screenSize[i].width - sizes[i]) {
              directions[i] = Offset(-directions[i].dx, directions[i].dy);
            }
            if (positions[i].dy <= 0 ||
                positions[i].dy >= screenSize[i].height - sizes[i]) {
              directions[i] = Offset(directions[i].dx, -directions[i].dy);
            }
          }
        });
      })
      ..repeat();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = [
      MediaQuery.of(context).size,
      MediaQuery.of(context).size,
      MediaQuery.of(context).size,
    ];

    return Stack(
      children: positions
          .asMap()
          .entries
          .map((entry) => Positioned(
        left: entry.value.dx,
        top: entry.value.dy,
        child: Container(
          width: sizes[entry.key],
          height: sizes[entry.key],
          decoration: BoxDecoration(
            color: Color(0xFF96D8E3),
            shape: BoxShape.circle,
          ),
        ),
      ))
          .toList(),
    );
  }
}