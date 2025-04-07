// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:provider/provider.dart';
// import 'package:mybete_app/have_diabetes/DashBoard/Reminder/reminder_model.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as tz_init;
// import 'dart:convert';
//
//
// // Global notifications plugin that can be initialized in main.dart
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// FlutterLocalNotificationsPlugin();
//
// // Initialize notifications (call this in main.dart)
// Future<void> initNotifications() async {
//   tz_init.initializeTimeZones();
//
//   const AndroidInitializationSettings initializationSettingsAndroid =
//   AndroidInitializationSettings('@mipmap/ic_launcher');
//   final DarwinInitializationSettings initializationSettingsIOS =
//   DarwinInitializationSettings(
//     requestAlertPermission: true,
//     requestBadgePermission: true,
//     requestSoundPermission: true,
//   );
//   final InitializationSettings initializationSettings = InitializationSettings(
//     android: initializationSettingsAndroid,
//     iOS: initializationSettingsIOS,
//   );
//   await flutterLocalNotificationsPlugin.initialize(
//     initializationSettings,
//   );
// }
//
// // Reminder model
// class Reminder {
//   String id;
//   String title;
//   String type; // "one-time" or "repeat"
//   DateTime? date;
//   String time;
//   String? repeatType; // "daily" or "custom"
//   DateTime? startsOn;
//   DateTime? endsOn;
//   bool? neverEnds;
//   String? note;
//   bool isActive;
//
//   Reminder({
//     required this.id,
//     required this.title,
//     required this.type,
//     this.date,
//     required this.time,
//     this.repeatType,
//     this.startsOn,
//     this.endsOn,
//     this.neverEnds,
//     this.note,
//     required this.isActive,
//   });
//
//   // Convert Reminder to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'title': title,
//       'type': type,
//       'date': date?.toIso8601String(),
//       'time': time,
//       'repeatType': repeatType,
//       'startsOn': startsOn?.toIso8601String(),
//       'endsOn': endsOn?.toIso8601String(),
//       'neverEnds': neverEnds,
//       'note': note,
//       'isActive': isActive,
//     };
//   }
//
//   // Create Reminder from JSON
//   factory Reminder.fromJson(Map<String, dynamic> json) {
//     return Reminder(
//       id: json['id'],
//       title: json['title'],
//       type: json['type'],
//       date: json['date'] != null ? DateTime.parse(json['date']) : null,
//       time: json['time'],
//       repeatType: json['repeatType'],
//       startsOn: json['startsOn'] != null ? DateTime.parse(json['startsOn']) : null,
//       endsOn: json['endsOn'] != null ? DateTime.parse(json['endsOn']) : null,
//       neverEnds: json['neverEnds'],
//       note: json['note'],
//       isActive: json['isActive'],
//     );
//   }
// }
//
// // Reminder Management Screen
// class RemindersScreen extends StatefulWidget {
//   const RemindersScreen({Key? key}) : super(key: key);
//
//   @override
//   State<RemindersScreen> createState() => _RemindersScreenState();
// }
//
// class _RemindersScreenState extends State<RemindersScreen> {
//   List<Reminder> reminders = [];
//   bool showSearch = false;
//   String searchQuery = "";
//   TextEditingController searchController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _loadReminders();
//   }
//
//   // Load reminders from SharedPreferences
//   Future<void> _loadReminders() async {
//     final prefs = await SharedPreferences.getInstance();
//     final String? remindersJson = prefs.getString('diabetesReminders');
//
//     if (remindersJson != null) {
//       try {
//         final List<dynamic> decodedList = jsonDecode(remindersJson);
//         setState(() {
//           reminders = decodedList.map((item) => Reminder.fromJson(item)).toList();
//         });
//         _scheduleNotifications();
//       } catch (e) {
//         debugPrint('Error parsing saved reminders: $e');
//       }
//     }
//   }
//
//   // Save reminders to SharedPreferences
//   Future<void> _saveReminders() async {
//     final prefs = await SharedPreferences.getInstance();
//     final String encodedData = jsonEncode(reminders.map((e) => e.toJson()).toList());
//     await prefs.setString('diabetesReminders', encodedData);
//     _scheduleNotifications();
//   }
//
//   // Schedule notifications for all active reminders
//   Future<void> _scheduleNotifications() async {
//     // Cancel all existing notifications
//     await flutterLocalNotificationsPlugin.cancelAll();
//
//     // Schedule new notifications for active reminders
//     for (var reminder in reminders) {
//       if (!reminder.isActive) continue;
//
//       // Parse time
//       final List<String> timeParts = reminder.time.split(':');
//       final int hour = int.parse(timeParts[0]);
//       final int minute = int.parse(timeParts[1]);
//
//       if (reminder.type == 'one-time' && reminder.date != null) {
//         // Schedule one-time notification
//         final DateTime scheduledDate = DateTime(
//           reminder.date!.year,
//           reminder.date!.month,
//           reminder.date!.day,
//           hour,
//           minute,
//         );
//
//         // Only schedule if it's in the future
//         if (scheduledDate.isAfter(DateTime.now())) {
//           await _scheduleNotification(
//             id: reminder.id.hashCode,
//             title: 'Diabetes App Reminder',
//             body: reminder.title,
//             scheduledDate: scheduledDate,
//           );
//         }
//       } else if (reminder.type == 'repeat') {
//         // For repeating reminders, we need to handle differently
//         if (reminder.repeatType == 'daily') {
//           // Schedule daily notification
//           await _scheduleDailyNotification(
//             id: reminder.id.hashCode,
//             title: 'Diabetes App Reminder',
//             body: reminder.title,
//             hour: hour,
//             minute: minute,
//           );
//         } else if (reminder.repeatType == 'custom' && reminder.startsOn != null) {
//           // Schedule custom notification
//           final DateTime startDate = DateTime(
//             reminder.startsOn!.year,
//             reminder.startsOn!.month,
//             reminder.startsOn!.day,
//             hour,
//             minute,
//           );
//
//           // Only schedule if start date is in the future or today
//           if (startDate.isAfter(DateTime.now()) ||
//               (startDate.year == DateTime.now().year &&
//                   startDate.month == DateTime.now().month &&
//                   startDate.day == DateTime.now().day)) {
//
//             await _scheduleDailyNotification(
//               id: reminder.id.hashCode,
//               title: 'Diabetes App Reminder',
//               body: reminder.title,
//               hour: hour,
//               minute: minute,
//               startDate: startDate,
//               endDate: reminder.neverEnds == true ? null : reminder.endsOn,
//             );
//           }
//         }
//       }
//     }
//   }
//
//   // Schedule a one-time notification
//   Future<void> _scheduleNotification({
//     required int id,
//     required String title,
//     required String body,
//     required DateTime scheduledDate,
//   }) async {
//     final tz.TZDateTime tzScheduledDate = tz.TZDateTime.from(
//       scheduledDate,
//       tz.local,
//     );
//
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       id,
//       title,
//       body,
//       tzScheduledDate,
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'diabetes_reminders',
//           'Diabetes Reminders',
//           channelDescription: 'Notifications for diabetes reminders',
//           importance: Importance.high,
//           priority: Priority.high,
//         ),
//         iOS: DarwinNotificationDetails(),
//       ),
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//       uiLocalNotificationDateInterpretation:
//       UILocalNotificationDateInterpretation.absoluteTime,
//     );
//   }
//
//   // Schedule a daily notification
//   Future<void> _scheduleDailyNotification({
//     required int id,
//     required String title,
//     required String body,
//     required int hour,
//     required int minute,
//     DateTime? startDate,
//     DateTime? endDate,
//   }) async {
//     final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
//     tz.TZDateTime scheduledDate = tz.TZDateTime(
//       tz.local,
//       startDate?.year ?? now.year,
//       startDate?.month ?? now.month,
//       startDate?.day ?? now.day,
//       hour,
//       minute,
//     );
//
//     // If the scheduled time is in the past, schedule for the next day
//     if (scheduledDate.isBefore(now)) {
//       scheduledDate = scheduledDate.add(const Duration(days: 1));
//     }
//
//     // Check if the end date is specified and not passed
//     if (endDate != null) {
//       final tz.TZDateTime tzEndDate = tz.TZDateTime(
//         tz.local,
//         endDate.year,
//         endDate.month,
//         endDate.day,
//         23,
//         59,
//         59,
//       );
//
//       if (scheduledDate.isAfter(tzEndDate)) {
//         return; // Don't schedule if beyond end date
//       }
//     }
//
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       id,
//       title,
//       body,
//       scheduledDate,
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'diabetes_reminders',
//           'Diabetes Reminders',
//           channelDescription: 'Notifications for diabetes reminders',
//           importance: Importance.high,
//           priority: Priority.high,
//         ),
//         iOS: DarwinNotificationDetails(),
//       ),
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//       matchDateTimeComponents: DateTimeComponents.time,
//       uiLocalNotificationDateInterpretation:
//       UILocalNotificationDateInterpretation.absoluteTime,
//     );
//   }
//
//   // Toggle reminder active state
//   void _toggleReminderActive(String id) {
//     setState(() {
//       final index = reminders.indexWhere((reminder) => reminder.id == id);
//       if (index != -1) {
//         reminders[index].isActive = !reminders[index].isActive;
//         _saveReminders();
//       }
//     });
//   }
//
//   // Delete reminder
//   void _deleteReminder(String id) {
//     setState(() {
//       reminders.removeWhere((reminder) => reminder.id == id);
//       _saveReminders();
//     });
//   }
//
//   // Format date for display
//   String _formatDate(DateTime date) {
//     return '${date.month}/${date.day}/${date.year}';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Filter reminders based on search query
//     final filteredReminders = searchQuery.isEmpty
//         ? reminders
//         : reminders
//         .where((reminder) =>
//         reminder.title.toLowerCase().contains(searchQuery.toLowerCase()))
//         .toList();
//
//     return Scaffold(
//       appBar: AppBar(
//         title: showSearch
//             ? TextField(
//           controller: searchController,
//           decoration: const InputDecoration(
//             hintText: 'Search reminders...',
//             border: InputBorder.none,
//             hintStyle: TextStyle(color: Colors.black54),
//           ),
//           style: const TextStyle(color: Colors.black),
//           onChanged: (value) {
//             setState(() {
//               searchQuery = value;
//             });
//           },
//           autofocus: true,
//         )
//             : const Text('Reminders'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             if (showSearch) {
//               setState(() {
//                 showSearch = false;
//                 searchQuery = '';
//                 searchController.clear();
//               });
//             } else {
//               Navigator.pop(context);
//             }
//           },
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(showSearch ? Icons.close : Icons.search),
//             onPressed: () {
//               setState(() {
//                 showSearch = !showSearch;
//                 if (!showSearch) {
//                   searchQuery = '';
//                   searchController.clear();
//                 }
//               });
//             },
//           ),
//         ],
//         backgroundColor: const Color(0xFF89D0ED), // Using midShade from your MyActivity
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 16),
//             child: ElevatedButton.icon(
//               icon: const Icon(Icons.add),
//               label: const Text('Add Reminder'),
//               onPressed: () async {
//                 final result = await Navigator.push<Reminder>(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ReminderSetupScreen(),
//                   ),
//                 );
//
//                 if (result != null) {
//                   setState(() {
//                     reminders.add(result);
//                     _saveReminders();
//                   });
//                 }
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFF5FB8DD), // Using primaryColor from your MyActivity
//                 foregroundColor: Colors.white,
//               ),
//             ),
//           ),
//           Expanded(
//             child: filteredReminders.isEmpty
//                 ? const Center(
//               child: Text(
//                 'No reminders found. Add a reminder to get started.',
//                 style: TextStyle(color: Colors.grey),
//               ),
//             )
//                 : ListView.builder(
//               itemCount: filteredReminders.length,
//               padding: const EdgeInsets.all(16.0),
//               itemBuilder: (context, index) {
//                 final reminder = filteredReminders[index];
//                 return Card(
//                   margin: const EdgeInsets.only(bottom: 16.0),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     reminder.title,
//                                     style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 16,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     reminder.type == 'one-time'
//                                         ? 'One time: ${reminder.date != null ? _formatDate(reminder.date!) : ""} at ${reminder.time}'
//                                         : reminder.repeatType == 'daily'
//                                         ? 'Repeat reminder (Daily): ${reminder.time}'
//                                         : 'Repeat reminder (Custom): From ${reminder.startsOn != null ? _formatDate(reminder.startsOn!) : ""}${reminder.neverEnds == true ? "" : " to ${reminder.endsOn != null ? _formatDate(reminder.endsOn!) : ""}"} at ${reminder.time}',
//                                     style: const TextStyle(
//                                       color: Colors.grey,
//                                       fontSize: 14,
//                                     ),
//                                   ),
//                                   if (reminder.note != null && reminder.note!.isNotEmpty)
//                                     Padding(
//                                       padding: const EdgeInsets.only(top: 4),
//                                       child: Text(
//                                         reminder.note!,
//                                         style: const TextStyle(
//                                           color: Colors.grey,
//                                           fontSize: 14,
//                                         ),
//                                       ),
//                                     ),
//                                 ],
//                               ),
//                             ),
//                             Switch(
//                               value: reminder.isActive,
//                               onChanged: (value) {
//                                 _toggleReminderActive(reminder.id);
//                               },
//                               activeColor: const Color(0xFF5FB8DD), // Using primaryColor from your MyActivity
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 8),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             OutlinedButton(
//                               onPressed: () async {
//                                 final result = await Navigator.push<Reminder>(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => ReminderSetupScreen(
//                                       initialReminder: reminder,
//                                     ),
//                                   ),
//                                 );
//
//                                 if (result != null) {
//                                   setState(() {
//                                     final index = reminders.indexWhere(
//                                             (r) => r.id == result.id);
//                                     if (index != -1) {
//                                       reminders[index] = result;
//                                       _saveReminders();
//                                     }
//                                   });
//                                 }
//                               },
//                               style: OutlinedButton.styleFrom(
//                                 minimumSize: const Size(80, 36),
//                               ),
//                               child: const Text('Edit'),
//                             ),
//                             const SizedBox(width: 8),
//                             OutlinedButton(
//                               onPressed: () {
//                                 _deleteReminder(reminder.id);
//                               },
//                               style: OutlinedButton.styleFrom(
//                                 minimumSize: const Size(80, 36),
//                               ),
//                               child: const Text('Delete'),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
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
// // Reminder Setup Screen
// class ReminderSetupScreen extends StatefulWidget {
//   final Reminder? initialReminder;
//
//   const ReminderSetupScreen({Key? key, this.initialReminder}) : super(key: key);
//
//   @override
//   State<ReminderSetupScreen> createState() => _ReminderSetupScreenState();
// }
//
// class _ReminderSetupScreenState extends State<ReminderSetupScreen> {
//   late String reminderType;
//   late String repeatType;
//   late TextEditingController titleController;
//   late DateTime? dateValue;
//   late TextEditingController timeController;
//   late DateTime? startsOnValue;
//   late DateTime? endsOnValue;
//   late bool neverEnds;
//   late TextEditingController noteController;
//
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Initialize with values from initialReminder or defaults
//     reminderType = widget.initialReminder?.type ?? 'one-time';
//     repeatType = widget.initialReminder?.repeatType ?? 'daily';
//     titleController =
//         TextEditingController(text: widget.initialReminder?.title ?? '');
//     dateValue = widget.initialReminder?.date ?? DateTime.now();
//
//     // Initialize time
//     final initialTime = widget.initialReminder?.time ?? '${TimeOfDay
//         .now()
//         .hour
//         .toString()
//         .padLeft(2, '0')}:${TimeOfDay
//         .now()
//         .minute
//         .toString()
//         .padLeft(2, '0')}';
//     timeController = TextEditingController(text: initialTime);
//
//     startsOnValue = widget.initialReminder?.startsOn ?? DateTime.now();
//     endsOnValue = widget.initialReminder?.endsOn ??
//         DateTime.now().add(const Duration(days: 7));
//     neverEnds = widget.initialReminder?.neverEnds ?? true;
//     noteController =
//         TextEditingController(text: widget.initialReminder?.note ?? '');
//   }
//
//   @override
//   void dispose() {
//     titleController.dispose();
//     timeController.dispose();
//     noteController.dispose();
//     super.dispose();
//   }
//
//   // Format date for display
//   String _formatDate(DateTime date) {
//     return '${date.month}/${date.day}/${date.year}';
//   }
//
//   // Show date picker
//   Future<void> _selectDate(BuildContext context,
//       {required DateTime initialDate, required Function(DateTime) onSelect}) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: initialDate,
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2101),
//     );
//
//     if (picked != null && picked != initialDate) {
//       onSelect(picked);
//     }
//   }
//
//   // Show time picker
//   Future<void> _selectTime(BuildContext context) async {
//     final TimeOfDay initialTime = TimeOfDay(
//       hour: int.parse(timeController.text.split(':')[0]),
//       minute: int.parse(timeController.text.split(':')[1]),
//     );
//
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: initialTime,
//     );
//
//     if (picked != null) {
//       setState(() {
//         timeController.text =
//         '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString()
//             .padLeft(2, '0')}';
//       });
//     }
//   }
//
//   // Save reminder
//   void _saveReminder() {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }
//
//     final reminder = Reminder(
//       id: widget.initialReminder?.id ?? DateTime
//           .now()
//           .millisecondsSinceEpoch
//           .toString(),
//       title: titleController.text,
//       type: reminderType,
//       time: timeController.text,
//       note: noteController.text.isEmpty ? null : noteController.text,
//       isActive: widget.initialReminder?.isActive ?? true,
//     );
//
//     if (reminderType == 'one-time') {
//       reminder.date = dateValue;
//     } else {
//       // Repeat reminder
//       reminder.repeatType = repeatType;
//
//       if (repeatType == 'custom') {
//         reminder.startsOn = startsOnValue;
//         reminder.neverEnds = neverEnds;
//
//         if (!neverEnds) {
//           reminder.endsOn = endsOnValue;
//         }
//       }
//     }
//
//     Navigator.pop(context, reminder);
//   }
//
//   // Clear form
//   void _clearForm() {
//     setState(() {
//       titleController.clear();
//       dateValue = DateTime.now();
//       timeController.text = '${TimeOfDay
//           .now()
//           .hour
//           .toString()
//           .padLeft(2, '0')}:${TimeOfDay
//           .now()
//           .minute
//           .toString()
//           .padLeft(2, '0')}';
//       startsOnValue = DateTime.now();
//       endsOnValue = DateTime.now().add(const Duration(days: 7));
//       noteController.clear();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Reminders'),
//         backgroundColor: const Color(
//             0xFF89D0ED), // Using midShade from your MyActivity
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Reminder Type Selector (One Time / Repeat)
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.grey[200],
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   padding: const EdgeInsets.all(4),
//                   margin: const EdgeInsets.only(bottom: 24),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               reminderType = 'one-time';
//                             });
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(vertical: 8),
//                             decoration: BoxDecoration(
//                               color: reminderType == 'one-time'
//                                   ? const Color(
//                                   0xFF5FB8DD) // Using primaryColor from your MyActivity
//                                   : Colors.transparent,
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                             child: Center(
//                               child: Text(
//                                 'One Time',
//                                 style: TextStyle(
//                                   color: reminderType == 'one-time'
//                                       ? Colors.white
//                                       : Colors.black,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               reminderType = 'repeat';
//                             });
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(vertical: 8),
//                             decoration: BoxDecoration(
//                               color: reminderType == 'repeat'
//                                   ? const Color(
//                                   0xFF5FB8DD) // Using primaryColor from your MyActivity
//                                   : Colors.transparent,
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                             child: Center(
//                               child: Text(
//                                 'Repeat',
//                                 style: TextStyle(
//                                   color: reminderType == 'repeat'
//                                       ? Colors.white
//                                       : Colors.black,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 // Repeat Type Selector (Daily / Custom) - Only shown for repeat reminders
//                 if (reminderType == 'repeat')
//                   Container(
//                     decoration: BoxDecoration(
//                       color: Colors.grey[200],
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                     padding: const EdgeInsets.all(4),
//                     margin: const EdgeInsets.only(bottom: 24),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 repeatType = 'daily';
//                               });
//                             },
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(vertical: 8),
//                               decoration: BoxDecoration(
//                                 color: repeatType == 'daily'
//                                     ? const Color(
//                                     0xFF5FB8DD) // Using primaryColor from your MyActivity
//                                     : Colors.transparent,
//                                 borderRadius: BorderRadius.circular(30),
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   'Daily',
//                                   style: TextStyle(
//                                     color: repeatType == 'daily'
//                                         ? Colors.white
//                                         : Colors.black,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           child: GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 repeatType = 'custom';
//                               });
//                             },
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(vertical: 8),
//                               decoration: BoxDecoration(
//                                 color: repeatType == 'custom'
//                                     ? const Color(
//                                     0xFF5FB8DD) // Using primaryColor from your MyActivity
//                                     : Colors.transparent,
//                                 borderRadius: BorderRadius.circular(30),
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   'Custom',
//                                   style: TextStyle(
//                                     color: repeatType == 'custom'
//                                         ? Colors.white
//                                         : Colors.black,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                 // Reminder Form Fields
//                 Card(
//                   elevation: 0,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     side: BorderSide(color: Colors.grey[300]!),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Task Title
//                         const Text(
//                           'Task Title*',
//                           style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         TextFormField(
//                           controller: titleController,
//                           decoration: const InputDecoration(
//                             hintText: 'Enter task title',
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter a task title';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 16),
//
//                         // Reminder Date - Only for one-time reminders
//                         if (reminderType == 'one-time') ...[
//                           const Text(
//                             'Reminder Date*',
//                             style: TextStyle(
//                               fontWeight: FontWeight.w500,
//                               color: Colors.black87,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           InkWell(
//                             onTap: () {
//                               _selectDate(
//                                 context,
//                                 initialDate: dateValue ?? DateTime.now(),
//                                 onSelect: (date) {
//                                   setState(() {
//                                     dateValue = date;
//                                   });
//                                 },
//                               );
//                             },
//                             child: InputDecorator(
//                               decoration: InputDecoration(
//                                 suffixIcon: const Icon(Icons.calendar_today),
//                                 hintText: 'Select date',
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                               ),
//                               child: Text(
//                                 dateValue != null
//                                     ? _formatDate(dateValue!)
//                                     : 'Select date',
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                         ],
//
//                         // Reminder Time
//                         const Text(
//                           'Reminder Time*',
//                           style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         InkWell(
//                           onTap: () {
//                             _selectTime(context);
//                           },
//                           child: InputDecorator(
//                             decoration: InputDecoration(
//                               suffixIcon: const Icon(Icons.access_time),
//                               hintText: 'Select time',
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                             child: Text(timeController.text),
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//
//                         // Custom repeat options
//                         if (reminderType == 'repeat' &&
//                             repeatType == 'custom') ...[
//                           const Text(
//                             'Starts on*',
//                             style: TextStyle(
//                               fontWeight: FontWeight.w500,
//                               color: Colors.black87,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           InkWell(
//                             onTap: () {
//                               _selectDate(
//                                 context,
//                                 initialDate: startsOnValue ?? DateTime.now(),
//                                 onSelect: (date) {
//                                   setState(() {
//                                     startsOnValue = date;
//                                     // If end date is before start date, update it
//                                     if (!neverEnds && endsOnValue != null &&
//                                         endsOnValue!.isBefore(date)) {
//                                       endsOnValue = date;
//                                     }
//                                   });
//                                 },
//                               );
//                             },
//                             child: InputDecorator(
//                               decoration: InputDecoration(
//                                 suffixIcon: const Icon(Icons.calendar_today),
//                                 hintText: 'Select start date',
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                               ),
//                               child: Text(
//                                 startsOnValue != null ? _formatDate(
//                                     startsOnValue!) : 'Select start date',
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//
//                           // Task never ends toggle
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               const Text(
//                                 'Task never ends',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w500,
//                                   color: Colors.black87,
//                                 ),
//                               ),
//                               Switch(
//                                 value: neverEnds,
//                                 onChanged: (value) {
//                                   setState(() {
//                                     neverEnds = value;
//                                   });
//                                 },
//                                 activeColor: const Color(
//                                     0xFF5FB8DD), // Using primaryColor from your MyActivity
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 16),
//
//                           // End date - only if task doesn't never end
//                           if (!neverEnds) ...[
//                             const Text(
//                               'Ends on*',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w500,
//                                 color: Colors.black87,
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             InkWell(
//                               onTap: () {
//                                 _selectDate(
//                                   context,
//                                   initialDate: endsOnValue ??
//                                       DateTime.now().add(
//                                           const Duration(days: 7)),
//                                   onSelect: (date) {
//                                     setState(() {
//                                       endsOnValue = date;
//                                     });
//                                   },
//                                 );
//                               },
//                               child: InputDecorator(
//                                 decoration: InputDecoration(
//                                   suffixIcon: const Icon(Icons.calendar_today),
//                                   hintText: 'Select end date',
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                 ),
//                                 child: Text(
//                                   endsOnValue != null ? _formatDate(
//                                       endsOnValue!) : 'Select end date',
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//                           ],
//                         ],
//
//                         // Note
//                         const Text(
//                           'Note (optional)',
//                           style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.grey,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         TextFormField(
//                           controller: noteController,
//                           decoration: const InputDecoration(
//                             hintText: 'Add a note',
//                           ),
//                           maxLines: 3,
//                         ),
//                         const SizedBox(height: 24),
//
//                         // Save and Clear buttons
//                         Row(
//                           children: [
//                             Expanded(
//                               child: ElevatedButton(
//                                 onPressed: _saveReminder,
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: const Color(0xFF5FB8DD),
//                                   // Using primaryColor from your MyActivity
//                                   foregroundColor: Colors.white,
//                                 ),
//                                 child: const Text('Save'),
//                               ),
//                             ),
//                             const SizedBox(width: 16),
//                             Expanded(
//                               child: OutlinedButton(
//                                 onPressed: _clearForm,
//                                 child: const Text('Clear'),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
//







// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:mybete_app/have_diabetes/DashBoard/Reminder/reminder_model.dart';
// import 'package:mybete_app/have_diabetes/DashBoard/Reminder/reminder_provider.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as tz_init;
//
// // Global notifications plugin that can be initialized in main.dart
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// FlutterLocalNotificationsPlugin();
//
// // Initialize notifications (call this in main.dart)
// Future<void> initNotifications() async {
//   tz_init.initializeTimeZones();
//
//   const AndroidInitializationSettings initializationSettingsAndroid =
//   AndroidInitializationSettings('@mipmap/ic_launcher');
//   final DarwinInitializationSettings initializationSettingsIOS =
//   DarwinInitializationSettings(
//     requestAlertPermission: true,
//     requestBadgePermission: true,
//     requestSoundPermission: true,
//   );
//   final InitializationSettings initializationSettings = InitializationSettings(
//     android: initializationSettingsAndroid,
//     iOS: initializationSettingsIOS,
//   );
//   await flutterLocalNotificationsPlugin.initialize(
//     initializationSettings,
//   );
// }
//
// // Reminder Management Screen
// class RemindersScreen extends StatefulWidget {
//   const RemindersScreen({Key? key}) : super(key: key);
//
//   @override
//   State<RemindersScreen> createState() => _RemindersScreenState();
// }
//
// class _RemindersScreenState extends State<RemindersScreen> {
//   bool showSearch = false;
//   String searchQuery = "";
//   TextEditingController searchController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   // Format date for display
//   String _formatDate(DateTime date) {
//     return '${date.month}/${date.day}/${date.year}';
//   }
//
//   // Format time for display
//   String _formatTime(DateTime time) {
//     return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: showSearch
//             ? TextField(
//           controller: searchController,
//           decoration: const InputDecoration(
//             hintText: 'Search reminders...',
//             border: InputBorder.none,
//             hintStyle: TextStyle(color: Colors.black54),
//           ),
//           style: const TextStyle(color: Colors.black),
//           onChanged: (value) {
//             setState(() {
//               searchQuery = value;
//             });
//           },
//           autofocus: true,
//         )
//             : const Text('Reminders'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             if (showSearch) {
//               setState(() {
//                 showSearch = false;
//                 searchQuery = '';
//                 searchController.clear();
//               });
//             } else {
//               Navigator.pop(context);
//             }
//           },
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(showSearch ? Icons.close : Icons.search),
//             onPressed: () {
//               setState(() {
//                 showSearch = !showSearch;
//                 if (!showSearch) {
//                   searchQuery = '';
//                   searchController.clear();
//                 }
//               });
//             },
//           ),
//         ],
//         backgroundColor: const Color(0xFF89D0ED),
//       ),
//       body: Consumer<ReminderProvider>(
//         builder: (context, reminderProvider, child) {
//           if (reminderProvider.isLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           if (reminderProvider.error != null) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Error: ${reminderProvider.error}',
//                     style: const TextStyle(color: Colors.red),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () {
//                       reminderProvider.clearError();
//                       reminderProvider.loadReminders();
//                     },
//                     child: const Text('Retry'),
//                   ),
//                 ],
//               ),
//             );
//           }
//
//           // Filter reminders based on search query
//           final filteredReminders = searchQuery.isEmpty
//               ? reminderProvider.reminders
//               : reminderProvider.reminders
//               .where((reminder) =>
//               reminder.title.toLowerCase().contains(searchQuery.toLowerCase()))
//               .toList();
//
//           return Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 16),
//                 child: ElevatedButton.icon(
//                   icon: const Icon(Icons.add),
//                   label: const Text('Add Reminder'),
//                   onPressed: () async {
//                     final result = await Navigator.push<Reminder>(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ReminderSetupScreen(),
//                       ),
//                     );
//
//                     if (result != null) {
//                       reminderProvider.addReminder(result);
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF5FB8DD),
//                     foregroundColor: Colors.white,
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: filteredReminders.isEmpty
//                     ? const Center(
//                   child: Text(
//                     'No reminders found. Add a reminder to get started.',
//                     style: TextStyle(color: Colors.grey),
//                   ),
//                 )
//                     : ListView.builder(
//                   itemCount: filteredReminders.length,
//                   padding: const EdgeInsets.all(16.0),
//                   itemBuilder: (context, index) {
//                     final reminder = filteredReminders[index];
//                     return Card(
//                       margin: const EdgeInsets.only(bottom: 16.0),
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         reminder.title,
//                                         style: const TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 16,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 4),
//                                       Text(
//                                         reminder.reminderType == 'one-time'
//                                             ? 'One time: ${reminder.reminderDate != null ? _formatDate(reminder.reminderDate!) : ""} at ${_formatTime(reminder.reminderTime)}'
//                                             : reminder.repeatType == 'daily'
//                                             ? 'Repeat reminder (Daily): ${_formatTime(reminder.reminderTime)}'
//                                             : 'Repeat reminder (Custom): From ${reminder.startsOn != null ? _formatDate(reminder.startsOn!) : ""}${reminder.neverEnds ? "" : " to ${reminder.endsOn != null ? _formatDate(reminder.endsOn!) : ""}"} at ${_formatTime(reminder.reminderTime)}',
//                                         style: const TextStyle(
//                                           color: Colors.grey,
//                                           fontSize: 14,
//                                         ),
//                                       ),
//                                       if (reminder.note.isNotEmpty)
//                                         Padding(
//                                           padding: const EdgeInsets.only(top: 4),
//                                           child: Text(
//                                             reminder.note,
//                                             style: const TextStyle(
//                                               color: Colors.grey,
//                                               fontSize: 14,
//                                             ),
//                                           ),
//                                         ),
//                                     ],
//                                   ),
//                                 ),
//                                 Switch(
//                                   value: reminder.isActive,
//                                   onChanged: (value) {
//                                     reminderProvider.toggleReminderActive(
//                                         reminder.id, value);
//                                   },
//                                   activeColor: const Color(0xFF5FB8DD),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 8),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 OutlinedButton(
//                                   onPressed: () async {
//                                     final result = await Navigator.push<Reminder>(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => ReminderSetupScreen(
//                                           initialReminder: reminder,
//                                         ),
//                                       ),
//                                     );
//
//                                     if (result != null) {
//                                       reminderProvider.updateReminder(result);
//                                     }
//                                   },
//                                   style: OutlinedButton.styleFrom(
//                                     minimumSize: const Size(80, 36),
//                                   ),
//                                   child: const Text('Edit'),
//                                 ),
//                                 const SizedBox(width: 8),
//                                 OutlinedButton(
//                                   onPressed: () {
//                                     reminderProvider.deleteReminder(reminder.id);
//                                   },
//                                   style: OutlinedButton.styleFrom(
//                                     minimumSize: const Size(80, 36),
//                                   ),
//                                   child: const Text('Delete'),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
//
// // Reminder Setup Screen
// class ReminderSetupScreen extends StatefulWidget {
//   final Reminder? initialReminder;
//
//   const ReminderSetupScreen({Key? key, this.initialReminder}) : super(key: key);
//
//   @override
//   State<ReminderSetupScreen> createState() => _ReminderSetupScreenState();
// }
//
// class _ReminderSetupScreenState extends State<ReminderSetupScreen> {
//   late String reminderType;
//   late String repeatType;
//   late TextEditingController titleController;
//   late DateTime? dateValue;
//   late TimeOfDay timeValue;
//   late DateTime? startsOnValue;
//   late DateTime? endsOnValue;
//   late bool neverEnds;
//   late TextEditingController noteController;
//
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Initialize with values from initialReminder or defaults
//     reminderType = widget.initialReminder?.reminderType ?? 'one-time';
//     repeatType = widget.initialReminder?.repeatType ?? 'daily';
//     titleController = TextEditingController(text: widget.initialReminder?.title ?? '');
//     dateValue = widget.initialReminder?.reminderDate ?? DateTime.now();
//
//     // Initialize time
//     if (widget.initialReminder != null) {
//       timeValue = TimeOfDay(
//         hour: widget.initialReminder!.reminderTime.hour,
//         minute: widget.initialReminder!.reminderTime.minute,
//       );
//     } else {
//       timeValue = TimeOfDay.now();
//     }
//
//     startsOnValue = widget.initialReminder?.startsOn ?? DateTime.now();
//     endsOnValue = widget.initialReminder?.endsOn ?? DateTime.now().add(const Duration(days: 7));
//     neverEnds = widget.initialReminder?.neverEnds ?? true;
//     noteController = TextEditingController(text: widget.initialReminder?.note ?? '');
//   }
//
//   @override
//   void dispose() {
//     titleController.dispose();
//     noteController.dispose();
//     super.dispose();
//   }
//
//   // Format date for display
//   String _formatDate(DateTime date) {
//     return '${date.month}/${date.day}/${date.year}';
//   }
//
//   // Show date picker
//   Future<void> _selectDate(BuildContext context,
//       {required DateTime initialDate, required Function(DateTime) onSelect}) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: initialDate,
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2101),
//     );
//
//     if (picked != null && picked != initialDate) {
//       onSelect(picked);
//     }
//   }
//
//   // Show time picker
//   Future<void> _selectTime(BuildContext context) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: timeValue,
//     );
//
//     if (picked != null) {
//       setState(() {
//         timeValue = picked;
//       });
//     }
//   }
//
//   // Save reminder
//   void _saveReminder() {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }
//
//     // Create DateTime from TimeOfDay
//     final now = DateTime.now();
//     final reminderTime = DateTime(
//       now.year,
//       now.month,
//       now.day,
//       timeValue.hour,
//       timeValue.minute,
//     );
//
//     final reminder = Reminder(
//       id: widget.initialReminder?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
//       title: titleController.text,
//       reminderType: reminderType,
//       repeatType: repeatType,
//       reminderTime: reminderTime,
//       note: noteController.text,
//       isActive: widget.initialReminder?.isActive ?? true,
//       userId: widget.initialReminder?.userId ?? '',
//       neverEnds: neverEnds,
//     );
//
//     if (reminderType == 'one-time') {
//       reminder.reminderDate = dateValue;
//     } else {
//       // Repeat reminder
//       if (repeatType == 'custom') {
//         reminder.startsOn = startsOnValue;
//         if (!neverEnds) {
//           reminder.endsOn = endsOnValue;
//         }
//       }
//     }
//
//     Navigator.pop(context, reminder);
//   }
//
//   // Clear form
//   void _clearForm() {
//     setState(() {
//       titleController.clear();
//       dateValue = DateTime.now();
//       timeValue = TimeOfDay.now();
//       startsOnValue = DateTime.now();
//       endsOnValue = DateTime.now().add(const Duration(days: 7));
//       noteController.clear();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.initialReminder == null ? 'Add Reminder' : 'Edit Reminder'),
//         backgroundColor: const Color(0xFF89D0ED),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Reminder Type Selector (One Time / Repeat)
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.grey[200],
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   padding: const EdgeInsets.all(4),
//                   margin: const EdgeInsets.only(bottom: 24),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               reminderType = 'one-time';
//                             });
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(vertical: 8),
//                             decoration: BoxDecoration(
//                               color: reminderType == 'one-time'
//                                   ? const Color(0xFF5FB8DD)
//                                   : Colors.transparent,
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                             child: Center(
//                               child: Text(
//                                 'One Time',
//                                 style: TextStyle(
//                                   color: reminderType == 'one-time'
//                                       ? Colors.white
//                                       : Colors.black,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               reminderType = 'repeat';
//                             });
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(vertical: 8),
//                             decoration: BoxDecoration(
//                               color: reminderType == 'repeat'
//                                   ? const Color(0xFF5FB8DD)
//                                   : Colors.transparent,
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                             child: Center(
//                               child: Text(
//                                 'Repeat',
//                                 style: TextStyle(
//                                   color: reminderType == 'repeat'
//                                       ? Colors.white
//                                       : Colors.black,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 // Repeat Type Selector (Daily / Custom) - Only shown for repeat reminders
//                 if (reminderType == 'repeat')
//                   Container(
//                     decoration: BoxDecoration(
//                       color: Colors.grey[200],
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                     padding: const EdgeInsets.all(4),
//                     margin: const EdgeInsets.only(bottom: 24),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 repeatType = 'daily';
//                               });
//                             },
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(vertical: 8),
//                               decoration: BoxDecoration(
//                                 color: repeatType == 'daily'
//                                     ? const Color(0xFF5FB8DD)
//                                     : Colors.transparent,
//                                 borderRadius: BorderRadius.circular(30),
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   'Daily',
//                                   style: TextStyle(
//                                     color: repeatType == 'daily'
//                                         ? Colors.white
//                                         : Colors.black,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           child: GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 repeatType = 'custom';
//                               });
//                             },
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(vertical: 8),
//                               decoration: BoxDecoration(
//                                 color: repeatType == 'custom'
//                                     ? const Color(0xFF5FB8DD)
//                                     : Colors.transparent,
//                                 borderRadius: BorderRadius.circular(30),
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   'Custom',
//                                   style: TextStyle(
//                                     color: repeatType == 'custom'
//                                         ? Colors.white
//                                         : Colors.black,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                 // Reminder Form Fields
//                 Card(
//                   elevation: 0,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     side: BorderSide(color: Colors.grey[300]!),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Task Title
//                         const Text(
//                           'Task Title*',
//                           style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         TextFormField(
//                           controller: titleController,
//                           decoration: const InputDecoration(
//                             hintText: 'Enter task title',
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter a task title';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 16),
//
//                         // Reminder Date - Only for one-time reminders
//                         if (reminderType == 'one-time') ...[
//                           const Text(
//                             'Reminder Date*',
//                             style: TextStyle(
//                               fontWeight: FontWeight.w500,
//                               color: Colors.black87,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           InkWell(
//                             onTap: () {
//                               _selectDate(
//                                 context,
//                                 initialDate: dateValue ?? DateTime.now(),
//                                 onSelect: (date) {
//                                   setState(() {
//                                     dateValue = date;
//                                   });
//                                 },
//                               );
//                             },
//                             child: InputDecorator(
//                               decoration: InputDecoration(
//                                 suffixIcon: const Icon(Icons.calendar_today),
//                                 hintText: 'Select date',
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                               ),
//                               child: Text(
//                                 dateValue != null
//                                     ? _formatDate(dateValue!)
//                                     : 'Select date',
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                         ],
//
//                         // Reminder Time
//                         const Text(
//                           'Reminder Time*',
//                           style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         InkWell(
//                           onTap: () {
//                             _selectTime(context);
//                           },
//                           child: InputDecorator(
//                             decoration: InputDecoration(
//                               suffixIcon: const Icon(Icons.access_time),
//                               hintText: 'Select time',
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                             child: Text(
//                               '${timeValue.hour.toString().padLeft(2, '0')}:${timeValue.minute.toString().padLeft(2, '0')}',
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//
//                         // Custom repeat options
//                         if (reminderType == 'repeat' && repeatType == 'custom') ...[
//                           const Text(
//                             'Starts on*',
//                             style: TextStyle(
//                               fontWeight: FontWeight.w500,
//                               color: Colors.black87,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           InkWell(
//                             onTap: () {
//                               _selectDate(
//                                 context,
//                                 initialDate: startsOnValue ?? DateTime.now(),
//                                 onSelect: (date) {
//                                   setState(() {
//                                     startsOnValue = date;
//                                     // If end date is before start date, update it
//                                     if (!neverEnds && endsOnValue != null &&
//                                         endsOnValue!.isBefore(date)) {
//                                       endsOnValue = date;
//                                     }
//                                   });
//                                 },
//                               );
//                             },
//                             child: InputDecorator(
//                               decoration: InputDecoration(
//                                 suffixIcon: const Icon(Icons.calendar_today),
//                                 hintText: 'Select start date',
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                               ),
//                               child: Text(
//                                 startsOnValue != null ? _formatDate(startsOnValue!) : 'Select start date',
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//
//                           // Task never ends toggle
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               const Text(
//                                 'Task never ends',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w500,
//                                   color: Colors.black87,
//                                 ),
//                               ),
//                               Switch(
//                                 value: neverEnds,
//                                 onChanged: (value) {
//                                   setState(() {
//                                     neverEnds = value;
//                                   });
//                                 },
//                                 activeColor: const Color(0xFF5FB8DD),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 16),
//
//                           // End date - only if task doesn't never end
//                           if (!neverEnds) ...[
//                             const Text(
//                               'Ends on*',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w500,
//                                 color: Colors.black87,
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             InkWell(
//                               onTap: () {
//                                 _selectDate(
//                                   context,
//                                   initialDate: endsOnValue ?? DateTime.now().add(const Duration(days: 7)),
//                                   onSelect: (date) {
//                                     setState(() {
//                                       endsOnValue = date;
//                                     });
//                                   },
//                                 );
//                               },
//                               child: InputDecorator(
//                                 decoration: InputDecoration(
//                                   suffixIcon: const Icon(Icons.calendar_today),
//                                   hintText: 'Select end date',
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                 ),
//                                 child: Text(
//                                   endsOnValue != null ? _formatDate(endsOnValue!) : 'Select end date',
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//                           ],
//                         ],
//
//                         // Note
//                         const Text(
//                           'Note (optional)',
//                           style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.grey,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         TextFormField(
//                           controller: noteController,
//                           decoration: const InputDecoration(
//                             hintText: 'Add a note',
//                           ),
//                           maxLines: 3,
//                         ),
//                         const SizedBox(height: 24),
//
//                         // Save and Clear buttons
//                         Row(
//                           children: [
//                             Expanded(
//                               child: ElevatedButton(
//                                 onPressed: _saveReminder,
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: const Color(0xFF5FB8DD),
//                                   foregroundColor: Colors.white,
//                                 ),
//                                 child: const Text('Save'),
//                               ),
//                             ),
//                             const SizedBox(width: 16),
//                             Expanded(
//                               child: OutlinedButton(
//                                 onPressed: _clearForm,
//                                 child: const Text('Clear'),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }







import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mybete_app/have_diabetes/DashBoard/Reminder/reminder_model.dart';
import 'package:mybete_app/have_diabetes/DashBoard/Reminder/reminder_provider.dart';
import 'package:mybete_app/have_diabetes/DashBoard/Reminder/reminder_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_init;
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Global notifications plugin that can be initialized in main.dart
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

// Initialize notifications (call this in main.dart)
Future<void> initNotifications() async {
  tz_init.initializeTimeZones();

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  final DarwinInitializationSettings initializationSettingsIOS =
  DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );
}

