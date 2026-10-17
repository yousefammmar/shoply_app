
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoply_app/features/cart/repo/cart_repo.dart';

import 'package:shoply_app/features/orders/repo/orders_repo.dart';
import 'package:shoply_app/core/model/product/product_model.dart';
part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepo cartRepo;

  final OrdersRepo _ordersRepo = OrdersRepo();

  StreamSubscription<Map<String, int>>? _subscription;

  CartCubit({required this.cartRepo}) : super(CartInitial());

  // ================= LOAD CART =================

  void loadCart() {
    emit(CartLoading());

    _subscription?.cancel();

    try {
      _subscription = cartRepo.watchCart().listen(
        (cartItems) {
          if (!isClosed) {
            emit(CartSuccess(cartItems));
          }
        },
        onError: (error) {
          if (!isClosed) {
            emit(CartError(error.toString()));
          }
        },
      );
    } catch (error) {
      emit(CartError(error.toString()));
    }
  }

  // ================= ADD TO CART =================

  Future<void> addToCart(
    String productId, {
    int quantity = 1,
  }) async {
    try {
      await cartRepo.addToCart(
        productId,
        quantity: quantity,
      );
    } catch (error) {
      if (!isClosed) {
        emit(CartError(error.toString()));
      }
      rethrow;
    }
  }

  // ================= UPDATE QUANTITY =================

  Future<void> updateQuantity(
    String productId,
    int quantity,
  ) async {
    try {
      await cartRepo.updateQuantity(productId, quantity);
    } catch (error) {
      if (!isClosed) {
        emit(CartError(error.toString()));
      }
      rethrow;
    }
  }

  // ================= REMOVE FROM CART =================

  Future<void> removeFromCart(String productId) async {
    try {
      await cartRepo.removeFromCart(productId);
    } catch (error) {
      if (!isClosed) {
        emit(CartError(error.toString()));
      }
      rethrow;
    }
  }

  // ================= CLOSE =================

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    await super.close();
  }

  // ================= CHECKOUT =================

  Future<void> checkout({
      required List<ProductModel> products,
    }) async {
      final currentState = state;

      if (currentState is! CartSuccess) {
        throw StateError('Cart is not ready');
      }

      final cartItems = currentState.cartItems;

      if (cartItems.isEmpty) {
        throw StateError('Cart is empty');
      }

      final purchasedProducts = products
          .where((product) => cartItems.containsKey(product.id))
          .toList();

      if (purchasedProducts.length != cartItems.length) {
        throw StateError('Some cart products could not be found');
      }

      final items = purchasedProducts.map((product) {
        final quantity = cartItems[product.id]!;

        return <String, dynamic>{
          'productId': product.id,
          'name': product.name,
          'price': product.price,
          'quantity': quantity,
          'image': product.images.isNotEmpty
              ? product.images.first
              : '',
        };
      }).toList();

      final total = purchasedProducts.fold<double>(
        0,
        (sum, product) =>
            sum + product.price * cartItems[product.id]!,
      );

      // Save the order first
      await _ordersRepo.createOrder(
        items: items,
        total: total,
      );

      // Clear the cart only after saving the order
      await cartRepo.clearCart();
    }
}

