import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeAnimations 
{
  static Widget fadeIn(Widget child)
  {
    return  child
      .animate()
      .fadeIn(duration: 500.ms)
      .slideY
      (
        begin: 0.15,
        end: 0,
        duration:500.ms,
        curve: Curves.easeOutCubic
      );
  }
  static Widget scaleIn(Widget child) {
    return child
        .animate()
        .scale(
          begin: const Offset(0.9, 0.9),
          end: const Offset(1, 1),
          duration: 400.ms,
          curve: Curves.easeOutBack,
        );
  }
  static Widget slideFromLeft(Widget child) {
    return child
        .animate()
        .fadeIn(duration: 400.ms)
        .slideX(
          begin: -0.2,
          end: 0,
          duration: 400.ms,
          curve: Curves.easeOut,
        );
  }
}