
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:shoply_app/core/utils/images/app_images.dart';
import 'package:shoply_app/features/home/animations/home_animations.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CachedNetworkImage(
        imageUrl: AppImages.bannerShoe,
        width: double.infinity,
        fit: BoxFit.contain,

        placeholder: (context, url) {
          return const SizedBox(
            height: 200,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },

        imageBuilder: (context, imageProvider) {
          return HomeAnimations.blurReveal(
            Image(
              image: imageProvider,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          );
        },

        errorWidget: (context, url, error) {
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
    );
  }
}
