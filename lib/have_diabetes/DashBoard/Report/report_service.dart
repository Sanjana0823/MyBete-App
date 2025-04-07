import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:csv/csv.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';
import '../MyActivity/log_entry.dart';
import '../MyActivity/log_service.dart';


class ReportService {
  final FirestoreService _firestoreService = FirestoreService();

  // Generate and save a report in the specified format
  Future<String?> generateReport(String format) async {
    try {
      // Check and request storage permission
      if (!await _checkPermission()) {
        return "Storage permission denied";
      }

      // Fetch log entries from Firestore
      final logs = await _firestoreService.getLogEntries();

      if (logs.isEmpty) {
        return "No data available to generate report";
      }

      // Sort logs by date (newest first)
      logs.sort((a, b) => b.date.compareTo(a.date));

      // Generate the appropriate file based on format
      String? filePath;
      if (format.toUpperCase() == 'CSV') {
        filePath = await _generateCSV(logs);
      } else if (format.toUpperCase() == 'PDF') {
        filePath = await _generatePDF(logs);
      } else {
        return "Unsupported format: $format";
      }

      return filePath;
    } catch (e) {
      debugPrint("Error generating report: $e");
      return "Error generating report: $e";
    }
  }

  // Generate CSV file from log entries
  Future<String?> _generateCSV(List<LogEntry> logs) async {
    try {
      // Create CSV data
      List<List<dynamic>> csvData = [];

      // Add header row
      csvData.add([
        'Date',
        'Time',
        'Tags',
        'Blood Sugar (mg/dL)',
        'Pills',
        'Blood Pressure',
        'Body Weight (kg)',
        'Tracking Moment',
        'Meal Time',
        'Food Type'
      ]);

      // Add data rows
      for (var log in logs) {
        // Format date and time
        final dateFormat = DateFormat('dd MMM yyyy');
        final timeFormat = DateFormat('HH:mm:ss');
        final date = dateFormat.format(log.date);
        final time = timeFormat.format(log.date);

        // Create tags string by combining tracking moment, meal time, and food type
        List<String> tags = [];
        if (log.trackingMoment != null) tags.add(log.trackingMoment!);
        if (log.mealTime != null) tags.add(log.mealTime!);
        if (log.foodType != null) tags.add(log.foodType!);
        final tagsString = tags.join(',');

        csvData.add([
          date,
          time,
          tagsString,
          log.bloodSugar?.toString() ?? '',
          log.pills ?? '',
          log.bloodPressure ?? '',
          log.bodyWeight?.toString() ?? '',
          log.trackingMoment ?? '',
          log.mealTime ?? '',
          log.foodType ?? ''
        ]);
      }

      // Convert to CSV string
      String csv = const ListToCsvConverter().convert(csvData);

      // Get download directory
      final directory = await _getDownloadDirectory();
      if (directory == null) {
        return "Could not access download directory";
      }

      // Create filename with timestamp
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final fileName = 'diabetes_log_$timestamp.csv';
      final filePath = '${directory.path}/$fileName';

      // Write to file
      final file = File(filePath);
      await file.writeAsString(csv);

      return filePath;
    } catch (e) {
      debugPrint("Error generating CSV: $e");
      return null;
    }
  }

  // Generate PDF file from log entries
  Future<String?> _generatePDF(List<LogEntry> logs) async {
    try {
      // Create PDF document
      final pdf = pw.Document();

      // Add title page
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    'Diabetes Log Report',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    'Generated on: ${DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now())}',
                    style: pw.TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  pw.SizedBox(height: 40),
                  pw.Text(
                    'Total Entries: ${logs.length}',
                    style: pw.TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );

      // Add data pages
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4.landscape,
          build: (pw.Context context) {
            return [
              pw.Header(
                level: 0,
                child: pw.Text('Diabetes Log Entries',
                    style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold
                    )
                ),
              ),
              pw.SizedBox(height: 10),
              _buildPdfTable(logs),
            ];
          },
        ),
      );

      // Get download directory
      final directory = await _getDownloadDirectory();
      if (directory == null) {
        return "Could not access download directory";
      }

      // Create filename with timestamp
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final fileName = 'diabetes_log_$timestamp.pdf';
      final filePath = '${directory.path}/$fileName';

      // Write to file
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      return filePath;
    } catch (e) {
      debugPrint("Error generating PDF: $e");
      return null;
    }
  }

  // Build PDF table
  pw.Widget _buildPdfTable(List<LogEntry> logs) {
    // Define table headers
    final headers = [
      'Date',
      'Time',
      'Tags',
      'Blood Sugar\n(mg/dL)',
      'Pills',
      'Blood Pressure',
      'Body Weight\n(kg)',
    ];

    // Create data rows
    final rows = logs.map((log) {
      // Format date and time
      final dateFormat = DateFormat('dd MMM yyyy');
      final timeFormat = DateFormat('HH:mm:ss');
      final date = dateFormat.format(log.date);
      final time = timeFormat.format(log.date);

      // Create tags string by combining tracking moment, meal time, and food type
      List<String> tags = [];
      if (log.trackingMoment != null) tags.add(log.trackingMoment!);
      if (log.mealTime != null) tags.add(log.mealTime!);
      if (log.foodType != null) tags.add(log.foodType!);
      final tagsString = tags.join(',\n');

      return [
        date,
        time,
        tagsString,
        log.bloodSugar?.toString() ?? '-',
        log.pills ?? '-',
        log.bloodPressure ?? '-',
        log.bodyWeight?.toString() ?? '-',
      ];
    }).toList();

    // Create table
    return pw.Table.fromTextArray(
      headers: headers,
      data: rows,
      border: pw.TableBorder.all(),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.center,
        2: pw.Alignment.centerLeft,
        3: pw.Alignment.center,
        4: pw.Alignment.center,
        5: pw.Alignment.center,
        6: pw.Alignment.center,
      },
    );
  }

  // Check and request storage permission
  Future<bool> _checkPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        return result == PermissionStatus.granted;
      }
      return true;
    } else if (Platform.isIOS) {
      // iOS doesn't need explicit permission for this operation
      return true;
    }
    return false;
  }

  // Get download directory based on platform
  Future<Directory?> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      // For Android, use the Downloads directory
      return Directory('/storage/emulated/0/Download');
    } else if (Platform.isIOS) {
      // For iOS, use the Documents directory
      return await getApplicationDocumentsDirectory();
    }
    // Fallback to temporary directory
    return await getTemporaryDirectory();
  }

  // Open the generated file
  Future<void> openFile(String filePath) async {
    try {
      final result = await OpenFile.open(filePath);
      if (result.type != ResultType.done) {
        debugPrint("Error opening file: ${result.message}");
      }
    } catch (e) {
      debugPrint("Error opening file: $e");
    }
  }

  // Share the generated file
  // Future<void> shareFile(String filePath) async {
  //   try {
  //     await Share.shareFiles([filePath]);
  //   } catch (e) {
  //     debugPrint("Error sharing file: $e");
  //   }
  // }

  // Share the generated file
  Future<void> shareFile(String filePath) async {
    try {
      final file = XFile(filePath);
      await Share.shareXFiles([file]);
    } catch (e) {
      debugPrint("Error sharing file: $e");
    }
    }
}