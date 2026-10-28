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
import 'package:shoply_app/l10n/l10n.dart';

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
            context.l10n.removedFromCart(product.name, quantity),
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.removeItemFailed(error)),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
  // Messages are built lazily so the context is only read while mounted.
  void _message(String Function(AppLocalizations l10n) value, {bool error = false}) {
    if (!mounted) return;
    final cs = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value(context.l10n)), backgroundColor: error ? cs.error : cs.primary,
      behavior: SnackBarBehavior.floating,
    ));
  }
  Future<void> _confirmRemoveProduct(
      ProductModel product,
      int quantity,
    ) async {
      final confirmed = await AppConfirmationDialog.show(
        context: context,
        title: context.l10n.removeItemTitle,
        message: context.l10n.removeItemMessage(product.name, quantity),
        confirmText: context.l10n.remove,
        cancelText: context.l10n.keepItem,
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
    } catch (e) { _message((l10n) => l10n.updateFailed(e), error: true); }
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
    } catch (e) { _message((l10n) => l10n.checkoutFailed(e), error: true); }
    finally { if (mounted) setState(() => _checkingOut = false); }
  }

  @override
  Widget build(BuildContext context) {
    final reduced = MediaQuery.disableAnimationsOf(context);
    final l10n = context.l10n;
    final cs = Theme.of(context).colorScheme;
    return BlocBuilder<CartCubit, CartState>(builder: (context, cartState) {
      if (cartState is CartInitial || cartState is CartLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (cartState is CartError) {
        return Center(child: Text(l10n.errorWithDetails(cartState.message), textAlign: TextAlign.center));
      }
      if (cartState is! CartSuccess) return const SizedBox.shrink();
      final items = cartState.cartItems;
      if (items.isEmpty) return const _EmptyCart();

      return BlocBuilder<ProductsCubit, ProductsState>(builder: (context, state) {
        if (state is ProductsInitial || state is ProductsLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ProductsError) {
          return Center(child: Text(l10n.errorWithDetails(state.message), textAlign: TextAlign.center));
        }
        if (state is! ProductsSuccess) return const SizedBox.shrink();
        final products = state.products.where((p) => items.containsKey(p.id)).toList();
        if (products.length != items.length) {
          return Center(child: Text(l10n.cartProductsLoadFailed));
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
                  alignment: AlignmentDirectional.centerEnd,
                  padding: const EdgeInsetsDirectional.only(end: 24),
                  decoration: BoxDecoration(color: cs.error, borderRadius: BorderRadius.circular(16)),
                  child: Icon(Icons.delete_outline, color: cs.onError, size: 29),
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
            decoration: BoxDecoration(color: cs.surface,
              border: Border(top: BorderSide(color: cs.outlineVariant))),
            child: SafeArea(top: false, child: Column(mainAxisSize: MainAxisSize.min, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(l10n.total, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                AnimatedSwitcher(
                  duration: reduced ? Duration.zero : const Duration(milliseconds: 250),
                  transitionBuilder: (child, a) => FadeTransition(opacity: a, child: ScaleTransition(scale: a, child: child)),
                  child: Text('\$${total.toStringAsFixed(2)}', key: ValueKey(total.toStringAsFixed(2)),
                    style: TextStyle(color: cs.primary, fontSize: 22, fontWeight: FontWeight.bold)),
                ),
              ]),
              const SizedBox(height: 16),
              SizedBox(width: double.infinity, height: 52, child: ElevatedButton(
                onPressed: _checkingOut || _busy.isNotEmpty ? null : () => _checkout(products),
                style: ElevatedButton.styleFrom(backgroundColor: cs.primary, foregroundColor: cs.onPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                child: AnimatedSwitcher(
                  duration: reduced ? Duration.zero : const Duration(milliseconds: 210),
                  child: _checkingOut
                      ? Row(key: const ValueKey('progress'), mainAxisSize: MainAxisSize.min, children: [
                          SizedBox(height: 19, width: 19, child: CircularProgressIndicator(strokeWidth: 2, color: cs.onPrimary)),
                          const SizedBox(width: 12), Text(l10n.processingOrder),
                        ])
                      : Text(l10n.checkout, key: const ValueKey('checkout'), style: const TextStyle(fontSize: 17)),
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
    final cs = Theme.of(context).colorScheme;
    final image = product.images.isEmpty ? null : product.images.first;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: cs.surface, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant)),
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
            style: TextStyle(fontSize: 16, color: cs.primary, fontWeight: FontWeight.bold)),
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
              icon: Icon(Icons.delete_outline, color: cs.error)),
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
    final cs = Theme.of(context).colorScheme;
    final content = Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.shopping_cart_outlined, color: cs.primary, size: 75),
      const SizedBox(height: 15),
      Text(context.l10n.emptyCart, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      const SizedBox(height: 7),
      Text(context.l10n.emptyCartHint, style: TextStyle(color: cs.onSurfaceVariant)),
    ]);
    return Center(child: MediaQuery.disableAnimationsOf(context) ? content
        : AnimatedScale(scale: 1, duration: const Duration(milliseconds: 350), child: content));
  }
}
