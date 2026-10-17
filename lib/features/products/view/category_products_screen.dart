
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoply_app/features/products/repo/products_repo.dart';
import 'package:shoply_app/features/products/view_model/products_cubit.dart';
import 'package:shoply_app/features/products/view/widgets/product_card.dart';
import 'package:shoply_app/features/products/view/widgets/product_details_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';
class CategoryProductsScreen extends StatelessWidget {
  final String categoryId;
  final String categoryName;

  const CategoryProductsScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductsCubit(
        productsRepo: ProductsRepo(),
      )..getProductsByCategory(categoryId),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(categoryName),
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF07583F),
          centerTitle: true,
        ),
        body: BlocBuilder<ProductsCubit, ProductsState>(
          builder: (context, state) {
            if (state is ProductsLoading ||
                state is ProductsInitial) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is ProductsError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    state.message,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            if (state is ProductsSuccess) {
              final products = state.products;

              if (products.isEmpty) {
                return const Center(
                  child: Text(
                    'No products found in this category',
                  ),
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: products.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  mainAxisExtent: 245,
                ),
                itemBuilder: (context, index) {
                  final product = products[index];

                  return ProductCard(
                    key: ValueKey(product.id),
                    product: product,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailsScreen(
                            product: product,
                          ),
                        ),
                      );
                    },
                  )
                      .animate()
                      .fadeIn(
                        duration: 420.ms,
                        delay: Duration(
                          milliseconds: (index % 8) * 55,
                        ),
                        curve: Curves.easeOutCubic,
                      )
                      .slideY(
                        begin: 0.12,
                        end: 0,
                        duration: 500.ms,
                        curve: Curves.easeOutCubic,
                      );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
