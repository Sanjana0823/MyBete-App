// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:mybete_app/firebase_options.dart';
// import 'package:timezone/data/latest.dart' as tz_init;
// import 'package:provider/provider.dart';
// import 'have_diabetes/DashBoard/MyActivity/log_provider.dart';
// import 'have_diabetes/DashBoard/Reminder/Reminder_screen.dart';
// import 'sign_up_screen.dart';
// import 'log_in_screen.dart';
// import 'diabete_options.dart';
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'firebase_options.dart';
//
//
//
//
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized(); // Ensures plugin binding
//   await Firebase.initializeApp(
//
//
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(MyApp());
// }
//
//
//
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(
//           create: (_) => LogProvider()..initialize(),
//         ),
//       ],
//       child: MaterialApp(
//         title: 'MyBete',
//         theme: ThemeData.light(),
//         darkTheme: ThemeData.dark(),
//         themeMode: ThemeMode.system,
//         home: FutureBuilder<bool>(
//           future: _checkLoginStatus(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasData && snapshot.data == true) {
//               return DiabeteOptions();
//             } else {
//               return DiabeteOptions();
//             }
//           },
//         ),
//       ),
//     );
//   }
//
//   Future<bool> _checkLoginStatus() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
//     String lastLoginDate = prefs.getString('lastLoginDate') ?? '';
//
//     if (isLoggedIn && _isSameDay(DateTime.parse(lastLoginDate), DateTime.now())) {
//       return true;
//     } else {
//       return false;
//     }
//   }
//
//   bool _isSameDay(DateTime date1, DateTime date2) {
//     return date1.year == date2.year &&
//         date1.month == date2.month &&
//         date1.day == date2.day;
//   }
// }



// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest.dart' as tz_init;
// import 'package:provider/provider.dart';
// import 'package:mybete_app/have_diabetes/DashBoard/Reminder/reminder_provider.dart';
//
// // Add this at the beginning of your main() function
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // Initialize Firebase
//   await Firebase.initializeApp();
//
//   // Initialize timezone data for notifications
//   tz_init.initializeTimeZones();
//
//   // Initialize notifications
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
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
//   await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//
//   runApp(MyApp());
// }
//
// // Wrap your app with ChangeNotifierProvider for ReminderProvider
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => ReminderProvider()),
//         // Add other providers here
//       ],
//       child: MaterialApp(
//         // Your existing app configuration
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:mybete_app/have_diabetes/DashBoard/Reminder/reminder_provider.dart';
// import 'package:mybete_app/have_diabetes/DashBoard/Reminder/Reminder_screen.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as tz_init;
// import 'package:mybete_app/firebase_options.dart';
//
//
// import 'diabete_options.dart';
// import 'have_diabetes/DashBoard/MyActivity/log_provider.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized(); // Ensures plugin binding
//
//   // Initialize Firebase
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//
//   // Initialize notifications for reminders
//   await initNotifications();
//
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         // Existing provider
//         ChangeNotifierProvider(
//           create: (_) => LogProvider()..initialize(),
//         ),
//         // Add ReminderProvider
//         ChangeNotifierProvider(
//           create: (_) => ReminderProvider(
//             notificationsPlugin: flutterLocalNotificationsPlugin,
//           ),
//         ),
//       ],
//       child: MaterialApp(
//         title: 'MyBete',
//         theme: ThemeData.light(),
//         darkTheme: ThemeData.dark(),
//         themeMode: ThemeMode.system,
//         home: FutureBuilder<bool>(
//           future: _checkLoginStatus(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasData && snapshot.data == true) {
//               return DiabeteOptions();
//             } else {
//               return DiabeteOptions();
//             }
//           },
//         ),
//       ),
//     );
//   }
//
//   Future<bool> _checkLoginStatus() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
//     String lastLoginDate = prefs.getString('lastLoginDate') ?? '';
//
//     if (isLoggedIn && _isSameDay(DateTime.parse(lastLoginDate), DateTime.now())) {
//       return true;
//     } else {
//       return false;
//     }
//   }
//
//   bool _isSameDay(DateTime date1, DateTime date2) {
//     return date1.year == date2.year &&
//         date1.month == date2.month &&
//         date1.day == date2.day;
//   }
// }












import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mybete_app/have_diabetes/DashBoard/Reminder/reminder_provider.dart';
import 'package:mybete_app/have_diabetes/DashBoard/Reminder/Reminder_screen.dart';
import 'package:mybete_app/firebase_options.dart';

import 'diabete_options.dart';
import 'have_diabetes/DashBoard/MyActivity/log_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures plugin binding

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize notifications for reminders
  await initNotifications();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Existing provider
        ChangeNotifierProvider(
          create: (_) => LogProvider()..initialize(),
        ),
        // Add ReminderProvider
        ChangeNotifierProvider(
          create: (_) => ReminderProvider(
            notificationsPlugin: flutterLocalNotificationsPlugin,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'MyBete',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.system,
        home: FutureBuilder<bool>(
          future: _checkLoginStatus(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData && snapshot.data == true) {
              return DiabeteOptions();
            } else {
              return DiabeteOptions();
            }
          },
        ),
      ),
    );
  }

  Future<bool> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String lastLoginDate = prefs.getString('lastLoginDate') ?? '';

    if (isLoggedIn && _isSameDay(DateTime.parse(lastLoginDate), DateTime.now())) {
      return true;
    } else {
      return false;
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}