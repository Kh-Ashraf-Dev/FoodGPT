import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/welcome/presentation/view/welcome_screen.dart';

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
