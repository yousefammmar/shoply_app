
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:shoply_app/features/home/animations/product_animations.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final double price;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final int index;
  final bool isFavorite;

  const ProductCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.onTap,
    this.onFavorite,
    this.index = 0,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return ProductAnimations.appear(
      GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.contain,
                        placeholder: (context, url) =>
                            const Center(
                              child: CircularProgressIndicator(),
                            ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.broken_image_outlined),
                      ),
                    ),
                  ),

                  Positioned(
                    right: 8,
                    top: 8,
                    child: IconButton(
                      onPressed: onFavorite,
                      icon: Icon(
                        isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: isFavorite
                            ? Colors.red
                            : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              '\$${price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Color(0xFF07583F),
              ),
            ),
          ],
        ),
      ),
      index: index,
    );
  }
}

