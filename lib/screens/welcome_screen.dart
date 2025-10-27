import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../widgets/gradient_background.dart';
import 'home_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _imageController;
  late AnimationController _textController;
  late AnimationController _buttonController;

  late Animation<Offset> _imageOffset;
  late Animation<double> _textOpacity;
  late Animation<double> _buttonScale;

  @override
  void initState() {
    super.initState();

    _imageController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _imageOffset = Tween(begin: const Offset(0, -0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _imageController, curve: Curves.easeOutBack),
        );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _textOpacity = CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    );

    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
      lowerBound: 0.7,
      upperBound: 1.0,
    );
    _buttonScale = CurvedAnimation(
      parent: _buttonController,
      curve: Curves.easeOutBack,
    );

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 300));
      _imageController.forward();
      await Future.delayed(const Duration(milliseconds: 400));
      _textController.forward();
      await Future.delayed(const Duration(milliseconds: 300));
      _buttonController.forward();
    });
  }

  @override
  void dispose() {
    _imageController.dispose();
    _textController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SlideTransition(
                position: _imageOffset,
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Hero(
                    tag: 'heroImage',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.network(
                        'https://media.istockphoto.com/id/1208512719/vector/mother-and-kid-girl-preparing-healthy-food-at-home-together-best-mom-ever-mother-and.jpg?s=612x612&w=0&k=20&c=NT_rtgElOHYlbXAzrHdxlClYmtCby8BD9QQLEstZ-j8=',
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              FadeTransition(
                opacity: _textOpacity,
                child: const Text(
                  'مرحبًا بك في تطبيق وجبات مامي الأنيقة 🍲',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              ScaleTransition(
                scale: _buttonScale,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 36,
                      vertical: 14,
                    ),
                    backgroundColor: Colors.white.withOpacity(0.9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 4,
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 800),
                        pageBuilder: (_, __, ___) => const HomeScreen(),
                        transitionsBuilder: (_, animation, __, child) =>
                            FadeTransition(opacity: animation, child: child),
                      ),
                    );
                  },
                  child: const Text(
                    'ابدأ الآن',
                    style: TextStyle(
                      color: Colors.pinkAccent,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
