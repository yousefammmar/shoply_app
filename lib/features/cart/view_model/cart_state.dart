
part of 'cart_cubit.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartSuccess extends CartState {
  final Map<String, int> cartItems;

  CartSuccess(this.cartItems);
}

class CartError extends CartState {
  final String message;

  CartError(this.message);
}
