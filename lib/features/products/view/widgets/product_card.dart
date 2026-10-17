
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shoply_app/core/model/product/product_model.dart';
import 'package:shoply_app/features/favorites/view_model/favorites_cubit.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        product.images.isNotEmpty ? product.images.first : null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= PRODUCT IMAGE =================
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
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
                  ),

                  // ================= FAVORITE BUTTON =================
                  Positioned(
                    top: 8,
                    right: 8,
                    child: BlocBuilder<FavoritesCubit, FavoritesState>(
                      builder: (context, state) {
                        final isFavorite =
                            state is FavoritesSuccess &&
                            state.favoriteIds.contains(product.id);

                        return Material(
                          color: Colors.white,
                          shape: const CircleBorder(),
                          child: IconButton(
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite
                                  ? Colors.red
                                  : Colors.grey.shade400,
                            ),
                            onPressed: state is FavoritesSuccess
                                ? () {
                                    context
                                        .read<FavoritesCubit>()
                                        .toggleFavorite(product.id);
                                  }
                                : null,
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
                  // Product Name
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

                  // Product Price
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF07583F),
                    ),
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
