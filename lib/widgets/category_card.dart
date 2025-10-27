import 'package:flutter/material.dart';

class CategoryCard extends StatefulWidget {
  final String category;

  const CategoryCard({super.key, required this.category});

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  String getImageForCategory() {
    switch (widget.category) {
      case 'فطور':
        return 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=600&q=80';
      case 'غداء':
        return 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?auto=format&fit=crop&w=600&q=80';
      case 'عشاء':
        return 'https://images.unsplash.com/photo-1551183053-bf91a1d81141?auto=format&fit=crop&w=600&q=80';
      case 'حلويات':
        return 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?auto=format&fit=crop&w=600&q=80';
      case 'سناكس':
        return 'https://plus.unsplash.com/premium_photo-1679591002405-13fec066bd53?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8c25hY2tzfGVufDB8fDB8fHww&auto=format&fit=crop&q=60&w=600';
      case 'صحي':
        return 'https://images.unsplash.com/photo-1540420773420-3366772f4999?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8aGVhbHRoeXxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&q=60&w=600';
      default:
        return 'https://source.unsplash.com/600x400/?food';
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          final safeValue = value.clamp(0.0, 1.0);
          return Transform.scale(
            scale: safeValue,
            child: Opacity(opacity: safeValue, child: child),
          );
        },
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(scale: _scaleAnimation.value, child: child);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.pinkAccent.withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  getImageForCategory(),
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.pinkAccent,
                        ),
                      ),
                    );
                  },
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.05),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    widget.category,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      shadows: [
                        Shadow(
                          color: Colors.black38,
                          offset: Offset(0, 2),
                          blurRadius: 6,
                        ),
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
