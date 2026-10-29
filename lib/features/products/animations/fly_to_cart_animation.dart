
import 'dart:async';

import 'package:flutter/material.dart';

class FlyToCartAnimation {
  FlyToCartAnimation._();

  static Future<void> play({
    required BuildContext context,
    required GlobalKey sourceKey,
    required GlobalKey targetKey,
    required String imageUrl,
  }) async {
    // Respect accessibility settings.
    if (MediaQuery.disableAnimationsOf(context)) return;

    if (imageUrl.isEmpty) return;

    final sourceContext = sourceKey.currentContext;
    final targetContext = targetKey.currentContext;

    if (sourceContext == null || targetContext == null) {
      return;
    }

    final overlay = Overlay.of(context);

    final overlayBox =
        overlay.context.findRenderObject() as RenderBox?;

    final sourceBox =
        sourceContext.findRenderObject() as RenderBox?;

    final targetBox =
        targetContext.findRenderObject() as RenderBox?;

    if (overlayBox == null ||
        sourceBox == null ||
        targetBox == null ||
        !sourceBox.attached ||
        !targetBox.attached ||
        !sourceBox.hasSize ||
        !targetBox.hasSize) {
      return;
    }

    // Coordinates relative to the overlay.
    final sourceCenter = sourceBox.localToGlobal(
      sourceBox.size.center(Offset.zero),
      ancestor: overlayBox,
    );

    final targetCenter = targetBox.localToGlobal(
      targetBox.size.center(Offset.zero),
      ancestor: overlayBox,
    );

    final completer = Completer<void>();

    late final OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) {
        return _FlyingProduct(
          imageUrl: imageUrl,
          start: sourceCenter,
          end: targetCenter,
          onComplete: () {
            entry.remove();
            entry.dispose();

            if (!completer.isCompleted) {
              completer.complete();
            }
          },
        );
      },
    );

    overlay.insert(entry);

    await completer.future;
  }
}

// ===================================================
// FLYING PRODUCT WIDGET
// ===================================================

class _FlyingProduct extends StatefulWidget {
  final String imageUrl;
  final Offset start;
  final Offset end;
  final VoidCallback onComplete;

  const _FlyingProduct({
    required this.imageUrl,
    required this.start,
    required this.end,
    required this.onComplete,
  });

  @override
  State<_FlyingProduct> createState() =>
      _FlyingProductState();
}

class _FlyingProductState extends State<_FlyingProduct>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _progress;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );

    _progress = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );

    _scale = Tween<double>(
      begin: 1,
      end: 0.20,
    ).animate(_progress);

    _opacity = TweenSequence<double>([
      TweenSequenceItem(
        tween: ConstantTween<double>(1),
        weight: 75,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1, end: 0),
        weight: 25,
      ),
    ]).animate(_progress);

    _controller.forward().whenComplete(() {
      widget.onComplete();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox.expand(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedBuilder(
              animation: _controller,
              child: _ProductThumbnail(
                imageUrl: widget.imageUrl,
              ),
              builder: (context, child) {
                final t = _progress.value;

                // Horizontal movement.
                final dx = widget.start.dx +
                    (widget.end.dx - widget.start.dx) * t;

                // Vertical movement with an arc.
                final baseY = widget.start.dy +
                    (widget.end.dy - widget.start.dy) * t;

                final arcHeight = 75 * 4 * t * (1 - t);

                final dy = baseY - arcHeight;

                return Positioned(
                  left: dx - 36,
                  top: dy - 36,
                  child: Opacity(
                    opacity: _opacity.value,
                    child: Transform.scale(
                      scale: _scale.value,
                      child: child,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ===================================================
// PRODUCT THUMBNAIL
// ===================================================

class _ProductThumbnail extends StatelessWidget {
  final String imageUrl;

  const _ProductThumbnail({
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: 72,
      height: 72,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: cs.primary,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.shopping_bag_outlined,
              color: cs.primary,
              size: 30,
            );
          },
        ),
      ),
    );
  }
}
