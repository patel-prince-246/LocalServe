import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const LocalServeApp());
}

class LocalServeApp extends StatelessWidget {
  const LocalServeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LocalServe',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,

      ),
      home: const HomeScreen(),
    );
  }
}