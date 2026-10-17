
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:shoply_app/core/utils/images/app_images.dart';

class HomeBanner extends StatefulWidget {
  const HomeBanner({super.key});

  @override
  State<HomeBanner> createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {
  static const Color primaryColor = Color(0xFF07583F);

  // Add new banner URLs here when available.
  static const List<String> banners = [
    AppImages.bannerShoe,
  ];

  final PageController _pageController = PageController();

  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildBanner(String imageUrl) {
    final reduceMotion =
        MediaQuery.disableAnimationsOf(context);

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.contain,
      width: double.infinity,
      imageBuilder: (context, imageProvider) {
        final image = Image(
          image: imageProvider,
          width: double.infinity,
          height: 190,
          fit: BoxFit.contain,
        );

        if (reduceMotion) return image;

        return image
            .animate()
            .fadeIn(
              duration: 500.ms,
              curve: Curves.easeOutCubic,
            )
            .scale(
              begin: const Offset(0.96, 0.96),
              end: const Offset(1, 1),
              duration: 750.ms,
              curve: Curves.easeOutCubic,
            );
      },
      placeholder: (context, url) {
        final placeholder = Container(
          height: 190,
          decoration: BoxDecoration(
            color: const Color(0xFFE7F4EE),
            borderRadius: BorderRadius.circular(18),
          ),
        );

        if (reduceMotion) return placeholder;

        return placeholder
            .animate(
              onPlay: (controller) => controller.repeat(),
            )
            .shimmer(
              duration: 1400.ms,
              color: Colors.white.withValues(alpha: 0.55),
            );
      },
      errorWidget: (context, url, error) {
        return const SizedBox(
          height: 190,
          child: Center(
            child: Icon(
              Icons.broken_image_outlined,
              color: primaryColor,
              size: 45,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion =
        MediaQuery.disableAnimationsOf(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: SizedBox(
            height: 190,
            width: double.infinity,
            child: PageView.builder(
              controller: _pageController,
              physics: banners.length > 1
                  ? const BouncingScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              itemCount: banners.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    double offset = 0;

                    if (_pageController.hasClients &&
                        _pageController.position
                            .haveDimensions) {
                      final page = _pageController.page ??
                          _currentPage.toDouble();

                      offset = (page - index)
                          .clamp(-1.0, 1.0)
                          .toDouble();
                    }

                    // Subtle horizontal parallax.
                    return Transform.translate(
                      offset: reduceMotion
                          ? Offset.zero
                          : Offset(offset * 18, 0),
                      child: child,
                    );
                  },
                  child: _buildBanner(banners[index]),
                );
              },
            ),
          ),
        ),

        // Indicators only appear when multiple banners exist.
        if (banners.length > 1) ...[
          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              banners.length,
              (index) {
                final selected = index == _currentPage;

                return AnimatedContainer(
                  duration: reduceMotion
                      ? Duration.zero
                      : const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 4,
                  ),
                  width: selected ? 26 : 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: selected
                        ? primaryColor
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
