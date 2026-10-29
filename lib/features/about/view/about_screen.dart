
import 'package:flutter/material.dart';
import 'package:shoply_app/l10n/l10n.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cs = Theme.of(context).colorScheme;
    final bodyStyle = TextStyle(
      fontSize: 16,
      height: 1.7,
      color: cs.onSurface.withValues(alpha: 0.87),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.aboutShoply, style: const TextStyle(fontWeight:FontWeight.bold), ),
        centerTitle: true,
        foregroundColor: cs.primary,
        
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
                color: cs.primaryContainer,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Icon(
                Icons.shopping_bag_outlined,
                size: 65,
                color: cs.primary,
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Shoply',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: cs.primary,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              l10n.aboutTagline,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: cs.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 32),

            Text(
              l10n.aboutTheApplication,
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              l10n.aboutParagraph1,
              textAlign: TextAlign.center,
              style: bodyStyle,
            ),

            const SizedBox(height: 20),

            Text(
              l10n.aboutParagraph2,
              textAlign: TextAlign.center,
              style: bodyStyle,
            ),

            const SizedBox(height: 32),

            _FeatureRow(
              icon: Icons.category_outlined,
              text: l10n.featureExploreCategories,
            ),

            _FeatureRow(
              icon: Icons.favorite_border,
              text: l10n.featureSaveFavorites,
            ),

            _FeatureRow(
              icon: Icons.shopping_cart_outlined,
              text: l10n.featureManageCart,
            ),

            _FeatureRow(
              icon: Icons.receipt_long_outlined,
              text: l10n.featureReviewOrders,
            ),

            _FeatureRow(
              icon: Icons.person_outline,
              text: l10n.featurePersonalizeAccount,
            ),

            const SizedBox(height: 30),

            Text(
              l10n.version('1.0.0'),
              style: TextStyle(color: cs.onSurfaceVariant),
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
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: cs.primary,
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
