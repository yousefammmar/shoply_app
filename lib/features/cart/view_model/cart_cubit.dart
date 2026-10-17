import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoply_app/core/model/product/product_model.dart';
import 'package:shoply_app/features/cart/repo/cart_repo.dart';
import 'package:shoply_app/features/orders/repo/orders_repo.dart';
part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepo cartRepo;
  final OrdersRepo _ordersRepo = OrdersRepo();
  StreamSubscription<Map<String, int>>? _subscription;
  bool _checkingOut = false;
  CartCubit({required this.cartRepo}) : super(CartInitial());

  void loadCart() {
    emit(CartLoading());
    _subscription?.cancel();
    try {
      _subscription = cartRepo.watchCart().listen(
        (items) { if (!isClosed) emit(CartSuccess(items)); },
        onError: (Object error) { if (!isClosed) emit(CartError(error.toString())); },
      );
    } catch (e) { if (!isClosed) emit(CartError(e.toString())); }
  }

  Future<void> addToCart(String id, {int quantity = 1}) => cartRepo.addToCart(id, quantity: quantity);
  Future<void> updateQuantity(String id, int quantity) => cartRepo.updateQuantity(id, quantity);
  Future<void> removeFromCart(String id) => cartRepo.removeFromCart(id);

  Future<void> checkout({required List<ProductModel> products}) async {
    if (_checkingOut) throw StateError('Checkout already in progress');
    final current = state;
    if (current is! CartSuccess || current.cartItems.isEmpty) throw StateError('Cart is not ready');
    _checkingOut = true;
    try {
      // Capture snapshot before network calls; UI blocks changes while checking out.
      final cart = Map<String, int>.from(current.cartItems);
      final found = products.where((p) => cart.containsKey(p.id)).toList();
      if (found.length != cart.length) throw StateError('Some cart products could not be found');
      final items = found.map((p) => <String, dynamic>{
        'productId': p.id,
        'name': p.name,
        'price': p.price,
        'quantity': cart[p.id]!,
        'image': p.images.isNotEmpty ? p.images.first : '',
      }).toList();
      final total = found.fold<double>(0, (sum, p) => sum + p.price * cart[p.id]!);
      await _ordersRepo.createOrder(items: items, total: total);
      await cartRepo.clearCart();
    } finally {
      _checkingOut = false;
    }
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    await super.close();
  }
}
