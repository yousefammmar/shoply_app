import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoply_app/core/local/local_storage.dart';
import 'package:shoply_app/core/utils/images/app_images.dart';
import 'package:shoply_app/features/onboarding/view_model/state.dart';

class OnBoardingCubit extends Cubit<OnBoardingState> {
  OnBoardingCubit() : super(OnBoardingInitState());

  final pageController = PageController();
  int index = 0;

  final onBoardImage = [
    AppImages.onboarding1,
    AppImages.onboarding2,
    AppImages.onboarding3,
  ];

  void nextPageController() {
    pageController.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  void skipOnBoard() {
    pageController.animateToPage(
      2,
      curve: Curves.easeIn,
      duration: Duration(milliseconds: 500),
    );
  }

  void changeIndex({required int index}) {
    this.index = index;
    emit(OnBoardingChangeIndexState());
  }

  void setShowOnBoard() async {
    await LocalStorage.instance.setShowOnboard(isShowOnboard: true);
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}
