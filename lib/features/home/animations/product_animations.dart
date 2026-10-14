import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ProductAnimation{
  static Widget appear
  (
    Widget child, 
    {
      int index=0,
    }
  )
  {
    return child
      .animate()
      .fadeIn(duration: 400.ms, delay: Duration(milliseconds: index*80),)
      .slideY(begin: 0.12,
        end: 0,
        duration:400.ms,
        curve: Curves.easeOutCubic,
      );
  }
  static Widget zoomIn(Widget child)
  {
    return child
        .animate()
        .scale(
          begin: const Offset(0.95, 0.95),
          end: const Offset(1, 1),
          duration: 350.ms,
          curve: Curves.easeOut,
        );
  }
}