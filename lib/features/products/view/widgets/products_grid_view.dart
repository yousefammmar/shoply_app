
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shoply_app/features/products/view_model/products_cubit.dart';
import 'package:shoply_app/features/products/view/widgets/product_card.dart';
import 'package:shoply_app/l10n/l10n.dart';

class ProductsGridView extends StatelessWidget {
  const ProductsGridView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        if (state is ProductsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is ProductsError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                context.l10n.errorWithDetails(state.message),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (state is ProductsSuccess) {
          final products = state.products;

          if (products.isEmpty) {
            return Center(
              child: Text(context.l10n.noProducts),
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
                product: product,
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
