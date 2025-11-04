import 'dart:math';

import 'package:flutter/material.dart';
import 'package:food_gpt/core/data/suggestions_model.dart';
import 'package:food_gpt/core/managers/favourite_manager.dart';
import 'package:food_gpt/features/favorites/presentation/view/favorites_screen.dart';
import 'package:food_gpt/features/recipe_detail/presentation/view/recipe_detialed_screen.dart';

class SuggestionScreen extends StatefulWidget {
  const SuggestionScreen({super.key, this.currentCategory});
  final String? currentCategory;

  @override
  State<SuggestionScreen> createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends State<SuggestionScreen>
    with TickerProviderStateMixin {
  late Map<String, dynamic> currentMeal;
  late AnimationController _controller;
  late AnimationController _sparkleController;
  late AnimationController _heartController;
  late AnimationController _floatingController;
  late AnimationController _descriptionController;
  late AnimationController _swipeController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _sparkleAnimation;
  late Animation<double> _heartBeatAnimation;
  late Animation<double> _descriptionSlideAnimation;
  late Animation<Offset> _swipeAnimation;

  final categories = const ['فطور', 'غداء', 'عشاء', 'تحلية', 'سناكس', 'صحي'];
  String currentCategory = '';
  bool _isFavorite = false;

  // Swipe variables
  double _dragDistance = 0;
  bool _isSwipeInProgress = false;

  @override
  void initState() {
    super.initState();

    currentCategory =
        widget.currentCategory ??
        categories[Random().nextInt(categories.length)];
    currentMeal = SuggestionData.getRandomMeal(
      currentCategory,
    ); // أول وجبة بدون استثناء
    _checkIfFavorite();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400), // كان 800
    );

