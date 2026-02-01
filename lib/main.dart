import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const ERBriwanApp());
}

class ERBriwanApp extends StatelessWidget {
  const ERBriwanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ERBriwan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2196F3)),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
