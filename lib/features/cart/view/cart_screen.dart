import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoply_app/core/model/product/product_model.dart';
import 'package:shoply_app/features/cart/repo/cart_repo.dart';
import 'package:shoply_app/features/cart/view_model/cart_cubit.dart';
import 'package:shoply_app/features/cart/view/widgets/checkout_success_dialog.dart';
import 'package:shoply_app/features/products/repo/products_repo.dart';
import 'package:shoply_app/features/products/view_model/products_cubit.dart';
import 'package:shoply_app/core/utils/widgets/dialog/app_confirmation_dialog.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider<CartCubit>(create: (_) => CartCubit(cartRepo: CartRepo())..loadCart()),
      BlocProvider<ProductsCubit>(create: (_) => ProductsCubit(productsRepo: ProductsRepo())..getProducts()),
    ],
    child: const _CartBody(),
  );
}

class _CartBody extends StatefulWidget {
  const _CartBody();
  @override
  State<_CartBody> createState() => _CartBodyState();
}

class _CartBodyState extends State<_CartBody> {
  static const green = Color(0xFF07583F);
  bool _checkingOut = false;
  final Set<String> _busy = {};
  Future<void> _removeProduct(
    ProductModel product,
    int quantity,
  ) async {
    try {
      await context.read<CartCubit>().removeFromCart(
        product.id,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${product.name}\n'
            'Quantity: $quantity\n'
            'Removed from cart successfully!',
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to remove item: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  void _message(String value, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value), backgroundColor: error ? Colors.red : green,
      behavior: SnackBarBehavior.floating,
    ));
  }
  Future<void> _confirmRemoveProduct(
      ProductModel product,
      int quantity,
    ) async {
      final confirmed = await AppConfirmationDialog.show(
        context: context,
        title: 'Remove Item?',
        message:
            'Are you sure you want to remove this product?\n\n'
            '${product.name}\n'
            'Quantity: $quantity',
        confirmText: 'Remove',
        cancelText: 'Keep Item',
        icon: Icons.delete_outline_rounded,
        isDangerous: true,
      );

      if (!confirmed || !mounted) return;

      await _removeProduct(product, quantity);
    }
  Future<void> _changeQuantity(String id, int value) async {
    if (_checkingOut || _busy.contains(id) || value < 1) return;
    setState(() => _busy.add(id));
    try {
      await context.read<CartCubit>().updateQuantity(id, value);
      HapticFeedback.selectionClick();
    } catch (e) { _message('Update failed: $e', error: true); }
    finally { if (mounted) setState(() => _busy.remove(id)); }
  }

  

