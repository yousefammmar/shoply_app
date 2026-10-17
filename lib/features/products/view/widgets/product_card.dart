
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:shoply_app/core/model/product/product_model.dart';
import 'package:shoply_app/features/favorites/repo/favorites_repo.dart';

class ProductCard extends StatefulWidget {
  final ProductModel product;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  static const Color primaryColor = Color(0xFF07583F);

  final FavoritesRepo _favoritesRepo = FavoritesRepo();

  late final Stream<Set<String>> _favoritesStream;

  bool isUpdating = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _favoritesStream = _favoritesRepo.watchFavorites();
  }

  Future<void> _toggleFavorite(bool isFavorite) async {
    if (isUpdating) return;

    setState(() => isUpdating = true);

    try {
      if (isFavorite) {
        await _favoritesRepo.removeFavorite(widget.product.id);
      } else {
        await _favoritesRepo.addFavorite(widget.product.id);
      }

      HapticFeedback.lightImpact();
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Favorite error: $error'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => isUpdating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    final imageUrl = product.images.isNotEmpty
        ? product.images.first
        : null;

    Widget productImage = ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(18),
      ),
      child: imageUrl == null
          ? const Center(
              child: Icon(
                Icons.image_not_supported_outlined,
                size: 40,
              ),
            )
          : Image.network(
              imageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(
                    Icons.broken_image_outlined,
                    size: 40,
                  ),
                );
              },
            ),
    );

    // Source image for the future Product Details Hero.
    // The destination must use the same unique Hero tag.
    if (widget.onTap != null && imageUrl != null) {
      productImage = Hero(
        tag: 'product-image-${product.id}',
        child: productImage,
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: widget.onTap == null
          ? null
          : (_) => setState(() => _isPressed = true),
      onTapUp: widget.onTap == null
          ? null
          : (_) => setState(() => _isPressed = false),
      onTapCancel: widget.onTap == null
          ? null
          : () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: reduceMotion ? 1 : (_isPressed ? 0.965 : 1),
        duration: reduceMotion
            ? Duration.zero
            : const Duration(milliseconds: 160),
        curve: Curves.easeOutCubic,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= PRODUCT IMAGE =================
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    productImage,

                    // ================= FAVORITE BUTTON =================
                    Positioned(
                      top: 8,
                      right: 8,
                      child: StreamBuilder<Set<String>>(
                        stream: _favoritesStream,
                        builder: (context, snapshot) {
                          final favoriteIds =
                              snapshot.data ?? <String>{};

                          final isFavorite =
                              favoriteIds.contains(product.id);

                          return AnimatedContainer(
                            duration: reduceMotion
                                ? Duration.zero
                                : const Duration(milliseconds: 220),
                            decoration: BoxDecoration(
                              color: isFavorite
                                  ? const Color(0xFFFFF0F1)
                                  : Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(
                                    alpha: 0.06,
                                  ),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: IconButton(
                              tooltip: isFavorite
                                  ? 'Remove from favorites'
                                  : 'Add to favorites',
                              icon: AnimatedSwitcher(
                                duration: reduceMotion
                                    ? Duration.zero
                                    : const Duration(milliseconds: 260),
                                transitionBuilder: (child, animation) {
                                  return ScaleTransition(
                                    scale: CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.easeOutBack,
                                    ),
                                    child: child,
                                  );
                                },
                                child: Icon(
                                  isFavorite
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_border_rounded,
                                  key: ValueKey(isFavorite),
                                  color: isFavorite
                                      ? Colors.redAccent
                                      : Colors.grey.shade500,
                                ),
                              ),
                              onPressed: isUpdating ||
                                      !snapshot.hasData ||
                                      snapshot.hasError
                                  ? null
                                  : () => _toggleFavorite(isFavorite),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // ================= PRODUCT INFO =================
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
