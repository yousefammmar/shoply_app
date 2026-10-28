
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoply_app/features/categories/view_model/categories_cubit.dart';
import 'package:shoply_app/features/categories/view_model/categories_state.dart';
import 'package:shoply_app/features/products/view/category_products_screen.dart';
import 'package:shoply_app/l10n/l10n.dart';
class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: BlocBuilder<CategoriesCubit, CategoriesState>(
        builder: (context, state) {
          if (state is CategoriesLoading ||
              state is CategoriesInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is CategoriesError) {
            return Center(
              child: Text(
                l10n.errorWithDetails(state.message),
                textAlign: TextAlign.center,
              ),
            );
          }

          if (state is CategoriesLoaded) {
            if (state.categories.isEmpty) {
              return Center(
                child: Text(l10n.noCategories),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.categories.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: 12),
              itemBuilder: (context, index) {
                
                final category = state.categories[index];
                final categoryName = l10n.categoryName(
                  category.id,
                  category.name,
                );
                
                return InkWell
                  (
                    borderRadius: BorderRadius.circular(16),
                    onTap:()
                    {
                      Navigator.push
                      (
                        context,
                        MaterialPageRoute(builder: (_)=>CategoryProductsScreen(categoryId: category.id, categoryName: categoryName))
                      );
                    },
                    child:Container(
                          height: 90,
                          decoration: BoxDecoration(
                            color: cs.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadiusDirectional.horizontal(
                                  start: Radius.circular(16),
                                ),
                                child: Image.network(
                                  category.image,
                                  width: 100,
                                  height: 90,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) =>
                                      const SizedBox(
                                    width: 100,
                                    child: Icon(Icons.broken_image_outlined),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  categoryName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const Icon(Icons.chevron_right),
                              const SizedBox(width: 16),
                            ],
                          ),
                        )
                  );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
