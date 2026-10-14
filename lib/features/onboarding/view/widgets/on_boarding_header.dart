
part of '../on_boarding_screen.dart';

class _OnBoardingHeader extends StatelessWidget {
  const _OnBoardingHeader();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: BlocBuilder<OnBoardingCubit, OnBoardingState>(
        buildWhen: (previous, current) {
          return current is! OnBoardingChangeIndexState;
        },
        builder: (context, state) {
          final cubit = context.read<OnBoardingCubit>();

          return PageView.builder(
            controller: cubit.pageController,
            itemCount: 3,
            onPageChanged: (index) {
              cubit.changeIndex(index: index);
            },
            itemBuilder: (context, index) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.network(
                      cubit.onBoardImage[index],
                      height: 400,
                      width: double.infinity,
                      fit: BoxFit.contain,

                      // Loading indicator
                      loadingBuilder: (
                        context,
                        child,
                        loadingProgress,
                      ) {
                        if (loadingProgress == null) {
                          return child;
                        }

                        return const SizedBox(
                          height: 400,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },

                      // Error handling
                      errorBuilder: (
                        context,
                        error,
                        stackTrace,
                      ) {
                        debugPrint('Image loading error: $error');

                        return const SizedBox(
                          height: 400,
                          child: Center(
                            child: Icon(
                              Icons.broken_image,
                              size: 60,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 10),

                    Text(
                      cubit.onBoardTitle[index],
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 10),

                    Text(
                      cubit.onBoardDescreption[index],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
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
