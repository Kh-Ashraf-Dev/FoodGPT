import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const FancyMommyMealsApp());
}

class FancyMommyMealsApp extends StatelessWidget {
  const FancyMommyMealsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fancy Mommy Meals',
      theme: AppTheme.lightTheme,
      home: const WelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}