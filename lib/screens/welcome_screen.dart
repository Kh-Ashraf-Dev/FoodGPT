import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:food_gpt/screens/home_screen.dart';

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
  late AnimationController _sparkleController;
  late AnimationController _floatingController;

  late Animation<double> _imageScale;
  late Animation<double> _imageRotation;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;
  late Animation<double> _buttonScale;
  late Animation<double> _sparkleAnimation;

  @override
  void initState() {
    super.initState();

    _imageController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _imageScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _imageController, curve: Curves.elasticOut),
    );
    _imageRotation = Tween<double>(begin: -0.2, end: 0.0).animate(
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
    _textSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
        );

    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _buttonScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.elasticOut),
    );

    _sparkleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _sparkleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _sparkleController, curve: Curves.easeInOut),
    );

    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 200));
      _imageController.forward();
      await Future.delayed(const Duration(milliseconds: 500));
      _textController.forward();
      await Future.delayed(const Duration(milliseconds: 400));
      _buttonController.forward();
    });
  }

  @override
  void dispose() {
    _imageController.dispose();
    _textController.dispose();
    _buttonController.dispose();
    _sparkleController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  Widget _buildFloatingEmoji(
    String emoji,
    double left,
    double top,
    double delay,
  ) {
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        final offset = sin((_floatingController.value + delay) * 2 * pi) * 20;
        final opacity =
            (sin((_floatingController.value + delay) * 2 * pi) + 1) / 2;
        return Positioned(
          left: left,
          top: top + offset,
          child: Opacity(
            opacity: opacity * 0.6,
            child: Text(emoji, style: const TextStyle(fontSize: 40)),
          ),
        );
      },
    );
  }

  Widget _buildSparkle(double left, double top, double delay) {
    return AnimatedBuilder(
      animation: _sparkleAnimation,
      builder: (context, child) {
        final scale = (sin((_sparkleAnimation.value + delay) * 2 * pi) + 1) / 2;
        final opacity =
            (sin((_sparkleAnimation.value + delay) * 2 * pi) + 1) / 3;
        return Positioned(
          left: left,
          top: top,
          child: Transform.scale(
            scale: scale,
            child: Opacity(
              opacity: opacity,
              child: Icon(Icons.star, color: Colors.yellow.shade300, size: 20),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.pink.shade400,
                Colors.purple.shade300,
                Colors.orange.shade300,
              ],
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                // Floating emojis
                _buildFloatingEmoji('🍕', 30, 100, 0),
                _buildFloatingEmoji(
                  '🍰',
                  MediaQuery.of(context).size.width - 80,
                  150,
                  0.3,
                ),
                _buildFloatingEmoji('🥗', 50, 500, 0.6),
                _buildFloatingEmoji(
                  '🍜',
                  MediaQuery.of(context).size.width - 70,
                  550,
                  0.9,
                ),

                // Sparkles
                _buildSparkle(60, 200, 0),
                _buildSparkle(
                  MediaQuery.of(context).size.width - 100,
                  250,
                  0.5,
                ),
                _buildSparkle(80, 600, 0.3),
                _buildSparkle(
                  MediaQuery.of(context).size.width - 120,
                  650,
                  0.8,
                ),

                // Main content
                Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),

                        // Image with animations
                        AnimatedBuilder(
                          animation: _imageController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _imageScale.value,
                              child: Transform.rotate(
                                angle: _imageRotation.value,
                                child: child,
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 40),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 30,
                                  offset: const Offset(0, 15),
                                  spreadRadius: 5,
                                ),
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.3),
                                  blurRadius: 15,
                                  offset: const Offset(-5, -5),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(35),
                                  child: Hero(
                                    tag: 'heroImage',
                                    child: Image.network(
                                      'https://media.istockphoto.com/id/1208512719/vector/mother-and-kid-girl-preparing-healthy-food-at-home-together-best-mom-ever-mother-and.jpg?s=612x612&w=0&k=20&c=NT_rtgElOHYlbXAzrHdxlClYmtCby8BD9QQLEstZ-j8=',
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return Container(
                                              height: 300,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Colors.pink.withOpacity(
                                                      0.3,
                                                    ),
                                                    Colors.purple.withOpacity(
                                                      0.3,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              child: const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                      color: Colors.white,
                                                      strokeWidth: 3,
                                                    ),
                                              ),
                                            );
                                          },
                                    ),
                                  ),
                                ),
                                // Gradient overlay
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(35),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.1),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                // Sparkle effect on corner
                                Positioned(
                                  top: 20,
                                  right: 20,
                                  child: AnimatedBuilder(
                                    animation: _sparkleController,
                                    builder: (context, child) {
                                      return Transform.rotate(
                                        angle:
                                            _sparkleController.value * 2 * pi,
                                        child: Opacity(
                                          opacity:
                                              (sin(
                                                    _sparkleController.value *
                                                        2 *
                                                        pi,
                                                  ) +
                                                  1) /
                                              3,
                                          child: Icon(
                                            Icons.auto_awesome,
                                            color: Colors.yellow.shade300,
                                            size: 32,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 50),

                        // Welcome text with slide animation
                        SlideTransition(
                          position: _textSlide,
                          child: FadeTransition(
                            opacity: _textOpacity,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 30,
                              ),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    'مرحبًا بك في',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text('✨', style: TextStyle(fontSize: 24)),
                                      SizedBox(width: 4),
                                      Text(
                                        'FoodGPT',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          letterSpacing: 0.8,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black26,
                                              offset: Offset(2, 2),
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        '🍲',
                                        style: TextStyle(fontSize: 24),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'اكتشف وصفات شهية ولذيذة\nلكل أوقات اليوم',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white.withOpacity(0.95),
                                      height: 1.5,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Start button with scale animation
                        ScaleTransition(
                          scale: _buttonScale,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.4),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    PageRouteBuilder(
                                      transitionDuration: const Duration(
                                        milliseconds: 800,
                                      ),
                                      pageBuilder: (_, __, ___) =>
                                          const HomeScreen(),
                                      transitionsBuilder:
                                          (_, animation, __, child) =>
                                              FadeTransition(
                                                opacity: animation,
                                                child: child,
                                              ),
                                    ),
                                  );
                                },
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 50,
                                    vertical: 18,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.white,
                                        Colors.white.withOpacity(0.95),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.rocket_launch_rounded,
                                        color: Colors.pink.shade400,
                                        size: 28,
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        'ابدأ الآن',
                                        style: TextStyle(
                                          color: Colors.pinkAccent,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Icon(
                                        Icons.arrow_back_rounded,
                                        color: Colors.pink.shade400,
                                        size: 24,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
