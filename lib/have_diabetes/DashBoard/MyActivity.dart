// //
// // import 'package:flutter/material.dart';
// // import 'package:fl_chart/fl_chart.dart';
// // import 'package:intl/intl.dart';
// //
// // import 'Profile.dart';
// // import 'Reminders.dart';
// // import 'Reports.dart';
// //
// // void main() {
// //   runApp(MyApp());
// // }
// //
// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       home: DashboardScreen(),
// //     );
// //   }
// // }
// //
// // class DashboardScreen extends StatefulWidget {
// //   @override
// //   _DashboardScreenState createState() => _DashboardScreenState();
// // }
// //
// // class _DashboardScreenState extends State<DashboardScreen> {
// //   int _selectedIndex = 0;
// //   final List<Widget> _screens = [
// //     MyActivityScreen(),
// //     ReportsScreen(),
// //     RemindersScreen(),
// //     ProfileScreen(),
// //   ];
// //
// //   void _onItemTapped(int index) {
// //     setState(() {
// //       _selectedIndex = index;
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: _screens[_selectedIndex],
// //       bottomNavigationBar: BottomNavigationBar(
// //         currentIndex: _selectedIndex,
// //         onTap: _onItemTapped,
// //         selectedItemColor: Color(0xFF5FB8DD),
// //         unselectedItemColor: Colors.grey,
// //         items: [
// //           BottomNavigationBarItem(icon: Icon(Icons.home), label: "My Activity"),
// //           BottomNavigationBarItem(icon: Icon(Icons.analytics), label: "Reports"),
// //           BottomNavigationBarItem(icon: Icon(Icons.alarm), label: "Reminders"),
// //           BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// // class MyActivityScreen extends StatefulWidget {
// //   @override
// //   _MyActivityScreenState createState() => _MyActivityScreenState();
// // }
// //
// // class _MyActivityScreenState extends State<MyActivityScreen> {
// //   List<Map<String, dynamic>> logEntries = [];
// //
// //   void _addLogEntry(Map<String, dynamic> log) {
// //     setState(() {
// //       logEntries.add(log);
// //     });
// //   }
// //
// //   void _deleteLogEntry(int index) {
// //     setState(() {
// //       logEntries.removeAt(index);
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text("My Activity", style: TextStyle(fontWeight: FontWeight.bold)),
// //         backgroundColor: Color(0xFF5FB8DD),
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             // Blood Sugar Graph
// //             Card(
// //               color: Color(0xFFC5EDFF),
// //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
// //               elevation: 5,
// //               child: Padding(
// //                 padding: const EdgeInsets.all(16.0),
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text("Blood Glucose Level (mg/dL)",
// //                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
// //                     SizedBox(height: 10),
// //                     Container(
// //                       height: 200,
// //                       child: LineChart(
// //                         LineChartData(
// //                           gridData: FlGridData(show: true),
// //                           titlesData: FlTitlesData(show: true),
// //                           borderData: FlBorderData(show: false),
// //                           lineBarsData: [
// //                             LineChartBarData(
// //                               spots: logEntries.isNotEmpty
// //                                   ? logEntries.asMap().entries.map((entry) {
// //                                 return FlSpot(
// //                                     entry.key.toDouble(),
// //                                     double.parse(entry.value['bloodSugar']));
// //                               }).toList()
// //                                   : [FlSpot(0, 0)],
// //                               isCurved: true,
// //                               color: Color(0xFF5EB7CF),
// //                               barWidth: 4,
// //                               belowBarData: BarAreaData(show: false),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //             SizedBox(height: 20),
// //             // Log History
// //             Expanded(
// //               child: ListView.builder(
// //                 itemCount: logEntries.length,
// //                 itemBuilder: (context, index) {
// //                   final log = logEntries[index];
// //                   return Card(
// //                     margin: EdgeInsets.symmetric(vertical: 5),
// //                     child: ListTile(
// //                       title: Text("${log['time']} - ${log['bloodSugar']} mg/dL"),
// //                       subtitle: Text("Food: ${log['foodType']}"),
// //                       trailing: IconButton(
// //                         icon: Icon(Icons.delete, color: Colors.red),
// //                         onPressed: () => _deleteLogEntry(index),
// //                       ),
// //                     ),
// //                   );
// //                 },
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //       floatingActionButton: FloatingActionButton(
// //         backgroundColor: Color(0xFF5FB8DD),
// //         onPressed: () async {
// //           final logData = await Navigator.push(
// //             context,
// //             MaterialPageRoute(builder: (context) => LogEntryScreen()),
// //           );
// //           if (logData != null) {
// //             _addLogEntry(logData);
// //           }
// //         },
// //         child: Icon(Icons.add, color: Colors.white),
// //       ),
// //     );
// //   }
// // }
// //
// // class LogEntryScreen extends StatefulWidget {
// //   @override
// //   _LogEntryScreenState createState() => _LogEntryScreenState();
// // }
// //
// // class _LogEntryScreenState extends State<LogEntryScreen> {
// //   DateTime selectedDate = DateTime.now();
// //   String bloodSugar = "";
// //   String foodType = "";
// //
// //   void _pickDateTime() async {
// //     DateTime? pickedDate = await showDatePicker(
// //       context: context,
// //       initialDate: selectedDate,
// //       firstDate: DateTime(2020),
// //       lastDate: DateTime(2101),
// //     );
// //     if (pickedDate != null) {
// //       TimeOfDay? pickedTime = await showTimePicker(
// //         context: context,
// //         initialTime: TimeOfDay.now(),
// //       );
// //       if (pickedTime != null) {
// //         setState(() {
// //           selectedDate = DateTime(
// //             pickedDate.year,
// //             pickedDate.month,
// //             pickedDate.day,
// //             pickedTime.hour,
// //             pickedTime.minute,
// //           );
// //         });
// //       }
// //     }
// //   }
// //
// //   void _saveLog() {
// //     if (bloodSugar.isNotEmpty && foodType.isNotEmpty) {
// //       Navigator.pop(context, {
// //         "time": DateFormat('HH:mm dd/MM/yyyy').format(selectedDate),
// //         "bloodSugar": bloodSugar,
// //         "foodType": foodType,
// //       });
// //     }
// //   }
// //
// //   void _discardLog() {
// //     showDialog(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         title: Text("Unsaved Entry"),
// //         content: Text("Your log entry has not been saved. Are you sure you want to discard?"),
// //         actions: [
// //           TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
// //           TextButton(
// //             onPressed: () {
// //               Navigator.pop(context); // Close the alert dialog
// //               Navigator.pop(context); // Go back to the previous screen
// //             },
// //             child: Text("Discard", style: TextStyle(color: Colors.red)),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text("Log Entry"),
// //         backgroundColor: Color(0xFF5FB8DD),
// //         leading: IconButton(icon: Icon(Icons.close), onPressed: _discardLog),
// //         actions: [
// //           IconButton(icon: Icon(Icons.check), onPressed: _saveLog),
// //         ],
// //       ),
// //       body: Padding(
// //         padding: EdgeInsets.all(16),
// //         child: Column(
// //           children: [
// //             TextFormField(
// //               readOnly: true,
// //               onTap: _pickDateTime,
// //               decoration: InputDecoration(labelText: "Date & Time"),
// //               controller: TextEditingController(text: DateFormat('HH:mm dd/MM/yyyy').format(selectedDate)),
// //             ),
// //             TextField(
// //               onChanged: (val) => bloodSugar = val,
// //               decoration: InputDecoration(labelText: "Blood Sugar (mg/dL)"),
// //               keyboardType: TextInputType.number,
// //             ),
// //             DropdownButtonFormField<String>(
// //               items: ["Water", "Vegetables", "Fast Food"].map((type) {
// //                 return DropdownMenuItem(value: type, child: Text(type));
// //               }).toList(),
// //               onChanged: (val) => foodType = val!,
// //               decoration: InputDecoration(labelText: "Food Type"),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
//
// //
// // import 'package:flutter/material.dart';
// // import 'package:fl_chart/fl_chart.dart';
// // import 'package:intl/intl.dart';
// //
// // import 'Profile.dart';
// // import 'Reminders.dart';
// // import 'Reports.dart';
// //
// // void main() {
// //   runApp(MyApp());
// // }
// //
// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       home: DashboardScreen(),
// //     );
// //   }
// // }
// //
// // // ------------------ DASHBOARD SCREEN ------------------
// // class DashboardScreen extends StatefulWidget {
// //   @override
// //   _DashboardScreenState createState() => _DashboardScreenState();
// // }
// //
// //  class _DashboardScreenState extends State<DashboardScreen> {
// //   int _selectedIndex = 0;
// //   final List<Widget> _screens = [
// //     MyActivityScreen(),
// //     ReportsScreen(),
// //     RemindersScreen(),
// //     ProfileScreen(),
// //   ];
// //
// //   void _onItemTapped(int index) {
// //     setState(() {
// //       _selectedIndex = index;
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: _screens[_selectedIndex],
// //       bottomNavigationBar: BottomNavigationBar(
// //         currentIndex: _selectedIndex,
// //         onTap: _onItemTapped,
// //         selectedItemColor: Color(0xFF5FB8DD),
// //         unselectedItemColor: Colors.grey,
// //         items: [
// //           BottomNavigationBarItem(icon: Icon(Icons.home), label: "My Activity"),
// //           BottomNavigationBarItem(icon: Icon(Icons.analytics), label: "Reports"),
// //           BottomNavigationBarItem(icon: Icon(Icons.alarm), label: "Reminders"),
// //           BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// // // ------------------ MY ACTIVITY SCREEN ------------------
// // class MyActivityScreen extends StatefulWidget {
// //   @override
// //   _MyActivityScreenState createState() => _MyActivityScreenState();
// // }
// //
// // class _MyActivityScreenState extends State<MyActivityScreen> {
// //   List<Map<String, dynamic>> logEntries = [];
// //
// //   void _addLogEntry(Map<String, dynamic> log) {
// //     setState(() {
// //       logEntries.add(log);
// //     });
// //   }
// //
// //   void _deleteLogEntry(int index) {
// //     setState(() {
// //       logEntries.removeAt(index);
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text("My Activity", style: TextStyle(fontWeight: FontWeight.bold)),
// //         backgroundColor: Colors.lightBlue[300],
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             // Blood Sugar Graph
// //             Card(
// //               color: Color(0xFFC5EDFF),
// //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
// //               elevation: 5,
// //               child: Padding(
// //                 padding: const EdgeInsets.all(16.0),
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text("Blood Glucose Level (mg/dL)",
// //                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
// //                     SizedBox(height: 10),
// //                     Container(
// //                       height: 200,
// //                       child: LineChart(
// //                         LineChartData(
// //                           gridData: FlGridData(show: true),
// //                           titlesData: FlTitlesData(show: true),
// //                           borderData: FlBorderData(show: false),
// //                           lineBarsData: [
// //                             LineChartBarData(
// //                               spots: logEntries.isNotEmpty
// //                                   ? logEntries.asMap().entries.map((entry) {
// //                                 return FlSpot(entry.key.toDouble(), entry.value['bloodSugar']);
// //                               }).toList()
// //                                   : [FlSpot(0, 0)],
// //                               isCurved: true,
// //                               color: Color(0xFF5EB7CF),
// //                               barWidth: 4,
// //                               belowBarData: BarAreaData(show: false),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //             SizedBox(height: 20),
// //             // Log History
// //             Expanded(
// //               child: ListView.builder(
// //                 itemCount: logEntries.length,
// //                 itemBuilder: (context, index) {
// //                   final log = logEntries[index];
// //                   return Card(
// //                     margin: EdgeInsets.symmetric(vertical: 5),
// //                     child: ListTile(
// //                       title: Text("${log['time']} - ${log['bloodSugar']} mg/dL"),
// //                       subtitle: Text("Food: ${log['foodType']}"),
// //                       trailing: IconButton(
// //                         icon: Icon(Icons.delete, color: Colors.red),
// //                         onPressed: () => _deleteLogEntry(index),
// //                       ),
// //                     ),
// //                   );
// //                 },
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //       floatingActionButton: FloatingActionButton(
// //         backgroundColor: Color(0xFF5FB8DD),
// //         onPressed: () async {
// //           final logData = await Navigator.push(
// //             context,
// //             MaterialPageRoute(builder: (context) => LogEntryScreen()),
// //           );
// //           if (logData != null) {
// //             _addLogEntry(logData);
// //           }
// //         },
// //         child: Icon(Icons.add, color: Colors.white),
// //       ),
// //     );
// //   }
// // }
// //
// // // ------------------ LOG ENTRY SCREEN ------------------
// // class LogEntryScreen extends StatefulWidget {
// //   @override
// //   _LogEntryScreenState createState() => _LogEntryScreenState();
// // }
// //
// // class _LogEntryScreenState extends State<LogEntryScreen> {
// //   DateTime selectedDate = DateTime.now();
// //   double? bloodSugar;
// //   String? pills;
// //   double? bloodPressure;
// //   double? bodyWeight;
// //   List<String> selectedTrackingMoments = [];
// //   List<String> selectedFoodTypes = [];
// //
// //   final List<String> trackingMoments = [
// //     "Breakfast", "Lunch", "Before Meal", "After Meal", "Fasting",
// //     "Snack", "Dinner", "Hypo Feeling", "Hyper Feeling"
// //   ];
// //
// //   final List<String> foodTypes = [
// //     "Water", "Vegetables", "Fruits", "Grains", "Legumes",
// //     "Meat", "Fish", "Egg", "Nuts", "Fast Food", "Alcohol",
// //     "Diet Soda", "Soft Drinks"
// //   ];
// //
// //   void _pickDateTime() async {
// //     DateTime? pickedDate = await showDatePicker(
// //       context: context,
// //       initialDate: selectedDate,
// //       firstDate: DateTime(2020),
// //       lastDate: DateTime(2101),
// //     );
// //     if (pickedDate != null) {
// //       TimeOfDay? pickedTime = await showTimePicker(
// //         context: context,
// //         initialTime: TimeOfDay.now(),
// //       );
// //       if (pickedTime != null) {
// //         setState(() {
// //           selectedDate = DateTime(
// //             pickedDate.year,
// //             pickedDate.month,
// //             pickedDate.day,
// //             pickedTime.hour,
// //             pickedTime.minute,
// //           );
// //         });
// //       }
// //     }
// //   }
// //
// //   void _saveLog() {
// //     if (bloodSugar == null || bloodPressure == null || bodyWeight == null) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text("Please fill in all required fields!")),
// //       );
// //       return;
// //     }
// //
// //     Navigator.pop(context, {
// //       "time": DateFormat('HH:mm dd/MM/yyyy').format(selectedDate),
// //       "bloodSugar": bloodSugar,
// //       "pills": pills,
// //       "bloodPressure": bloodPressure,
// //       "bodyWeight": bodyWeight,
// //       "trackingMoments": selectedTrackingMoments,
// //       "foodType": selectedFoodTypes,
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text("Log Entry"),
// //         backgroundColor: Color(0xFF5FB8DD),
// //         actions: [IconButton(icon: Icon(Icons.check), onPressed: _saveLog)],
// //       ),
// //       body: Padding(
// //         padding: EdgeInsets.all(16),
// //         child: Column(
// //           children: [
// //             TextFormField(
// //               readOnly: true,
// //               onTap: _pickDateTime,
// //               decoration: InputDecoration(labelText: "Date & Time"),
// //               controller: TextEditingController(text: DateFormat('HH:mm dd/MM/yyyy').format(selectedDate)),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
//
//
// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'LogDetails/LogInterface.dart';
// import 'package:mybete_app/have_diabetes/DashBoard/profile/Profile.dart';
// import 'profile/Profile.dart';
// import 'Reminders.dart';
// import 'Reports.dart';
//
//
// class MyActivityScreen extends StatefulWidget {
//   @override
//   _MyActivityScreenState createState() => _MyActivityScreenState();
// }
//
// class _MyActivityScreenState extends State<MyActivityScreen> {
//   int _selectedIndex = 0;
//
//   // Navigation Bar Screens
//   final List<Widget> _screens = [
//     MyActivityScreenContent(), // Main Activity Screen
//     ReportScreen(),
//     RemindersScreen(),
//     ProfileScreen(),
//   ];
//
//   void _onTabTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[_selectedIndex], // Show selected screen
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onTabTapped,
//         selectedItemColor: Colors.lightBlue, // Highlight selected tab
//         unselectedItemColor: Colors.grey,
//         showUnselectedLabels: true,
//         items: [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "My activity"),
//           BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Reports"),
//           BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Reminders"),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
//         ],
//       ),
//     );
//   }
// }
//
// // Separate Widget for My Activity Screen Content
// class MyActivityScreenContent extends StatefulWidget {
//   @override
//   _MyActivityScreenContentState createState() => _MyActivityScreenContentState();
// }
//
// class _MyActivityScreenContentState extends State<MyActivityScreenContent> {
//   List<Map<String, dynamic>> logHistory = [];
//
//   void _deleteLogEntry(int index) {
//     setState(() {
//       logHistory.removeAt(index);
//     });
//   }
//
//   void _navigateToLogEntryScreen() async {
//     final newLogEntry = await Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => LogEntryScreen()),
//     );
//
//     if (newLogEntry != null) {
//       setState(() {
//         logHistory.add(newLogEntry);
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("My Activity", style: TextStyle(fontWeight: FontWeight.bold)),
//         backgroundColor: Colors.lightBlue[300],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Blood Glucose Graph
//             Card(
//               color: Color(0xFFC5EDFF),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//               elevation: 5,
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("Blood Glucose Level (mg/dL)",
//                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                     SizedBox(height: 10),
//                     Container(
//                       height: 200,
//                       child: LineChart(
//                         LineChartData(
//                           gridData: FlGridData(show: true),
//                           titlesData: FlTitlesData(show: true),
//                           borderData: FlBorderData(show: false),
//                           lineBarsData: [
//                             LineChartBarData(
//                               spots: logHistory.isNotEmpty
//                                   ? logHistory.asMap().entries.map((entry) {
//                                 return FlSpot(entry.key.toDouble(), entry.value['bloodSugar']);
//                               }).toList()
//                                   : [FlSpot(0, 0)],
//                               isCurved: true,
//                               color: Color(0xFF5EB7CF),
//                               barWidth: 4,
//                               belowBarData: BarAreaData(show: false),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             // Today's Summary
//             Center(
//               child: Column(
//                 children: [
//                   Text("Today", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                   Text("-- -- ----", style: TextStyle(fontSize: 16, color: Colors.grey)),
//                   SizedBox(height: 10),
//                   CircleAvatar(
//                     radius: 40,
//                     backgroundColor: Colors.blue[100],
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           logHistory.isNotEmpty
//                               ? "${logHistory.last['bloodSugar']} mg/dL"
//                               : "---",
//                           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                         ),
//                         Text("Average", style: TextStyle(fontSize: 14, color: Colors.grey)),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   TextButton(
//                     onPressed: () {},
//                     child: Text("See more >", style: TextStyle(color: Colors.blue)),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 10),
//             // Log History
//             Expanded(
//               child: logHistory.isEmpty
//                   ? Center(
//                 child: Text("No log entries yet.", style: TextStyle(color: Colors.grey)),
//               )
//                   : ListView.builder(
//                 itemCount: logHistory.length,
//                 itemBuilder: (context, index) {
//                   final log = logHistory[index];
//                   return Card(
//                     margin: EdgeInsets.symmetric(vertical: 5),
//                     child: ExpansionTile(
//                       title: Text("${log['date']}"),
//                       children: [
//                         ListTile(
//                           title: Text("Time: ${log['time']}"),
//                           subtitle: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text("Blood Sugar: ${log['bloodSugar']} mg/dL"),
//                               Text("Pills: ${log['pills']}"),
//                               Text("Blood Pressure: ${log['bloodPressure']} mmHg"),
//                               Text("Body Weight: ${log['bodyWeight']} kg"),
//                               Text("Food: ${log['foodType']}"),
//                             ],
//                           ),
//                           trailing: IconButton(
//                             icon: Icon(Icons.delete, color: Colors.red),
//                             onPressed: () => _deleteLogEntry(index),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Color(0xFF5FB8DD),
//         onPressed: _navigateToLogEntryScreen,
//         child: Icon(Icons.add, color: Colors.white),
//       ),
//     );
//   }
// }
