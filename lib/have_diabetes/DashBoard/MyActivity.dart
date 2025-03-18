import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'LogDetails/LogInterface.dart';
import 'profile/Profile.dart';
import 'Reminder/Reminder_screen.dart';
import 'Reports.dart';


class MyActivityScreen extends StatefulWidget {
  @override
  _MyActivityScreenState createState() => _MyActivityScreenState();
}

class _MyActivityScreenState extends State<MyActivityScreen> {
  int _selectedIndex = 0;

  // Navigation Bar Screens
  final List<Widget> _screens = [
    MyActivityScreenContent(), // Main Activity Screen
    ReportsScreen(),
    RemindersScreen(),
    ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Show selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        selectedItemColor: Colors.lightBlue, // Highlight selected tab
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "My activity"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Reports"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Reminders"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

// Separate Widget for My Activity Screen Content
class MyActivityScreenContent extends StatefulWidget {
  @override
  _MyActivityScreenContentState createState() => _MyActivityScreenContentState();
}

class _MyActivityScreenContentState extends State<MyActivityScreenContent> {
  List<Map<String, dynamic>> logHistory = [];

  void _deleteLogEntry(int index) {
    setState(() {
      logHistory.removeAt(index);
    });
  }

  void _navigateToLogEntryScreen() async {
    final newLogEntry = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LogEntryScreen()),
    );

    if (newLogEntry != null) {
      setState(() {
        logHistory.add(newLogEntry);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Activity", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.lightBlue[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Blood Glucose Graph
            Card(
              color: Color(0xFFC5EDFF),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Blood Glucose Level (mg/dL)",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Container(
                      height: 200,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: true),
                          titlesData: FlTitlesData(show: true),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: logHistory.isNotEmpty
                                  ? logHistory.asMap().entries.map((entry) {
                                return FlSpot(entry.key.toDouble(), entry.value['bloodSugar']);
                              }).toList()
                                  : [FlSpot(0, 0)],
                              isCurved: true,
                              color: Color(0xFF5EB7CF),
                              barWidth: 4,
                              belowBarData: BarAreaData(show: false),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // Today's Summary
            Center(
              child: Column(
                children: [
                  Text("Today", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  //Text("-- -- ----", style: TextStyle(fontSize: 16, color: Colors.grey)),
                  SizedBox(height: 10),
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.blue[100],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          logHistory.isNotEmpty
                              ? "${logHistory.last['bloodSugar']} mg/dL"
                              : "---",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text("Average", style: TextStyle(fontSize: 14, color: Colors.grey)),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {},
                    child: Text("See more >", style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            // Log History
            Expanded(
              child: logHistory.isEmpty
                  ? Center(
                child: Text("No log entries yet.", style: TextStyle(color: Colors.grey)),
              )
                  : ListView.builder(
                itemCount: logHistory.length,
                itemBuilder: (context, index) {
                  final log = logHistory[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ExpansionTile(
                      title: Text("${log['date']}"),
                      children: [
                        ListTile(
                          title: Text("Time: ${log['time']}"),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Blood Sugar: ${log['bloodSugar']} mg/dL"),
                              Text("Pills: ${log['pills']}"),
                              Text("Blood Pressure: ${log['bloodPressure']} mmHg"),
                              Text("Body Weight: ${log['bodyWeight']} kg"),
                              Text("Food: ${log['foodType']}"),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteLogEntry(index),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF5FB8DD),
        onPressed: _navigateToLogEntryScreen,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
