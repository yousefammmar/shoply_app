import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shoply_app/core/utils/images/app_images.dart';
import 'package:shoply_app/core/utils/theme/app_colors.dart';
class HomeCategories extends StatelessWidget
{
  const HomeCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
        ('Tops', AppImages.categoryClothes),
        ('Bags', AppImages.categoryBags),
        ('Shoes', AppImages.categoryShoes),
        ('Sunglasses', AppImages.categorySunglasses),
        ('Perfumes', AppImages.categoryPerfume),
      ];
    return Column
    (
      crossAxisAlignment: CrossAxisAlignment.start,
      
      children:
      [
        Row (
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: 
          [
            const Text
            (
              'Categories',
              style: TextStyle
              (
                fontSize: 20,
                fontWeight:FontWeight.bold
              ),
            ),
            TextButton
            (
              onPressed:(){}, 
              child: const Text 
              (
                'View All',
                style: TextStyle(color: AppColors.primaryColor),
              )
            ),
          ]
        ),
        const SizedBox(height:12),
          Row(
          children: List.generate(categories.length, (index) {
            final category = categories[index];

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F7F7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Image.network(
                          category.$2,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.image_not_supported_outlined,
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      category.$1,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            )
                .animate()
                .fadeIn(
                  delay: Duration(milliseconds: index * 100),
                  duration: 400.ms,
                )
                .scale(
                  begin: const Offset(0.85, 0.85),
                  end: const Offset(1, 1),
                  duration: 400.ms,
                  curve: Curves.easeOutBack,
                );
          }),
        ),
      ]
    
    );

  }
  
}