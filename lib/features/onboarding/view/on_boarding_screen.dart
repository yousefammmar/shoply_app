import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoply_app/core/routes/app_pages.dart';
import 'package:shoply_app/core/utils/widgets/button/custom_button.dart';
import 'package:shoply_app/core/utils/widgets/smooth_indicator/custom_smooth_indicator.dart';
import 'package:shoply_app/core/utils/widgets/text_button/custom_text_button.dart';
import 'package:shoply_app/features/onboarding/view_model/cubit.dart';
import 'package:shoply_app/features/onboarding/view_model/state.dart';
import 'package:shoply_app/l10n/l10n.dart';
part 'widgets/on_boarding_header.dart';
part 'widgets/on_boarding_bottom.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnBoardingCubit(),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              _OnBoardingHeader(),
              SizedBox(height: 8),
              _OnBoardingBottom(),
            ],
          ),
        ),
      ),
    );
  }
}
