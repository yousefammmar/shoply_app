
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeAnimations {

  // ================= FADE IN =================

  static Widget fadeIn(Widget child) {
    return child
        .animate()
        .fadeIn(duration: 500.ms)
        .slideY(
          begin: 0.15,
          end: 0,
          duration: 500.ms,
          curve: Curves.easeOutCubic,
        );
  }

  // ================= SCALE IN =================

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

  // ================= SLIDE FROM LEFT =================

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

  // ================= BLUR REVEAL =================

  static Widget blurReveal(Widget child) {
    return child
        .animate()
        .fadeIn(
          duration: 650.ms,
          curve: Curves.easeOut,
        )
        .blur(
          begin: const Offset(8, 8),
          end: Offset.zero,
          duration: 650.ms,
          curve: Curves.easeOutCubic,
        )
        .slideY(
          begin: 0.12,
          end: 0,
          duration: 650.ms,
          curve: Curves.easeOutCubic,
        );
  }

  // ================= ELASTIC POP =================

  static Widget elasticPop(
    Widget child, {
    int delay = 0,
  }) {
    return child
        .animate()
        .fadeIn(
          delay: Duration(milliseconds: delay),
          duration: 350.ms,
        )
        .scale(
          begin: const Offset(0.7, 0.7),
          end: const Offset(1, 1),
          delay: Duration(milliseconds: delay),
          duration: 550.ms,
          curve: Curves.elasticOut,
        );
  }

  // ================= SHIMMER HIGHLIGHT =================

  static Widget shimmerHighlight(Widget child) {
    return child
        .animate()
        .shimmer(
          duration: 1400.ms,
          delay: 500.ms,
          color: Colors.white.withValues(alpha: 0.22),
        );
  }
}
