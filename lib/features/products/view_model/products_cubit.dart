
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shoply_app/core/model/product/product_model.dart';
import 'package:shoply_app/features/products/repo/products_repo.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final ProductsRepo productsRepo;

  ProductsCubit({required this.productsRepo})
      : super(ProductsInitial());

  // Get all products
  Future<void> getProducts() async {
    emit(ProductsLoading());

    final result = await productsRepo.getProducts();

    result.fold(
      (error) => emit(ProductsError(error)),
      (products) => emit(ProductsSuccess(products)),
    );
  }

  // Get products by category
  Future<void> getProductsByCategory(String categoryId) async {
    emit(ProductsLoading());

    final result = await productsRepo.getProductsByCategory(
      categoryId,
    );

    result.fold(
      (error) => emit(ProductsError(error)),
      (products) => emit(ProductsSuccess(products)),
    );
  }
}
