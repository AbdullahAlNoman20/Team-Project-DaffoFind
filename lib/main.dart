import 'package:firebase_core/firebase_core.dart'; // Firebase Core package for initializing Firebase
import 'package:flutter/foundation.dart'; // For detecting platform (web vs mobile)
import 'package:flutter/material.dart'; // Flutter UI framework

// Import all app pages/screens
// import 'package:flutter_app_one/pages/Home.dart';
// import 'package:flutter_app_one/pages/Register.dart';
// import 'package:flutter_app_one/pages/login.dart';
// import 'package:flutter_app_one/pages/LostPage.dart';
// import 'package:flutter_app_one/pages/FindPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures that binding is initialized before using platform channels

  // Initialize Firebase based on the platform
  if (kIsWeb) {
    // Firebase initialization for web platform with specific options
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyAiWPhEE7fzkQ4VcjHRby2fG-Z6wvuY82o", // Web API key
            authDomain: "daffofind.firebaseapp.com", // Web auth domain
            projectId: "daffofind", // Firebase project ID
            storageBucket: "daffofind.firebasestorage.app", // Firebase Storage (note: seems misconfigured, normally ends in .com)
            messagingSenderId: "386169160609", // Firebase messaging sender ID
            appId: "1:386169160609:web:124b9861cf0841aff501e0")); // Firebase app ID
  } else {
    // For mobile platforms (Android/iOS), use default Firebase config
    await Firebase.initializeApp();
  }

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
