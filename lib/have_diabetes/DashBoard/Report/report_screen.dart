import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../MyActivity/log_provider.dart';
import 'report_service.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String selectedFormat = 'CSV';
  bool isGenerating = false;
  final ReportService _reportService = ReportService();

  // Define the color palette
  final Color lightBlue1 = Color(0xFFAEECFF);
  final Color lightBlue2 = Color(0xFF89D0ED);
  final Color mediumBlue = Color(0xFF5EB7CF);
  final Color brightBlue = Color(0xFF5FB8DD);
  final Color paleBlue = Color(0xFFC5EDFF);
  final Color bgColor = Color(0xFFE6F7FF); // Light blue background

  void _showFormatSelectionDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (context, setDialogState) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Select File Format",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedFormat = 'PDF';
                          });
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: selectedFormat == 'PDF' ? brightBlue.withOpacity(0.1) : Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: selectedFormat == 'PDF' ? brightBlue : Colors.grey[300]!,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: selectedFormat == 'PDF' ? brightBlue : Colors.white,
                                  border: Border.all(
                                    color: selectedFormat == 'PDF' ? brightBlue : Colors.grey[400]!,
                                    width: 1.5,
                                  ),
                                ),
                                child: selectedFormat == 'PDF'
                                    ? Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Colors.white,
                                )
                                    : null,
                              ),
                              SizedBox(width: 12),
                              Text(
                                'PDF',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: selectedFormat == 'PDF' ? FontWeight.w600 : FontWeight.w500,
                                  color: selectedFormat == 'PDF' ? brightBlue : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedFormat = 'CSV';
                          });
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: selectedFormat == 'CSV' ? brightBlue.withOpacity(0.1) : Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: selectedFormat == 'CSV' ? brightBlue : Colors.grey[300]!,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: selectedFormat == 'CSV' ? brightBlue : Colors.white,
                                  border: Border.all(
                                    color: selectedFormat == 'CSV' ? brightBlue : Colors.grey[400]!,
                                    width: 1.5,
                                  ),
                                ),
                                child: selectedFormat == 'CSV'
                                    ? Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Colors.white,
                                )
                                    : null,
                              ),
                              SizedBox(width: 12),
                              Text(
                                'CSV',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: selectedFormat == 'CSV' ? FontWeight.w600 : FontWeight.w500,
                                  color: selectedFormat == 'CSV' ? brightBlue : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              "Cancel",
                              style: GoogleFonts.poppins(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
        );
      },
    );
  }

  void _showExportConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Create Report",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Do you want to create a report in $selectedFormat format?",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.poppins(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _generateReport();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: brightBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          "Export",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showExportSuccessDialog(String filePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.green,
                    size: 40,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Report Generated",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "Your $selectedFormat report has been generated and saved to your downloads folder.",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _reportService.openFile(filePath);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: brightBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          "Open",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _reportService.shareFile(filePath);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[800],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          "Share",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Error",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  errorMessage,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brightBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: Size(double.infinity, 45),
                  ),
                  child: Text(
                    "OK",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Generate the report
  Future<void> _generateReport() async {
    // Check if there's data to export
    final logProvider = Provider.of<LogProvider>(context, listen: false);
    if (logProvider.logs.isEmpty) {
      _showErrorDialog("No data available to generate report");
      return;
    }

    // Show loading indicator
    setState(() {
      isGenerating = true;
    });

    // Show a snackbar to indicate report generation is in progress
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            SizedBox(width: 12),
            Text('Generating $selectedFormat report...'),
          ],
        ),
        duration: Duration(seconds: 2),
      ),
    );

    try {
      // Generate the report
      final filePath = await _reportService.generateReport(selectedFormat);

      // Hide loading indicator
      setState(() {
        isGenerating = false;
      });

      if (filePath == null || filePath.startsWith("Error") || filePath.startsWith("No data")) {
        // Show error dialog
        _showErrorDialog(filePath ?? "Failed to generate report");
      } else {
        // Show success dialog
        _showExportSuccessDialog(filePath);
      }
    } catch (e) {
      // Hide loading indicator
      setState(() {
        isGenerating = false;
      });

      // Show error dialog
      _showErrorDialog("Error generating report: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgColor,

        appBar: AppBar(
          backgroundColor: lightBlue2,
          elevation: 0,
          title: Text(
            "Report",
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          // leading: IconButton(
          //   icon: Icon(Icons.arrow_back, color: Colors.black87),
          //   onPressed: () => Navigator.of(context).pop(),
          // ),
        ),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // File format selector
                      Text(
                        "File format",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8),
                      GestureDetector(
                        onTap: _showFormatSelectionDialog,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                selectedFormat,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              Icon(
                                Icons.arrow_drop_down,
                                color: Colors.grey[600],
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 30),

                      // Date range selector
                      // Text(
                      //   "Date Range",
                      //   style: GoogleFonts.poppins(
                      //     fontSize: 16,
                      //     fontWeight: FontWeight.w500,
                      //     color: Colors.black87,
                      //   ),
                      // ),
                      // SizedBox(height: 8),
                      // Container(
                      //   width: double.infinity,
                      //   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      //   decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     borderRadius: BorderRadius.circular(8),
                      //     border: Border.all(color: Colors.grey[300]!),
                      //   ),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Text(
                      //         "All Time",
                      //         style: GoogleFonts.poppins(
                      //           fontSize: 16,
                      //           color: Colors.black87,
                      //         ),
                      //       ),
                      //       Icon(
                      //         Icons.arrow_drop_down,
                      //         color: Colors.grey[600],
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      SizedBox(height: 30),

                      // Export button
                      ElevatedButton(
                        onPressed: isGenerating ? null : _showExportConfirmationDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isGenerating ? Colors.grey : mediumBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          minimumSize: Size(double.infinity, 55),
                          elevation: 2,
                        ),
                        child: isGenerating
                            ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              "Generating...",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                            : Text(
                          "Export",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      SizedBox(height: 30),

                      // Information box
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: lightBlue2.withOpacity(0.5)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.info_outline, color: brightBlue, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  "Information",
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Reports are generated in the background and saved to your downloads folder. You will be able to check the progress in your notifications.",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.black87,
                                height: 1.5,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "• CSV files can be opened with Excel or Google Sheets\n• PDF files can be viewed with any PDF reader",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.black87,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            ),
        );
    }
}