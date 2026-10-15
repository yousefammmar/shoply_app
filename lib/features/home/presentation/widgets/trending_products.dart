
import 'package:flutter/material.dart';

import 'package:shoply_app/core/utils/images/app_images.dart';
import 'package:shoply_app/features/home/presentation/widgets/product_card.dart';

class TrendingProducts extends StatelessWidget {
  const TrendingProducts({super.key});

  static const Color primaryColor = Color(0xFF07583F);

  @override
  Widget build(BuildContext context) {
    final products = [
      (
        name: 'Sport Sneakers',
        image: AppImages.shoes1,
        price: 120.0,
      ),
      (
        name: 'Leather Bag',
        image: AppImages.bag1,
        price: 85.0,
      ),
      (
        name: 'Casual Top',
        image: AppImages.shirt1,
        price: 45.0,
      ),
      (
        name: 'Sunglasses',
        image: AppImages.glasses1,
        price: 60.0,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Trending Products',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: Navigate to all products.
              },
              child: const Text(
                'View All',
                style: TextStyle(color: primaryColor),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: products.length,
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 16,
            mainAxisExtent: 260,
          ),
          itemBuilder: (context, index) {
            final product = products[index];

            return ProductCard(
              name: product.name,
              imageUrl: product.image,
              price: product.price,
              index: index,
            );
          },
        ),
      ],
    );
  }
}
