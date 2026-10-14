import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ProductAnimations {
  static Widget appear(
    Widget child, {
    int index = 0,
  }) {
    return child
        .animate()
        .fadeIn(
          duration: 400.ms,
          delay: Duration(milliseconds: index * 80),
        )
        .slideY(
          begin: 0.12,
          end: 0,
          duration: 400.ms,
          curve: Curves.easeOutCubic,
        );
  }
}