// Reminder Management Screen
class RemindersScreen extends StatefulWidget {
  const RemindersScreen({Key? key}) : super(key: key);

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  bool showSearch = false;
  String searchQuery = "";
  TextEditingController searchController = TextEditingController();
  final ReminderService _reminderService = ReminderService();

  @override
  void initState() {
    super.initState();
    // Ensure reminders are loaded when screen is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReminderProvider>(context, listen: false).loadReminders();
    });
  }

  // Format date for display
  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  // Format time for display
  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: showSearch
            ? TextField(
          controller: searchController,
          decoration: const InputDecoration(
            hintText: 'Search reminders...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.black54),
          ),
          style: const TextStyle(color: Colors.black),
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
          },
          autofocus: true,
        )
            : const Text('Reminders'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (showSearch) {
              setState(() {
                showSearch = false;
                searchQuery = '';
                searchController.clear();
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          IconButton(
            icon: Icon(showSearch ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                showSearch = !showSearch;
                if (!showSearch) {
                  searchQuery = '';
                  searchController.clear();
                }
              });
            },
          ),
        ],
        backgroundColor: const Color(0xFF89D0ED),
      ),
      body: Consumer<ReminderProvider>(
        builder: (context, reminderProvider, child) {
          if (reminderProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (reminderProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Error: ${reminderProvider.error}',
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      reminderProvider.clearError();
                      reminderProvider.loadReminders();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Filter reminders based on search query
          final filteredReminders = searchQuery.isEmpty
              ? reminderProvider.reminders
              : reminderProvider.reminders
              .where((reminder) =>
              reminder.title.toLowerCase().contains(searchQuery.toLowerCase()))
              .toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 16),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Add Reminder'),
                  onPressed: () async {
                    final result = await Navigator.push<Reminder>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReminderSetupScreen(
                          userId: _reminderService.currentUserId,
                        ),
                      ),
                    );

                    if (result != null) {
                      reminderProvider.addReminder(result);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5FB8DD),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: filteredReminders.isEmpty
                    ? const Center(
                  child: Text(
                    'No reminders found. Add a reminder to get started.',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
                    : ListView.builder(
                  itemCount: filteredReminders.length,
                  padding: const EdgeInsets.all(16.0),
                  itemBuilder: (context, index) {
                    final reminder = filteredReminders[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        reminder.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        reminder.reminderType == 'one-time'
                                            ? 'One time: ${reminder.reminderDate != null ? _formatDate(reminder.reminderDate!) : ""} at ${_formatTime(reminder.reminderTime)}'
                                            : reminder.repeatType == 'daily'
                                            ? 'Repeat reminder (Daily): ${_formatTime(reminder.reminderTime)}'
                                            : 'Repeat reminder (Custom): From ${reminder.startsOn != null ? _formatDate(reminder.startsOn!) : ""}${reminder.neverEnds ? "" : " to ${reminder.endsOn != null ? _formatDate(reminder.endsOn!) : ""}"} at ${_formatTime(reminder.reminderTime)}',
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                      if (reminder.note.isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 4),
                                          child: Text(
                                            reminder.note,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Switch(
                                  value: reminder.isActive,
                                  onChanged: (value) {
                                    reminderProvider.toggleReminderActive(
                                        reminder.id, value);
                                  },
                                  activeColor: const Color(0xFF5FB8DD),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  icon: const Icon(Icons.edit, size: 18),
                                  label: const Text('Edit'),
                                  onPressed: () async {
                                    final result = await Navigator.push<Reminder>(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ReminderSetupScreen(
                                          userId: _reminderService.currentUserId,
                                          reminder: reminder,
                                        ),
                                      ),
                                    );

                                    if (result != null) {
                                      reminderProvider.updateReminder(result);
                                    }
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.blue,
                                  ),
                                ),
                                TextButton.icon(
                                  icon: const Icon(Icons.delete, size: 18),
                                  label: const Text('Delete'),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Delete Reminder'),
                                        content: const Text(
                                            'Are you sure you want to delete this reminder?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              reminderProvider
                                                  .deleteReminder(reminder.id);
                                            },
                                            child: const Text('Delete'),
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Reminder Setup Screen
class ReminderSetupScreen extends StatefulWidget {
  final String userId;
  final Reminder? reminder;

  const ReminderSetupScreen({
    Key? key,
    required this.userId,
    this.reminder,
  }) : super(key: key);

  @override
  State<ReminderSetupScreen> createState() => _ReminderSetupScreenState();
}

class _ReminderSetupScreenState extends State<ReminderSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();

  String _reminderType = 'one-time';
  String _repeatType = 'daily';
  DateTime _reminderDate = DateTime.now();
  TimeOfDay _reminderTime = TimeOfDay.now();
  DateTime _startsOn = DateTime.now();
  DateTime _endsOn = DateTime.now().add(const Duration(days: 30));
  bool _neverEnds = true;

  @override
  void initState() {
    super.initState();
    if (widget.reminder != null) {
      // Populate form with existing reminder data
      _titleController.text = widget.reminder!.title;
      _noteController.text = widget.reminder!.note;
      _reminderType = widget.reminder!.reminderType;
      _repeatType = widget.reminder!.repeatType;

      if (widget.reminder!.reminderDate != null) {
        _reminderDate = widget.reminder!.reminderDate!;
      }

      _reminderTime = TimeOfDay(
        hour: widget.reminder!.reminderTime.hour,
        minute: widget.reminder!.reminderTime.minute,
      );

      if (widget.reminder!.startsOn != null) {
        _startsOn = widget.reminder!.startsOn!;
      }

      if (widget.reminder!.endsOn != null) {
        _endsOn = widget.reminder!.endsOn!;
      }

      _neverEnds = widget.reminder!.neverEnds;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, DateTime initialDate,
      Function(DateTime) onDateSelected) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      onDateSelected(picked);
    }
  }

  Future<void> _selectTime(BuildContext context, TimeOfDay initialTime,
      Function(TimeOfDay) onTimeSelected) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (picked != null) {
      onTimeSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.reminder == null ? 'Add Reminder' : 'Edit Reminder'),
        backgroundColor: const Color(0xFF89D0ED),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Reminder Type',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('One Time'),
                      value: 'one-time',
                      groupValue: _reminderType,
                      onChanged: (value) {
                        setState(() {
                          _reminderType = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Repeat'),
                      value: 'repeat',
                      groupValue: _reminderType,
                      onChanged: (value) {
                        setState(() {
                          _reminderType = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_reminderType == 'one-time') ...[
                const Text(
                  'Date',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ListTile(
                  title: Text(
                    '${_reminderDate.month}/${_reminderDate.day}/${_reminderDate.year}',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () {
                    _selectDate(context, _reminderDate, (date) {
                      setState(() {
                        _reminderDate = date;
                      });
                    });
                  },
                ),
              ] else ...[
                const Text(
                  'Repeat Type',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Daily'),
                        value: 'daily',
                        groupValue: _repeatType,
                        onChanged: (value) {
                          setState(() {
                            _repeatType = value!;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Custom'),
                        value: 'custom',
                        groupValue: _repeatType,
                        onChanged: (value) {
                          setState(() {
                            _repeatType = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                if (_repeatType == 'custom') ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Starts On',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ListTile(
                    title: Text(
                      '${_startsOn.month}/${_startsOn.day}/${_startsOn.year}',
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () {
                      _selectDate(context, _startsOn, (date) {
                        setState(() {
                          _startsOn = date;
                        });
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  CheckboxListTile(
                    title: const Text('Never Ends'),
                    value: _neverEnds,
                    onChanged: (value) {
                      setState(() {
                        _neverEnds = value!;
                      });
                    },
                  ),
                  if (!_neverEnds) ...[
                    const Text(
                      'Ends On',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ListTile(
                      title: Text(
                        '${_endsOn.month}/${_endsOn.day}/${_endsOn.year}',
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () {
                        _selectDate(context, _endsOn, (date) {
                          setState(() {
                            _endsOn = date;
                          });
                        });
                      },
                    ),
                  ],
                ],
              ],
              const SizedBox(height: 16),
              const Text(
                'Time',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ListTile(
                title: Text(
                  '${_reminderTime.hour.toString().padLeft(2, '0')}:${_reminderTime.minute.toString().padLeft(2, '0')}',
                ),
                trailing: const Icon(Icons.access_time),
                onTap: () {
                  _selectTime(context, _reminderTime, (time) {
                    setState(() {
                      _reminderTime = time;
                    });
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Note (Optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final DateTime now = DateTime.now();
                      final DateTime reminderTime = DateTime(
                        now.year,
                        now.month,
                        now.day,
                        _reminderTime.hour,
                        _reminderTime.minute,
                      );

                      final reminder = Reminder(
                        id: widget.reminder?.id ?? const Uuid().v4(),
                        title: _titleController.text,
                        reminderType: _reminderType,
                        repeatType: _repeatType,
                        reminderDate: _reminderType == 'one-time' ? _reminderDate : null,
                        reminderTime: reminderTime,
                        startsOn: _reminderType == 'repeat' && _repeatType == 'custom'
                            ? _startsOn
                            : null,
                        endsOn: _reminderType == 'repeat' &&
                            _repeatType == 'custom' &&
                            !_neverEnds
                            ? _endsOn
                            : null,
                        neverEnds: _neverEnds,
                        note: _noteController.text,
                        isActive: widget.reminder?.isActive ?? true,
                        userId: widget.userId,
                      );

                      Navigator.pop(context, reminder);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5FB8DD),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    widget.reminder == null ? 'Add Reminder' : 'Update Reminder',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




















