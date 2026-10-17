import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CheckoutSuccessDialog extends StatefulWidget {
  const CheckoutSuccessDialog({super.key});
  @override
  State<CheckoutSuccessDialog> createState() => _CheckoutSuccessDialogState();
}

class _CheckoutSuccessDialogState extends State<CheckoutSuccessDialog>
    with SingleTickerProviderStateMixin {
  static const green = Color(0xFF07583F);
  late final AnimationController _confetti;
  @override
  void initState() {
    super.initState();
    _confetti = AnimationController(vsync: this, duration: const Duration(milliseconds: 1450));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !MediaQuery.disableAnimationsOf(context)) _confetti.forward();
    });
  }
  @override
  void dispose() { _confetti.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    final reduced = MediaQuery.disableAnimationsOf(context);
    Widget entrance(Widget child, int delay) => reduced ? child : child.animate()
        .fadeIn(delay: Duration(milliseconds: delay), duration: 400.ms)
        .slideY(begin: .1, end: 0, delay: Duration(milliseconds: delay), duration: 400.ms);
    Widget check = const CircleAvatar(
      radius: 51, backgroundColor: Color(0xFFE7F4EE),
      child: Icon(Icons.check_circle_rounded, color: green, size: 76),
    );
    if (!reduced) check = check.animate().scale(
        begin: const Offset(.3, .3), end: const Offset(1, 1),
        duration: 580.ms, curve: Curves.easeOutBack);
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 25),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Stack(children: [
          if (!reduced) Positioned.fill(child: IgnorePointer(
            child: AnimatedBuilder(animation: _confetti,
                builder: (context, child) => CustomPaint(painter: _ConfettiPainter(_confetti.value))),
          )),
          Padding(padding: const EdgeInsets.all(25), child: Column(
            mainAxisSize: MainAxisSize.min, children: [
              const SizedBox(height: 10),
              check,
              const SizedBox(height: 22),
              entrance(const Text('Order Placed Successfully!', textAlign: TextAlign.center,
                  style: TextStyle(color: green, fontSize: 21, fontWeight: FontWeight.bold)), 150),
              const SizedBox(height: 12),
              entrance(const Text('Thank you for shopping with Shoply!\nYour order is saved in Order History.',
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 14, height: 1.6, color: Colors.black54)), 280),
              const SizedBox(height: 23),
              entrance(SizedBox(width: double.infinity, height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(backgroundColor: green, foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                  child: const Text('Done', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ), 390),
            ],
          )),
        ]),
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  final double progress;
  _ConfettiPainter(this.progress);
  static const colors = [Color(0xFF07583F), Color(0xFF40A878), Color(0xFFFFC857), Color(0xFFEF7777)];
  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(42);
    for (var i = 0; i < 42; i++) {
      final angle = rng.nextDouble() * math.pi * 2;
      final distance = 45 + rng.nextDouble() * 175;
      final t = progress;
      final x = size.width / 2 + math.cos(angle) * distance * t;
      final y = size.height * .24 + math.sin(angle) * distance * t + 90 * t * t;
      final opacity = (1 - t).clamp(0.0, 1.0);
      final paint = Paint()..color = colors[i % colors.length].withValues(alpha: opacity);
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(angle + t * 4);
      canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: 4, height: 8), paint);
      canvas.restore();
    }
  }
  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => oldDelegate.progress != progress;
}
