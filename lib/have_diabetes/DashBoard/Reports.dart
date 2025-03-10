
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class ReportsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Reports")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text("Upload Report", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             SizedBox(height: 20),
//             ElevatedButton.icon(
//               icon: Icon(Icons.upload_file),
//               label: Text("Browse Files"),
//               onPressed: () {},
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';



class ReportsScreen extends StatefulWidget {
  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  File? selectedFile;
  String? fileName;
  String? downloadURL;
  Map<String, dynamic>? comparisonResults;

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
        fileName = result.files.single.name;
      });
    }
  }

  Future<void> uploadReport() async {
    if (selectedFile == null) {
      Fluttertoast.showToast(msg: "Please select a file first!");
      return;
    }

    try {
      String filePath = "reports/${DateTime.now().millisecondsSinceEpoch}_$fileName";
      Reference storageRef = FirebaseStorage.instance.ref().child(filePath);
      await storageRef.putFile(selectedFile!);
      String fileURL = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance.collection("reports").add({
        "fileName": fileName,
        "fileURL": fileURL,
        "uploadDate": DateTime.now().toIso8601String(),
        "glucose": 140, // Placeholder for extracted values
        "hba1c": 6.5,
      });

      setState(() {
        downloadURL = fileURL;
      });

      Fluttertoast.showToast(msg: "Report uploaded successfully!");
    } catch (e) {
      Fluttertoast.showToast(msg: "Error uploading file: $e");
    }
  }

  Future<void> fetchAndCompareReports() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("reports")
        .orderBy("uploadDate", descending: true)
        .limit(2)
        .get();

    if (snapshot.docs.length < 2) {
      Fluttertoast.showToast(msg: "Not enough reports to compare.");
      return;
    }

    var latest = snapshot.docs[0].data() as Map<String, dynamic>;
    var previous = snapshot.docs[1].data() as Map<String, dynamic>;

    int glucoseChange = latest["glucose"] - previous["glucose"];
    double hba1cChange = latest["hba1c"] - previous["hba1c"];

    setState(() {
      comparisonResults = {
        "glucose": glucoseChange > 0
            ? "Increased by $glucoseChange mg/dL"
            : glucoseChange < 0
            ? "Decreased by ${glucoseChange.abs()} mg/dL"
            : "No change",
        "hba1c": hba1cChange > 0
            ? "Increased by $hba1cChange%"
            : hba1cChange < 0
            ? "Decreased by ${hba1cChange.abs()}%"
            : "No change",
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Report", style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.lightBlue[300],
        ),
        body: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                GestureDetector(
                  onTap: pickFile,
                  child: Container(
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue, width: 2),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud_upload, size: 40, color: Colors.blue),
                          SizedBox(height: 5),
                          Text("Browse Files to Upload Report",
                              style: TextStyle(color: Colors.blue)),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: uploadReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    child: Text("Upload Report", style: TextStyle(fontSize: 16)),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: fetchAndCompareReports,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    child: Text("Compare Reports", style: TextStyle(fontSize: 16)),
                  ),
                ),
                SizedBox(height: 20),
                if (comparisonResults != null)
                  Container(
                    padding: EdgeInsets.all(15),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(color: Colors.grey.shade300, blurRadius: 5),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Comparison Results:",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Glucose Trend: ${comparisonResults!["glucose"]}",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        Text(
                          "HbA1c Trend: ${comparisonResults!["hba1c"]}",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            ),
        );
    }
}