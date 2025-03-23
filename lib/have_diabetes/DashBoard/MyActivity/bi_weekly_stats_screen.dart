import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

import 'monthly_stats_screen.dart';

class BiWeeklyStatsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> logEntries;
  final Color primaryColor;
  final Color accentColor;
  final Color lightColor;
  final Color veryLightColor;
  final Color tealColor;
  final Color textColor;

  const BiWeeklyStatsScreen({
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
  _BiWeeklyStatsScreenState createState() => _BiWeeklyStatsScreenState();
}

class _BiWeeklyStatsScreenState extends State<BiWeeklyStatsScreen> {
  late DateTime _startDate;
  late DateTime _endDate;
  double _biWeeklyAverage = 0;
  int _totalLogs = 0;
  List<Map<String, dynamic>> _biWeeklyData = [];
  bool _isWeek1Expanded = true;
  bool _isWeek2Expanded = false;

  @override
  void initState() {
    super.initState();
    _calculateDateRange();
    _processData();
  }

  // Calculate the date range for the bi-weekly period
  void _calculateDateRange() {
    final now = DateTime.now();
    // Start from 2 weeks ago
    _startDate = now.subtract(const Duration(days: 14));
    // End today
    _endDate = now;
  }

  // Process log data for the bi-weekly period
  void _processData() {
    // Filter entries for the bi-weekly period
    final biWeekEntries = widget.logEntries.where((entry) {
      final date = (entry['date'] as Timestamp).toDate();
      return date.isAfter(_startDate.subtract(const Duration(days: 1))) &&
          date.isBefore(_endDate.add(const Duration(days: 1))) &&
          entry['bloodSugar'] != null;
    }).toList();

    // Calculate bi-weekly average
    double sum = 0;
    for (var entry in biWeekEntries) {
      sum += entry['bloodSugar'];
    }
    _biWeeklyAverage = biWeekEntries.isNotEmpty ? sum / biWeekEntries.length : 0;
    _totalLogs = biWeekEntries.length;

    // Group by week
    final weekData = <int, List<double>>{};
    for (var entry in biWeekEntries) {
      final date = (entry['date'] as Timestamp).toDate();
      // 0 for this week, 1 for last week
      final weekIndex = date.isAfter(_startDate.add(const Duration(days: 7))) ? 0 : 1;

      if (!weekData.containsKey(weekIndex)) {
        weekData[weekIndex] = [];
      }

      weekData[weekIndex]!.add(entry['bloodSugar']);
    }

    // Calculate weekly averages
    _biWeeklyData = List.generate(2, (index) {
      final values = weekData[index] ?? [];
      final average = values.isNotEmpty
          ? values.reduce((a, b) => a + b) / values.length
          : 0.0;

      return {
        'week': index,
        'average': average,
        'count': values.length,
      };
    });
  }

  // Navigate to monthly stats
  void _navigateToMonthlyStats() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MonthlyStatsScreen(
          logEntries: widget.logEntries,
          primaryColor: widget.primaryColor,
          accentColor: widget.accentColor,
          lightColor: widget.lightColor,
          veryLightColor: widget.veryLightColor,
          tealColor: widget.tealColor,
          textColor: widget.textColor,
        ),
      ),
    );
  }

  // Build the bi-weekly chart
  Widget _buildBiWeeklyChart() {
    return Container(
      height: 200,
      padding: const EdgeInsets.only(top: 16, right: 16, left: 8, bottom: 8),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: _biWeeklyData.map((e) => e['average']).whereType<double>().isEmpty
              ? 200
              : (_biWeeklyData.map((e) => e['average']).whereType<double>().reduce(max) * 1.2),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final data = _biWeeklyData[groupIndex];
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
                  String text = '';
                  if (index == 0) {
                    text = 'Week 9';
                  } else if (index == 1) {
                    text = 'Week 10';
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      text,
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
            2,
                (index) {
              final data = _biWeeklyData[index];
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: data['average'] ?? 0,
                    color: widget.accentColor,
                    width: 40,
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

  // Build collapsible week section
  Widget _buildWeekSection(String title, bool isExpanded, VoidCallback onToggle) {
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
              child: _buildBiWeeklyChart(),
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
                    // Bi-Weekly stats header with arrow
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bi-Weekly Stats',
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
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: widget.accentColor,
                          ),
                          onPressed: _navigateToMonthlyStats,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Bi-Weekly average
                    _buildAverageCircle(_biWeeklyAverage),
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

                    // Week sections
                    _buildWeekSection(
                        'Feb 24, 2025 - Mar 9, 2025',
                        _isWeek1Expanded,
                            () => setState(() => _isWeek1Expanded = !_isWeek1Expanded)
                    ),

                    _buildWeekSection(
                        'Feb 10 - 23, 2025',
                        _isWeek2Expanded,
                            () => setState(() => _isWeek2Expanded = !_isWeek2Expanded)
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

