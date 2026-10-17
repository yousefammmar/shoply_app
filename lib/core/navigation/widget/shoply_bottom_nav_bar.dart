
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'package:shoply_app/features/home/animations/navigation_animations.dart';

class ShoplyBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChange;

  const ShoplyBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChange,
  });

  static const Color primaryColor = Color(0xFF07583F);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
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
            selectedIndex: selectedIndex,
            onTabChange: (index) {
              HapticFeedback.selectionClick();
              onTabChange(index);
            },
            gap: 5,
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 12,
            ),
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutCubic,
            color: Colors.grey.shade600,
            activeColor: primaryColor,
            tabBackgroundColor:
                primaryColor.withValues(alpha: 0.09),
            tabBorderRadius: 14,
            textStyle: const TextStyle(
              color: primaryColor,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
            tabs: [
              GButton(
                icon: Icons.home_outlined,
                text: 'Home',
                leading: BottomNavAnimations.animateIcon(
                  Icon(
                    selectedIndex == 0
                        ? Icons.home_rounded
                        : Icons.home_outlined,
                    color: selectedIndex == 0
                        ? primaryColor
                        : Colors.grey.shade600,
                  ),
                  isSelected: selectedIndex == 0,
                ),
              ),
              GButton(
                icon: Icons.grid_view_rounded,
                text: 'Categories',
                leading: BottomNavAnimations.animateIcon(
                  Icon(
                    Icons.grid_view_rounded,
                    color: selectedIndex == 1
                        ? primaryColor
                        : Colors.grey.shade600,
                  ),
                  isSelected: selectedIndex == 1,
                ),
              ),
              GButton(
                icon: Icons.favorite_border_rounded,
                text: 'Favorite',
                leading: BottomNavAnimations.animateIcon(
                  Icon(
                    selectedIndex == 2
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: selectedIndex == 2
                        ? primaryColor
                        : Colors.grey.shade600,
                  ),
                  isSelected: selectedIndex == 2,
                ),
              ),
              GButton(
                icon: Icons.shopping_cart_outlined,
                text: 'Cart',
                leading: BottomNavAnimations.animateIcon(
                  Icon(
                    selectedIndex == 3
                        ? Icons.shopping_cart_rounded
                        : Icons.shopping_cart_outlined,
                    color: selectedIndex == 3
                        ? primaryColor
                        : Colors.grey.shade600,
                  ),
                  isSelected: selectedIndex == 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
