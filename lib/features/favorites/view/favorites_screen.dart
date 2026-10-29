
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shoply_app/features/favorites/repo/favorites_repo.dart';
import 'package:shoply_app/features/products/repo/products_repo.dart';
import 'package:shoply_app/features/products/view_model/products_cubit.dart';
import 'package:shoply_app/features/products/view/widgets/product_card.dart';
import 'package:shoply_app/features/products/view/widgets/product_details_screen.dart';
import 'package:shoply_app/l10n/l10n.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductsCubit(
        productsRepo: ProductsRepo(),
      )..getProducts(),
      child: const _FavoritesBody(),
    );
  }
}

class _FavoritesBody extends StatefulWidget {
  const _FavoritesBody();

  @override
  State<_FavoritesBody> createState() => _FavoritesBodyState();
}

class _FavoritesBodyState extends State<_FavoritesBody> {
  final FavoritesRepo _favoritesRepo = FavoritesRepo();

  late final Stream<Set<String>> _favoritesStream;

  @override
  void initState() {
    super.initState();
    _favoritesStream = _favoritesRepo.watchFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return StreamBuilder<Set<String>>(
      stream: _favoritesStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                l10n.favoritesLoadFailed(snapshot.error!),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final favoriteIds = snapshot.data!;

        if (favoriteIds.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 75,
                  color: muted,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.noFavorites,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.noFavoritesHint,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: muted),
                ),
              ],
            ),
          );
        }

        return BlocBuilder<ProductsCubit, ProductsState>(
          builder: (context, state) {
            if (state is ProductsLoading ||
                state is ProductsInitial) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is ProductsError) {
              return Center(
                child: Text(
                  l10n.errorWithDetails(state.message),
                  textAlign: TextAlign.center,
                ),
              );
            }

            if (state is ProductsSuccess) {
              final favoriteProducts = state.products
                  .where(
                    (product) => favoriteIds.contains(product.id),
                  )
                  .toList();

              if (favoriteProducts.isEmpty) {
                return Center(
                  child: Text(
                    l10n.noMatchingFavorites,
                  ),
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: favoriteProducts.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  mainAxisExtent: 245,
                ),
                itemBuilder: (context, index) {
                  final product = favoriteProducts[index];

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
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        );
      },
    );
  }
}
