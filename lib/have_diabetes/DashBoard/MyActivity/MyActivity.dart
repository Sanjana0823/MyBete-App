import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mybete_app/have_diabetes/DashBoard/profile/Profile.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';





import '../Reminder/Reminder_screen.dart';
import '../Report/report_screen.dart';
import 'LogDetails/LogInterface.dart';
import 'log_provider.dart';
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
  final ScrollController _statsScrollController = ScrollController();

  // Colors from the provided palette
  final Color _primaryColor = const Color(0xFF89D0ED); // Medium blue
  final Color _accentColor = const Color(0xFF5FB8DD);  // Medium-bright blue
  final Color _lightColor = const Color(0xFFAEECFF);   // Light blue
  final Color _veryLightColor = const Color(0xFFC5EDFF); // Very light blue
  final Color _tealColor = const Color(0xFF5EB7CF);    // Blue-teal
  final Color _textColor = const Color(0xFF2C3E50);    // Dark blue-gray

  bool _isSearching = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  List<LogEntry> _filteredLogEntries = [];

  // Expanded sections
  Set<String> _expandedSections = {'Today'};

  // Current day index for stats
  int _currentDayIndex = 0;
  List<String> _availableDays = [];

  // Loading state for delete operation
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    // Initialize log provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final logProvider = Provider.of<LogProvider>(context, listen: false);
        logProvider.fetchLogs().then((_) {
          _updateAvailableDays();
        });
      }
    });
  }

  void _updateAvailableDays() {
    if (!mounted) return;

    final logProvider = Provider.of<LogProvider>(context, listen: false);
    final groupedDates = logProvider.groupedByDate.keys.toList();
    groupedDates.sort((a, b) => b.compareTo(a)); // Sort in descending order

    setState(() {
      _availableDays = groupedDates;
      // Set current day to today or the most recent day with logs
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      _currentDayIndex = _availableDays.contains(today)
          ? _availableDays.indexOf(today)
          : (_availableDays.isNotEmpty ? 0 : -1);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _statsPageController.dispose();
    _statsScrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Navigate to log entry screen
  void _navigateToLogEntry({LogEntry? logEntry}) {
    // Convert LogEntry to Map<String, dynamic> if it exists
    final logEntryMap = logEntry != null ? logEntry.toFirestore() : null;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LogInterface(logEntry: logEntryMap),
      ),
    ).then((_) {
      print("Print ==> $_");
      // Refresh data when returning from log entry screen
      if (!mounted) {
        Provider.of<LogProvider>(context, listen: false).fetchLogs().then((_) {
          _updateAvailableDays();
        });
      }
    }).catchError((err) {
      print("Print ==> $err");
    });
  }

  // Delete log entry
  Future<void> _deleteLogEntry(String id) async {
    // Prevent multiple delete operations
    if (_isDeleting) return;

    setState(() {
      _isDeleting = true;
    });

    try {
      // Show a loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(_accentColor),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Deleting...',
                    style: TextStyle(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

      // Delete the log entry
      await Provider.of<LogProvider>(context, listen: false).deleteLog(id);

      // Close the loading dialog
      Navigator.of(context).pop();

      // Show success message
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

      // Update the UI immediately
      if (mounted) {
        setState(() {
          // This will trigger a rebuild with the updated data
        });
      }
    } catch (e) {
      // Close the loading dialog if it's open
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

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
    } finally {
      setState(() {
        _isDeleting = false;
      });
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

  void _navigateToWeeklyStats() {
    final logProvider = Provider.of<LogProvider>(context, listen: false);
    // Convert LogEntry objects to Maps
    final logEntriesMaps = logProvider.logs.map((log) => log.toFirestore()).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WeeklyStatsScreen(
          logEntries: logEntriesMaps,
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

  // Build the stats graph for a specific day
  Widget _buildDayStatsGraph(String day) {
    final logProvider = Provider.of<LogProvider>(context);
    final dayLogs = logProvider.groupedByDate[day] ?? [];

    // Sort by time
    dayLogs.sort((a, b) => a.date.compareTo(b.date));

    // Create spots for the line chart
    final spots = <FlSpot>[];
    for (var log in dayLogs) {
      if (log.bloodSugar != null) {
        final hour = log.date.hour + (log.date.minute / 60);
        spots.add(FlSpot(hour, log.bloodSugar!));
      }
    }

    // Format the day for display
    final displayDate = _formatDate(day);

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 300,
      padding: const EdgeInsets.only(top: 16, right: 16, left: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Blood Glucose Level (mg/dL) - $displayDate',
            style: TextStyle(
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontSize: 12,
              color: _textColor,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
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
                lineBarsData: spots.isEmpty
                    ? []
                    : [
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

  // Build the scrollable stats graph
  Widget _buildStatsGraph() {
    if (_availableDays.isEmpty) {
      return Container(
        height: 300,
        child: Center(
          child: Text(
            'No data available',
            style: TextStyle(
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontSize: 16,
              color: _textColor,
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        Container(
          height: 300,
          child: PageView.builder(
            controller: _statsPageController,
            itemCount: _availableDays.length,
            onPageChanged: (index) {
              setState(() {
                _currentDayIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return _buildDayStatsGraph(_availableDays[index]);
            },
          ),
        ),
        const SizedBox(height: 8),
        // Day navigation indicators
        if (_availableDays.length > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios, size: 16),
                onPressed: _currentDayIndex > 0
                    ? () {
                  _statsPageController.previousPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
                    : null,
                color: _currentDayIndex > 0 ? _accentColor : Colors.grey,
              ),
              Text(
                _availableDays.isNotEmpty && _currentDayIndex >= 0
                    ? _formatDate(_availableDays[_currentDayIndex])
                    : 'No Data',
                style: TextStyle(
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: _textColor,
                ),
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward_ios, size: 16),
                onPressed: _currentDayIndex < _availableDays.length - 1
                    ? () {
                  _statsPageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
                    : null,
                color: _currentDayIndex < _availableDays.length - 1
                    ? _accentColor
                    : Colors.grey,
              ),
            ],
          ),
      ],
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
  Widget _buildLogEntryItem(LogEntry log) {
    final timeStr = DateFormat('HH:mm').format(log.date);

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
                    onTap: () => _navigateToLogEntry(logEntry: log),
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
                    onTap: () => _showDeleteConfirmation(log.id!),
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
          if (log.bloodSugar != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Text(
                    '${log.bloodSugar} mg/dL',
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
          if (log.bloodPressure != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  Text(
                    '${log.bloodPressure}',
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
          if (log.bodyWeight != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  Text(
                    '${log.bodyWeight} kg',
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
          if (log.trackingMoment != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Text(
                    '${log.trackingMoment}',
                    style: TextStyle(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: _textColor,
                    ),
                  ),
                  if (log.mealTime != null)
                    Text(
                      ' (${log.mealTime})',
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
          if (log.foodType != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  Text(
                    '${log.foodType}',
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
    if (!mounted) return;

    final logProvider = Provider.of<LogProvider>(context, listen: false);
    final logs = logProvider.logs;

    if (_searchQuery.isEmpty) {
      setState(() {
        _filteredLogEntries = logs;
      });
      return;
    }

    final query = _searchQuery.toLowerCase();
    final filtered = logs.where((log) {
      // Search in blood sugar
      if (log.bloodSugar != null &&
          log.bloodSugar.toString().contains(query)) {
        return true;
      }

      // Search in pills
      if (log.pills != null &&
          log.pills!.toLowerCase().contains(query)) {
        return true;
      }

      // Search in blood pressure
      if (log.bloodPressure != null &&
          log.bloodPressure!.toLowerCase().contains(query)) {
        return true;
      }

      // Search in body weight
      if (log.bodyWeight != null &&
          log.bodyWeight.toString().contains(query)) {
        return true;
      }

      // Search in tracking moment
      if (log.trackingMoment != null &&
          log.trackingMoment!.toLowerCase().contains(query)) {
        return true;
      }

      // Search in food type
      if (log.foodType != null &&
          log.foodType!.toLowerCase().contains(query)) {
        return true;
      }

      // Search in date
      final dateStr = DateFormat('yyyy-MM-dd HH:mm').format(log.date).toLowerCase();
      if (dateStr.contains(query)) {
        return true;
      }

      return false;
    }).toList();

    setState(() {
      _filteredLogEntries = filtered;
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

    // Group filtered entries by date
    final grouped = <String, List<LogEntry>>{};
    for (var log in _filteredLogEntries) {
      final dateString = DateFormat('yyyy-MM-dd').format(log.date);
      if (!grouped.containsKey(dateString)) {
        grouped[dateString] = [];
      }
      grouped[dateString]!.add(log);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: grouped.length,
      itemBuilder: (context, index) {
        final date = grouped.keys.elementAt(index);
        final logs = grouped[date]!;
        final formattedDate = _formatDate(date);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 8, top: index > 0 ? 16 : 0),
              child: Text(
                formattedDate,
                style: TextStyle(
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _textColor,
                ),
              ),
            ),
            ...logs.map((log) => _buildLogEntryItem(log)).toList(),
            if (index == grouped.length - 1)
              const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  // Build My Activity content
  Widget _buildMyActivityContent() {
    return Consumer<LogProvider>(
        builder: (context, logProvider, child) {
          final isLoading = logProvider.isLoading;
          final logs = logProvider.logs;
          final groupedByDate = logProvider.groupedByDate;
          final todayAverage = logProvider.todayAverage;

          return SafeArea(
            top: false,
            child: Column(
              children: [
                // App bar with search functionality
                Container(
                  padding: const EdgeInsets.only(top: 0),
                  color: _primaryColor,
                  child: _isSearching
                      ? Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 40, bottom: 16),
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
                          },
                        ),
                      ],
                    ),
                  )
                      : Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'My Activity',
                          style: TextStyle(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.search, color: Colors.black87),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          onPressed: () {
                            setState(() {
                              _isSearching = true;
                              _filteredLogEntries = Provider.of<LogProvider>(context, listen: false).logs;
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
                  padding: const EdgeInsets.only(left: 120, right: 15, top: 0, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(),
                      Text(
                        'Today',
                        style: TextStyle(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: _textColor,
                        ),
                      ),
                      Spacer(),
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
                      _buildAverageCircle(todayAverage),
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
                  child: isLoading || _isDeleting
                      ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(_accentColor),
                    ),
                  )
                      : _isSearching
                      ? _buildSearchResults()
                      : groupedByDate.isEmpty
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
                    itemCount: groupedByDate.length,
                    itemBuilder: (context, index) {
                      final date = groupedByDate.keys.elementAt(index);
                      final logs = groupedByDate[date]!;
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
                                  children: logs.map((log) => _buildLogEntryItem(log)).toList(),
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
          },
        );
    }
}