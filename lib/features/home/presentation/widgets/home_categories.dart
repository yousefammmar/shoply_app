
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:shoply_app/core/utils/images/app_images.dart';
import 'package:shoply_app/features/products/view/category_products_screen.dart';
import 'package:shoply_app/features/favorites/view_model/favorites_cubit.dart';

class HomeCategories extends StatelessWidget {
  const HomeCategories({super.key});

  static const Color primaryColor = Color(0xFF07583F);

  // Category IDs must match Firestore.
  static const categories = [
    (id: 'clothes', name: 'Tops', image: AppImages.categoryClothes),
    (id: 'bags', name: 'Bags', image: AppImages.categoryBags),
    (id: 'shoes', name: 'Shoes', image: AppImages.categoryShoes),
    (id: 'glasses', name: 'Sunglasses', image: AppImages.categoryGlasses),
    (id: 'perfumes', name: 'Perfumes', image: AppImages.categoryPerfumes),
  ];

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

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
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            separatorBuilder: (_, _) =>
                const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final category = categories[index];

              Widget card = _AnimatedCategoryCard(
                key: ValueKey(category.id),
                title: category.name,
                imageUrl: category.image,
                onTap: () {
                  final favoritesCubit =
                      context.read<FavoritesCubit>();

                  HapticFeedback.selectionClick();

                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: reduceMotion
                          ? Duration.zero
                          : const Duration(milliseconds: 360),
                      reverseTransitionDuration: reduceMotion
                          ? Duration.zero
                          : const Duration(milliseconds: 280),
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return BlocProvider.value(
                          value: favoritesCubit,
                          child: CategoryProductsScreen(
                            categoryId: category.id,
                            categoryName: category.name,
                          ),
                        );
                      },
                      transitionsBuilder: (
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      ) {
                        if (reduceMotion) return child;

                        return FadeTransition(
                          opacity: CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOut,
                          ),
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.06, 0),
                              end: Offset.zero,
                            ).animate(
                              CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeOutCubic,
                              ),
                            ),
                            child: child,
                          ),
                        );
                      },
                    ),
                  );
                },
              );

              if (!reduceMotion) {
                card = card
                    .animate()
                    .fadeIn(
                      delay: Duration(milliseconds: index * 65),
                      duration: 380.ms,
                    )
                    .slideX(
                      begin: 0.12,
                      end: 0,
                      delay: Duration(milliseconds: index * 65),
                      duration: 450.ms,
                      curve: Curves.easeOutCubic,
                    );
              }

              return card;
            },
          ),
        ),
      ],
    );
  }
}

class _AnimatedCategoryCard extends StatefulWidget {
  final String title;
  final String imageUrl;
  final VoidCallback onTap;

  const _AnimatedCategoryCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  State<_AnimatedCategoryCard> createState() =>
      _AnimatedCategoryCardState();
}

class _AnimatedCategoryCardState extends State<_AnimatedCategoryCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) {
        setState(() => _isPressed = true);
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
      },
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: reduceMotion
            ? 1
            : (_isPressed ? 0.94 : 1),
        duration: reduceMotion
            ? Duration.zero
            : const Duration(milliseconds: 170),
        curve: Curves.easeOutCubic,
        child: SizedBox(
          width: 130,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    Image.network(
                      widget.imageUrl,
                      width: 130,
                      height: 130,
                      fit: BoxFit.cover,
                      loadingBuilder: (
                        context,
                        child,
                        progress,
                      ) {
                        if (progress == null) return child;

                        final placeholder = Container(
                          width: 130,
                          height: 130,
                          color: const Color(0xFFE7F4EE),
                        );

                        if (reduceMotion) return placeholder;

                        return placeholder
                            .animate(
                              onPlay: (controller) =>
                                  controller.repeat(),
                            )
                            .shimmer(
                              duration: 1300.ms,
                              color: Colors.white54,
                            );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const SizedBox(
                          width: 130,
                          height: 130,
                          child: Icon(
                            Icons.broken_image_outlined,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),

                    Positioned(
                      top: 9,
                      right: 9,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.88),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_outward_rounded,
                          size: 15,
                          color: Color(0xFF07583F),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 9),

              Text(
                widget.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
