
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const Color primaryColor = Color(0xFF07583F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('About Shoply', style: TextStyle(fontWeight:FontWeight.bold), ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: primaryColor,
        
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),

            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: const Color(0xFFE7F4EE),
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 65,
                color: primaryColor,
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Shoply',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Your Everyday Shopping Companion',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 32),

            const Text(
              'About the Application',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'Shoply is a modern e-commerce mobile '
              'application designed to make online '
              'shopping simple, convenient, and enjoyable. '
              'It provides an organized shopping experience '
              'where users can explore products across '
              'different categories, discover trending '
              'items, and view detailed product information.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                height: 1.7,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'With Shoply, customers can save their '
              'favorite products, manage their shopping '
              'cart, adjust product quantities, review '
              'their order history, and personalize '
              'their account information.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                height: 1.7,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 32),

            const _FeatureRow(
              icon: Icons.category_outlined,
              text: 'Explore Product Categories',
            ),

            const _FeatureRow(
              icon: Icons.favorite_border,
              text: 'Save Favorite Products',
            ),

            const _FeatureRow(
              icon: Icons.shopping_cart_outlined,
              text: 'Manage Shopping Cart',
            ),

            const _FeatureRow(
              icon: Icons.receipt_long_outlined,
              text: 'Review Order History',
            ),

            const _FeatureRow(
              icon: Icons.person_outline,
              text: 'Personalize Your Account',
            ),

            const SizedBox(height: 30),

            const Text(
              'Version 1.0.0',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureRow({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9F8),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF07583F),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
