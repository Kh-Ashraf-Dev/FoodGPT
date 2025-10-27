import 'dart:math';

import 'package:flutter/material.dart';
import 'package:food_gpt/core/data/suggestions_model.dart';

class SuggestionScreen extends StatefulWidget {
  const SuggestionScreen({super.key});

  @override
  State<SuggestionScreen> createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends State<SuggestionScreen>
    with SingleTickerProviderStateMixin {
  late Map currentMeal;
  late AnimationController _controller;
  late Animation<double> _animation;

  final categories = const ['فطور', 'غداء', 'عشاء', 'تحلية', 'سناكس', 'صحي'];

  @override
  void initState() {
    super.initState();
    currentMeal = SuggestionData.getRandomMeal(
      categories[Random().nextInt(categories.length)],
    );

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  void suggestAgain() {
    _controller.reverse().then((_) {
      setState(() {
        currentMeal = SuggestionData.getRandomMeal(
          categories[Random().nextInt(categories.length)],
        );
      });
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();

    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title: Text(
          'اقتراح ${categories[Random().nextInt(categories.length)]} 🍽️',
        ),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: ScaleTransition(
            scale: _animation,
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              color: Colors.white,
              margin: const EdgeInsets.all(30),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 50,
                  horizontal: 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      currentMeal["name"],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.pinkAccent,
                      ),
                    ),
                    const SizedBox(height: 15),

                    Hero(
                      tag:
                          'mealImage-${categories[Random().nextInt(categories.length)]}',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          currentMeal["image"] ??
                              'https://media.istockphoto.com/id/1208512719/vector/mother-and-kid-girl-preparing-healthy-food-at-home-together-best-mom-ever-mother-and.jpg?s=612x612&w=0&k=20&c=NT_rtgElOHYlbXAzrHdxlClYmtCby8BD9QQLEstZ-j8=',
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: 200,
                              color: Colors.pink[50],
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.pinkAccent,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                height: 200,
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                  size: 80,
                                ),
                              ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: suggestAgain,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pinkAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          icon: const Icon(Icons.refresh),
                          label: const Text('اقترح وجبة أخرى'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '❤️ تمت إضافة "${currentMeal["name"]}" إلى المفضلة!',
                                ),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink[200],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          icon: const Icon(Icons.favorite),
                          label: const Text('أعجبتني!'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
