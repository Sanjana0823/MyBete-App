import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class MonthlyStatsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> logEntries;
  final Color primaryColor;
  final Color accentColor;
  final Color lightColor;
  final Color veryLightColor;
  final Color tealColor;
  final Color textColor;

  const MonthlyStatsScreen({
    Key? key,
    required this.logEntries,
    required this.primaryColor,
    required this.accentColor,
    required this.lightColor,
    required this.veryLightColor,
    required this.tealColor,
    required this.textColor,
  }) : super(key: key);

  @override
  _MonthlyStatsScreenState createState() => _MonthlyStatsScreenState();
}

class _MonthlyStatsScreenState extends State<MonthlyStatsScreen> {
  late DateTime _startDate;
  late DateTime _endDate;
  double _monthlyAverage = 0;
  int _totalLogs = 0;
  List<Map<String, dynamic>> _monthlyData = [];
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;
  bool _isMonthExpanded = true;

  @override
  void initState() {
    super.initState();
    _calculateDateRange();
    _processData();
  }

  // Calculate the date range for the current month
  void _calculateDateRange() {
    _startDate = DateTime(_selectedYear, _selectedMonth, 1);
    // End on the last day of the month
    _endDate = DateTime(_selectedYear, _selectedMonth + 1, 0);
  }

  // Process log data for the current month
  void _processData() {
    // Filter entries for the current month
    final monthEntries = widget.logEntries.where((entry) {
      final date = (entry['date'] as Timestamp).toDate();
      return date.isAfter(_startDate.subtract(const Duration(days: 1))) &&
          date.isBefore(_endDate.add(const Duration(days: 1))) &&
          entry['bloodSugar'] != null;
    }).toList();

    // Calculate monthly average
    double sum = 0;
    for (var entry in monthEntries) {
      sum += entry['bloodSugar'];
    }
    _monthlyAverage = monthEntries.isNotEmpty ? sum / monthEntries.length : 0;
    _totalLogs = monthEntries.length;

    // Group by week of month
    final weekData = <int, List<double>>{};
    for (var entry in monthEntries) {
      final date = (entry['date'] as Timestamp).toDate();
      // Calculate week of month (1-5)
      final weekOfMonth = ((date.day - 1) / 7).floor() + 1;

      if (!weekData.containsKey(weekOfMonth)) {
        weekData[weekOfMonth] = [];
      }

      weekData[weekOfMonth]!.add(entry['bloodSugar']);
    }

    // Calculate weekly averages
    _monthlyData = List.generate(5, (index) {
      final weekNum = index + 1;
      final values = weekData[weekNum] ?? [];
      final average = values.isNotEmpty
          ? values.reduce((a, b) => a + b) / values.length
          : 0.0;

      return {
        'week': weekNum,
        'average': average,
        'count': values.length,
      };
    });
  }

  // Change month
  void _changeMonth(int month, int year) {
    setState(() {
      _selectedMonth = month;
      _selectedYear = year;
      _calculateDateRange();
      _processData();
    });
  }

  // Show month picker
  void _showMonthPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 300,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        color: widget.accentColor,
                      ),
                    ),
                  ),
                  Text(
                    'Select Month',
                    style: TextStyle(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: widget.textColor,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Done',
                      style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w600,
                        color: widget.accentColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 2,
                  ),
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    final month = index + 1;
                    final isSelected = month == _selectedMonth;
                    return InkWell(
                      onTap: () {
                        _changeMonth(month, _selectedYear);
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: isSelected ? widget.accentColor : widget.lightColor.withAlpha(76),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            DateFormat('MMM').format(DateTime(2022, month)),
                            style: TextStyle(
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontSize: 16,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? Colors.white : widget.textColor,
                            ),
                          ),
                        ),
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

  // Build the monthly chart
  Widget _buildMonthlyChart() {
    return Container(
      height: 200,
      padding: const EdgeInsets.only(top: 16, right: 16, left: 8, bottom: 8),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: _monthlyData.map((e) => e['average']).whereType<double>().isEmpty
              ? 200
              : (_monthlyData.map((e) => e['average']).whereType<double>().reduce(max) * 1.2),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final data = _monthlyData[groupIndex];
                return BarTooltipItem(
                  '${data['average'] > 0 ? data['average'].toStringAsFixed(1) : 'No data'} mg/dL\n${data['count']} logs',
                  TextStyle(
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    backgroundColor: widget.textColor.withAlpha(200),
                  ),
                );
              },
            ),
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
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Week ${index + 1}',
                      style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        color: widget.textColor.withAlpha(179),
                        fontSize: 12,
                      ),
                    ),
                  );
                },
                reservedSize: 30,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 50,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      color: widget.textColor.withAlpha(179),
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
              bottom: BorderSide(color: Colors.grey.withAlpha(51)),
              left: BorderSide(color: Colors.grey.withAlpha(51)),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            horizontalInterval: 50,
            getDrawingHorizontalLine: (value) {
              // Highlight high and low glucose levels
              if (value == 180) { // High glucose level
                return FlLine(
                  color: Colors.red.withAlpha(76),
                  strokeWidth: 1,
                  dashArray: [5, 5],
                );
              } else if (value == 70) { // Low glucose level
                return FlLine(
                  color: Colors.orange.withAlpha(76),
                  strokeWidth: 1,
                  dashArray: [5, 5],
                );
              }
              return FlLine(
                color: Colors.grey.withAlpha(51),
                strokeWidth: 0.5,
              );
            },
          ),
          barGroups: List.generate(
            5,
                (index) {
              final data = _monthlyData[index];
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: data['average'] ?? 0,
                    color: widget.accentColor,
                    width: 20,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: 200,
                      color: widget.lightColor.withAlpha(51),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
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
        color: widget.lightColor,
        border: Border.all(
          color: widget.accentColor.withAlpha(76),
          width: 2,
        ),
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
                color: widget.textColor,
              ),
            ),
            Text(
              'mg/dL',
              style: TextStyle(
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontSize: 14,
                color: widget.textColor.withAlpha(179),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build collapsible month section
  Widget _buildMonthSection(String title, bool isExpanded, VoidCallback onToggle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: widget.lightColor.withAlpha(100),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: widget.textColor,
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: widget.accentColor,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Container(
              height: 200,
              padding: const EdgeInsets.all(16),
              child: _buildMonthlyChart(),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('d MMM');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: widget.primaryColor,
        title: Text(
          'Stats',
          style: TextStyle(
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Total logs
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: widget.primaryColor,
              border: Border(
                bottom: BorderSide(color: Colors.grey.withAlpha(51)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total logs',
                  style: TextStyle(
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  _totalLogs.toString(),
                  style: TextStyle(
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Monthly stats header with calendar icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Monthly Stats',
                              style: TextStyle(
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: widget.textColor,
                              ),
                            ),
                            Text(
                              '${dateFormat.format(_startDate)} - ${dateFormat.format(_endDate)}',
                              style: TextStyle(
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontSize: 14,
                                color: widget.textColor.withAlpha(179),
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.calendar_today,
                            size: 20,
                            color: widget.accentColor,
                          ),
                          onPressed: _showMonthPicker,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Monthly average
                    _buildAverageCircle(_monthlyAverage),
                    const SizedBox(height: 8),
                    Text(
                      'Average',
                      style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 14,
                        color: widget.textColor.withAlpha(179),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Month section
                    _buildMonthSection(
                        'February 2025',
                        _isMonthExpanded,
                            () => setState(() => _isMonthExpanded = !_isMonthExpanded)
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

