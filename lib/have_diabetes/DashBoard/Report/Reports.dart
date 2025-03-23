// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
//
//
//
// class ReportsScreen extends StatefulWidget {
//   @override
//   _ReportsScreenState createState() => _ReportsScreenState();
// }
//
// class _ReportsScreenState extends State<ReportsScreen> {
//   File? selectedFile;
//   String? fileName;
//   String? downloadURL;
//   Map<String, dynamic>? comparisonResults;
//
//   Future<void> pickFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles();
//     if (result != null) {
//       setState(() {
//         selectedFile = File(result.files.single.path!);
//         fileName = result.files.single.name;
//       });
//     }
//   }
//
//   Future<void> uploadReport() async {
//     if (selectedFile == null) {
//       Fluttertoast.showToast(msg: "Please select a file first!");
//       return;
//     }
//
//     try {
//       String filePath = "reports/${DateTime.now().millisecondsSinceEpoch}_$fileName";
//       Reference storageRef = FirebaseStorage.instance.ref().child(filePath);
//       await storageRef.putFile(selectedFile!);
//       String fileURL = await storageRef.getDownloadURL();
//
//       await FirebaseFirestore.instance.collection("reports").add({
//         "fileName": fileName,
//         "fileURL": fileURL,
//         "uploadDate": DateTime.now().toIso8601String(),
//         "glucose": 140, // Placeholder for extracted values
//         "hba1c": 6.5,
//       });
//
//       setState(() {
//         downloadURL = fileURL;
//       });
//
//       Fluttertoast.showToast(msg: "Report uploaded successfully!");
//     } catch (e) {
//       Fluttertoast.showToast(msg: "Error uploading file: $e");
//     }
//   }
//
//   Future<void> fetchAndCompareReports() async {
//     QuerySnapshot snapshot = await FirebaseFirestore.instance
//         .collection("reports")
//         .orderBy("uploadDate", descending: true)
//         .limit(2)
//         .get();
//
//     if (snapshot.docs.length < 2) {
//       Fluttertoast.showToast(msg: "Not enough reports to compare.");
//       return;
//     }
//
//     var latest = snapshot.docs[0].data() as Map<String, dynamic>;
//     var previous = snapshot.docs[1].data() as Map<String, dynamic>;
//
//     int glucoseChange = latest["glucose"] - previous["glucose"];
//     double hba1cChange = latest["hba1c"] - previous["hba1c"];
//
//     setState(() {
//       comparisonResults = {
//         "glucose": glucoseChange > 0
//             ? "Increased by $glucoseChange mg/dL"
//             : glucoseChange < 0
//             ? "Decreased by ${glucoseChange.abs()} mg/dL"
//             : "No change",
//         "hba1c": hba1cChange > 0
//             ? "Increased by $hba1cChange%"
//             : hba1cChange < 0
//             ? "Decreased by ${hba1cChange.abs()}%"
//             : "No change",
//       };
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("Report", style: TextStyle(fontWeight: FontWeight.bold)),
//           backgroundColor: Colors.lightBlue[300],
//         ),
//         body: Padding(
//             padding: EdgeInsets.all(20),
//             child: Column(
//               children: [
//                 GestureDetector(
//                   onTap: pickFile,
//                   child: Container(
//                     width: double.infinity,
//                     height: 120,
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.blue, width: 2),
//                       borderRadius: BorderRadius.circular(10),
//                       color: Colors.white,
//                     ),
//                     child: Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.cloud_upload, size: 40, color: Colors.blue),
//                           SizedBox(height: 5),
//                           Text("Browse Files to Upload Report",
//                               style: TextStyle(color: Colors.blue)),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: uploadReport,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
//                     child: Text("Upload Report", style: TextStyle(fontSize: 16)),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: fetchAndCompareReports,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue.shade700,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
//                     child: Text("Compare Reports", style: TextStyle(fontSize: 16)),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 if (comparisonResults != null)
//                   Container(
//                     padding: EdgeInsets.all(15),
//                     margin: EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(10),
//                       boxShadow: [
//                         BoxShadow(color: Colors.grey.shade300, blurRadius: 5),
//                       ],
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Comparison Results:",
//                           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                         ),
//                         SizedBox(height: 10),
//                         Text(
//                           "Glucose Trend: ${comparisonResults!["glucose"]}",
//                           style: TextStyle(fontSize: 16, color: Colors.black),
//                         ),
//                         Text(
//                           "HbA1c Trend: ${comparisonResults!["hba1c"]}",
//                           style: TextStyle(fontSize: 16, color: Colors.black),
//                         ),
//                       ],
//                     ),
//                   ),
//               ],
//             ),
//             ),
//         );
//     }
// }
//
//
//
//
//
//

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String selectedFormat = 'CSV';

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
                          _showExportSuccessDialog();
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

  void _showExportSuccessDialog() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            decoration: BoxDecoration(
              color: lightBlue2,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(0),
              ),
            ),
            child: Text(
              "Report",
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),

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

                  // Export button
                  ElevatedButton(
                    onPressed: _showExportConfirmationDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mediumBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: Size(double.infinity, 55),
                      elevation: 2,
                    ),
                    child: Text(
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
                    child: Text(
                      "Reports are generated in the background and saved to your downloads folder. You will be able to check the progress in your notifications.",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.black87,
                        height: 1.5,
                      ),
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

