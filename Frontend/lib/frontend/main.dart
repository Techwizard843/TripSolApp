import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tripsol_clean/frontend/signUp_screen.dart';
import 'package:tripsol_clean/frontend/login_screen.dart';
import 'package:tripsol_clean/frontend/intro_page.dart';
import 'package:tripsol_clean/frontend/home_screen.dart';
import 'package:tripsol_clean/frontend/saved_trips_page.dart';
import 'package:tripsol_clean/frontend/profile_page.dart';
import 'package:tripsol_clean/frontend/settings_page.dart';
import 'package:tripsol_clean/frontend/about_app_page.dart';

const enableFirebase = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (enableFirebase) {
    await Firebase.initializeApp();
  }
  runApp(const TripSolApp());
}

class TripSolApp extends StatelessWidget {
  const TripSolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TripSol',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const IntroPage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(
          userEmail: "hasini@gmail.com", // mock
          savedTripsCount: 2, // mock
        ),
        '/saved': (context) => const SavedTripsPage(),
        '/settings': (context) => const SettingsPage(),
        '/about': (context) => const AboutAppPage(),
        '/saved-trips': (context) => const SavedTripsPage(),
      },
    );
  }
}
