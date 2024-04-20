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
        primarySwatch: Colors.yellow,  // Bright and engaging theme
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const InitialScreenDecider(),
    );
  }
}

class InitialScreenDecider extends StatefulWidget {
  const InitialScreenDecider({super.key});

  @override
  _InitialScreenDeciderState createState() => _InitialScreenDeciderState();
}

class _InitialScreenDeciderState extends State<InitialScreenDecider> {
  late Future<bool> hasSeen;

  @override
  void initState() {
    super.initState();
    hasSeen = checkFirstSeen();
  }

  Future<bool> checkFirstSeen() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final bool seen = (prefs.getBool('seen') ?? false);
      if (!seen) {
        await prefs.setBool('seen', true);
      }
      return seen;
    } catch (e) {
      // Handling SharedPreferences errors
      print('Failed to access SharedPreferences: $e');
      return false;  // Assuming false if there's an error accessing prefs
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: hasSeen,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == true) {
            return const HomeScreen();
          } else if (snapshot.data == false) {
            return const WelcomeScreen();
          }
        }
        // Handle loading and error state more gracefully
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
