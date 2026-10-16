import 'package:flutter/material.dart';
import 'package:shoply_app/core/routes/app_pages.dart';
import 'package:shoply_app/features/forgot_password/view/forgot_password_screen.dart';
import 'package:shoply_app/features/home/view/home_screen.dart';
import 'package:shoply_app/features/login/view/login_screen.dart';
import 'package:shoply_app/features/onboarding/view/on_boarding_screen.dart';
import 'package:shoply_app/features/signup/view/signup_screen.dart';
import 'package:shoply_app/features/splash/view/splash_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoply_app/features/home/home_view_model/home_cubit.dart';
import 'package:shoply_app/core/repositories/category_repository.dart';
import 'package:shoply_app/features/categories/view/categories_screen.dart';
import 'package:shoply_app/features/categories/view_model/categories_cubit.dart';
import 'package:shoply_app/core/navigation/main_screen.dart';
import 'package:shoply_app/core/navigation/cubit/main_cubit.dart';
class AppRoutes {
  static Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppPages.splashScreen:
        return MaterialPageRoute(
          builder: (context) {
            return SplashScreen();
          },
        );

      case AppPages.onBoardingScreen:
        return MaterialPageRoute(
          builder: (context) {
            return OnBoardingScreen();
          },
        );

      case AppPages.loginScreen:
        return MaterialPageRoute(
          builder: (context) {
            return const LoginScreen();
          },
        );

      case AppPages.signupScreen:
        return MaterialPageRoute(
          builder: (context) {
            return const SignupScreen();
          },
        );

      case AppPages.forgotPasswordScreen:
        return MaterialPageRoute(
          builder: (context) {
            return const ForgotPasswordScreen();
          },
        );

      
      
      case AppPages.homeScreen:
        return MaterialPageRoute(
          builder: (context) {
            return BlocProvider<MainCubit>(
              create: (_) => MainCubit(),
              child: const MainScreen(),
            );
          },
        );
        


      case AppPages.categoriesScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) => CategoriesCubit(
              CategoryRepository(),
            )..loadCategories(),
            child: const CategoriesScreen(),
          ),
        );


    }
    return null;
  }
}
