
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'package:shoply_app/features/home/animations/navigation_animations.dart';
import 'package:shoply_app/features/cart/repo/cart_repo.dart';
import 'package:shoply_app/l10n/l10n.dart';

class ShoplyBottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChange;

  const ShoplyBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChange,
  });

  @override
  State<ShoplyBottomNavBar> createState() =>
      _ShoplyBottomNavBarState();
}

class _ShoplyBottomNavBarState
    extends State<ShoplyBottomNavBar> {
  late final Stream<Map<String, int>> _cartStream;

  @override
  void initState() {
    super.initState();

    // One subscription for the lifetime of the nav bar.
    _cartStream = CartRepo().watchCart();
  }

  // ================= CART ICON + BADGE =================

  Widget _buildCartIcon(int count) {
    final cs = Theme.of(context).colorScheme;
    final selected = widget.selectedIndex == 3;
    final reduceMotion =
        MediaQuery.disableAnimationsOf(context);

    return SizedBox(
      width: 34,
      height: 32,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(
            child: BottomNavAnimations.animateIcon(
              Icon(
                selected
                    ? Icons.shopping_cart_rounded
                    : Icons.shopping_cart_outlined,
                color: selected
                    ? cs.primary
                    : cs.onSurfaceVariant,
              ),
              isSelected: selected,
            ),
          ),

          PositionedDirectional(
            top: -6,
            end: -8,
            child: AnimatedSwitcher(
              duration: reduceMotion
                  ? Duration.zero
                  : const Duration(milliseconds: 360),
              switchInCurve: Curves.elasticOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: animation,
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                );
              },
              child: count == 0
                  ? const SizedBox.shrink(
                      key: ValueKey('empty'),
                    )
                  : Container(
                      key: ValueKey(count),
                      constraints: const BoxConstraints(
                        minWidth: 19,
                        minHeight: 19,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE53935),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: cs.surface,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        count > 99 ? '99+' : '$count',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    return StreamBuilder<Map<String, int>>(
      stream: _cartStream,
      builder: (context, snapshot) {
        final cartItems =
            snapshot.data ?? <String, int>{};

        // Total quantity, not just unique product IDs.
        final count = cartItems.values.fold<int>(
          0,
          (total, quantity) => total + quantity,
        );

        return Container(
          decoration: BoxDecoration(
            color: cs.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.06,
                ),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              child: GNav(
                selectedIndex: widget.selectedIndex,
                onTabChange: (index) {
                  HapticFeedback.selectionClick();
                  widget.onTabChange(index);
                },
                gap: 5,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 12,
                ),
                duration:
                    const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                color: cs.onSurfaceVariant,
                activeColor: cs.primary,
                tabBackgroundColor:
                    cs.primary.withValues(alpha: 0.09),
                tabBorderRadius: 14,
                textStyle: TextStyle(
                  color: cs.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
                tabs: [
                  // HOME
                  GButton(
                    icon: Icons.home_outlined,
                    text: l10n.home,
                    leading:
                        BottomNavAnimations.animateIcon(
                      Icon(
                        widget.selectedIndex == 0
                            ? Icons.home_rounded
                            : Icons.home_outlined,
                        color: widget.selectedIndex == 0
                            ? cs.primary
                            : cs.onSurfaceVariant,
                      ),
                      isSelected:
                          widget.selectedIndex == 0,
                    ),
                  ),

                  // CATEGORIES
                  GButton(
                    icon: Icons.grid_view_rounded,
                    text: l10n.categories,
                    leading:
                        BottomNavAnimations.animateIcon(
                      Icon(
                        Icons.grid_view_rounded,
                        color: widget.selectedIndex == 1
                            ? cs.primary
                            : cs.onSurfaceVariant,
                      ),
                      isSelected:
                          widget.selectedIndex == 1,
                    ),
                  ),

                  // FAVORITES
                  GButton(
                    icon: Icons.favorite_border_rounded,
                    text: l10n.favorites,
                    leading:
                        BottomNavAnimations.animateIcon(
                      Icon(
                        widget.selectedIndex == 2
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: widget.selectedIndex == 2
                            ? cs.primary
                            : cs.onSurfaceVariant,
                      ),
                      isSelected:
                          widget.selectedIndex == 2,
                    ),
                  ),

                  // CART
                  GButton(
                    icon: Icons.shopping_cart_outlined,
                    text: l10n.cart,
                    leading: _buildCartIcon(count),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
