import 'package:flutter/material.dart';
import 'package:shoply_app/core/utils/images/app_images.dart';

class HomeCategories extends StatelessWidget {
  const HomeCategories({super.key});

  static const categories = [
    ('Tops', AppImages.categoryClothes),
    ('Bags', AppImages.categoryBags),
    ('Shoes', AppImages.categoryShoes),
    ('Sunglasses', AppImages.categoryGlasses),
    ('Perfumes', AppImages.categoryPerfumes),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Categories',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 175,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            separatorBuilder: (_, __) =>
                const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final (name, imageUrl) = categories[index];

              return SizedBox(
                width: 130,
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        imageUrl,
                        width: 130,
                        height: 130,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                        debugPrint('IMAGE ERROR: $imageUrl');
                        debugPrint('DETAILS: $error');

                        return const Icon(Icons.broken_image);
                      },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}