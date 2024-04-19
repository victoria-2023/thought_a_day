import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import 'welcome_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thought-A-Day',
      theme: ThemeData(
        primarySwatch: Colors.yellow, // Updated to yellow theme
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const CheckFirstSeen(),
    );
  }
}

class CheckFirstSeen extends StatefulWidget {
  const CheckFirstSeen({super.key});

  @override
  _CheckFirstSeenState createState() => _CheckFirstSeenState();
}

class _CheckFirstSeenState extends State<CheckFirstSeen> {
  late Future<bool> seenFuture;

  @override
  void initState() {
    super.initState();
    seenFuture = _checkFirstSeen();
  }

  Future<bool> _checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seen = (prefs.getBool('seen') ?? false);
    if (!seen) {
      await prefs.setBool('seen', true);
    }
    return seen;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: seenFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return snapshot.data! ? const HomeScreen() : const WelcomeScreen();
          } else {
            return const WelcomeScreen(); // Fallback if data is unexpectedly null
          }
        } else {
          return const CircularProgressIndicator(); // Show loading spinner while checking preferences
        }
      },
    );
  }
}