  Future<void> _checkout(List<ProductModel> products) async {
    if (_checkingOut || _busy.isNotEmpty) return;
    setState(() => _checkingOut = true);
    try {
      await context.read<CartCubit>().checkout(products: products);
      if (!mounted) return;
      HapticFeedback.mediumImpact();
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => const CheckoutSuccessDialog(),
      );
    } catch (e) { _message('Checkout failed: $e', error: true); }
    finally { if (mounted) setState(() => _checkingOut = false); }
  }

  @override
  Widget build(BuildContext context) {
    final reduced = MediaQuery.disableAnimationsOf(context);
    return BlocBuilder<CartCubit, CartState>(builder: (context, cartState) {
      if (cartState is CartInitial || cartState is CartLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (cartState is CartError) return Center(child: Text(cartState.message));
      if (cartState is! CartSuccess) return const SizedBox.shrink();
      final items = cartState.cartItems;
      if (items.isEmpty) return const _EmptyCart();

      return BlocBuilder<ProductsCubit, ProductsState>(builder: (context, state) {
        if (state is ProductsInitial || state is ProductsLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ProductsError) return Center(child: Text(state.message));
        if (state is! ProductsSuccess) return const SizedBox.shrink();
        final products = state.products.where((p) => items.containsKey(p.id)).toList();
        if (products.length != items.length) {
          return const Center(child: Text('Some cart products could not be loaded.'));
        }
        final total = products.fold<double>(0, (s, p) => s + p.price * items[p.id]!);

        return Column(children: [
          Expanded(child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final product = products[i];
              final quantity = items[product.id]!;
              final busy = _checkingOut || _busy.contains(product.id);
              // confirmDismiss performs the Firestore removal first; on success
              // the live cart stream removes the card. Do not dismiss locally.
              return Dismissible(
                key: ValueKey('cart-${product.id}'),
                direction: busy ? DismissDirection.none : DismissDirection.endToStart,
                confirmDismiss: (_) async 
                {
                  await _confirmRemoveProduct(
                    product,
                    quantity,
                  );

                  // Firestore updates the list through CartCubit.
                  // Do not let Dismissible remove the item a second time.
                  return false;
                },
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 24),
                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(16)),
                  child: const Icon(Icons.delete_outline, color: Colors.white, size: 29),
                ),
                child: _CartProductCard(
                  product: product,
                  quantity: quantity,
                  busy: busy,
                  onAdd: () => _changeQuantity(product.id, quantity + 1),
                  onMinus: quantity == 1 ? null : () => _changeQuantity(product.id, quantity - 1),
                  onDelete: () => _confirmRemoveProduct(
                      product,
                      quantity,
                    ),
                ),
              );
            },
          )),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade200))),
            child: SafeArea(top: false, child: Column(mainAxisSize: MainAxisSize.min, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                AnimatedSwitcher(
                  duration: reduced ? Duration.zero : const Duration(milliseconds: 250),
                  transitionBuilder: (child, a) => FadeTransition(opacity: a, child: ScaleTransition(scale: a, child: child)),
                  child: Text('\$${total.toStringAsFixed(2)}', key: ValueKey(total.toStringAsFixed(2)),
                    style: const TextStyle(color: green, fontSize: 22, fontWeight: FontWeight.bold)),
                ),
              ]),
              const SizedBox(height: 16),
              SizedBox(width: double.infinity, height: 52, child: ElevatedButton(
                onPressed: _checkingOut || _busy.isNotEmpty ? null : () => _checkout(products),
                style: ElevatedButton.styleFrom(backgroundColor: green, foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                child: AnimatedSwitcher(
                  duration: reduced ? Duration.zero : const Duration(milliseconds: 210),
                  child: _checkingOut
                      ? const Row(key: ValueKey('progress'), mainAxisSize: MainAxisSize.min, children: [
                          SizedBox(height: 19, width: 19, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
                          SizedBox(width: 12), Text('Processing Order...'),
                        ])
                      : const Text('Checkout', key: ValueKey('checkout'), style: TextStyle(fontSize: 17)),
                ),
              )),
            ])),
          ),
        ]);
      });
    });
  }
}

class _CartProductCard extends StatelessWidget {
  final ProductModel product;
  final int quantity;
  final bool busy;
  final VoidCallback onAdd;
  final VoidCallback? onMinus;
  final VoidCallback onDelete;
  const _CartProductCard({required this.product, required this.quantity,
    required this.busy, required this.onAdd, required this.onMinus, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final reduced = MediaQuery.disableAnimationsOf(context);
    final image = product.images.isEmpty ? null : product.images.first;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200)),
      child: Row(children: [
        ClipRRect(borderRadius: BorderRadius.circular(12), child: SizedBox(
          width: 95, height: 95,
          child: image == null ? const Icon(Icons.image_not_supported_outlined)
              : Image.network(image, fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const Icon(Icons.broken_image_outlined)),
        )),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 5),
          Text('\$${product.price.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 16, color: Color(0xFF07583F), fontWeight: FontWeight.bold)),
          const SizedBox(height: 9),
          Row(children: [
            IconButton(onPressed: busy ? null : onMinus,
              visualDensity: VisualDensity.compact, icon: const Icon(Icons.remove, size: 19)),
            SizedBox(width: 30, child: AnimatedSwitcher(
              duration: reduced ? Duration.zero : const Duration(milliseconds: 200),
              child: Text('$quantity', key: ValueKey(quantity), textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            )),
            IconButton(onPressed: busy ? null : onAdd,
              visualDensity: VisualDensity.compact, icon: const Icon(Icons.add, size: 19)),
            const Spacer(),
            IconButton(onPressed: busy ? null : onDelete,
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.delete_outline, color: Colors.red)),
          ]),
        ])),
      ]),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();
  @override
  Widget build(BuildContext context) {
    final content = Column(mainAxisSize: MainAxisSize.min, children: [
      const Icon(Icons.shopping_cart_outlined, color: Color(0xFF07583F), size: 75),
      const SizedBox(height: 15),
      const Text('Your cart is empty', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      const SizedBox(height: 7),
      const Text('Add some products to get started', style: TextStyle(color: Colors.grey)),
    ]);
    return Center(child: MediaQuery.disableAnimationsOf(context) ? content
        : AnimatedScale(scale: 1, duration: const Duration(milliseconds: 350), child: content));
  }
}
