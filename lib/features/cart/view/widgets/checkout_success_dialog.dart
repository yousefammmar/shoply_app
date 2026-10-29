
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shoply_app/l10n/l10n.dart';

class CheckoutSuccessDialog extends StatefulWidget {
  // Null values fall back to the localized order-placed texts.
  final String? title;
  final String? message;
  final String? buttonText;

  const CheckoutSuccessDialog({
    super.key,
    this.title,
    this.message,
    this.buttonText,
  });

  @override
  State<CheckoutSuccessDialog> createState() =>
      _CheckoutSuccessDialogState();
}

class _CheckoutSuccessDialogState
    extends State<CheckoutSuccessDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _confettiController;

  @override
  void initState() {
    super.initState();

    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1450),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      if (!MediaQuery.disableAnimationsOf(context)) {
        _confettiController.forward();
      }
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  // ================= ENTRANCE ANIMATION =================

  Widget _animateEntrance(
    Widget child, {
    required int delay,
    required bool reduceMotion,
  }) {
    if (reduceMotion) return child;

    return child
        .animate()
        .fadeIn(
          delay: Duration(milliseconds: delay),
          duration: 400.ms,
        )
        .slideY(
          begin: 0.1,
          end: 0,
          delay: Duration(milliseconds: delay),
          duration: 400.ms,
          curve: Curves.easeOutCubic,
        );
  }

  // ================= SUCCESS ICON =================

  Widget _buildSuccessIcon(bool reduceMotion) {
    final cs = Theme.of(context).colorScheme;
    Widget icon = CircleAvatar(
      radius: 51,
      backgroundColor: cs.primaryContainer,
      child: Icon(
        Icons.check_circle_rounded,
        color: cs.primary,
        size: 76,
      ),
    );

    if (reduceMotion) return icon;

    return icon
        .animate()
        .fadeIn(duration: 250.ms)
        .scale(
          begin: const Offset(0.3, 0.3),
          end: const Offset(1, 1),
          duration: 580.ms,
          curve: Curves.easeOutBack,
        );
  }

  // ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    final bool reduceMotion =
        MediaQuery.disableAnimationsOf(context);
    final l10n = context.l10n;
    final cs = Theme.of(context).colorScheme;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 25,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(26),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Stack(
          children: [
            // ================= CONFETTI =================

            if (!reduceMotion)
              Positioned.fill(
                child: IgnorePointer(
                  child: AnimatedBuilder(
                    animation: _confettiController,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: _ConfettiPainter(
                          progress: _confettiController.value,
                        ),
                      );
                    },
                  ),
                ),
              ),

            // ================= DIALOG CONTENT =================

            Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),

                  // SUCCESS CHECKMARK
                  _buildSuccessIcon(reduceMotion),

                  const SizedBox(height: 22),

                  // DYNAMIC TITLE
                  _animateEntrance(
                    Text(
                      widget.title ?? l10n.orderPlacedTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: cs.primary,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    delay: 150,
                    reduceMotion: reduceMotion,
                  ),

                  const SizedBox(height: 12),

                  // DYNAMIC MESSAGE
                  _animateEntrance(
                    Text(
                      widget.message ?? l10n.orderPlacedMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                    delay: 280,
                    reduceMotion: reduceMotion,
                  ),

                  const SizedBox(height: 23),

                  // ACTION BUTTON
                  _animateEntrance(
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cs.primary,
                          foregroundColor: cs.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          widget.buttonText ?? l10n.done,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    delay: 390,
                    reduceMotion: reduceMotion,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================================================
// CONFETTI PAINTER
// ==================================================

class _ConfettiPainter extends CustomPainter {
  final double progress;

  const _ConfettiPainter({
    required this.progress,
  });

  static const List<Color> colors = [
    Color(0xFF07583F),
    Color(0xFF40A878),
    Color(0xFFFFC857),
    Color(0xFFEF7777),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(42);

    for (int i = 0; i < 42; i++) {
      final angle =
          random.nextDouble() * math.pi * 2;

      final distance =
          45 + random.nextDouble() * 175;

      final t = progress;

      // Horizontal movement
      final x = size.width / 2 +
          math.cos(angle) * distance * t;

      // Vertical movement with gravity
      final y = size.height * 0.24 +
          math.sin(angle) * distance * t +
          90 * t * t;

      // Gradually fade out each particle
      final opacity =
          (1 - t).clamp(0.0, 1.0);

      final paint = Paint()
        ..color = colors[i % colors.length]
            .withValues(alpha: opacity);

      canvas.save();

      canvas.translate(x, y);

      canvas.rotate(angle + t * 4);

      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: 4,
          height: 8,
        ),
        paint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(
    covariant _ConfettiPainter oldDelegate,
  ) {
    return oldDelegate.progress != progress;
  }
}
