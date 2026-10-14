import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';


class BottomNavAnimations {
  static Widget animateIcon(
    Widget child, {
    required bool isSelected,
  }) {
    return child
        .animate(
          key: ValueKey(isSelected),
        )
        .scale(
          begin: isSelected
              ? const Offset(0.8, 0.8)
              : const Offset(1, 1),
          end: const Offset(1, 1),
          duration: 350.ms,
          curve: Curves.easeOutBack,
        )
        .fadeIn(
          duration: 250.ms,
        );
  }
}
