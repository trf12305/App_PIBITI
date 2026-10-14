import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

class FemmeApp extends StatelessWidget {
  const FemmeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Femme',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
      ),
      home: const SplashScreen(),
    );
  }
}