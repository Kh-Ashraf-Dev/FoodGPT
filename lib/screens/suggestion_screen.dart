import 'package:flutter/material.dart';

import '../core/utils/meal_repository.dart';
import '../widgets/meal_card.dart';

class SuggestionScreen extends StatefulWidget {
  const SuggestionScreen({super.key});

  @override
  State<SuggestionScreen> createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends State<SuggestionScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final meal = MealRepository.meals[index];
    return Scaffold(
      appBar: AppBar(title: const Text('اقتراح وجبة')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              child: MealCard(key: ValueKey(meal.id), meal: meal),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      index = (index + 1) % MealRepository.meals.length;
                    });
                  },
                  child: const Text('اقترح وجبة أخرى'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(onPressed: () {}, child: const Text('أعجبتني!')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
