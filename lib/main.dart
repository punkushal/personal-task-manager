import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_task_manager/firebase_options.dart';
import 'package:personal_task_manager/providers/task_provider.dart';
import 'package:personal_task_manager/screens/home_screen.dart';
import 'package:provider/provider.dart';

import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
      create: (context) => TaskProvider(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Task Manager',
      theme: AppTheme.lightTheme,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomeScreen();
          }
          return LoginScreen();
        },
      ),
    );
  }
}

class AppTheme {
  // Define a reusable light theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: Colors.blue, // Main app color
      scaffoldBackgroundColor: Colors.white, // White background
      textTheme: GoogleFonts.dmSansTextTheme(), // Use DM Sans font
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.blue, // Blue app bar
        foregroundColor: Colors.white, // White text/icon on app bar
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue, // Blue button color
          foregroundColor: Colors.white, // White text on buttons
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Rounded buttons
          ),
        ),
      ),
    );
  }
}
