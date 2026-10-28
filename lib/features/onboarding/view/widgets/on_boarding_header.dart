
part of '../on_boarding_screen.dart';

class _OnBoardingHeader extends StatelessWidget {
  const _OnBoardingHeader();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: BlocBuilder<OnBoardingCubit, OnBoardingState>(
        buildWhen: (previous, current) {
          return current is! OnBoardingChangeIndexState;
        },
        builder: (context, state) {
          final cubit = context.read<OnBoardingCubit>();
          final l10n = context.l10n;
          final cs = Theme.of(context).colorScheme;
          final titles = [
            l10n.onboardingTitle1,
            l10n.onboardingTitle2,
            l10n.onboardingTitle3,
          ];
          final descriptions = [
            l10n.onboardingDescription1,
            l10n.onboardingDescription2,
            l10n.onboardingDescription3,
          ];

          return PageView.builder(
            controller: cubit.pageController,
            itemCount: 3,
            onPageChanged: (index) {
              cubit.changeIndex(index: index);
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Column(
                  children: [
                    // Flexible image height
                    Expanded(
                      child: Image.network(
                        cubit.onBoardImage[index],
                        width: double.infinity,
                        fit: BoxFit.contain,
                        loadingBuilder: (
                          context,
                          child,
                          loadingProgress,
                        ) {
                          if (loadingProgress == null) {
                            return child;
                          }

                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        errorBuilder: (
                          context,
                          error,
                          stackTrace,
                        ) {
                          return Center(
                            child: Icon(
                              Icons.broken_image,
                              size: 50,
                              color: cs.onSurfaceVariant,
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      titles[index],
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      descriptions[index],
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
