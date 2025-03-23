// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'dart:math';
//
//
// import '../LogDetails/LogInterface.dart';
// import '../Reminders.dart';
// import '../Report/Reports.dart';
// import '../profile/Profile.dart';
// import 'weekly_stats_screen.dart';
//
// class MyActivityScreen extends StatefulWidget {
//   const MyActivityScreen({Key? key}) : super(key: key);
//
//   @override
//   _MyActivityScreenState createState() => _MyActivityScreenState();
// }
//
// class _MyActivityScreenState extends State<MyActivityScreen> {
//   int _selectedIndex = 0;
//   final ScrollController _scrollController = ScrollController();
//   final PageController _statsPageController = PageController();
//
//   // Colors from the provided palette
//   final Color _primaryColor = const Color(0xFF89D0ED); // Medium blue
//   final Color _accentColor = const Color(0xFF5FB8DD);  // Medium-bright blue
//   final Color _lightColor = const Color(0xFFAEECFF);   // Light blue
//   final Color _veryLightColor = const Color(0xFFC5EDFF); // Very light blue
//   final Color _tealColor = const Color(0xFF5EB7CF);    // Blue-teal
//   final Color _textColor = const Color(0xFF2C3E50);    // Dark blue-gray
//
//   // Log data
//   List<Map<String, dynamic>> _logEntries = [];
//   Map<String, List<Map<String, dynamic>>> _groupedByDate = {};
//   double _todayAverage = 0;
//   bool _isLoading = true;
//
//   bool _isSearching = false;
//   String _searchQuery = '';
//   final TextEditingController _searchController = TextEditingController();
//   List<Map<String, dynamic>> _filteredLogEntries = [];
//
//   // Expanded sections
//   Set<String> _expandedSections = {'Today'};
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchLogEntries();
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     _statsPageController.dispose();
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   // Fetch log entries from Firestore
//   Future<void> _fetchLogEntries() async {
//     setState(() {
//       _isLoading = true;
//     });
//
//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null) {
//         setState(() {
//           _isLoading = false;
//         });
//         return;
//       }
//
//       final snapshot = await FirebaseFirestore.instance
//           .collection('logEntries')
//           .where('userId', isEqualTo: user.uid)
//           .orderBy('date', descending: true)
//           .get();
//
//       final entries = snapshot.docs.map((doc) {
//         final data = doc.data();
//         data['id'] = doc.id;
//         return data;
//       }).toList();
//
//       // Group entries by date
//       final grouped = <String, List<Map<String, dynamic>>>{};
//       double todaySum = 0;
//       int todayCount = 0;
//
//       final today = DateTime.now();
//       final todayString = DateFormat('yyyy-MM-dd').format(today);
//
//       for (var entry in entries) {
//         final date = (entry['date'] as Timestamp).toDate();
//         final dateString = DateFormat('yyyy-MM-dd').format(date);
//
//         if (!grouped.containsKey(dateString)) {
//           grouped[dateString] = [];
//         }
//
//         grouped[dateString]!.add(entry);
//
//         // Calculate today's average
//         if (dateString == todayString && entry['bloodSugar'] != null) {
//           todaySum += entry['bloodSugar'];
//           todayCount++;
//         }
//       }
//
//       setState(() {
//         _logEntries = entries;
//         _filteredLogEntries = entries; // Initialize filtered entries
//         _groupedByDate = grouped;
//         _todayAverage = todayCount > 0 ? todaySum / todayCount : 0;
//         _isLoading = false;
//       });
//     } catch (e) {
//       print('Error fetching log entries: $e');
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   // Navigate to log entry screen
//   void _navigateToLogEntry({Map<String, dynamic>? logEntry}) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => LogEntryScreen(logEntry: logEntry),
//       ),
//     ).then((_) {
//       // Refresh data when returning from log entry screen
//       _fetchLogEntries();
//     });
//   }
//
//   // Delete log entry
//   Future<void> _deleteLogEntry(String id) async {
//     try {
//       await FirebaseFirestore.instance.collection('logEntries').doc(id).delete();
//       // Refresh the data after deletion
//       _fetchLogEntries();
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             'Log entry deleted successfully',
//             style: TextStyle(
//               fontFamily: GoogleFonts.poppins().fontFamily,
//             ),
//           ),
//           backgroundColor: Colors.green,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           margin: const EdgeInsets.all(10),
//         ),
//       );
//     } catch (e) {
//       print('Error deleting log entry: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             'Error deleting log entry: $e',
//             style: TextStyle(
//               fontFamily: GoogleFonts.poppins().fontFamily,
//             ),
//           ),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           margin: const EdgeInsets.all(10),
//         ),
//       );
//     }
//   }
//
//   // Toggle section expansion
//   void _toggleSection(String date) {
//     setState(() {
//       if (_expandedSections.contains(date)) {
//         _expandedSections.remove(date);
//       } else {
//         _expandedSections.add(date);
//       }
//     });
//   }
//
//   // Format date for display
//   String _formatDate(String dateString) {
//     if (dateString == DateFormat('yyyy-MM-dd').format(DateTime.now())) {
//       return 'Today';
//     } else if (dateString == DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 1)))) {
//       return 'Yesterday';
//     } else {
//       final date = DateFormat('yyyy-MM-dd').parse(dateString);
//       return DateFormat('EEEE d MMMM yyyy').format(date);
//     }
//   }
//
//   // Navigate to weekly stats
//   void _navigateToWeeklyStats() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => WeeklyStatsScreen(
//           logEntries: _logEntries,
//           primaryColor: _primaryColor,
//           accentColor: _accentColor,
//           lightColor: _lightColor,
//           veryLightColor: _veryLightColor,
//           tealColor: _tealColor,
//           textColor: _textColor,
//         ),
//       ),
//     );
//   }
//
//   // Build the stats graph
//   Widget _buildStatsGraph() {
//     // Filter entries for today
//     final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
//     final todayEntries = _groupedByDate[today] ?? [];
//
//     // Sort by time
//     todayEntries.sort((a, b) {
//       final aTime = (a['date'] as Timestamp).toDate();
//       final bTime = (b['date'] as Timestamp).toDate();
//       return aTime.compareTo(bTime);
//     });
//
//     // Create spots for the line chart
//     final spots = <FlSpot>[];
//     for (var entry in todayEntries) {
//       if (entry['bloodSugar'] != null) {
//         final time = (entry['date'] as Timestamp).toDate();
//         final hour = time.hour + (time.minute / 60);
//         spots.add(FlSpot(hour, entry['bloodSugar'].toDouble()));
//       }
//     }
//
//     return Container(
//       height: 200,
//       padding: const EdgeInsets.only(top: 16, right: 16, left: 8),
//       child: spots.isEmpty
//           ? Center(
//         child: Text(
//           'No blood sugar data for today',
//           style: TextStyle(
//             fontFamily: GoogleFonts.poppins().fontFamily,
//             color: _textColor.withAlpha(178),
//             fontSize: 14,
//           ),
//         ),
//       )
//           : LineChart(
//         LineChartData(
//           gridData: FlGridData(
//             show: true,
//             drawVerticalLine: true,
//             drawHorizontalLine: true,
//             horizontalInterval: 50,
//             verticalInterval: 4,
//             getDrawingHorizontalLine: (value) {
//               // Highlight high and low glucose levels
//               if (value == 180) { // High glucose level
//                 return FlLine(
//                   color: Colors.red.withAlpha(76),
//                   strokeWidth: 1,
//                   dashArray: [5, 5],
//                 );
//               } else if (value == 70) { // Low glucose level
//                 return FlLine(
//                   color: Colors.orange.withAlpha(76),
//                   strokeWidth: 1,
//                   dashArray: [5, 5],
//                 );
//               }
//               return FlLine(
//                 color: Colors.grey.withAlpha(51),
//                 strokeWidth: 0.5,
//               );
//             },
//             getDrawingVerticalLine: (value) {
//               return FlLine(
//                 color: Colors.grey.withAlpha(51),
//                 strokeWidth: 0.5,
//               );
//             },
//           ),
//           titlesData: FlTitlesData(
//             show: true,
//             rightTitles: AxisTitles(
//               sideTitles: SideTitles(showTitles: false),
//             ),
//             topTitles: AxisTitles(
//               sideTitles: SideTitles(showTitles: false),
//             ),
//             bottomTitles: AxisTitles(
//               sideTitles: SideTitles(
//                 showTitles: true,
//                 reservedSize: 30,
//                 interval: 4,
//                 getTitlesWidget: (value, meta) {
//                   String text = '';
//                   if (value == 0) {
//                     text = '00:00';
//                   } else if (value == 4) {
//                     text = '04:00';
//                   } else if (value == 8) {
//                     text = '08:00';
//                   } else if (value == 12) {
//                     text = '12:00';
//                   } else if (value == 16) {
//                     text = '16:00';
//                   } else if (value == 20) {
//                     text = '20:00';
//                   } else if (value == 24) {
//                     text = '24:00';
//                   }
//                   return Padding(
//                     padding: const EdgeInsets.only(top: 8.0),
//                     child: Text(
//                       text,
//                       style: TextStyle(
//                         fontFamily: GoogleFonts.poppins().fontFamily,
//                         color: _textColor.withAlpha(178),
//                         fontSize: 10,
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             leftTitles: AxisTitles(
//               sideTitles: SideTitles(
//                 showTitles: true,
//                 interval: 50,
//                 getTitlesWidget: (value, meta) {
//                   return Text(
//                     value.toInt().toString(),
//                     style: TextStyle(
//                       fontFamily: GoogleFonts.poppins().fontFamily,
//                       color: _textColor.withAlpha(178),
//                       fontSize: 10,
//                     ),
//                   );
//                 },
//                 reservedSize: 40,
//               ),
//             ),
//           ),
//           borderData: FlBorderData(
//             show: true,
//             border: Border(
//               bottom: BorderSide(color: Colors.grey.withAlpha(51)),
//               left: BorderSide(color: Colors.grey.withAlpha(51)),
//             ),
//           ),
//           minX: 0,
//           maxX: 24,
//           minY: spots.isEmpty ? 0 : max(0, spots.map((e) => e.y).reduce(min) - 20),
//           maxY: spots.isEmpty ? 200 : spots.map((e) => e.y).reduce(max) + 20,
//           lineBarsData: [
//             LineChartBarData(
//               spots: spots,
//               isCurved: true,
//               color: _accentColor,
//               barWidth: 3,
//               isStrokeCapRound: true,
//               dotData: FlDotData(
//                 show: true,
//                 getDotPainter: (spot, percent, barData, index) {
//                   return FlDotCirclePainter(
//                     radius: 4,
//                     color: _accentColor,
//                     strokeWidth: 2,
//                     strokeColor: Colors.white,
//                   );
//                 },
//               ),
//               belowBarData: BarAreaData(
//                 show: true,
//                 color: _accentColor.withAlpha(50),
//               ),
//             ),
//           ],
//           lineTouchData: LineTouchData(
//             touchTooltipData: LineTouchTooltipData(
//               getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
//                 return touchedBarSpots.map((barSpot) {
//                   final hour = barSpot.x.toInt();
//                   final minute = ((barSpot.x - hour) * 60).toInt();
//                   final timeStr = '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
//                   return LineTooltipItem(
//                     '${barSpot.y.toStringAsFixed(1)} mg/dL\n$timeStr',
//                     TextStyle(
//                       fontFamily: GoogleFonts.poppins().fontFamily,
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       backgroundColor: _textColor.withAlpha(200),
//                     ),
//                   );
//                 }).toList();
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Build the average circle
//   Widget _buildAverageCircle(double average) {
//     return Container(
//       width: 120,
//       height: 120,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: _lightColor,
//         border: Border.all(
//           color: _accentColor.withAlpha(76),
//           width: 2,
//         ),
//       ),
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               average > 0 ? average.toStringAsFixed(1) : '---',
//               style: TextStyle(
//                 fontFamily: GoogleFonts.poppins().fontFamily,
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: _textColor,
//               ),
//             ),
//             Text(
//               'mg/dL',
//               style: TextStyle(
//                 fontFamily: GoogleFonts.poppins().fontFamily,
//                 fontSize: 14,
//                 color: _textColor.withAlpha(178),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Build a log entry item
//   Widget _buildLogEntryItem(Map<String, dynamic> entry) {
//     final time = (entry['date'] as Timestamp).toDate();
//     final timeStr = DateFormat('HH:mm').format(time);
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withAlpha(13),
//             blurRadius: 2,
//             offset: const Offset(0, 1),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 timeStr,
//                 style: TextStyle(
//                   fontFamily: GoogleFonts.poppins().fontFamily,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: _textColor,
//                 ),
//               ),
//               Row(
//                 children: [
//                   if (entry['bloodSugar'] != null)
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: _lightColor,
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                       child: Text(
//                         '${entry['bloodSugar']} mg/dL',
//                         style: TextStyle(
//                           fontFamily: GoogleFonts.poppins().fontFamily,
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500,
//                           color: _textColor,
//                         ),
//                       ),
//                     ),
//                   const SizedBox(width: 8),
//                   // Edit button
//                   InkWell(
//                     onTap: () => _navigateToLogEntry(logEntry: entry),
//                     child: Container(
//                       padding: const EdgeInsets.all(6),
//                       decoration: BoxDecoration(
//                         color: _veryLightColor,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Icon(
//                         Icons.edit,
//                         size: 16,
//                         color: _tealColor,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   // Delete button
//                   InkWell(
//                     onTap: () => _showDeleteConfirmation(entry['id']),
//                     child: Container(
//                       padding: const EdgeInsets.all(6),
//                       decoration: BoxDecoration(
//                         color: Colors.red.withAlpha(26),
//                         shape: BoxShape.circle,
//                       ),
//                       child: Icon(
//                         Icons.delete,
//                         size: 16,
//                         color: Colors.red[400],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           if (entry['bloodPressure'] != null ||
//               entry['bodyWeight'] != null ||
//               entry['pills'] != null)
//             Padding(
//               padding: const EdgeInsets.only(top: 8),
//               child: Wrap(
//                 spacing: 8,
//                 runSpacing: 8,
//                 children: [
//                   if (entry['bloodPressure'] != null)
//                     _buildInfoChip('${entry['bloodPressure']} mmHg'),
//                   if (entry['bodyWeight'] != null)
//                     _buildInfoChip('${entry['bodyWeight']} kg'),
//                   if (entry['pills'] != null) _buildInfoChip(entry['pills']),
//                 ],
//               ),
//             ),
//           if (entry['trackingMoment'] != null || entry['foodType'] != null)
//             Padding(
//               padding: const EdgeInsets.only(top: 8),
//               child: Row(
//                 children: [
//                   if (entry['trackingMoment'] != null)
//                     Text(
//                       entry['trackingMoment'],
//                       style: TextStyle(
//                         fontFamily: GoogleFonts.poppins().fontFamily,
//                         fontSize: 14,
//                         color: _textColor.withAlpha(178),
//                       ),
//                     ),
//                   if (entry['trackingMoment'] != null && entry['foodType'] != null)
//                     Text(
//                       ' • ',
//                       style: TextStyle(
//                         fontFamily: GoogleFonts.poppins().fontFamily,
//                         fontSize: 14,
//                         color: _textColor.withAlpha(178),
//                       ),
//                     ),
//                   if (entry['foodType'] != null)
//                     Text(
//                       entry['foodType'],
//                       style: TextStyle(
//                         fontFamily: GoogleFonts.poppins().fontFamily,
//                         fontSize: 14,
//                         color: _textColor.withAlpha(178),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   // Build info chip
//   Widget _buildInfoChip(String text) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: _veryLightColor,
//         borderRadius: BorderRadius.circular(4),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(
//           fontFamily: GoogleFonts.poppins().fontFamily,
//           fontSize: 12,
//           color: _textColor,
//         ),
//       ),
//     );
//   }
//
//   // Show delete confirmation dialog
//   Future<void> _showDeleteConfirmation(String id) async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Colors.white,
//           title: Text(
//             'Delete Log Entry',
//             style: TextStyle(
//               fontFamily: GoogleFonts.poppins().fontFamily,
//               fontWeight: FontWeight.bold,
//               color: _textColor,
//             ),
//           ),
//           content: Text(
//             'Are you sure you want to delete this log entry? This action cannot be undone.',
//             style: TextStyle(
//               fontFamily: GoogleFonts.poppins().fontFamily,
//               color: _textColor,
//             ),
//           ),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text(
//                 'Cancel',
//                 style: TextStyle(
//                   fontFamily: GoogleFonts.poppins().fontFamily,
//                   color: _accentColor,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             ElevatedButton(
//               child: Text(
//                 'Delete',
//                 style: TextStyle(
//                   fontFamily: GoogleFonts.poppins().fontFamily,
//                   color: Colors.white,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red[400],
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _deleteLogEntry(id);
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   // Filter log entries based on search query
//   void _filterLogEntries() {
//     if (_searchQuery.isEmpty) {
//       setState(() {
//         _filteredLogEntries = _logEntries;
//       });
//       return;
//     }
//
//     final query = _searchQuery.toLowerCase();
//     setState(() {
//       _filteredLogEntries = _logEntries.where((entry) {
//         // Search in blood sugar
//         if (entry['bloodSugar'] != null &&
//             entry['bloodSugar'].toString().contains(query)) {
//           return true;
//         }
//
//         // Search in pills
//         if (entry['pills'] != null &&
//             entry['pills'].toString().toLowerCase().contains(query)) {
//           return true;
//         }
//
//         // Search in blood pressure
//         if (entry['bloodPressure'] != null &&
//             entry['bloodPressure'].toString().toLowerCase().contains(query)) {
//           return true;
//         }
//
//         // Search in body weight
//         if (entry['bodyWeight'] != null &&
//             entry['bodyWeight'].toString().contains(query)) {
//           return true;
//         }
//
//         // Search in tracking moment
//         if (entry['trackingMoment'] != null &&
//             entry['trackingMoment'].toString().toLowerCase().contains(query)) {
//           return true;
//         }
//
//         // Search in food type
//         if (entry['foodType'] != null &&
//             entry['foodType'].toString().toLowerCase().contains(query)) {
//           return true;
//         }
//
//         // Search in date
//         final date = (entry['date'] as Timestamp).toDate();
//         final dateStr = DateFormat('yyyy-MM-dd HH:mm').format(date).toLowerCase();
//         if (dateStr.contains(query)) {
//           return true;
//         }
//
//         return false;
//       }).toList();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Navigation destinations
//     final destinations = [
//       NavigationDestination(
//         icon: Icon(Icons.home_outlined),
//         selectedIcon: Icon(Icons.home),
//         label: 'Activity',
//       ),
//       NavigationDestination(
//         icon: Icon(Icons.bar_chart_outlined),
//         selectedIcon: Icon(Icons.bar_chart),
//         label: 'Reports',
//       ),
//       NavigationDestination(
//         icon: Icon(Icons.notifications_outlined),
//         selectedIcon: Icon(Icons.notifications),
//         label: 'Reminders',
//       ),
//       NavigationDestination(
//         icon: Icon(Icons.person_outline),
//         selectedIcon: Icon(Icons.person),
//         label: 'Profile',
//       ),
//     ];
//
//     // Main content based on selected index
//     Widget mainContent;
//     switch (_selectedIndex) {
//       case 0:
//         mainContent = _buildMyActivityContent();
//         break;
//       case 1:
//         mainContent = ReportScreen();
//         break;
//       case 2:
//         mainContent = RemindersScreen();
//         break;
//       case 3:
//         mainContent = ProfileScreen();
//         break;
//       default:
//         mainContent = _buildMyActivityContent();
//     }
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: mainContent,
//       bottomNavigationBar: NavigationBar(
//         backgroundColor: Colors.white,
//         indicatorColor: _lightColor,
//         selectedIndex: _selectedIndex,
//         onDestinationSelected: (int index) {
//           setState(() {
//             _selectedIndex = index;
//           });
//         },
//         destinations: destinations,
//         labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
//       ),
//       floatingActionButton: _selectedIndex == 0
//           ? FloatingActionButton(
//         onPressed: () => _navigateToLogEntry(),
//         backgroundColor: _accentColor,
//         child: const Icon(Icons.add, color: Colors.white),
//       )
//           : null,
//       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//     );
//   }
//
//   // Build search results
//   Widget _buildSearchResults() {
//     if (_filteredLogEntries.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.search_off,
//               size: 48,
//               color: _accentColor.withAlpha(128),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'No results found',
//               style: TextStyle(
//                 fontFamily: GoogleFonts.poppins().fontFamily,
//                 fontSize: 16,
//                 color: _textColor.withAlpha(178),
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Try a different search term',
//               style: TextStyle(
//                 fontFamily: GoogleFonts.poppins().fontFamily,
//                 fontSize: 14,
//                 color: _textColor.withAlpha(128),
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//
//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: _filteredLogEntries.length,
//       itemBuilder: (context, index) {
//         final entry = _filteredLogEntries[index];
//         final date = (entry['date'] as Timestamp).toDate();
//         final dateStr = DateFormat('EEEE d MMMM yyyy').format(date);
//
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (index == 0 ||
//                 DateFormat('yyyy-MM-dd').format(date) !=
//                     DateFormat('yyyy-MM-dd').format((
//                         _filteredLogEntries[index - 1]['date'] as Timestamp).toDate()))
//               Padding(
//                 padding: EdgeInsets.only(bottom: 8, top: index > 0 ? 16 : 0),
//                 child: Text(
//                   dateStr,
//                   style: TextStyle(
//                     fontFamily: GoogleFonts.poppins().fontFamily,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: _textColor,
//                   ),
//                 ),
//               ),
//             _buildLogEntryItem(entry),
//             if (index == _filteredLogEntries.length - 1)
//               const SizedBox(height: 16),
//           ],
//         );
//       },
//     );
//   }
//
//   // Build My Activity content
//   Widget _buildMyActivityContent() {
//     return SafeArea(
//       child: Column(
//         children: [
//           // App bar with search functionality
//           Container(
//             padding: const EdgeInsets.symmetric(vertical: 8),
//             color: _primaryColor,
//             child: _isSearching
//                 ? Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _searchController,
//                       autofocus: true,
//                       decoration: InputDecoration(
//                         hintText: 'Search logs...',
//                         hintStyle: TextStyle(
//                           fontFamily: GoogleFonts.poppins().fontFamily,
//                           color: Colors.black54,
//                         ),
//                         border: InputBorder.none,
//                         prefixIcon: Icon(Icons.search, color: Colors.black87),
//                       ),
//                       style: TextStyle(
//                         fontFamily: GoogleFonts.poppins().fontFamily,
//                         fontSize: 16,
//                         color: Colors.black87,
//                       ),
//                       onChanged: (value) {
//                         setState(() {
//                           _searchQuery = value;
//                         });
//                         _filterLogEntries();
//                       },
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.close, color: Colors.black87),
//                     onPressed: () {
//                       setState(() {
//                         _isSearching = false;
//                         _searchQuery = '';
//                         _searchController.clear();
//                       });
//                       _filterLogEntries();
//                     },
//                   ),
//                 ],
//               ),
//             )
//                 : Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'My Activity',
//                     style: TextStyle(
//                       fontFamily: GoogleFonts.poppins().fontFamily,
//                       fontSize: 22,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.search, color: Colors.black87),
//                     onPressed: () {
//                       setState(() {
//                         _isSearching = true;
//                       });
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           // Stats section (fixed during scroll)
//           Container(
//             color: Colors.white,
//             child: Column(
//               children: [
//                 // Stats graph
//                 _buildStatsGraph(),
//
//                 // Today's average and See More button
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   child: Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Today',
//                             style: TextStyle(
//                               fontFamily: GoogleFonts.poppins().fontFamily,
//                               fontSize: 18,
//                               fontWeight: FontWeight.w600,
//                               color: _textColor,
//                             ),
//                           ),
//                           TextButton(
//                             onPressed: _navigateToWeeklyStats,
//                             child: Text(
//                               'See more >',
//                               style: TextStyle(
//                                 fontFamily: GoogleFonts.poppins().fontFamily,
//                                 fontSize: 14,
//                                 color: _accentColor,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       Center(
//                         child: Column(
//                           children: [
//                             _buildAverageCircle(_todayAverage),
//                             const SizedBox(height: 4),
//                             Text(
//                               'Average',
//                               style: TextStyle(
//                                 fontFamily: GoogleFonts.poppins().fontFamily,
//                                 fontSize: 14,
//                                 color: _textColor.withAlpha(178),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 // Divider
//                 Divider(height: 1, color: Colors.grey[200]),
//               ],
//             ),
//           ),
//
//           // Log entries (scrollable)
//           Expanded(
//             child: _isLoading
//                 ? Center(
//               child: CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(_accentColor),
//               ),
//             )
//                 : _isSearching
//                 ? _buildSearchResults()
//                 : _groupedByDate.isEmpty
//                 ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.note_alt_outlined,
//                     size: 48,
//                     color: _accentColor.withAlpha(128),
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     'No log entries yet',
//                     style: TextStyle(
//                       fontFamily: GoogleFonts.poppins().fontFamily,
//                       fontSize: 16,
//                       color: _textColor.withAlpha(178),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     'Tap the + button to add your first log',
//                     style: TextStyle(
//                       fontFamily: GoogleFonts.poppins().fontFamily,
//                       fontSize: 14,
//                       color: _textColor.withAlpha(128),
//                     ),
//                   ),
//                 ],
//               ),
//             )
//                 : ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: _groupedByDate.length,
//               itemBuilder: (context, index) {
//                 final date = _groupedByDate.keys.elementAt(index);
//                 final entries = _groupedByDate[date]!;
//                 final formattedDate = _formatDate(date);
//                 final isExpanded = _expandedSections.contains(formattedDate);
//
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Date header with expand/collapse
//                     InkWell(
//                       onTap: () => _toggleSection(formattedDate),
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               formattedDate,
//                               style: TextStyle(
//                                 fontFamily: GoogleFonts.poppins().fontFamily,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                                 color: _textColor,
//                               ),
//                             ),
//                             Icon(
//                               isExpanded
//                                   ? Icons.keyboard_arrow_up
//                                   : Icons.keyboard_arrow_down,
//                               color: _accentColor,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//
//                     // Log entries for this date
//                     if (isExpanded)
//                       ...entries.map((entry) => _buildLogEntryItem(entry)).toList(),
//
//                     // Divider
//                     Divider(height: 16, color: Colors.grey[200]),
//                   ],
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mybete_app/have_diabetes/DashBoard/profile/Profile.dart';
import 'dart:math';

import '../LogDetails/LogInterface.dart';
import '../Reminder/Reminders.dart';
import '../Report/Reports.dart';
import 'weekly_stats_screen.dart';


class MyActivityScreen extends StatefulWidget {
  const MyActivityScreen({Key? key}) : super(key: key);

  @override
  _MyActivityScreenState createState() => _MyActivityScreenState();
}

class _MyActivityScreenState extends State<MyActivityScreen> {
  int _selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();
  final PageController _statsPageController = PageController();

  // Colors from the provided palette
  final Color _primaryColor = const Color(0xFF89D0ED); // Medium blue
  final Color _accentColor = const Color(0xFF5FB8DD);  // Medium-bright blue
  final Color _lightColor = const Color(0xFFAEECFF);   // Light blue
  final Color _veryLightColor = const Color(0xFFC5EDFF); // Very light blue
  final Color _tealColor = const Color(0xFF5EB7CF);    // Blue-teal
  final Color _textColor = const Color(0xFF2C3E50);    // Dark blue-gray

  // Log data
  List<Map<String, dynamic>> _logEntries = [];
  Map<String, List<Map<String, dynamic>>> _groupedByDate = {};
  double _todayAverage = 0;
  bool _isLoading = true;

  bool _isSearching = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredLogEntries = [];

  // Expanded sections
  Set<String> _expandedSections = {'Today'};

  @override
  void initState() {
    super.initState();
    _fetchLogEntries();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _statsPageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Fetch log entries from Firestore
  Future<void> _fetchLogEntries() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final snapshot = await FirebaseFirestore.instance
          .collection('logEntries')
          .where('userId', isEqualTo: user.uid)
          .orderBy('date', descending: true)
          .get();

      final entries = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();

      // Group entries by date
      final grouped = <String, List<Map<String, dynamic>>>{};
      double todaySum = 0;
      int todayCount = 0;

      final today = DateTime.now();
      final todayString = DateFormat('yyyy-MM-dd').format(today);

      for (var entry in entries) {
        final date = (entry['date'] as Timestamp).toDate();
        final dateString = DateFormat('yyyy-MM-dd').format(date);

        if (!grouped.containsKey(dateString)) {
          grouped[dateString] = [];
        }

        grouped[dateString]!.add(entry);

        // Calculate today's average
        if (dateString == todayString && entry['bloodSugar'] != null) {
          todaySum += entry['bloodSugar'];
          todayCount++;
        }
      }

      setState(() {
        _logEntries = entries;
        _filteredLogEntries = entries; // Initialize filtered entries
        _groupedByDate = grouped;
        _todayAverage = todayCount > 0 ? todaySum / todayCount : 0;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching log entries: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Navigate to log entry screen
  void _navigateToLogEntry({Map<String, dynamic>? logEntry}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LogEntryScreen(logEntry: logEntry),
      ),
    ).then((_) {
      // Refresh data when returning from log entry screen
      _fetchLogEntries();
    });
  }

  // Delete log entry
  Future<void> _deleteLogEntry(String id) async {
    try {
      await FirebaseFirestore.instance.collection('logEntries').doc(id).delete();
      // Refresh the data after deletion
      _fetchLogEntries();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Log entry deleted successfully',
            style: TextStyle(
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(10),
        ),
      );
    } catch (e) {
      print('Error deleting log entry: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error deleting log entry: $e',
            style: TextStyle(
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(10),
        ),
      );
    }
  }

  // Toggle section expansion
  void _toggleSection(String date) {
    setState(() {
      if (_expandedSections.contains(date)) {
        _expandedSections.remove(date);
      } else {
        _expandedSections.add(date);
      }
    });
  }

  // Format date for display
  String _formatDate(String dateString) {
    if (dateString == DateFormat('yyyy-MM-dd').format(DateTime.now())) {
      return 'Today';
    } else if (dateString == DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 1)))) {
      return 'Yesterday';
    } else {
      final date = DateFormat('yyyy-MM-dd').parse(dateString);
      return DateFormat('EEEE d MMMM yyyy').format(date);
    }
  }

  // Navigate to weekly stats
  void _navigateToWeeklyStats() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WeeklyStatsScreen(
          logEntries: _logEntries,
          primaryColor: _primaryColor,
          accentColor: _accentColor,
          lightColor: _lightColor,
          veryLightColor: _veryLightColor,
          tealColor: _tealColor,
          textColor: _textColor,
        ),
      ),
    );
  }

  // Build the stats graph
  Widget _buildStatsGraph() {
    // Filter entries for today
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final todayEntries = _groupedByDate[today] ?? [];

    // Sort by time
    todayEntries.sort((a, b) {
      final aTime = (a['date'] as Timestamp).toDate();
      final bTime = (b['date'] as Timestamp).toDate();
      return aTime.compareTo(bTime);
    });

    // Create spots for the line chart
    final spots = <FlSpot>[];
    for (var entry in todayEntries) {
      if (entry['bloodSugar'] != null) {
        final time = (entry['date'] as Timestamp).toDate();
        final hour = time.hour + (time.minute / 60);
        spots.add(FlSpot(hour, entry['bloodSugar'].toDouble()));
      }
    }

    return Container(
      height: 300,
      padding: const EdgeInsets.only(top: 16, right: 16, left: 8),
      child: spots.isEmpty
          ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Blood Glucose Level (mg/dL)',
            style: TextStyle(
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontSize: 12,
              color: _textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  drawHorizontalLine: true,
                  horizontalInterval: 80,
                  verticalInterval: 3,
                  getDrawingHorizontalLine: (value) {
                    if (value == 160) { // High glucose level
                      return FlLine(
                        color: Colors.red.withAlpha(100),
                        strokeWidth: 1,
                      );
                    } else if (value == 80) { // Low glucose level
                      return FlLine(
                        color: Colors.blue.withAlpha(100),
                        strokeWidth: 1,
                      );
                    }
                    return FlLine(
                      color: Colors.grey.withAlpha(30),
                      strokeWidth: 0.5,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withAlpha(30),
                      strokeWidth: 0.5,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    axisNameWidget: Text(
                      'Time of Day (hours)',
                      style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 12,
                        color: _textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    axisNameSize: 25,
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 3,
                      getTitlesWidget: (value, meta) {
                        String text = '';
                        if (value == 0) {
                          text = '00:00';
                        } else if (value == 3) {
                          text = '03:00';
                        } else if (value == 6) {
                          text = '06:00';
                        } else if (value == 9) {
                          text = '09:00';
                        } else if (value == 12) {
                          text = '12:00';
                        } else if (value == 15) {
                          text = '15:00';
                        } else if (value == 18) {
                          text = '18:00';
                        } else if (value == 21) {
                          text = '21:00';
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            text,
                            style: TextStyle(
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              color: _textColor.withAlpha(150),
                              fontSize: 10,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 80,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            color: _textColor.withAlpha(150),
                            fontSize: 10,
                          ),
                        );
                      },
                      reservedSize: 40,
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.withAlpha(50)),
                    left: BorderSide(color: Colors.grey.withAlpha(50)),
                  ),
                ),
                minX: 0,
                maxX: 24,
                minY: 0,
                maxY: 240,
                lineBarsData: [],
              ),
            ),
          ),
        ],
      )
          : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Blood Glucose Level (mg/dL)',
            style: TextStyle(
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontSize: 12,
              color: _textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  drawHorizontalLine: true,
                  horizontalInterval: 80,
                  verticalInterval: 3,
                  getDrawingHorizontalLine: (value) {
                    if (value == 160) { // High glucose level
                      return FlLine(
                        color: Colors.red.withAlpha(100),
                        strokeWidth: 1,
                      );
                    } else if (value == 80) { // Low glucose level
                      return FlLine(
                        color: Colors.blue.withAlpha(100),
                        strokeWidth: 1,
                      );
                    }
                    return FlLine(
                      color: Colors.grey.withAlpha(30),
                      strokeWidth: 0.5,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withAlpha(30),
                      strokeWidth: 0.5,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    axisNameWidget: Text(
                      'Time of Day (hours)',
                      style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 12,
                        color: _textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    axisNameSize: 25,
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 3,
                      getTitlesWidget: (value, meta) {
                        String text = '';
                        if (value == 0) {
                          text = '00:00';
                        } else if (value == 3) {
                          text = '03:00';
                        } else if (value == 6) {
                          text = '06:00';
                        } else if (value == 9) {
                          text = '09:00';
                        } else if (value == 12) {
                          text = '12:00';
                        } else if (value == 15) {
                          text = '15:00';
                        } else if (value == 18) {
                          text = '18:00';
                        } else if (value == 21) {
                          text = '21:00';
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            text,
                            style: TextStyle(
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              color: _textColor.withAlpha(150),
                              fontSize: 10,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 80,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            color: _textColor.withAlpha(150),
                            fontSize: 10,
                          ),
                        );
                      },
                      reservedSize: 40,
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.withAlpha(50)),
                    left: BorderSide(color: Colors.grey.withAlpha(50)),
                  ),
                ),
                minX: 0,
                maxX: 24,
                minY: 0,
                maxY: 240,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: _accentColor,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 5,
                          color: _accentColor,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: _accentColor.withAlpha(30),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                      return touchedBarSpots.map((barSpot) {
                        final hour = barSpot.x.toInt();
                        final minute = ((barSpot.x - hour) * 60).toInt();
                        final timeStr = '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
                        return LineTooltipItem(
                          '${barSpot.y.toStringAsFixed(1)} mg/dL\n$timeStr',
                          TextStyle(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build the average circle
  Widget _buildAverageCircle(double average) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _lightColor,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              average > 0 ? average.toStringAsFixed(1) : '---',
              style: TextStyle(
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _textColor,
              ),
            ),
            Text(
              'mg/dL',
              style: TextStyle(
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontSize: 14,
                color: _textColor.withAlpha(178),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build a log entry item
  Widget _buildLogEntryItem(Map<String, dynamic> entry) {
    final time = (entry['date'] as Timestamp).toDate();
    final timeStr = DateFormat('HH:mm').format(time);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                timeStr,
                style: TextStyle(
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _textColor,
                ),
              ),
              Row(
                children: [
                  // Edit button
                  InkWell(
                    onTap: () => _navigateToLogEntry(logEntry: entry),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.edit,
                        size: 16,
                        color: _textColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Delete button
                  InkWell(
                    onTap: () => _showDeleteConfirmation(entry['id']),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.delete,
                        size: 16,
                        color: Colors.red[400],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Blood Sugar
          if (entry['bloodSugar'] != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Text(
                    '${entry['bloodSugar']} mg/dL',
                    style: TextStyle(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: _textColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Blood sugar',
                    style: TextStyle(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

          // Blood Pressure
          if (entry['bloodPressure'] != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  Text(
                    '${entry['bloodPressure']}',
                    style: TextStyle(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: _textColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Blood pressure',
                    style: TextStyle(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

          // Body Weight
          if (entry['bodyWeight'] != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  Text(
                    '${entry['bodyWeight']} kg',
                    style: TextStyle(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: _textColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Body weight',
                    style: TextStyle(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

          // Tracking Moment
          if (entry['trackingMoment'] != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Text(
                    '${entry['trackingMoment']}',
                    style: TextStyle(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: _textColor,
                    ),
                  ),
                  if (entry['mealTime'] != null)
                    Text(
                      ' (${entry['mealTime']})',
                      style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: _textColor,
                      ),
                    ),
                  const SizedBox(width: 4),
                  Text(
                    'Blood tracking moment',
                    style: TextStyle(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

          // Food Type
          if (entry['foodType'] != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  Text(
                    '${entry['foodType']}',
                    style: TextStyle(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: _textColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Food type',
                    style: TextStyle(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // Show delete confirmation dialog
  Future<void> _showDeleteConfirmation(String id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Delete Log Entry',
            style: TextStyle(
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.bold,
              color: _textColor,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this log entry? This action cannot be undone.',
            style: TextStyle(
              fontFamily: GoogleFonts.poppins().fontFamily,
              color: _textColor,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: _accentColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text(
                'Delete',
                style: TextStyle(
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteLogEntry(id);
              },
            ),
          ],
        );
      },
    );
  }

  // Filter log entries based on search query
  void _filterLogEntries() {
    if (_searchQuery.isEmpty) {
      setState(() {
        _filteredLogEntries = _logEntries;
      });
      return;
    }

    final query = _searchQuery.toLowerCase();
    setState(() {
      _filteredLogEntries = _logEntries.where((entry) {
        // Search in blood sugar
        if (entry['bloodSugar'] != null &&
            entry['bloodSugar'].toString().contains(query)) {
          return true;
        }

        // Search in pills
        if (entry['pills'] != null &&
            entry['pills'].toString().toLowerCase().contains(query)) {
          return true;
        }

        // Search in blood pressure
        if (entry['bloodPressure'] != null &&
            entry['bloodPressure'].toString().toLowerCase().contains(query)) {
          return true;
        }

        // Search in body weight
        if (entry['bodyWeight'] != null &&
            entry['bodyWeight'].toString().contains(query)) {
          return true;
        }

        // Search in tracking moment
        if (entry['trackingMoment'] != null &&
            entry['trackingMoment'].toString().toLowerCase().contains(query)) {
          return true;
        }

        // Search in food type
        if (entry['foodType'] != null &&
            entry['foodType'].toString().toLowerCase().contains(query)) {
          return true;
        }

        // Search in date
        final date = (entry['date'] as Timestamp).toDate();
        final dateStr = DateFormat('yyyy-MM-dd HH:mm').format(date).toLowerCase();
        if (dateStr.contains(query)) {
          return true;
        }

        return false;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Navigation destinations
    final destinations = [
      NavigationDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home),
        label: 'Activity',
      ),
      NavigationDestination(
        icon: Icon(Icons.bar_chart_outlined),
        selectedIcon: Icon(Icons.bar_chart),
        label: 'Reports',
      ),
      NavigationDestination(
        icon: Icon(Icons.notifications_outlined),
        selectedIcon: Icon(Icons.notifications),
        label: 'Reminders',
      ),
      NavigationDestination(
        icon: Icon(Icons.person_outline),
        selectedIcon: Icon(Icons.person),
        label: 'Profile',
      ),
    ];

    // Main content based on selected index
    Widget mainContent;
    switch (_selectedIndex) {
      case 0:
        mainContent = _buildMyActivityContent();
        break;
      case 1:
        mainContent = ReportScreen();
        break;
      case 2:
        mainContent = RemindersScreen();
        break;
      case 3:
        mainContent = ProfileScreen();
        break;
      default:
        mainContent = _buildMyActivityContent();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: mainContent,
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        indicatorColor: _lightColor,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: destinations,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
        onPressed: () => _navigateToLogEntry(),
        backgroundColor: _accentColor,
        child: const Icon(Icons.add, color: Colors.white),
      )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // Build search results
  Widget _buildSearchResults() {
    if (_filteredLogEntries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 48,
              color: _accentColor.withAlpha(128),
            ),
            const SizedBox(height: 16),
            Text(
              'No results found',
              style: TextStyle(
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontSize: 16,
                color: _textColor.withAlpha(178),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try a different search term',
              style: TextStyle(
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontSize: 14,
                color: _textColor.withAlpha(128),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredLogEntries.length,
      itemBuilder: (context, index) {
        final entry = _filteredLogEntries[index];
        final date = (entry['date'] as Timestamp).toDate();
        final dateStr = DateFormat('EEEE d MMMM yyyy').format(date);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (index == 0 ||
                DateFormat('yyyy-MM-dd').format(date) !=
                    DateFormat('yyyy-MM-dd').format((
                        _filteredLogEntries[index - 1]['date'] as Timestamp).toDate()))
              Padding(
                padding: EdgeInsets.only(bottom: 8, top: index > 0 ? 16 : 0),
                child: Text(
                  dateStr,
                  style: TextStyle(
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _textColor,
                  ),
                ),
              ),
            _buildLogEntryItem(entry),
            if (index == _filteredLogEntries.length - 1)
              const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  // Build My Activity content
  Widget _buildMyActivityContent() {
    return SafeArea(
      child: Column(
        children: [
          // App bar with search functionality
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            color: _primaryColor,
            child: _isSearching
                ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Search logs...',
                        hintStyle: TextStyle(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          color: Colors.black54,
                        ),
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search, color: Colors.black87),
                      ),
                      style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                        _filterLogEntries();
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black87),
                    onPressed: () {
                      setState(() {
                        _isSearching = false;
                        _searchQuery = '';
                        _searchController.clear();
                      });
                      _filterLogEntries();
                    },
                  ),
                ],
              ),
            )
                : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Activity',
                    style: TextStyle(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.black87),
                    onPressed: () {
                      setState(() {
                        _isSearching = true;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          // Stats section
          _buildStatsGraph(),

          // Today's average and See More button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Today',
                  style: TextStyle(
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: _textColor,
                  ),
                ),
                TextButton(
                  onPressed: _navigateToWeeklyStats,
                  child: Text(
                    'See more >',
                    style: TextStyle(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: 14,
                      color: _accentColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Average circle
          Center(
            child: Column(
              children: [
                _buildAverageCircle(_todayAverage),
                const SizedBox(height: 4),
                Text(
                  'Average',
                  style: TextStyle(
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontSize: 14,
                    color: _textColor.withAlpha(178),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Divider
          Divider(height: 1, color: Colors.grey[200]),

          // Log entries (scrollable)
          Expanded(
            child: _isLoading
                ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(_accentColor),
              ),
            )
                : _isSearching
                ? _buildSearchResults()
                : _groupedByDate.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.note_alt_outlined,
                    size: 48,
                    color: _accentColor.withAlpha(128),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No log entries yet',
                    style: TextStyle(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: 16,
                      color: _textColor.withAlpha(178),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the + button to add your first log',
                    style: TextStyle(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: 14,
                      color: _textColor.withAlpha(128),
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _groupedByDate.length,
              itemBuilder: (context, index) {
                final date = _groupedByDate.keys.elementAt(index);
                final entries = _groupedByDate[date]!;
                final formattedDate = _formatDate(date);
                final isExpanded = _expandedSections.contains(formattedDate);

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: _lightColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date header with expand/collapse
                      InkWell(
                        onTap: () => _toggleSection(formattedDate),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                formattedDate,
                                style: TextStyle(
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: _textColor,
                                ),
                              ),
                              Icon(
                                isExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: _accentColor,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Log entries for this date
                      if (isExpanded)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          child: Column(
                            children: entries.map((entry) => _buildLogEntryItem(entry)).toList(),
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
    );
  }
}

