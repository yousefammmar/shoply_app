import 'package:flutter/material.dart';
import 'package:shoply_app/core/routes/app_pages.dart';
import 'package:shoply_app/features/categories/view/categories_screen.dart';
import 'package:shoply_app/features/forgot_password/view/forgot_password_screen.dart';
import 'package:shoply_app/features/login/view/login_screen.dart';
import 'package:shoply_app/features/main/view/main_screen.dart';
import 'package:shoply_app/features/onboarding/view/on_boarding_screen.dart';
import 'package:shoply_app/features/products/view/products_screen.dart';
import 'package:shoply_app/features/signup/view/signup_screen.dart';
import 'package:shoply_app/features/splash/view/splash_screen.dart';

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

      case AppPages.mainScreen:
        return MaterialPageRoute(
          builder: (context) {
            return const MainScreen();
          },
        );

      case AppPages.categoriesScreen:
        return MaterialPageRoute(
          builder: (context) {
            return const CategoriesScreen();
          },
        );

      case AppPages.productsScreen:
        return MaterialPageRoute(
          builder: (context) {
            final arguments = settings.arguments as Map<String, dynamic>;
            final titleText = arguments['titleText'];
            final categoryId = arguments['categoryId'];
            return ProductsScreen(titleText: titleText, categoryId: categoryId);
          },
        );
    }
    return null;
  }
}