    _sparkleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _descriptionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300), // كان 600
    );
    _descriptionController.forward();

    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200), // كان 300
    );

    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    _swipeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250), // كان 400
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _slideAnimation = Tween<double>(
      begin: 50,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _sparkleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _sparkleController, curve: Curves.easeInOut),
    );

    _heartBeatAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(parent: _heartController, curve: Curves.easeOut));

    _descriptionSlideAnimation = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(
        parent: _descriptionController,
        curve: Curves.easeOutCubic,
      ),
    );

    _swipeAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(2.0, 0)).animate(
          CurvedAnimation(parent: _swipeController, curve: Curves.easeInOut),
        );

    _controller.forward();
  }

  void _checkIfFavorite() async {
    final isFav = await FavoritesManager.isFavorite(currentMeal["name"]);
    if (mounted) {
      setState(() {
        _isFavorite = isFav;
      });
    }
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (!_isSwipeInProgress) {
      setState(() {
        _dragDistance += details.primaryDelta ?? 0;
      });
    }
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_isSwipeInProgress) return;

    final screenWidth = MediaQuery.of(context).size.width;
    final threshold = screenWidth * 0.3;

    if (_dragDistance.abs() > threshold) {
      _performSwipeAnimation();
    } else {
      setState(() {
        _dragDistance = 0;
      });
    }
  }

  void _performSwipeAnimation() {
    setState(() {
      _isSwipeInProgress = true;
    });

    final direction = _dragDistance < 0 ? -1.0 : 1.0;

    _swipeController.reset();
    _swipeAnimation =
        Tween<Offset>(
          begin: Offset(_dragDistance / MediaQuery.of(context).size.width, 0),
          end: Offset(2.0 * direction, 0),
        ).animate(
          CurvedAnimation(parent: _swipeController, curve: Curves.easeInOut),
        );

    _swipeController.forward().then((_) {
      _descriptionController.reverse().then((_) {
        setState(() {
          currentCategory =
              widget.currentCategory ??
              categories[Random().nextInt(categories.length)];
          currentMeal = SuggestionData.getRandomMeal(
            currentCategory,
            excludeMealName: currentMeal["name"],
          );
          _isFavorite = false;
          _dragDistance = 0;
        });
        _checkIfFavorite();

        // Reset swipe animation from opposite side
        _swipeAnimation =
            Tween<Offset>(
              begin: Offset(-2.0 * direction, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: _swipeController,
                curve: Curves.easeOutCubic,
              ),
            );

        _swipeController.reset();
        _swipeController.forward().then((_) {
          setState(() {
            _isSwipeInProgress = false;
          });
        });

        Future.delayed(const Duration(milliseconds: 100), () {
          // كان 200
          _descriptionController.forward();
        });
      });
    });
  }

  void suggestAgain() {
    if (_isSwipeInProgress) return;

    _controller.reverse().then((_) {
      _descriptionController.reverse().then((_) {
        setState(() {
          currentCategory =
              widget.currentCategory ??
              categories[Random().nextInt(categories.length)];
          currentMeal = SuggestionData.getRandomMeal(
            currentCategory,
            excludeMealName: currentMeal["name"],
          );
          _isFavorite = false;
        });
        _checkIfFavorite();
        _controller.forward();
        Future.delayed(const Duration(milliseconds: 200), () {
          // كان 400
          _descriptionController.forward();
        });
      });
    });
  }

  void toggleFavorite() async {
    final Map<String, dynamic> mealWithCategory = {
      ...currentMeal,
      'category': currentCategory,
    };

    if (_isFavorite) {
      final removed = await FavoritesManager.removeFromFavorites(
        currentMeal["name"],
      );
      if (removed) {
        setState(() {
          _isFavorite = false;
        });
        _heartController.forward().then((_) => _heartController.reverse());

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.heart_broken, color: Colors.white),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '💔 تمت إزالة "${currentMeal["name"]}" من المفضلة',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.grey.shade700,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } else {
      final added = await FavoritesManager.addToFavorites(mealWithCategory);
      if (added) {
        setState(() {
          _isFavorite = true;
        });
        _heartController.forward().then((_) => _heartController.reverse());

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.favorite, color: Colors.white),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '❤️ تمت إضافة "${currentMeal["name"]}" إلى المفضلة!',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.pink,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              duration: const Duration(seconds: 2),
              action: SnackBarAction(
                label: 'عرض',
                textColor: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FavoritesScreen()),
                  );
                },
              ),
            ),
          );
        }
      }
    }
  }

  IconData getCategoryIcon() {
    switch (currentCategory) {
      case 'فطور':
        return Icons.wb_sunny_rounded;
      case 'غداء':
        return Icons.restaurant_rounded;
      case 'عشاء':
        return Icons.nightlight_round;
      case 'تحلية':
        return Icons.cake_rounded;
      case 'سناكس':
        return Icons.cookie_rounded;
      case 'صحي':
        return Icons.eco_rounded;
      default:
        return Icons.fastfood_rounded;
    }
  }

  Color getCategoryColor() {
    switch (currentCategory) {
      case 'فطور':
        return Colors.orange;
      case 'غداء':
        return Colors.red;
      case 'عشاء':
        return Colors.purple;
      case 'تحلية':
        return Colors.pink;
      case 'سناكس':
        return Colors.amber;
      case 'صحي':
        return Colors.green;
      default:
        return Colors.pinkAccent;
    }
  }

  Widget _buildFloatingHeart(double left, double top, double delay) {
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        final offset = sin((_floatingController.value + delay) * 2 * pi) * 15;
        final opacity =
            (sin((_floatingController.value + delay) * 2 * pi) + 1) / 2;
        return Positioned(
          left: left,
          top: top + offset,
          child: Opacity(
            opacity: opacity * 0.4,
            child: Icon(Icons.favorite, color: Colors.pink.shade300, size: 20),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _sparkleController.dispose();
    _heartController.dispose();
    _floatingController.dispose();
    _descriptionController.dispose();
    _swipeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(currentMeal["description"]);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                getCategoryColor().withOpacity(0.1),
                Colors.pink.shade50,
                Colors.purple.shade50,
              ],
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                _buildFloatingHeart(30, 100, 0),
                _buildFloatingHeart(
                  MediaQuery.of(context).size.width - 50,
                  200,
                  0.3,
                ),
                _buildFloatingHeart(50, 400, 0.6),
                _buildFloatingHeart(
                  MediaQuery.of(context).size.width - 70,
                  500,
                  0.9,
                ),

                Column(
                  children: [
                    // Custom App Bar
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            getCategoryColor(),
                            getCategoryColor().withOpacity(0.7),
                          ],
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: getCategoryColor().withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.arrow_forward_rounded),
                              color: Colors.white,
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                          Expanded(
                            child: AnimatedBuilder(
                              animation: _sparkleAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale:
                                      1 +
                                      (sin(_sparkleAnimation.value * 2 * pi) *
                                          0.03),
                                  child: child,
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    getCategoryIcon(),
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'اقتراح $currentCategory',
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  AnimatedBuilder(
                                    animation: _sparkleController,
                                    builder: (context, child) {
                                      return Transform.rotate(
                                        angle:
                                            _sparkleController.value * 2 * pi,
                                        child: Icon(
                                          Icons.auto_awesome,
                                          color: Colors.white,
                                          size: 22,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 48),
                        ],
                      ),
                    ),

                    // Swipe hint text
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Opacity(
                        opacity: 0.6,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.swipe,
                              size: 18,
                              color: getCategoryColor(),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'اسحب يميناً أو يساراً لوجبة جديدة',
                              style: TextStyle(
                                fontSize: 13,
                                color: getCategoryColor(),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Main Content
                    Expanded(
                      child: Center(
                        child: SingleChildScrollView(
                          child: GestureDetector(
                            onHorizontalDragUpdate: _onHorizontalDragUpdate,
                            onHorizontalDragEnd: _onHorizontalDragEnd,
                            child: AnimatedBuilder(
                              animation: _isSwipeInProgress
                                  ? _swipeAnimation
                                  : _slideAnimation,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: _isSwipeInProgress
                                      ? Offset(
                                          _swipeAnimation.value.dx *
                                              MediaQuery.of(context).size.width,
                                          0,
                                        )
                                      : Offset(
                                          _dragDistance,
                                          _slideAnimation.value,
                                        ),
                                  child: Transform.rotate(
                                    angle: _isSwipeInProgress
                                        ? _swipeAnimation.value.dx * 0.2
                                        : (_dragDistance /
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width) *
                                              0.2,
                                    child: Opacity(
                                      opacity: _isSwipeInProgress
                                          ? 1.0 -
                                                _swipeAnimation.value.dx.abs() *
                                                    0.5
                                          : 1.0 -
                                                (_dragDistance.abs() /
                                                        MediaQuery.of(
                                                          context,
                                                        ).size.width) *
                                                    0.3,
                                      child: child,
                                    ),
                                  ),
                                );
                              },
                              child: FadeTransition(
                                opacity: _fadeAnimation,
                                child: ScaleTransition(
                                  scale: _scaleAnimation,
                                  child: Container(
                                    margin: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(35),
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Colors.white,
                                          getCategoryColor().withOpacity(0.05),
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: getCategoryColor().withOpacity(
                                            0.3,
                                          ),
                                          blurRadius: 30,
                                          offset: const Offset(0, 15),
                                          spreadRadius: 5,
                                        ),
                                        BoxShadow(
                                          color: Colors.white,
                                          blurRadius: 15,
                                          offset: const Offset(-5, -5),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(35),
                                      child: Stack(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(25),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                // Category Badge
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 8,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        getCategoryColor(),
                                                        getCategoryColor()
                                                            .withOpacity(0.7),
                                                      ],
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color:
                                                            getCategoryColor()
                                                                .withOpacity(
                                                                  0.3,
                                                                ),
                                                        blurRadius: 8,
                                                        offset: const Offset(
                                                          0,
                                                          4,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Icon(
                                                        getCategoryIcon(),
                                                        color: Colors.white,
                                                        size: 18,
                                                      ),
                                                      const SizedBox(width: 6),
                                                      Text(
                                                        currentCategory,
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                const SizedBox(height: 20),

                                                // Meal Name
                                                Text(
                                                  currentMeal["name"],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 28,
                                                    fontWeight: FontWeight.bold,
                                                    color: getCategoryColor(),
                                                    height: 1.3,
                                                  ),
                                                ),

                                                const SizedBox(height: 20),

                                                // Image Container
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          25,
                                                        ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color:
                                                            getCategoryColor()
                                                                .withOpacity(
                                                                  0.3,
                                                                ),
                                                        blurRadius: 20,
                                                        offset: const Offset(
                                                          0,
                                                          10,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          25,
                                                        ),
                                                    child: Stack(
                                                      children: [
                                                        Image.network(
                                                          currentMeal["image"] ??
                                                              'https://media.istockphoto.com/id/1208512719/vector/mother-and-kid-girl-preparing-healthy-food-at-home-together-best-mom-ever-mother-and.jpg?s=612x612&w=0&k=20&c=NT_rtgElOHYlbXAzrHdxlClYmtCby8BD9QQLEstZ-j8=',
                                                          height: 240,
                                                          width:
                                                              double.infinity,
                                                          fit: BoxFit.cover,
                                                          loadingBuilder:
                                                              (
                                                                context,
                                                                child,
                                                                loadingProgress,
                                                              ) {
                                                                if (loadingProgress ==
                                                                    null)
                                                                  return child;
                                                                return Container(
                                                                  height: 240,
                                                                  decoration: BoxDecoration(
                                                                    gradient: LinearGradient(
                                                                      colors: [
                                                                        getCategoryColor()
                                                                            .withOpacity(
                                                                              0.2,
                                                                            ),
                                                                        getCategoryColor()
                                                                            .withOpacity(
                                                                              0.1,
                                                                            ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  child: Center(
                                                                    child: CircularProgressIndicator(
                                                                      color:
                                                                          getCategoryColor(),
                                                                      strokeWidth:
                                                                          3,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                          errorBuilder:
                                                              (
                                                                context,
                                                                error,
                                                                stackTrace,
                                                              ) => Container(
                                                                height: 240,
                                                                color: Colors
                                                                    .grey[300],
                                                                child: Icon(
                                                                  Icons
                                                                      .restaurant_rounded,
                                                                  color: Colors
                                                                      .grey,
                                                                  size: 80,
                                                                ),
                                                              ),
                                                        ),
                                                        // Gradient overlay
                                                        Container(
                                                          height: 240,
                                                          decoration: BoxDecoration(
                                                            gradient: LinearGradient(
                                                              begin: Alignment
                                                                  .topCenter,
                                                              end: Alignment
                                                                  .bottomCenter,
                                                              colors: [
                                                                Colors
                                                                    .transparent,
                                                                getCategoryColor()
                                                                    .withOpacity(
                                                                      0.1,
                                                                    ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),

                                                const SizedBox(height: 20),

                                                // Description Section
                                                AnimatedBuilder(
                                                  animation:
                                                      _descriptionSlideAnimation,
                                                  builder: (context, child) {
                                                    return Transform.translate(
                                                      offset: Offset(
                                                        0,
                                                        _descriptionSlideAnimation
                                                            .value,
                                                      ),
                                                      child: FadeTransition(
                                                        opacity:
                                                            _descriptionController,
                                                        child: child,
                                                      ),
                                                    );
                                                  },
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            const EdgeInsets.all(
                                                              16,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color:
                                                              getCategoryColor()
                                                                  .withOpacity(
                                                                    0.08,
                                                                  ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                20,
                                                              ),
                                                          border: Border.all(
                                                            color:
                                                                getCategoryColor()
                                                                    .withOpacity(
                                                                      0.2,
                                                                    ),
                                                            width: 1.5,
                                                          ),
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .restaurant,
                                                                  color:
                                                                      getCategoryColor(),
                                                                  size: 20,
                                                                ),
                                                                const SizedBox(
                                                                  width: 8,
                                                                ),
                                                                Text(
                                                                  'نبذة عن الوصفة',
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color:
                                                                        getCategoryColor(),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(
                                                              currentMeal["description"] ??
                                                                  '',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .grey
                                                                    .shade700,
                                                                height: 1.6,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 12,
                                                      ),
                                                      // Detailed Recipe Button
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          gradient: LinearGradient(
                                                            colors: [
                                                              getCategoryColor(),
                                                              getCategoryColor()
                                                                  .withOpacity(
                                                                    0.8,
                                                                  ),
                                                            ],
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                20,
                                                              ),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: getCategoryColor()
                                                                  .withOpacity(
                                                                    0.3,
                                                                  ),
                                                              blurRadius: 10,
                                                              offset:
                                                                  const Offset(
                                                                    0,
                                                                    5,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                        child: Material(
                                                          color: Colors
                                                              .transparent,
                                                          child: InkWell(
                                                            onTap: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) => RecipeDetailScreen(
                                                                    meal:
                                                                        currentMeal,
                                                                    categoryColor:
                                                                        getCategoryColor(),
                                                                    categoryIcon:
                                                                        getCategoryIcon(),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  20,
                                                                ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    vertical:
                                                                        14,
                                                                    horizontal:
                                                                        20,
                                                                  ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: const [
                                                                  Icon(
                                                                    Icons
                                                                        .menu_book_rounded,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 22,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Text(
                                                                    'طريقة التحضير بالتفصيل',
                                                                    style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 8,
                                                                  ),
                                                                  Icon(
                                                                    Icons
                                                                        .arrow_back_rounded,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 20,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 25),
                                                // Buttons
                                                Row(
                                                  children: [
                                                    // Refresh Button
                                                    Expanded(
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          gradient: LinearGradient(
                                                            colors: [
                                                              getCategoryColor(),
                                                              getCategoryColor()
                                                                  .withOpacity(
                                                                    0.7,
                                                                  ),
                                                            ],
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                25,
                                                              ),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: getCategoryColor()
                                                                  .withOpacity(
                                                                    0.4,
                                                                  ),
                                                              blurRadius: 10,
                                                              offset:
                                                                  const Offset(
                                                                    0,
                                                                    5,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                        child: Material(
                                                          color: Colors
                                                              .transparent,
                                                          child: InkWell(
                                                            onTap: suggestAgain,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  25,
                                                                ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    vertical:
                                                                        14,
                                                                    horizontal:
                                                                        16,
                                                                  ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: const [
                                                                  Icon(
                                                                    Icons
                                                                        .refresh_rounded,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 22,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 8,
                                                                  ),
                                                                  Text(
                                                                    'وجبة أخرى',
                                                                    style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),

                                                    const SizedBox(width: 12),

                                                    // Favorite Button
                                                    Expanded(
                                                      child: AnimatedBuilder(
                                                        animation:
                                                            _heartBeatAnimation,
                                                        builder: (context, child) {
                                                          return Transform.scale(
                                                            scale:
                                                                _heartBeatAnimation
                                                                    .value,
                                                            child: child,
                                                          );
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            gradient: LinearGradient(
                                                              colors:
                                                                  _isFavorite
                                                                  ? [
                                                                      Colors
                                                                          .pink,
                                                                      Colors
                                                                          .pink
                                                                          .shade300,
                                                                    ]
                                                                  : [
                                                                      Colors
                                                                          .grey
                                                                          .shade300,
                                                                      Colors
                                                                          .grey
                                                                          .shade200,
                                                                    ],
                                                            ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  25,
                                                                ),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color:
                                                                    (_isFavorite
                                                                            ? Colors.pink
                                                                            : Colors.grey)
                                                                        .withOpacity(
                                                                          0.3,
                                                                        ),
                                                                blurRadius: 10,
                                                                offset:
                                                                    const Offset(
                                                                      0,
                                                                      5,
                                                                    ),
                                                              ),
                                                            ],
                                                          ),
                                                          child: Material(
                                                            color: Colors
                                                                .transparent,
                                                            child: InkWell(
                                                              onTap:
                                                                  toggleFavorite,
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    25,
                                                                  ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets.symmetric(
                                                                      vertical:
                                                                          14,
                                                                      horizontal:
                                                                          16,
                                                                    ),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Icon(
                                                                      _isFavorite
                                                                          ? Icons.favorite
                                                                          : Icons.favorite_border_rounded,
                                                                      color:
                                                                          _isFavorite
                                                                          ? Colors.white
                                                                          : Colors.grey.shade600,
                                                                      size: 22,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 8,
                                                                    ),
                                                                    Text(
                                                                      _isFavorite
                                                                          ? 'مفضلة!'
                                                                          : 'أعجبتني',
                                                                      style: TextStyle(
                                                                        color:
                                                                            _isFavorite
                                                                            ? Colors.white
                                                                            : Colors.grey.shade600,
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),

                                          // Corner sparkles
                                          Positioned(
                                            top: 15,
                                            right: 15,
                                            child: AnimatedBuilder(
                                              animation: _sparkleController,
                                              builder: (context, child) {
                                                return Transform.rotate(
                                                  angle:
                                                      _sparkleController.value *
                                                      2 *
                                                      pi,
                                                  child: Opacity(
                                                    opacity:
                                                        (sin(
                                                              _sparkleController
                                                                      .value *
                                                                  2 *
                                                                  pi,
                                                            ) +
                                                            1) /
                                                        3,
                                                    child: Icon(
                                                      Icons.auto_awesome,
                                                      color: getCategoryColor(),
                                                      size: 24,
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
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
