
import 'package:flutter/material.dart';
import 'package:shoply_app/core/utils/images/app_images.dart';
import 'package:shoply_app/features/home/animations/home_animations.dart';
class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});
  @override
  Widget build(BuildContext context) {
    return HomeAnimations.fadeIn(
      ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          AppImages.bannerShoe,
          width: double.infinity,
          fit: BoxFit.contain,
          loadingBuilder: (context, child, progress) {
            if (progress == null) {
              return child;
            }
            return const SizedBox(
              height: 200,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return const SizedBox(
              height: 200,
              child: Center(
                child: Icon(
                  Icons.broken_image_outlined,
                  size: 50,
                  color: Colors.grey,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
