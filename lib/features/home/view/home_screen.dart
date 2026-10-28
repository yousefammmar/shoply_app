
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:shoply_app/features/home/home_view_model/home_cubit.dart';
import 'package:shoply_app/features/home/presentation/widgets/home_banner.dart';
import 'package:shoply_app/features/home/presentation/widgets/home_categories.dart';
import 'package:shoply_app/features/home/presentation/widgets/trending_products.dart';
import 'package:shoply_app/l10n/l10n.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _hasAnimated = false;

  @override
  Widget build(BuildContext context) {
    final reduceMotion =
        MediaQuery.disableAnimationsOf(context);

    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) {
        return current is HomeLoading ||
            current is HomeLoaded ||
            current is HomeError;
      },
      builder: (context, state) {
        if (state is HomeLoading) {
          return const _HomeLoadingSkeleton();
        }

        if (state is HomeError) {
          final cs = Theme.of(context).colorScheme;
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.wifi_off_rounded,
                    size: 58,
                    color: cs.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    context.l10n.somethingWentWrong,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<HomeCubit>().loadProducts();
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: Text(context.l10n.tryAgain),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      foregroundColor: cs.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Play the main entrance once per mounted HomeScreen.
        final shouldAnimate = !_hasAnimated && !reduceMotion;

        if (!_hasAnimated) {
          _hasAnimated = true;
        }

        Widget reveal(
          Widget child, {
          required int delay,
          double offset = 0.10,
        }) {
          if (!shouldAnimate) return child;

          return child
              .animate()
              .fadeIn(
                delay: Duration(milliseconds: delay),
                duration: 480.ms,
                curve: Curves.easeOutCubic,
              )
              .slideY(
                begin: offset,
                end: 0,
                delay: Duration(milliseconds: delay),
                duration: 560.ms,
                curve: Curves.easeOutCubic,
              );
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= HERO BANNER =================
              reveal(
                const HomeBanner(),
                delay: 0,
                offset: 0.06,
              ),

              const SizedBox(height: 24),

              // ================= CATEGORIES =================
              reveal(
                const HomeCategories(),
                delay: 110,
                offset: 0.10,
              ),

              const SizedBox(height: 24),

              // ================= TRENDING PRODUCTS =================
              reveal(
                const TrendingProducts(),
                delay: 230,
                offset: 0.12,
              ),

              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}

// ================= LOADING SKELETON =================

class _HomeLoadingSkeleton extends StatelessWidget {
  const _HomeLoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    final reduceMotion =
        MediaQuery.disableAnimationsOf(context);
    final cs = Theme.of(context).colorScheme;

    Widget skeleton({
      required double height,
      double? width,
      BorderRadius? borderRadius,
    }) {
      final placeholder = Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: cs.surfaceContainerHigh,
          borderRadius:
              borderRadius ?? BorderRadius.circular(14),
        ),
      );

      if (reduceMotion) return placeholder;

      return placeholder
          .animate(
            onPlay: (controller) => controller.repeat(),
          )
          .shimmer(
            duration: 1350.ms,
            color: cs.surface.withValues(alpha: 0.55),
          );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner placeholder
          skeleton(
            height: 180,
            width: double.infinity,
            borderRadius: BorderRadius.circular(20),
          ),

          const SizedBox(height: 28),

          // Categories heading
          skeleton(height: 22, width: 135),

          const SizedBox(height: 18),

          // Category placeholders
          Row(
            children: [
              for (int i = 0; i < 4; i++) ...[
                if (i > 0) const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 1,
                        child: skeleton(
                          height: double.infinity,
                          width: double.infinity,
                          borderRadius:
                              BorderRadius.circular(18),
                        ),
                      ),
                      const SizedBox(height: 10),
                      skeleton(height: 12),
                    ],
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 30),

          // Trending heading
          skeleton(height: 22, width: 170),

          const SizedBox(height: 18),

          // Product placeholders
          Row(
            children: [
              for (int i = 0; i < 2; i++) ...[
                if (i > 0) const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      skeleton(
                        height: 170,
                        width: double.infinity,
                        borderRadius:
                            BorderRadius.circular(18),
                      ),
                      const SizedBox(height: 12),
                      skeleton(height: 14, width: 120),
                      const SizedBox(height: 8),
                      skeleton(height: 12, width: 75),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
