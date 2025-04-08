// import 'package:flutter/material.dart';
//
// class SupportFeedbackScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Ask Support"),
//         backgroundColor: Color(0xFF5FB8DD),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(decoration: InputDecoration(hintText: "Send us a message")),
//             SizedBox(height: 20),
//             ElevatedButton(onPressed: () {}, child: Text("Send")),
//           ],
//         ),
//       ),
//     );
//   }
// }




// import 'package:flutter/material.dart';
//
// class SupportFeedbackScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           "Ask Support",
//           style: TextStyle(color: Colors.black, fontSize: 20),
//         ),
//         backgroundColor: Color(0xFF89D0ED),
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Text(
//                 "Send us a message",
//                 style: TextStyle(
//                   color: Colors.grey,
//                   fontSize: 14,
//                 ),
//               ),
//               SizedBox(height: 8),
//               Container(
//                 height: 200, // Fixed height for the text field
//                 child: TextField(
//                   maxLines: null, // Allow unlimited lines
//                   expands: true, // Make the text field expand to fill the container
//                   textAlignVertical: TextAlignVertical.top,
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     contentPadding: EdgeInsets.all(12),
//                     hintText: "Type your message here...",
//                     hintStyle: TextStyle(color: Colors.grey),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 16),
//               SizedBox(
//                 width: double.infinity,
//                 height: 48, // Fixed height for the button
//                 child: ElevatedButton(
//                   onPressed: () {},
//                   child: Text(
//                     "Send",
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xFF89D0ED),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }





// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class SupportFeedbackScreen extends StatefulWidget {
//   @override
//   _SupportFeedbackScreenState createState() => _SupportFeedbackScreenState();
// }
//
// class _SupportFeedbackScreenState extends State<SupportFeedbackScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   final String _supportEmail = "thenujaasuntharesan@gmail.com";
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           // Header
//           Container(
//             width: double.infinity,
//             color: Color(0xFF89D0ED),
//             padding: EdgeInsets.only(top: 40, bottom: 15, left: 10, right: 20),
//             child: Row(
//               children: [
//                 IconButton(
//                   icon: Icon(Icons.arrow_back, color: Colors.black),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//                 Text(
//                   "Ask support",
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           Expanded(
//             child: Container(
//               color: Color(0xFFF0F9FD),
//               padding: EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Send us a message",
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Color(0xFF89D0ED),
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   Expanded(
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         border: Border.all(color: Color(0xFF89D0ED)),
//                         borderRadius: BorderRadius.circular(5),
//                       ),
//                       child: TextField(
//                         controller: _messageController,
//                         maxLines: null,
//                         expands: true,
//                         decoration: InputDecoration(
//                           border: InputBorder.none,
//                           contentPadding: EdgeInsets.all(10),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Align(
//                     alignment: Alignment.bottomRight,
//                     child: Padding(
//                       padding: EdgeInsets.only(top: 10),
//                       child: ElevatedButton(
//                         onPressed: _sendSupportEmail,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Color(0xFF89D0ED),
//                           padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
//                         ),
//                         child: Text("Send"),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<void> _sendSupportEmail() async {
//     if (_messageController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Please enter a message")),
//       );
//       return;
//     }
//
//     final Uri emailUri = Uri(
//       scheme: 'mailto',
//       path: _supportEmail,
//       query: 'subject=myBete App Support&body=${Uri.encodeComponent(_messageController.text)}',
//     );
//
//     if (await canLaunch(emailUri.toString())) {
//       await launch(emailUri.toString());
//       _messageController.clear();
//       Navigator.pop(context);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Could not launch email client")),
//       );
//     }
//   }
//
//   @override
//   void dispose() {
//     _messageController.dispose();
//     super.dispose();
//   }
// }





import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class SupportFeedbackScreen extends StatefulWidget {
  @override
  _SupportFeedbackScreenState createState() => _SupportFeedbackScreenState();
}

class _SupportFeedbackScreenState extends State<SupportFeedbackScreen> {
  final TextEditingController _messageController = TextEditingController();
  final String _supportEmail = "thenujaasuntharesan@gmail.com";
  bool _isSending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            color: Color(0xFF89D0ED),
            padding: EdgeInsets.only(top: 40, bottom: 15, left: 10, right: 20),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(
                  "Ask support",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Container(
              color: Color(0xFFF0F9FD),
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Send us a message",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF89D0ED),
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Color(0xFF89D0ED)),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextField(
                        controller: _messageController,
                        maxLines: null,
                        expands: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(10),
                          hintText: "Type your message here...",
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                        onPressed: _isSending ? null : _sendFeedback,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF89D0ED),
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        ),
                        child: _isSending
                            ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            )
                        )
                            : Text("Send"),
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

  Future<void> _sendFeedback() async {
    if (_messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a message")),
      );
      return;
    }

    setState(() {
      _isSending = true;
    });

    try {
      // Store message in Firestore
      await _saveMessageToFirestore();

      // Send email
      await _sendSupportEmail();

      // Clear message and show success
      _messageController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Feedback sent successfully")),
      );

      // Return to previous screen
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error sending feedback: ${e.toString()}")),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  Future<void> _saveMessageToFirestore() async {
    try {
      // Get current timestamp
      final timestamp = DateTime.now();
      final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(timestamp);

      // Save to Firestore
      await FirebaseFirestore.instance.collection('feedback').add({
        'message': _messageController.text,
        'email': _supportEmail,
        'timestamp': timestamp,
        'formattedDate': formattedDate,
        'status': 'pending', // Can be used for tracking response status
      });
    } catch (e) {
      print("Error saving to Firestore: $e");
      throw e;
    }
  }

  Future<void> _sendSupportEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: _supportEmail,
      query: 'subject=myBete App Support&body=${Uri.encodeComponent(_messageController.text)}',
    );

    if (await canLaunch(emailUri.toString())) {
      await launch(emailUri.toString());
    } else {
      throw 'Could not launch email client';
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}