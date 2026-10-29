
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:shoply_app/features/products/view_model/products_cubit.dart';
import 'package:shoply_app/features/products/view/widgets/product_card.dart';

import 'package:shoply_app/features/products/view/widgets/product_details_screen.dart';
import 'package:shoply_app/l10n/l10n.dart';
class TrendingProducts extends StatefulWidget {
  const TrendingProducts({super.key});

  @override
  State<TrendingProducts> createState() => _TrendingProductsState();
}

class _TrendingProductsState extends State<TrendingProducts> {
  // Prevent unnecessary entrance animation after rebuilding.
  final Set<String> _animatedProductIds = {};

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final l10n = context.l10n;
    final cs = Theme.of(context).colorScheme;

    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        if (state is ProductsLoading) {
          return const _TrendingSkeleton();
        }

        if (state is ProductsError) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 42,
                  color: cs.primary,
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.errorWithDetails(state.message),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: () {
                    context.read<ProductsCubit>().getProducts();
                  },
                  icon: const Icon(Icons.refresh),
                  label: Text(l10n.tryAgain),
                ),
              ],
            ),
          );
        }

        if (state is ProductsSuccess) {
          final products = state.products
              .where((product) => product.isTrending)
              .toList();

          if (products.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(l10n.noTrendingProducts),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= SECTION HEADER =================
              Row(
                children: [
                  const Icon(
                    Icons.local_fire_department_rounded,
                    color: Color(0xFFE88A2D),
                    size: 25,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.trendingProducts,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: cs.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      l10n.popular,
                      style: TextStyle(
                        color: cs.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ================= PRODUCTS GRID =================
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

                  final shouldAnimate = !reduceMotion &&
                      !_animatedProductIds.contains(product.id);

                  // Mark before future widget rebuilds.
                  _animatedProductIds.add(product.id);

                  Widget card = ProductCard(
                    key: ValueKey(product.id),
                    product: product,
                    onTap: ()
                    {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_)=>ProductDetailsScreen(product:product))
                      );
                    }
                  );

                  if (!shouldAnimate) return card;

                  return card
                      .animate()
                      .fadeIn(
                        delay: Duration(
                          milliseconds: (index % 6) * 65,
                        ),
                        duration: 420.ms,
                        curve: Curves.easeOutCubic,
                      )
                      .slideY(
                        begin: 0.10,
                        end: 0,
                        delay: Duration(
                          milliseconds: (index % 6) * 65,
                        ),
                        duration: 500.ms,
                        curve: Curves.easeOutCubic,
                      )
                      .scale(
                        begin: const Offset(0.97, 0.97),
                        end: const Offset(1, 1),
                        delay: Duration(
                          milliseconds: (index % 6) * 65,
                        ),
                        duration: 500.ms,
                        curve: Curves.easeOutCubic,
                      );
                },
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

// ================= SHIMMER LOADING =================

class _TrendingSkeleton extends StatelessWidget {
  const _TrendingSkeleton();

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final cs = Theme.of(context).colorScheme;

    Widget skeleton(double height) {
      final placeholder = Container(
        height: height,
        decoration: BoxDecoration(
          color: cs.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(16),
        ),
      );

      if (reduceMotion) return placeholder;

      return placeholder
          .animate(
            onPlay: (controller) => controller.repeat(),
          )
          .shimmer(
            duration: 1400.ms,
            color: cs.surface.withValues(alpha: 0.5),
          );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        skeleton(24),
        const SizedBox(height: 16),
        Row(
          children: [
            for (int i = 0; i < 2; i++) ...[
              if (i > 0) const SizedBox(width: 12),
              Expanded(
                child: Column(
                  children: [
                    skeleton(190),
                    const SizedBox(height: 10),
                    skeleton(16),
                    const SizedBox(height: 8),
                    skeleton(12),
                  ],
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
