import 'package:firebase_core/firebase_core.dart'; // Firebase Core package for initializing Firebase
import 'package:flutter/foundation.dart'; // For detecting platform (web vs mobile)
import 'package:flutter/material.dart'; // Flutter UI framework


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures that binding is initialized before using platform channels

  // Initialize Firebase based on the platform
  

  // Run the root widget of the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hides the debug banner in the top right corner
      title: 'Flutter Login', // App title
      theme: ThemeData.dark(), // App-wide theme (dark mode)
      
      initialRoute: '/', // Default route (starts at Login page)
      
      // Route definitions for named navigation
      
    );
  }
}
