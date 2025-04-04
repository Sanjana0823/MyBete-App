import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mybete_app/firebase_options.dart';
import 'package:provider/provider.dart';
import 'have_diabetes/DashBoard/MyActivity/log_provider.dart';
import 'diabete_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures plugin binding

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LogProvider()..initialize(),
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

