
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class ShoplyBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChange;

  const ShoplyBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF086548);

    return SafeArea(
      top: false,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        child: GNav(
          selectedIndex: selectedIndex,
          onTabChange: onTabChange,
          rippleColor: green.withValues(alpha: 0.08),
          hoverColor: Colors.grey.shade100,
          gap: 6,
          activeColor: green,
          color: Colors.grey.shade700,
          iconSize: 23,
          textStyle: const TextStyle(
            color: green,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          tabBackgroundColor:
          green.withValues(alpha: 0.09),
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 12,
          ),
          duration: const Duration(milliseconds: 300),
          tabs: const [
            GButton(
              icon: Icons.home_outlined,
              text: 'Home',
            ),
            GButton(
              icon: Icons.grid_view_outlined,
              text: 'Categories',
            ),
            GButton(
              icon: Icons.favorite_border,
              text: 'Favorite',
            ),
            GButton(
              icon: Icons.shopping_cart_outlined,
              text: 'Cart',
            ),
          ],
        ),
      ),
    );
  }
}
