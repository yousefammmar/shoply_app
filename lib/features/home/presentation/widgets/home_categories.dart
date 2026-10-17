
import 'package:flutter/material.dart';

import 'package:shoply_app/core/utils/images/app_images.dart';
import 'package:shoply_app/features/products/view/category_products_screen.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoply_app/features/favorites/view_model/favorites_cubit.dart';

class HomeCategories extends StatelessWidget {
  const HomeCategories({super.key});

  // categoryId must match Firestore categoryId
  static const categories = [
    (
      id: 'clothes',
      name: 'Tops',
      image: AppImages.categoryClothes,
    ),
    (
      id: 'bags',
      name: 'Bags',
      image: AppImages.categoryBags,
    ),
    (
      id: 'shoes',
      name: 'Shoes',
      image: AppImages.categoryShoes,
    ),
    (
      id: 'glasses',
      name: 'Sunglasses',
      image: AppImages.categoryGlasses,
    ),
    (
      id: 'perfumes',
      name: 'Perfumes',
      image: AppImages.categoryPerfumes,
    ),
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
            separatorBuilder: (_, _) =>
                const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final category = categories[index];

              return InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  final favoritesCubit = context.read<FavoritesCubit>();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: favoritesCubit,
                        child: CategoryProductsScreen(
                          categoryId: category.id,
                          categoryName: category.name,
                        ),
                      ),
                    ),
                  );
                },
                child: SizedBox(
                  width: 130,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          category.image,
                          width: 130,
                          height: 130,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            debugPrint(
                              'IMAGE ERROR: ${category.image}',
                            );
                            debugPrint('DETAILS: $error');

                            return const SizedBox(
                              width: 130,
                              height: 130,
                              child: Icon(Icons.broken_image),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        category.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
