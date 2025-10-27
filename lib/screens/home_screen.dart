import 'dart:math';

import 'package:flutter/material.dart';
import 'package:food_gpt/screens/suggestions_screen.dart';

import '../widgets/category_card.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final categories = const ['فطور', 'غداء', 'عشاء', 'حلويات', 'سناكس', 'صحي'];
  final random = Random();

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    Future.delayed(const Duration(milliseconds: 300), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildAnimatedGridItem(BuildContext context, int index) {
    final delay = index * 100;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 800 + delay),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        final safeValue = value.clamp(0.0, 1.0);
        return Transform.scale(
          scale: safeValue,
          child: Opacity(opacity: safeValue, child: child),
        );
      },
      child: CategoryCard(category: categories[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.pink.shade50,
        appBar: AppBar(
          backgroundColor: Colors.pinkAccent.shade100,
          title: FadeTransition(
            opacity: _fadeAnimation,
            child: const Text(
              'وجبات مامي الفاخرة',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
          ),
          centerTitle: true,
          elevation: 4,
        ),
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
              ),
              itemCount: categories.length,
              itemBuilder: _buildAnimatedGridItem,
            ),
          ),
        ),
        bottomNavigationBar: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: BottomNavigationBar(
            backgroundColor: Colors.pinkAccent.shade100,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'الرئيسية',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.lightbulb),
                label: 'اقتراح وجبة',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'المفضلة',
              ),
            ],
            onTap: (index) {
              if (index == 1) {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => SuggestionScreen(),
                    transitionsBuilder: (_, animation, __, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(scale: animation, child: child),
                      );
                    },
                  ),
                );
              } else if (index == 2) {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const FavoritesScreen(),
                    transitionsBuilder: (_, animation, __, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 1),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
