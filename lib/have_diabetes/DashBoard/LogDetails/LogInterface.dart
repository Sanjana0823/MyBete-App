// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../MyActivity/MyActivity.dart';
//
// class LogEntryScreen extends StatefulWidget {
//   final Map<String, dynamic>? logEntry;
//
//   const LogEntryScreen({Key? key, this.logEntry}) : super(key: key);
//
//   @override
//   _LogInterfaceState createState() => _LogInterfaceState();
// }
//
// class _LogInterfaceState extends State<LogEntryScreen> {
//   // Form controllers
//   final TextEditingController _bloodSugarController = TextEditingController();
//   final TextEditingController _pillsController = TextEditingController();
//   final TextEditingController _bodyWeightController = TextEditingController();
//
//   // Blood pressure values
//   int _systolicValue = 120; // Default value
//   int _diastolicValue = 80; // Default value
//   bool _hasBloodPressure = false;
//
//   // Selected values
//   DateTime _selectedDateTime = DateTime.now();
//   String? _selectedTrackingMoment;
//   String? _selectedMealTime;
//   String? _selectedFoodType;
//
//   // Tracking if user has made changes
//   bool _hasChanges = false;
//
//   // Colors from the provided palette
//   final Color _primaryColor = const Color(0xFF89D0ED); // Medium blue
//   final Color _accentColor = const Color(0xFF5FB8DD);  // Medium-bright blue
//   final Color _lightColor = const Color(0xFFAEECFF);   // Light blue
//   final Color _veryLightColor = const Color(0xFFC5EDFF); // Very light blue
//   final Color _tealColor = const Color(0xFF5EB7CF);    // Blue-teal
//   final Color _textColor = const Color(0xFF2C3E50);    // Dark blue-gray
//   final Color _labelColor = const Color(0xFF7F8C8D);   // Medium gray
//
//   // Button states
//   bool _isSaveHovered = false;
//   bool _isClearHovered = false;
//
//   // Scroll controllers for blood pressure
//   final FixedExtentScrollController _systolicScrollController = FixedExtentScrollController(initialItem: 70); // 120 - 50
//   final FixedExtentScrollController _diastolicScrollController = FixedExtentScrollController(initialItem: 60); // 80 - 20
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Add listeners to detect changes
//     _bloodSugarController.addListener(_onFormChanged);
//     _pillsController.addListener(_onFormChanged);
//     _bodyWeightController.addListener(_onFormChanged);
//
//     // Load data from logEntry if editing an existing entry
//     if (widget.logEntry != null) {
//       // Set blood sugar
//       if (widget.logEntry!['bloodSugar'] != null) {
//         _bloodSugarController.text = widget.logEntry!['bloodSugar'].toString();
//       }
//
//       // Set pills
//       if (widget.logEntry!['pills'] != null) {
//         _pillsController.text = widget.logEntry!['pills'];
//       }
//
//       // Set body weight
//       if (widget.logEntry!['bodyWeight'] != null) {
//         _bodyWeightController.text = widget.logEntry!['bodyWeight'].toString();
//       }
//
//       // Set blood pressure
//       if (widget.logEntry!['bloodPressure'] != null) {
//         final bpParts = widget.logEntry!['bloodPressure'].toString().split('/');
//         if (bpParts.length == 2) {
//           try {
//             _systolicValue = int.parse(bpParts[0]);
//             _diastolicValue = int.parse(bpParts[1]);
//             _hasBloodPressure = true;
//           } catch (e) {
//             print('Error parsing blood pressure: $e');
//           }
//         }
//       }
//
//       // Set date
//       if (widget.logEntry!['date'] != null) {
//         _selectedDateTime = (widget.logEntry!['date'] as Timestamp).toDate();
//       }
//
//       // Set tracking moment
//       if (widget.logEntry!['trackingMoment'] != null) {
//         _selectedTrackingMoment = widget.logEntry!['trackingMoment'];
//       }
//
//       // Set meal time
//       if (widget.logEntry!['mealTime'] != null) {
//         _selectedMealTime = widget.logEntry!['mealTime'];
//       }
//
//       // Set food type
//       if (widget.logEntry!['foodType'] != null) {
//         _selectedFoodType = widget.logEntry!['foodType'];
//       }
//
//       // Mark as having changes to enable save button
//       _hasChanges = true;
//     }
//   }
//
//   void _onFormChanged() {
//     setState(() {
//       _hasChanges = _bloodSugarController.text.isNotEmpty ||
//           _pillsController.text.isNotEmpty ||
//           _bodyWeightController.text.isNotEmpty ||
//           _hasBloodPressure ||
//           _selectedTrackingMoment != null ||
//           _selectedMealTime != null ||
//           _selectedFoodType != null;
//     });
//   }
//
//   @override
//   void dispose() {
//     _bloodSugarController.dispose();
//     _pillsController.dispose();
//     _bodyWeightController.dispose();
//     _systolicScrollController.dispose();
//     _diastolicScrollController.dispose();
//     super.dispose();
//   }
//
//   // Show date picker
//   Future<void> _selectDate() async {
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: _selectedDateTime,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2030),
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: ColorScheme.light(
//               primary: _accentColor,
//               onPrimary: Colors.white,
//               surface: Colors.white,
//               onSurface: _textColor,
//             ),
//             textButtonTheme: TextButtonThemeData(
//               style: TextButton.styleFrom(
//                 foregroundColor: _accentColor,
//               ),
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//
//     if (pickedDate != null) {
//       _selectTime(pickedDate);
//     }
//   }
//
//   // Show time picker
//   Future<void> _selectTime(DateTime pickedDate) async {
//     final TimeOfDay? pickedTime = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: ColorScheme.light(
//               primary: _accentColor,
//               onPrimary: Colors.white,
//               surface: Colors.white,
//               onSurface: _textColor,
//             ),
//             textButtonTheme: TextButtonThemeData(
//               style: TextButton.styleFrom(
//                 foregroundColor: _accentColor,
//               ),
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//
//     if (pickedTime != null) {
//       setState(() {
//         _selectedDateTime = DateTime(
//           pickedDate.year,
//           pickedDate.month,
//           pickedDate.day,
//           pickedTime.hour,
//           pickedTime.minute,
//         );
//         _onFormChanged();
//       });
//     }
//   }
//
//   // Get food options based on tracking moment
//   List<String> _getFoodOptions() {
//     if (_selectedTrackingMoment == 'Fasting') {
//       return ['Water', 'Soft Drink', 'Diet Soda', 'Milk'];
//     }
//     return [
//       'Water', 'Vegetable', 'Fruit', 'Grain', 'Dairy',
//       'Egg', 'Fish', 'Meal', 'Nuts', 'Sweets',
//       'Alcohol', 'Diet Soda', 'Soft Drink', 'Fast Food'
//     ];
//   }
//
//   // Get meal time options based on tracking moment
//   List<String> _getMealTimeOptions() {
//     if (_selectedTrackingMoment == 'Fasting') {
//       return ['Before consuming', 'After consuming'];
//     }
//     return ['Before meal', 'After meal'];
//   }
//
//   // Clear all form fields
//   void _clearForm() {
//     setState(() {
//       _bloodSugarController.clear();
//       _pillsController.clear();
//       _bodyWeightController.clear();
//       _systolicValue = 120;
//       _diastolicValue = 80;
//       _hasBloodPressure = false;
//       _selectedTrackingMoment = null;
//       _selectedMealTime = null;
//       _selectedFoodType = null;
//       _selectedDateTime = DateTime.now();
//       _hasChanges = false;
//
//       // Reset scroll controllers
//       _systolicScrollController.jumpToItem(70); // 120 - 50
//       _diastolicScrollController.jumpToItem(60); // 80 - 20
//     });
//   }
//
//   // Check if any data has been entered
//   bool _hasAnyData() {
//     return _bloodSugarController.text.isNotEmpty ||
//         _pillsController.text.isNotEmpty ||
//         _bodyWeightController.text.isNotEmpty ||
//         _hasBloodPressure ||
//         _selectedTrackingMoment != null ||
//         _selectedMealTime != null ||
//         _selectedFoodType != null;
//   }
//
//   // Show empty fields alert
//   void _showEmptyFieldsAlert() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Colors.white,
//           title: Text(
//             'No Data Entered',
//             style: TextStyle(
//               fontFamily: GoogleFonts.poppins().fontFamily,
//               fontWeight: FontWeight.bold,
//               color: _textColor,
//             ),
//           ),
//           content: Text(
//             'Please enter at least one field before saving.',
//             style: TextStyle(
//               fontFamily: GoogleFonts.poppins().fontFamily,
//               color: _textColor,
//             ),
//           ),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//           actions: <Widget>[
//             ElevatedButton(
//               child: Text(
//                 'OK',
//                 style: TextStyle(
//                   fontFamily: GoogleFonts.poppins().fontFamily,
//                   color: Colors.white,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: _accentColor,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   // Save log entry to Firestore
//   Future<void> _saveLogEntry() async {
//     // Check if any data has been entered
//     if (!_hasAnyData()) {
//       _showEmptyFieldsAlert();
//       return;
//     }
//
//     // Validate blood sugar is a valid double if entered
//     if (_bloodSugarController.text.isNotEmpty) {
//       try {
//         double.parse(_bloodSugarController.text);
//       } catch (e) {
//         _showSnackBar('Blood sugar must be a valid number');
//         return;
//       }
//     }
//
//     // Validate body weight is a valid double if entered
//     if (_bodyWeightController.text.isNotEmpty) {
//       try {
//         double.parse(_bodyWeightController.text);
//       } catch (e) {
//         _showSnackBar('Body weight must be a valid number');
//         return;
//       }
//     }
//
//     // Check if user is authenticated
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       print('Authentication error: No user is currently signed in');
//       _showSnackBar('You must be logged in to save data');
//       return;
//     }
//
//     print('Attempting to save data for user: ${user.uid}'); // Add logging
//
//     try {
//       // Check if we're editing an existing entry
//       final String? existingId = widget.logEntry != null ? widget.logEntry!['id'] as String? : null;
//
//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null) {
//         _showSnackBar('You must be logged in to save data');
//         return;
//       }
//
//       // Log what we're about to save
//       print('Preparing to save log entry with:');
//       print('- Blood Sugar: ${_bloodSugarController.text.isEmpty ? "null" : _bloodSugarController.text}');
//       print('- Pills: ${_pillsController.text.isEmpty ? "null" : _pillsController.text}');
//       print('- Blood Pressure: ${_hasBloodPressure ? "$_systolicValue/$_diastolicValue" : "null"}');
//       print('- Body Weight: ${_bodyWeightController.text.isEmpty ? "null" : _bodyWeightController.text}');
//       print('- Tracking Moment: $_selectedTrackingMoment');
//       print('- Meal Time: $_selectedMealTime');
//       print('- Food Type: $_selectedFoodType');
//
//       // Show loading indicator
//       _showLoadingDialog();
//
//       // Create data map
//       final data = {
//         'userId': user.uid,
//         'date': Timestamp.fromDate(_selectedDateTime),
//         'bloodSugar': _bloodSugarController.text.isEmpty
//             ? null
//             : double.parse(_bloodSugarController.text),
//         'pills': _pillsController.text.isEmpty ? null : _pillsController.text,
//         'bloodPressure': _hasBloodPressure
//             ? '$_systolicValue/$_diastolicValue'
//             : null,
//         'bodyWeight': _bodyWeightController.text.isEmpty
//             ? null
//             : double.parse(_bodyWeightController.text),
//         'trackingMoment': _selectedTrackingMoment,
//         'mealTime': _selectedMealTime,
//         'foodType': _selectedFoodType,
//         'createdAt': Timestamp.now(),
//         'updatedAt': Timestamp.now(),
//       };
//
//       // Remove null values
//       data.removeWhere((key, value) => value == null);
//
//       // Save to Firestore
//       try {
//         print('Attempting to save to Firestore collection: logEntries');
//
//         if (existingId != null) {
//           // Update existing document
//           await FirebaseFirestore.instance.collection('logEntries').doc(existingId).update(data);
//           print('Document updated successfully with ID: $existingId');
//         } else {
//           // Create new document
//           final docRef = await FirebaseFirestore.instance.collection('logEntries').add(data);
//           print('Document saved successfully with ID: ${docRef.id}');
//         }
//
//         // Dismiss loading dialog
//         Navigator.of(context).pop();
//
//         // Navigate back to MyActivity
//         _navigateToMyActivity();
//
//         // Show success message
//         _showSnackBar('Log entry ${existingId != null ? 'updated' : 'saved'} successfully', isSuccess: true);
//       } catch (firestoreError) {
//         print('Firestore error: $firestoreError');
//         if (Navigator.of(context).canPop()) {
//           Navigator.of(context).pop();
//         }
//         _showSnackBar('Error saving to database: $firestoreError');
//       }
//     } catch (e) {
//       // Dismiss loading dialog if showing
//       if (Navigator.of(context).canPop()) {
//         Navigator.of(context).pop();
//       }
//
//       print('Error saving log entry: $e'); // Add detailed console logging
//       _showSnackBar('Error saving log entry: $e');
//     }
//   }
//
//   // Show a snackbar message
//   void _showSnackBar(String message, {bool isSuccess = false}) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: isSuccess ? Colors.green : Colors.red,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//         margin: const EdgeInsets.all(10),
//       ),
//     );
//   }
//
//   // Show loading dialog
//   void _showLoadingDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return Dialog(
//           backgroundColor: Colors.white,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 20),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(_accentColor),
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   'Saving...',
//                   style: TextStyle(
//                     fontFamily: GoogleFonts.poppins().fontFamily,
//                     color: _textColor,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   // Navigate to MyActivity
//   void _navigateToMyActivity() {
//     Navigator.of(context).pushReplacement(
//       MaterialPageRoute(builder: (context) => const MyActivityScreen()),
//     );
//   }
//
//   // Show discard confirmation dialog
//   Future<void> _showDiscardDialog() async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Colors.white,
//           title: Text(
//             'Unsaved Entry',
//             style: TextStyle(
//               fontFamily: GoogleFonts.poppins().fontFamily,
//               fontWeight: FontWeight.bold,
//               color: _textColor,
//             ),
//           ),
//           content: Text(
//             'Your log entry has not been saved. Are you sure you want to discard?',
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
//                 'Discard',
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
//                 // Navigate to MyActivity interface
//                 _navigateToMyActivity();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   // Show blood pressure picker
//   void _showBloodPressurePicker() {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return Container(
//               height: 300,
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       TextButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         child: Text(
//                           'Cancel',
//                           style: TextStyle(
//                             fontFamily: GoogleFonts.poppins().fontFamily,
//                             color: _accentColor,
//                           ),
//                         ),
//                       ),
//                       Text(
//                         'Blood Pressure',
//                         style: TextStyle(
//                           fontFamily: GoogleFonts.poppins().fontFamily,
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                           color: _textColor,
//                         ),
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           this.setState(() {
//                             _hasBloodPressure = true;
//                             _onFormChanged();
//                           });
//                           Navigator.pop(context);
//                         },
//                         child: Text(
//                           'Done',
//                           style: TextStyle(
//                             fontFamily: GoogleFonts.poppins().fontFamily,
//                             fontWeight: FontWeight.w600,
//                             color: _accentColor,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   Expanded(
//                     child: Row(
//                       children: [
//                         // Systolic picker (50-300)
//                         Expanded(
//                           child: ListWheelScrollView.useDelegate(
//                             controller: _systolicScrollController,
//                             itemExtent: 50,
//                             perspective: 0.005,
//                             diameterRatio: 1.5,
//                             physics: const FixedExtentScrollPhysics(),
//                             onSelectedItemChanged: (index) {
//                               setState(() {
//                                 _systolicValue = index + 50; // Start from 50
//                               });
//                             },
//                             childDelegate: ListWheelChildBuilderDelegate(
//                               childCount: 251, // 300 - 50 + 1
//                               builder: (context, index) {
//                                 final value = index + 50;
//                                 return Center(
//                                   child: Text(
//                                     value.toString(),
//                                     style: TextStyle(
//                                       fontFamily: GoogleFonts.poppins().fontFamily,
//                                       fontSize: 24,
//                                       fontWeight: FontWeight.w500,
//                                       color: _systolicValue == value
//                                           ? _accentColor
//                                           : _textColor.withOpacity(0.5),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         ),
//
//                         // Separator
//                         Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 16),
//                           child: Text(
//                             '/',
//                             style: TextStyle(
//                               fontFamily: GoogleFonts.poppins().fontFamily,
//                               fontSize: 30,
//                               fontWeight: FontWeight.bold,
//                               color: _textColor,
//                             ),
//                           ),
//                         ),
//
//                         // Diastolic picker (20-200)
//                         Expanded(
//                           child: ListWheelScrollView.useDelegate(
//                             controller: _diastolicScrollController,
//                             itemExtent: 50,
//                             perspective: 0.005,
//                             diameterRatio: 1.5,
//                             physics: const FixedExtentScrollPhysics(),
//                             onSelectedItemChanged: (index) {
//                               setState(() {
//                                 _diastolicValue = index + 20; // Start from 20
//                               });
//                             },
//                             childDelegate: ListWheelChildBuilderDelegate(
//                               childCount: 181, // 200 - 20 + 1
//                               builder: (context, index) {
//                                 final value = index + 20;
//                                 return Center(
//                                   child: Text(
//                                     value.toString(),
//                                     style: TextStyle(
//                                       fontFamily: GoogleFonts.poppins().fontFamily,
//                                       fontSize: 24,
//                                       fontWeight: FontWeight.w500,
//                                       color: _diastolicValue == value
//                                           ? _accentColor
//                                           : _textColor.withOpacity(0.5),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   // Handle back button press
//   Future<bool> _onWillPop() async {
//     if (_hasChanges) {
//       await _showDiscardDialog();
//       return false;
//     }
//     _navigateToMyActivity();
//     return false;
//   }
//
//   // Custom button widget with color swap effect
//   Widget _buildCustomButton({
//     required String text,
//     required VoidCallback onPressed,
//     required bool isHovered,
//     required Function(bool) onHover,
//   }) {
//     return MouseRegion(
//       onEnter: (_) => onHover(true),
//       onExit: (_) => onHover(false),
//       child: GestureDetector(
//         onTapDown: (_) => onHover(true),
//         onTapUp: (_) {
//           onHover(false);
//           onPressed();
//         },
//         onTapCancel: () => onHover(false),
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 150),
//           height: 50,
//           decoration: BoxDecoration(
//             color: isHovered ? _textColor : _primaryColor,
//             borderRadius: BorderRadius.circular(10),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 blurRadius: 4,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: Center(
//             child: Text(
//               text,
//               style: TextStyle(
//                 fontFamily: GoogleFonts.poppins().fontFamily,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: isHovered ? _primaryColor : _textColor,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: SafeArea(
//           child: Container(
//             color: Colors.white,
//             child: Column(
//               children: [
//                 // Header with X and ✓ buttons
//                 Container(
//                   decoration: BoxDecoration(
//                     color: _primaryColor,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.1),
//                         blurRadius: 4,
//                         offset: const Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       // Close button
//                       Material(
//                         color: Colors.transparent,
//                         child: InkWell(
//                           onTap: () {
//                             if (_hasChanges) {
//                               _showDiscardDialog();
//                             } else {
//                               _navigateToMyActivity();
//                             }
//                           },
//                           borderRadius: BorderRadius.circular(30),
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Icon(
//                               Icons.close,
//                               color: Colors.black87,
//                               size: 28,
//                             ),
//                           ),
//                         ),
//                       ),
//
//                       // Title
//                       Text(
//                         'Log',
//                         style: TextStyle(
//                           fontFamily: GoogleFonts.poppins().fontFamily,
//                           fontSize: 22,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.black87,
//                         ),
//                       ),
//
//                       // Save button
//                       Material(
//                         color: Colors.transparent,
//                         child: InkWell(
//                           onTap: _saveLogEntry,
//                           borderRadius: BorderRadius.circular(30),
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Icon(
//                               Icons.check,
//                               color: Colors.black87,
//                               size: 28,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 // Form fields
//                 Expanded(
//                   child: ListView(
//                     padding: EdgeInsets.zero,
//                     children: [
//                       // Date and Time
//                       _buildListTile(
//                         'Time / Date',
//                         GestureDetector(
//                           onTap: _selectDate,
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 16,
//                               vertical: 12,
//                             ),
//                             decoration: BoxDecoration(
//                               border: Border.all(color: _primaryColor),
//                               borderRadius: BorderRadius.circular(8),
//                               color: Colors.white,
//                             ),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Icon(
//                                   Icons.calendar_today,
//                                   size: 16,
//                                   color: _accentColor,
//                                 ),
//                                 const SizedBox(width: 8),
//                                 Text(
//                                   DateFormat('HH:mm dd/MM/yyyy').format(_selectedDateTime),
//                                   style: TextStyle(
//                                     fontFamily: GoogleFonts.poppins().fontFamily,
//                                     fontSize: 16,
//                                     color: _textColor,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//
//                       // Blood Sugar
//                       _buildListTile(
//                         'Blood Sugar',
//                         Container(
//                           width: 185, // Slightly increase container width
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               Expanded( // Wrap in Expanded
//                                 child: Container(
//                                   height: 48,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(8),
//                                     color: Colors.white,
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Colors.black.withOpacity(0.05),
//                                         blurRadius: 2,
//                                         offset: const Offset(0, 1),
//                                       ),
//                                     ],
//                                   ),
//                                   child: TextField(
//                                     controller: _bloodSugarController,
//                                     keyboardType: const TextInputType.numberWithOptions(decimal: true),
//                                     textAlign: TextAlign.right,
//                                     style: TextStyle(
//                                       fontFamily: GoogleFonts.poppins().fontFamily,
//                                       fontSize: 16,
//                                       color: _textColor,
//                                     ),
//                                     decoration: InputDecoration(
//                                       hintText: '--',
//                                       hintStyle: TextStyle(
//                                         color: Colors.grey[400],
//                                         fontFamily: GoogleFonts.poppins().fontFamily,
//                                       ),
//                                       border: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(8),
//                                         borderSide: BorderSide(color: _primaryColor),
//                                       ),
//                                       enabledBorder: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(8),
//                                         borderSide: BorderSide(color: _primaryColor.withOpacity(0.5)),
//                                       ),
//                                       focusedBorder: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(8),
//                                         borderSide: BorderSide(color: _accentColor, width: 2),
//                                       ),
//                                       contentPadding: const EdgeInsets.symmetric(
//                                         horizontal: 12,
//                                         vertical: 8,
//                                       ),
//                                       filled: true,
//                                       fillColor: Colors.white,
//                                     ),
//                                     // Add input formatter to ensure only valid doubles
//                                     inputFormatters: [
//                                       FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 8), // Reduce spacing
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 12,
//                                   vertical: 8,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: _lightColor,
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: Text(
//                                   'mg/dL',
//                                   style: TextStyle(
//                                     fontFamily: GoogleFonts.poppins().fontFamily,
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w500,
//                                     color: _textColor,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//
//                       // Pills
//                       _buildListTile(
//                         'Pills',
//                         Container(
//                           width: 180,
//                           height: 48,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(8),
//                             color: Colors.white,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.05),
//                                 blurRadius: 2,
//                                 offset: const Offset(0, 1),
//                               ),
//                             ],
//                           ),
//                           child: TextField(
//                             controller: _pillsController,
//                             style: TextStyle(
//                               fontFamily: GoogleFonts.poppins().fontFamily,
//                               fontSize: 16,
//                               color: _textColor,
//                             ),
//                             decoration: InputDecoration(
//                               hintText: 'Optional',
//                               hintStyle: TextStyle(
//                                 color: Colors.grey[400],
//                                 fontFamily: GoogleFonts.poppins().fontFamily,
//                               ),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                                 borderSide: BorderSide(color: _primaryColor),
//                               ),
//                               enabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                                 borderSide: BorderSide(color: _primaryColor.withOpacity(0.5)),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                                 borderSide: BorderSide(color: _accentColor, width: 2),
//                               ),
//                               contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 12,
//                                 vertical: 8,
//                               ),
//                               filled: true,
//                               fillColor: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//
//                       // Blood Pressure
//                       _buildListTile(
//                         'Blood Pressure',
//                         Container(
//                           width: 185,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               Expanded(
//                                 child: GestureDetector(
//                                   onTap: _showBloodPressurePicker,
//                                   child: Container(
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 16,
//                                       vertical: 12,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       border: Border.all(color: _primaryColor.withOpacity(0.5)),
//                                       borderRadius: BorderRadius.circular(8),
//                                       color: Colors.white,
//                                     ),
//                                     child: Text(
//                                       _hasBloodPressure ? '$_systolicValue/$_diastolicValue' : '- / -',
//                                       style: TextStyle(
//                                         fontFamily: GoogleFonts.poppins().fontFamily,
//                                         fontSize: 16,
//                                         color: _hasBloodPressure ? _textColor : Colors.grey[400],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 8),
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 12,
//                                   vertical: 8,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: _lightColor,
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: Text(
//                                   'mmHg',
//                                   style: TextStyle(
//                                     fontFamily: GoogleFonts.poppins().fontFamily,
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w500,
//                                     color: _textColor,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//
//                       // Body Weight
//                       _buildListTile(
//                         'Body Weight',
//                         Container(
//                           width: 185,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               Expanded(
//                                 child: Container(
//                                   height: 48,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(8),
//                                     color: Colors.white,
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Colors.black.withOpacity(0.05),
//                                         blurRadius: 2,
//                                         offset: const Offset(0, 1),
//                                       ),
//                                     ],
//                                   ),
//                                   child: TextField(
//                                     controller: _bodyWeightController,
//                                     keyboardType: const TextInputType.numberWithOptions(decimal: true),
//                                     textAlign: TextAlign.right,
//                                     style: TextStyle(
//                                       fontFamily: GoogleFonts.poppins().fontFamily,
//                                       fontSize: 16,
//                                       color: _textColor,
//                                     ),
//                                     decoration: InputDecoration(
//                                       hintText: '--',
//                                       hintStyle: TextStyle(
//                                         color: Colors.grey[400],
//                                         fontFamily: GoogleFonts.poppins().fontFamily,
//                                       ),
//                                       border: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(8),
//                                         borderSide: BorderSide(color: _primaryColor),
//                                       ),
//                                       enabledBorder: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(8),
//                                         borderSide: BorderSide(color: _primaryColor.withOpacity(0.5)),
//                                       ),
//                                       focusedBorder: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(8),
//                                         borderSide: BorderSide(color: _accentColor, width: 2),
//                                       ),
//                                       contentPadding: const EdgeInsets.symmetric(
//                                         horizontal: 12,
//                                         vertical: 8,
//                                       ),
//                                       filled: true,
//                                       fillColor: Colors.white,
//                                     ),
//                                     // Add input formatter to ensure only valid doubles
//                                     inputFormatters: [
//                                       FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 8),
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 12,
//                                   vertical: 8,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: _lightColor,
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: Text(
//                                   'kg',
//                                   style: TextStyle(
//                                     fontFamily: GoogleFonts.poppins().fontFamily,
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w500,
//                                     color: _textColor,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//
//                       // Blood Sugar Tracking Moment
//                       Container(
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           border: Border(
//                             bottom: BorderSide(color: Colors.grey[200]!),
//                           ),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   'Blood Sugar Tracking Moment',
//                                   style: TextStyle(
//                                     fontFamily: GoogleFonts.poppins().fontFamily,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w600,
//                                     color: _textColor,
//                                   ),
//                                 ),
//                                 Icon(
//                                   Icons.keyboard_arrow_down,
//                                   color: _accentColor,
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 16),
//
//                             // Tracking Moment Dropdown
//                             Container(
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(8),
//                                 color: Colors.white,
//                                 border: Border.all(color: _primaryColor.withOpacity(0.5)),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.05),
//                                     blurRadius: 2,
//                                     offset: const Offset(0, 1),
//                                   ),
//                                 ],
//                               ),
//                               child: DropdownButtonFormField<String>(
//                                 value: _selectedTrackingMoment,
//                                 isExpanded: true,
//                                 hint: Text(
//                                   'Select tracking moment',
//                                   style: TextStyle(
//                                     fontFamily: GoogleFonts.poppins().fontFamily,
//                                     color: Colors.grey[400],
//                                   ),
//                                 ),
//                                 decoration: InputDecoration(
//                                   contentPadding: const EdgeInsets.symmetric(
//                                     horizontal: 16,
//                                     vertical: 12,
//                                   ),
//                                   border: InputBorder.none,
//                                   filled: true,
//                                   fillColor: Colors.white,
//                                 ),
//                                 icon: Icon(
//                                   Icons.arrow_drop_down,
//                                   color: _accentColor,
//                                 ),
//                                 style: TextStyle(
//                                   fontFamily: GoogleFonts.poppins().fontFamily,
//                                   fontSize: 16,
//                                   color: _textColor,
//                                 ),
//                                 onChanged: (String? newValue) {
//                                   setState(() {
//                                     _selectedTrackingMoment = newValue;
//                                     // Reset meal time when tracking moment changes
//                                     _selectedMealTime = null;
//                                     _onFormChanged();
//                                   });
//                                 },
//                                 items: <String>[
//                                   'Breakfast',
//                                   'Lunch',
//                                   'Snacks',
//                                   'Dinner',
//                                   'Fasting'
//                                 ].map<DropdownMenuItem<String>>((String value) {
//                                   return DropdownMenuItem<String>(
//                                     value: value,
//                                     child: Text(
//                                       value,
//                                       style: TextStyle(
//                                         fontFamily: GoogleFonts.poppins().fontFamily,
//                                       ),
//                                     ),
//                                   );
//                                 }).toList(),
//                               ),
//                             ),
//
//                             // Show meal time options if tracking moment is selected
//                             if (_selectedTrackingMoment != null) ...[
//                               const SizedBox(height: 16),
//                               Container(
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(8),
//                                   color: Colors.white,
//                                   border: Border.all(color: _primaryColor.withOpacity(0.5)),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black.withOpacity(0.05),
//                                       blurRadius: 2,
//                                       offset: const Offset(0, 1),
//                                     ),
//                                   ],
//                                 ),
//                                 child: DropdownButtonFormField<String>(
//                                   value: _selectedMealTime,
//                                   isExpanded: true,
//                                   hint: Text(
//                                     _selectedTrackingMoment == 'Fasting'
//                                         ? 'Select consuming time'
//                                         : 'Select meal time',
//                                     style: TextStyle(
//                                       fontFamily: GoogleFonts.poppins().fontFamily,
//                                       color: Colors.grey[400],
//                                     ),
//                                   ),
//                                   decoration: InputDecoration(
//                                     contentPadding: const EdgeInsets.symmetric(
//                                       horizontal: 16,
//                                       vertical: 12,
//                                     ),
//                                     border: InputBorder.none,
//                                     filled: true,
//                                     fillColor: Colors.white,
//                                   ),
//                                   icon: Icon(
//                                     Icons.arrow_drop_down,
//                                     color: _accentColor,
//                                   ),
//                                   style: TextStyle(
//                                     fontFamily: GoogleFonts.poppins().fontFamily,
//                                     fontSize: 16,
//                                     color: _textColor,
//                                   ),
//                                   onChanged: (String? newValue) {
//                                     setState(() {
//                                       _selectedMealTime = newValue;
//                                       _onFormChanged();
//                                     });
//                                   },
//                                   items: _getMealTimeOptions()
//                                       .map<DropdownMenuItem<String>>((String value) {
//                                     return DropdownMenuItem<String>(
//                                       value: value,
//                                       child: Text(
//                                         value,
//                                         style: TextStyle(
//                                           fontFamily: GoogleFonts.poppins().fontFamily,
//                                         ),
//                                       ),
//                                     );
//                                   }).toList(),
//                                 ),
//                               ),
//                             ],
//                           ],
//                         ),
//                       ),
//
//                       // Food Type
//                       Container(
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           border: Border(
//                             bottom: BorderSide(color: Colors.grey[200]!),
//                           ),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   'Food Type',
//                                   style: TextStyle(
//                                     fontFamily: GoogleFonts.poppins().fontFamily,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w600,
//                                     color: _textColor,
//                                   ),
//                                 ),
//                                 Icon(
//                                   Icons.keyboard_arrow_down,
//                                   color: _accentColor,
//                                 ),
//                               ],
//                             ),
//
//                             // Show food type dropdown if tracking moment is selected
//                             if (_selectedTrackingMoment != null) ...[
//                               const SizedBox(height: 16),
//                               Container(
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(8),
//                                   color: Colors.white,
//                                   border: Border.all(color: _primaryColor.withOpacity(0.5)),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black.withOpacity(0.05),
//                                       blurRadius: 2,
//                                       offset: const Offset(0, 1),
//                                     ),
//                                   ],
//                                 ),
//                                 child: DropdownButtonFormField<String>(
//                                   value: _selectedFoodType,
//                                   isExpanded: true,
//                                   hint: Text(
//                                     'Select food type',
//                                     style: TextStyle(
//                                       fontFamily: GoogleFonts.poppins().fontFamily,
//                                       color: Colors.grey[400],
//                                     ),
//                                   ),
//                                   decoration: InputDecoration(
//                                     contentPadding: const EdgeInsets.symmetric(
//                                       horizontal: 16,
//                                       vertical: 12,
//                                     ),
//                                     border: InputBorder.none,
//                                     filled: true,
//                                     fillColor: Colors.white,
//                                   ),
//                                   icon: Icon(
//                                     Icons.arrow_drop_down,
//                                     color: _accentColor,
//                                   ),
//                                   style: TextStyle(
//                                     fontFamily: GoogleFonts.poppins().fontFamily,
//                                     fontSize: 16,
//                                     color: _textColor,
//                                   ),
//                                   onChanged: (String? newValue) {
//                                     setState(() {
//                                       _selectedFoodType = newValue;
//                                       _onFormChanged();
//                                     });
//                                   },
//                                   items: _getFoodOptions()
//                                       .map<DropdownMenuItem<String>>((String value) {
//                                     return DropdownMenuItem<String>(
//                                       value: value,
//                                       child: Text(
//                                         value,
//                                         style: TextStyle(
//                                           fontFamily: GoogleFonts.poppins().fontFamily,
//                                         ),
//                                       ),
//                                     );
//                                   }).toList(),
//                                 ),
//                               ),
//                             ],
//                           ],
//                         ),
//                       ),
//
//                       // Spacer
//                       const SizedBox(height: 20),
//                     ],
//                   ),
//                 ),
//
//                 // Action Buttons
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.05),
//                         blurRadius: 4,
//                         offset: const Offset(0, -2),
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     children: [
//                       // Clear button
//                       Expanded(
//                         child: StatefulBuilder(
//                           builder: (context, setState) => GestureDetector(
//                             onTapDown: (_) => setState(() => _isClearHovered = true),
//                             onTapUp: (_) {
//                               setState(() => _isClearHovered = false);
//                               _clearForm();
//                             },
//                             onTapCancel: () => setState(() => _isClearHovered = false),
//                             child: AnimatedContainer(
//                               duration: const Duration(milliseconds: 150),
//                               height: 50,
//                               decoration: BoxDecoration(
//                                 color: _isClearHovered ? _textColor : _primaryColor,
//                                 borderRadius: BorderRadius.circular(10),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.1),
//                                     blurRadius: 4,
//                                     offset: const Offset(0, 2),
//                                   ),
//                                 ],
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   'Clear',
//                                   style: TextStyle(
//                                     fontFamily: GoogleFonts.poppins().fontFamily,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w600,
//                                     color: _isClearHovered ? _primaryColor : _textColor,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 16),
//                       // Save button
//                       Expanded(
//                         child: StatefulBuilder(
//                           builder: (context, setState) => GestureDetector(
//                             onTapDown: (_) => setState(() => _isSaveHovered = true),
//                             onTapUp: (_) {
//                               setState(() => _isSaveHovered = false);
//                               _saveLogEntry();
//                             },
//                             onTapCancel: () => setState(() => _isSaveHovered = false),
//                             child: AnimatedContainer(
//                               duration: const Duration(milliseconds: 150),
//                               height: 50,
//                               decoration: BoxDecoration(
//                                 color: _isSaveHovered ? _textColor : _primaryColor,
//                                 borderRadius: BorderRadius.circular(10),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.1),
//                                     blurRadius: 4,
//                                     offset: const Offset(0, 2),
//                                   ),
//                                 ],
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   'Save',
//                                   style: TextStyle(
//                                     fontFamily: GoogleFonts.poppins().fontFamily,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w600,
//                                     color: _isSaveHovered ? _primaryColor : _textColor,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Helper method to build list tiles
//   Widget _buildListTile(String title, Widget content) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         border: Border(
//           bottom: BorderSide(color: Colors.grey[200]!),
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: TextStyle(
//               fontFamily: GoogleFonts.poppins().fontFamily,
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: _textColor,
//             ),
//           ),
//           content,
//         ],
//       ),
//     );
//   }
// }
//

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import '../MyActivity/MyActivity.dart';

class LogEntryScreen extends StatefulWidget {
  final Map<String, dynamic>? logEntry;

  const LogEntryScreen({Key? key, this.logEntry}) : super(key: key);

  @override
  _LogInterfaceState createState() => _LogInterfaceState();
}

class _LogInterfaceState extends State<LogEntryScreen> {
  // Form controllers
  final TextEditingController _bloodSugarController = TextEditingController();
  final TextEditingController _pillsController = TextEditingController();
  final TextEditingController _bodyWeightController = TextEditingController();

  // Blood pressure values
  int _systolicValue = 120; // Default value
  int _diastolicValue = 80; // Default value
  bool _hasBloodPressure = false;

  // Selected values
  DateTime _selectedDateTime = DateTime.now();
  String? _selectedTrackingMoment;
  String? _selectedMealTime;
  String? _selectedFoodType;

  // Tracking if user has made changes
  bool _hasChanges = false;

  // Colors from the provided palette
  final Color _primaryColor = const Color(0xFF89D0ED); // Medium blue
  final Color _accentColor = const Color(0xFF5FB8DD);  // Medium-bright blue
  final Color _lightColor = const Color(0xFFAEECFF);   // Light blue
  final Color _veryLightColor = const Color(0xFFC5EDFF); // Very light blue
  final Color _tealColor = const Color(0xFF5EB7CF);    // Blue-teal
  final Color _textColor = const Color(0xFF2C3E50);    // Dark blue-gray
  final Color _labelColor = const Color(0xFF7F8C8D);   // Medium gray

  // Button states
  bool _isSaveHovered = false;
  bool _isClearHovered = false;

  // Scroll controllers for blood pressure
  final FixedExtentScrollController _systolicScrollController = FixedExtentScrollController(initialItem: 70); // 120 - 50
  final FixedExtentScrollController _diastolicScrollController = FixedExtentScrollController(initialItem: 60); // 80 - 20

  // Loading state
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    // Add listeners to detect changes
    _bloodSugarController.addListener(_onFormChanged);
    _pillsController.addListener(_onFormChanged);
    _bodyWeightController.addListener(_onFormChanged);

    // Load data from logEntry if editing an existing entry
    if (widget.logEntry != null) {
      // Set blood sugar
      if (widget.logEntry!['bloodSugar'] != null) {
        _bloodSugarController.text = widget.logEntry!['bloodSugar'].toString();
      }

      // Set pills
      if (widget.logEntry!['pills'] != null) {
        _pillsController.text = widget.logEntry!['pills'];
      }

      // Set body weight
      if (widget.logEntry!['bodyWeight'] != null) {
        _bodyWeightController.text = widget.logEntry!['bodyWeight'].toString();
      }

      // Set blood pressure
      if (widget.logEntry!['bloodPressure'] != null) {
        final bpParts = widget.logEntry!['bloodPressure'].toString().split('/');
        if (bpParts.length == 2) {
          try {
            _systolicValue = int.parse(bpParts[0]);
            _diastolicValue = int.parse(bpParts[1]);
            _hasBloodPressure = true;
          } catch (e) {
            print('Error parsing blood pressure: $e');
          }
        }
      }

      // Set date
      if (widget.logEntry!['date'] != null) {
        _selectedDateTime = (widget.logEntry!['date'] as Timestamp).toDate();
      }

      // Set tracking moment
      if (widget.logEntry!['trackingMoment'] != null) {
        _selectedTrackingMoment = widget.logEntry!['trackingMoment'];
      }

      // Set meal time
      if (widget.logEntry!['mealTime'] != null) {
        _selectedMealTime = widget.logEntry!['mealTime'];
      }

      // Set food type
      if (widget.logEntry!['foodType'] != null) {
        _selectedFoodType = widget.logEntry!['foodType'];
      }

      // Mark as having changes to enable save button
      _hasChanges = true;
    }
  }

  void _onFormChanged() {
    setState(() {
      _hasChanges = _bloodSugarController.text.isNotEmpty ||
          _pillsController.text.isNotEmpty ||
          _bodyWeightController.text.isNotEmpty ||
          _hasBloodPressure ||
          _selectedTrackingMoment != null ||
          _selectedMealTime != null ||
          _selectedFoodType != null;
    });
  }

  @override
  void dispose() {
    _bloodSugarController.dispose();
    _pillsController.dispose();
    _bodyWeightController.dispose();
    _systolicScrollController.dispose();
    _diastolicScrollController.dispose();
    super.dispose();
  }

  // Show date picker
  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: _accentColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: _textColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: _accentColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      _selectTime(pickedDate);
    }
  }

  // Show time picker
  Future<void> _selectTime(DateTime pickedDate) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: _accentColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: _textColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: _accentColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      setState(() {
        _selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        _onFormChanged();
      });
    }
  }

  // Get food options based on tracking moment
  List<String> _getFoodOptions() {
    if (_selectedTrackingMoment == 'Fasting') {
      return ['Water', 'Soft Drink', 'Diet Soda', 'Milk'];
    }
    return [
      'Water', 'Vegetable', 'Fruit', 'Grain', 'Dairy',
      'Egg', 'Fish', 'Meal', 'Nuts', 'Sweets',
      'Alcohol', 'Diet Soda', 'Soft Drink', 'Fast Food'
    ];
  }

  // Get meal time options based on tracking moment
  List<String> _getMealTimeOptions() {
    if (_selectedTrackingMoment == 'Fasting') {
      return ['Before consuming', 'After consuming'];
    }
    return ['Before meal', 'After meal'];
  }

  // Clear all form fields
  void _clearForm() {
    setState(() {
      _bloodSugarController.clear();
      _pillsController.clear();
      _bodyWeightController.clear();
      _systolicValue = 120;
      _diastolicValue = 80;
      _hasBloodPressure = false;
      _selectedTrackingMoment = null;
      _selectedMealTime = null;
      _selectedFoodType = null;
      _selectedDateTime = DateTime.now();
      _hasChanges = false;

      // Reset scroll controllers
      _systolicScrollController.jumpToItem(70); // 120 - 50
      _diastolicScrollController.jumpToItem(60); // 80 - 20
    });
  }

  // Check if any data has been entered
  bool _hasAnyData() {
    return _bloodSugarController.text.isNotEmpty ||
        _pillsController.text.isNotEmpty ||
        _bodyWeightController.text.isNotEmpty ||
        _hasBloodPressure ||
        _selectedTrackingMoment != null ||
        _selectedMealTime != null ||
        _selectedFoodType != null;
  }

  // Show empty fields alert
  void _showEmptyFieldsAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'No Data Entered',
            style: TextStyle(
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.bold,
              color: _textColor,
            ),
          ),
          content: Text(
            'Please enter at least one field before saving.',
            style: TextStyle(
              fontFamily: GoogleFonts.poppins().fontFamily,
              color: _textColor,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text(
                'OK',
                style: TextStyle(
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _accentColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Save log entry to Firestore
  Future<void> _saveLogEntry() async {
    // Check if already saving to prevent multiple attempts
    if (_isSaving) return;

    // Check if any data has been entered
    if (!_hasAnyData()) {
      _showEmptyFieldsAlert();
      return;
    }

    // Validate blood sugar is a valid double if entered
    if (_bloodSugarController.text.isNotEmpty) {
      try {
        double.parse(_bloodSugarController.text);
      } catch (e) {
        _showSnackBar('Blood sugar must be a valid number');
        return;
      }
    }

    // Validate body weight is a valid double if entered
    if (_bodyWeightController.text.isNotEmpty) {
      try {
        double.parse(_bodyWeightController.text);
      } catch (e) {
        _showSnackBar('Body weight must be a valid number');
        return;
      }
    }

    // Check if user is authenticated
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('Authentication error: No user is currently signed in');
      _showSnackBar('You must be logged in to save data');
      return;
    }

    // Set saving state to true
    setState(() {
      _isSaving = true;
    });

    print('Attempting to save data for user: ${user.uid}');

    // Show loading dialog
    BuildContext? dialogContext;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        dialogContext = context;
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(_accentColor),
                ),
                const SizedBox(height: 16),
                Text(
                  'Saving...',
                  style: TextStyle(
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    color: _textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    try {
      // Check if we're editing an existing entry
      final String? existingId = widget.logEntry != null ? widget.logEntry!['id'] as String? : null;

      // Create data map
      final data = {
        'userId': user.uid,
        'date': Timestamp.fromDate(_selectedDateTime),
        'bloodSugar': _bloodSugarController.text.isEmpty
            ? null
            : double.parse(_bloodSugarController.text),
        'pills': _pillsController.text.isEmpty ? null : _pillsController.text,
        'bloodPressure': _hasBloodPressure
            ? '$_systolicValue/$_diastolicValue'
            : null,
        'bodyWeight': _bodyWeightController.text.isEmpty
            ? null
            : double.parse(_bodyWeightController.text),
        'trackingMoment': _selectedTrackingMoment,
        'mealTime': _selectedMealTime,
        'foodType': _selectedFoodType,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      };

      // Remove null values
      data.removeWhere((key, value) => value == null);

      // Save to Firestore
      if (existingId != null) {
        // Update existing document
        await FirebaseFirestore.instance.collection('logEntries').doc(existingId).update(data);
        print('Document updated successfully with ID: $existingId');
      } else {
        // Create new document
        final docRef = await FirebaseFirestore.instance.collection('logEntries').add(data);
        print('Document saved successfully with ID: ${docRef.id}');
      }

      // Ensure we close the dialog first
      if (dialogContext != null && Navigator.of(dialogContext!).canPop()) {
        Navigator.of(dialogContext!).pop();
      }

      // Reset saving state
      setState(() {
        _isSaving = false;
      });

      // Show success message
      _showSnackBar('Log entry ${existingId != null ? 'updated' : 'saved'} successfully', isSuccess: true);

      // Navigate back to MyActivity after a short delay to ensure dialog is closed
      Future.delayed(Duration(milliseconds: 100), () {
        _navigateToMyActivity();
      });

    } catch (e) {
      print('Error saving log entry: $e');

      // Ensure we close the dialog
      if (dialogContext != null && Navigator.of(dialogContext!).canPop()) {
        Navigator.of(dialogContext!).pop();
      }

      // Reset saving state
      setState(() {
        _isSaving = false;
      });

      // Show error message
      _showSnackBar('Error saving log entry: $e');
    }
  }

  // Show a snackbar message
  void _showSnackBar(String message, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(10),
      ),
    );
  }

  // Show loading dialog
  // void _showLoadingDialog() {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         backgroundColor: Colors.white,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(15),
  //         ),
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(vertical: 20),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               CircularProgressIndicator(
  //                 valueColor: AlwaysStoppedAnimation<Color>(_accentColor),
  //               ),
  //               const SizedBox(height: 16),
  //               Text(
  //                 'Saving...',
  //                 style: TextStyle(
  //                   fontFamily: GoogleFonts.poppins().fontFamily,
  //                   color: _textColor,
  //                   fontWeight: FontWeight.w500,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // Navigate to MyActivity
  void _navigateToMyActivity() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const MyActivityScreen()),
    );
  }

  // Show discard confirmation dialog
  Future<void> _showDiscardDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Unsaved Entry',
            style: TextStyle(
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.bold,
              color: _textColor,
            ),
          ),
          content: Text(
            'Your log entry has not been saved. Are you sure you want to discard?',
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
                'Discard',
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
                // Navigate to MyActivity interface
                _navigateToMyActivity();
              },
            ),
          ],
        );
      },
    );
  }

  // Show blood pressure picker
  void _showBloodPressurePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                            color: _accentColor,
                          ),
                        ),
                      ),
                      Text(
                        'Blood Pressure',
                        style: TextStyle(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: _textColor,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          this.setState(() {
                            _hasBloodPressure = true;
                            _onFormChanged();
                          });
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Done',
                          style: TextStyle(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w600,
                            color: _accentColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Row(
                      children: [
                        // Systolic picker (50-300)
                        Expanded(
                          child: ListWheelScrollView.useDelegate(
                            controller: _systolicScrollController,
                            itemExtent: 50,
                            perspective: 0.005,
                            diameterRatio: 1.5,
                            physics: const FixedExtentScrollPhysics(),
                            onSelectedItemChanged: (index) {
                              setState(() {
                                _systolicValue = index + 50; // Start from 50
                              });
                            },
                            childDelegate: ListWheelChildBuilderDelegate(
                              childCount: 251, // 300 - 50 + 1
                              builder: (context, index) {
                                final value = index + 50;
                                return Center(
                                  child: Text(
                                    value.toString(),
                                    style: TextStyle(
                                      fontFamily: GoogleFonts.poppins().fontFamily,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500,
                                      color: _systolicValue == value
                                          ? _accentColor
                                          : _textColor.withOpacity(0.5),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        // Separator
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            '/',
                            style: TextStyle(
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: _textColor,
                            ),
                          ),
                        ),

                        // Diastolic picker (20-200)
                        Expanded(
                          child: ListWheelScrollView.useDelegate(
                            controller: _diastolicScrollController,
                            itemExtent: 50,
                            perspective: 0.005,
                            diameterRatio: 1.5,
                            physics: const FixedExtentScrollPhysics(),
                            onSelectedItemChanged: (index) {
                              setState(() {
                                _diastolicValue = index + 20; // Start from 20
                              });
                            },
                            childDelegate: ListWheelChildBuilderDelegate(
                              childCount: 181, // 200 - 20 + 1
                              builder: (context, index) {
                                final value = index + 20;
                                return Center(
                                  child: Text(
                                    value.toString(),
                                    style: TextStyle(
                                      fontFamily: GoogleFonts.poppins().fontFamily,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500,
                                      color: _diastolicValue == value
                                          ? _accentColor
                                          : _textColor.withOpacity(0.5),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Handle back button press
  Future<bool> _onWillPop() async {
    if (_hasChanges) {
      await _showDiscardDialog();
      return false;
    }
    _navigateToMyActivity();
    return false;
  }

  // Custom button widget with color swap effect
  Widget _buildCustomButton({
    required String text,
    required VoidCallback onPressed,
    required bool isHovered,
    required Function(bool) onHover,
  }) {
    return MouseRegion(
      onEnter: (_) => onHover(true),
      onExit: (_) => onHover(false),
      child: GestureDetector(
        onTapDown: (_) => onHover(true),
        onTapUp: (_) {
          onHover(false);
          onPressed();
        },
        onTapCancel: () => onHover(false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 50,
          decoration: BoxDecoration(
            color: isHovered ? _textColor : _primaryColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isHovered ? _primaryColor : _textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                // Header with X and ✓ buttons
                Container(
                  decoration: BoxDecoration(
                    color: _primaryColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Close button
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            if (_hasChanges) {
                              _showDiscardDialog();
                            } else {
                              _navigateToMyActivity();
                            }
                          },
                          borderRadius: BorderRadius.circular(30),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.close,
                              color: Colors.black87,
                              size: 28,
                            ),
                          ),
                        ),
                      ),

                      // Title
                      Text(
                        'Log',
                        style: TextStyle(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),

                      // Save button
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _isSaving ? null : _saveLogEntry,
                          borderRadius: BorderRadius.circular(30),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.check,
                              color: _isSaving ? Colors.grey : Colors.black87,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Form fields
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      // Date and Time
                      _buildListTile(
                        'Time / Date',
                        GestureDetector(
                          onTap: _selectDate,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: _primaryColor),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: _accentColor,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  DateFormat('HH:mm dd/MM/yyyy').format(_selectedDateTime),
                                  style: TextStyle(
                                    fontFamily: GoogleFonts.poppins().fontFamily,
                                    fontSize: 16,
                                    color: _textColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Blood Sugar
                      _buildListTile(
                        'Blood Sugar',
                        Container(
                          width: 185, // Slightly increase container width
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded( // Wrap in Expanded
                                child: Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 2,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: TextField(
                                    controller: _bloodSugarController,
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontFamily: GoogleFonts.poppins().fontFamily,
                                      fontSize: 16,
                                      color: _textColor,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: '--',
                                      hintStyle: TextStyle(
                                        color: Colors.grey[400],
                                        fontFamily: GoogleFonts.poppins().fontFamily,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(color: _primaryColor),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(color: _primaryColor.withOpacity(0.5)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(color: _accentColor, width: 2),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    // Add input formatter to ensure only valid doubles
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8), // Reduce spacing
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: _lightColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'mg/dL',
                                  style: TextStyle(
                                    fontFamily: GoogleFonts.poppins().fontFamily,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: _textColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Pills
                      _buildListTile(
                        'Pills',
                        Container(
                          width: 180,
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _pillsController,
                            style: TextStyle(
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontSize: 16,
                              color: _textColor,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Optional',
                              hintStyle: TextStyle(
                                color: Colors.grey[400],
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: _primaryColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: _primaryColor.withOpacity(0.5)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: _accentColor, width: 2),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      // Blood Pressure
                      _buildListTile(
                        'Blood Pressure',
                        Container(
                          width: 185,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: _showBloodPressurePicker,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: _primaryColor.withOpacity(0.5)),
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white,
                                    ),
                                    child: Text(
                                      _hasBloodPressure ? '$_systolicValue/$_diastolicValue' : '- / -',
                                      style: TextStyle(
                                        fontFamily: GoogleFonts.poppins().fontFamily,
                                        fontSize: 16,
                                        color: _hasBloodPressure ? _textColor : Colors.grey[400],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: _lightColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'mmHg',
                                  style: TextStyle(
                                    fontFamily: GoogleFonts.poppins().fontFamily,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: _textColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Body Weight
                      _buildListTile(
                        'Body Weight',
                        Container(
                          width: 185,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 2,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: TextField(
                                    controller: _bodyWeightController,
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontFamily: GoogleFonts.poppins().fontFamily,
                                      fontSize: 16,
                                      color: _textColor,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: '--',
                                      hintStyle: TextStyle(
                                        color: Colors.grey[400],
                                        fontFamily: GoogleFonts.poppins().fontFamily,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(color: _primaryColor),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(color: _primaryColor.withOpacity(0.5)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(color: _accentColor, width: 2),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    // Add input formatter to ensure only valid doubles
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: _lightColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'kg',
                                  style: TextStyle(
                                    fontFamily: GoogleFonts.poppins().fontFamily,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: _textColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Blood Sugar Tracking Moment
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey[200]!),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Blood Sugar Tracking Moment',
                                  style: TextStyle(
                                    fontFamily: GoogleFonts.poppins().fontFamily,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: _textColor,
                                  ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: _accentColor,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Tracking Moment Dropdown
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                                border: Border.all(color: _primaryColor.withOpacity(0.5)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 2,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: DropdownButtonFormField<String>(
                                value: _selectedTrackingMoment,
                                isExpanded: true,
                                hint: Text(
                                  'Select tracking moment',
                                  style: TextStyle(
                                    fontFamily: GoogleFonts.poppins().fontFamily,
                                    color: Colors.grey[400],
                                  ),
                                ),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  border: InputBorder.none,
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: _accentColor,
                                ),
                                style: TextStyle(
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontSize: 16,
                                  color: _textColor,
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedTrackingMoment = newValue;
                                    // Reset meal time when tracking moment changes
                                    _selectedMealTime = null;
                                    _onFormChanged();
                                  });
                                },
                                items: <String>[
                                  'Breakfast',
                                  'Lunch',
                                  'Snacks',
                                  'Dinner',
                                  'Fasting'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                        fontFamily: GoogleFonts.poppins().fontFamily,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),

                            // Show meal time options if tracking moment is selected
                            if (_selectedTrackingMoment != null) ...[
                              const SizedBox(height: 16),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  border: Border.all(color: _primaryColor.withOpacity(0.5)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 2,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: DropdownButtonFormField<String>(
                                  value: _selectedMealTime,
                                  isExpanded: true,
                                  hint: Text(
                                    _selectedTrackingMoment == 'Fasting'
                                        ? 'Select consuming time'
                                        : 'Select meal time',
                                    style: TextStyle(
                                      fontFamily: GoogleFonts.poppins().fontFamily,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    border: InputBorder.none,
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: _accentColor,
                                  ),
                                  style: TextStyle(
                                    fontFamily: GoogleFonts.poppins().fontFamily,
                                    fontSize: 16,
                                    color: _textColor,
                                  ),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedMealTime = newValue;
                                      _onFormChanged();
                                    });
                                  },
                                  items: _getMealTimeOptions()
                                      .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                          fontFamily: GoogleFonts.poppins().fontFamily,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      // Food Type
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey[200]!),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Food Type',
                                  style: TextStyle(
                                    fontFamily: GoogleFonts.poppins().fontFamily,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: _textColor,
                                  ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: _accentColor,
                                ),
                              ],
                            ),

                            // Show food type dropdown if tracking moment is selected
                            if (_selectedTrackingMoment != null) ...[
                              const SizedBox(height: 16),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  border: Border.all(color: _primaryColor.withOpacity(0.5)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 2,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: DropdownButtonFormField<String>(
                                  value: _selectedFoodType,
                                  isExpanded: true,
                                  hint: Text(
                                    'Select food type',
                                    style: TextStyle(
                                      fontFamily: GoogleFonts.poppins().fontFamily,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    border: InputBorder.none,
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: _accentColor,
                                  ),
                                  style: TextStyle(
                                    fontFamily: GoogleFonts.poppins().fontFamily,
                                    fontSize: 16,
                                    color: _textColor,
                                  ),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedFoodType = newValue;
                                      _onFormChanged();
                                    });
                                  },
                                  items: _getFoodOptions()
                                      .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                          fontFamily: GoogleFonts.poppins().fontFamily,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      // Spacer
                      const SizedBox(height: 20),
                    ],
                  ),
                ),

                // Action Buttons
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Clear button
                      Expanded(
                        child: StatefulBuilder (
                          builder: (context, setState) => GestureDetector (
                            onTapDown: (_) => setState(() => _isClearHovered = true),
                            onTapUp: (_) {
                              setState(() => _isClearHovered = false);
                              _clearForm();
                            },
                            onTapCancel: () => setState(() => _isClearHovered = false),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              height: 50,
                              decoration: BoxDecoration(
                                color: _isClearHovered ? _textColor : _primaryColor,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  'Clear',
                                  style: TextStyle(
                                    fontFamily: GoogleFonts.poppins().fontFamily,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: _isClearHovered ? _primaryColor : _textColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Save button
                      Expanded(
                        child: StatefulBuilder(
                          builder: (context, setState) => GestureDetector(
                            onTapDown: (_) => setState(() => _isSaveHovered = true),
                            onTapUp: (_) {
                              setState(() => _isSaveHovered = false);
                              _saveLogEntry();
                            },
                            onTapCancel: () => setState(() => _isSaveHovered = false),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              height: 50,
                              decoration: BoxDecoration(
                                color: _isSaveHovered ? _textColor : _primaryColor,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                    fontFamily: GoogleFonts.poppins().fontFamily,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: _isSaveHovered ? _primaryColor : _textColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build list tiles
  Widget _buildListTile(String title, Widget content) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: _textColor,
            ),
          ),
          content,
        ],
      ),
    );
  }
}

