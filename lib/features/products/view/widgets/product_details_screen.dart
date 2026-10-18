import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shoply_app/core/model/product/product_model.dart';
import 'package:shoply_app/features/cart/repo/cart_repo.dart';
import 'package:shoply_app/features/favorites/repo/favorites_repo.dart';
import 'package:shoply_app/features/products/animations/fly_to_cart_animation.dart';
import 'package:shoply_app/features/cart/view/widgets/checkout_success_dialog.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;
  const ProductDetailsScreen({super.key, required this.product});
  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  static const green = Color(0xFF07583F);
  final _cartRepo = CartRepo();
  final _favoritesRepo = FavoritesRepo();
  final _imageKey = GlobalKey();
  final _cartKey = GlobalKey();
  late final Stream<Set<String>> _favorites;
  int _quantity = 1;
  int _imageIndex = 0;
  bool _adding = false;
  bool _favoriteBusy = false;
  bool _added = false;

  @override
  void initState() {
    super.initState();
    _favorites = _favoritesRepo.watchFavorites();
  }

  Future<void> _toggleFavorite(bool currentlyFavorite) async {
    if (_favoriteBusy) return;
    setState(() => _favoriteBusy = true);
    try {
      if (currentlyFavorite) {
        await _favoritesRepo.removeFavorite(widget.product.id);
      } else {
        await _favoritesRepo.addFavorite(widget.product.id);
      }
      HapticFeedback.selectionClick();
    } catch (e) {
      if (mounted) _message('Could not update favorites: $e', error: true);
    } finally {
      if (mounted) setState(() => _favoriteBusy = false);
    }
  }

  void _message(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      behavior: SnackBarBehavior.floating,
      backgroundColor: error ? Colors.red : green,
    ));
  }

  
  Future<void> _addToCart() async {
          if (_adding) return;

          setState(() {
            _adding = true;
            _added = false;
          });

          try {
            final addedQuantity = _quantity;

            // Step 1: Save product to Firestore.
            await _cartRepo.addToCart(
              widget.product.id,
              quantity: addedQuantity,
            );

            if (!mounted) return;

            HapticFeedback.mediumImpact();

            // Step 2: Play Fly-to-Cart animation.
            if (_imageIndex == 0 &&
                widget.product.images.isNotEmpty) {
              try {
                await FlyToCartAnimation.play(
                  context: context,
                  sourceKey: _imageKey,
                  targetKey: _cartKey,
                  imageUrl: widget.product.images.first,
                );
              } catch (_) {
                // Animation failure should not affect
                // a successfully saved cart item.
              }
            }

            if (!mounted) return;

            setState(() {
              _added = true;
            });

            // Step 3: Display animated success dialog.
            await showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return CheckoutSuccessDialog(
                  title: 'Added to Cart!',
                  message:
                      '${widget.product.name}\n'
                      'Quantity: $_quantity\n\n'
                      'Your product has been added to your shopping cart.',
                  buttonText: 'Continue Shopping',
                );
              },
            );
          } catch (error) {
            if (!mounted) return;

            _message(
              'Unable to add to cart: $error',
              error: true,
            );
          } finally {
            if (mounted) {
              setState(() {
                _adding = false;
              });
            }
          }
        }


  Widget _gallery(bool reduceMotion) {
    final images = widget.product.images;
    if (images.isEmpty) {
      return const SizedBox(height: 290, child: Center(child: Icon(Icons.image_not_supported_outlined, size: 56)));
    }
    return Column(children: [
      SizedBox(
        height: 290,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: PageView.builder(
            itemCount: images.length,
            onPageChanged: (i) => setState(() => _imageIndex = i),
            itemBuilder: (context, i) {
              Widget image = Container(
                color: const Color(0xFFF7F9F8),
                alignment: Alignment.center,
                child: Image.network(images[i], fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => const Icon(Icons.broken_image_outlined, size: 45)),
              );
              if (i == 0) {
                image = Hero(
                  tag: 'product-image-${widget.product.id}',
                  child: KeyedSubtree(key: _imageKey, child: image),
                );
              }
              return image;
            },
          ),
        ),
      ),
      if (images.length > 1) ...[
        const SizedBox(height: 14),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(images.length, (i) {
          return AnimatedContainer(
            duration: reduceMotion ? Duration.zero : const Duration(milliseconds: 240),
            width: i == _imageIndex ? 25 : 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(color: i == _imageIndex ? green : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20)),
          );
        })),
      ],
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final reduced = MediaQuery.disableAnimationsOf(context);
    Widget reveal(Widget child, int delay) => reduced ? child : child.animate()
        .fadeIn(delay: Duration(milliseconds: delay), duration: 350.ms)
        .slideY(begin: .07, end: 0, delay: Duration(milliseconds: delay), duration: 430.ms);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: green,
        actions: [
          StreamBuilder<Set<String>>(
            stream: _favorites,
            builder: (context, snapshot) {
              final selected = snapshot.data?.contains(product.id) ?? false;
              return IconButton(
                tooltip: selected ? 'Remove from favorites' : 'Add to favorites',
                onPressed: snapshot.hasData && !snapshot.hasError && !_favoriteBusy
                    ? () => _toggleFavorite(selected) : null,
                icon: AnimatedSwitcher(
                  duration: reduced ? Duration.zero : const Duration(milliseconds: 230),
                  transitionBuilder: (child, a) => ScaleTransition(scale: a, child: child),
                  child: Icon(selected ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      key: ValueKey(selected), color: selected ? Colors.redAccent : green),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Icon(Icons.shopping_cart_rounded, key: _cartKey, color: green),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _gallery(reduced),
          const SizedBox(height: 22),
          reveal(Text(product.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), 70),
          const SizedBox(height: 10),
          reveal(Text('\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: green)), 130),
          const SizedBox(height: 18),
          reveal(Text(product.description, style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black54)), 190),
          const SizedBox(height: 24),
          Row(children: [
            const Text('Quantity', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const Spacer(),
            IconButton(onPressed: _adding || _quantity <= 1 ? null : () {
              HapticFeedback.selectionClick(); setState(() { _quantity--; _added = false; });
            }, icon: const Icon(Icons.remove_circle_outline)),
            SizedBox(width: 40, child: AnimatedSwitcher(
              duration: reduced ? Duration.zero : const Duration(milliseconds: 180),
              child: Text('$_quantity', key: ValueKey(_quantity), textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            )),
            IconButton(onPressed: _adding ? null : () {
              HapticFeedback.selectionClick(); setState(() { _quantity++; _added = false; });
            }, icon: const Icon(Icons.add_circle_outline)),
          ]),
          const SizedBox(height: 25),
          SizedBox(width: double.infinity, height: 54, child: ElevatedButton(
            onPressed: _adding ? null : _addToCart,
            style: ElevatedButton.styleFrom(backgroundColor: green, foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
            child: AnimatedSwitcher(
              duration: reduced ? Duration.zero : const Duration(milliseconds: 200),
              child: _adding
                  ? const SizedBox(key: ValueKey('loading'), height: 22, width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Row(key: ValueKey(_added), mainAxisSize: MainAxisSize.min, children: [
                      Icon(_added ? Icons.check_circle_rounded : Icons.shopping_cart_outlined),
                      const SizedBox(width: 9),
                      Text(_added ? 'Added to Cart!' : 'Add to Cart'),
                    ]),
            ),
          )),
        ]),
      ),
    );
  }
}
