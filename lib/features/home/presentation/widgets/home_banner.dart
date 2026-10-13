
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        'assets/images/banner_shoe.png',
        width: double.infinity,
        fit: BoxFit.contain,
      ),
    )
        .animate()
        .fadeIn(
      duration: 400.ms,
      curve: Curves.easeOut,
    )
        .slideY(
      begin: 0.15,
      end: 0,
      duration: 400.ms,
      curve: Curves.easeOutCubic,
    );
  }
}
