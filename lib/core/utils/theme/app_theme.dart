import 'package:flutter/material.dart';
import 'package:shoply_app/core/utils/fonts/app_fonts.dart';
import 'package:shoply_app/core/utils/theme/app_colors.dart';

class AppTheme {
  static final ThemeData themeLight = _build(
    const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primaryColor,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.secondary,
      onPrimaryContainer: AppColors.primaryColor,
      secondary: AppColors.primaryColor,
      onSecondary: AppColors.onPrimary,
      error: AppColors.error,
      onError: AppColors.onError,
      surface: AppColors.backgrround,
      onSurface: Colors.black,
      onSurfaceVariant: AppColors.mutedTextLight,
      surfaceContainerLow: AppColors.surfaceLight,
      surfaceContainerHigh: AppColors.skeletonLight,
      outlineVariant: AppColors.borderLight,
    ),
    dialogColor: AppColors.backgrround,
  );

  static final ThemeData themeDark = _build(
    const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primaryDark,
      onPrimary: AppColors.onPrimaryDark,
      primaryContainer: AppColors.secondaryDark,
      onPrimaryContainer: AppColors.onSecondaryDark,
      secondary: AppColors.primaryDark,
      onSecondary: AppColors.onPrimaryDark,
      error: AppColors.errorDark,
      onError: AppColors.onErrorDark,
      surface: AppColors.backgroundDark,
      onSurface: AppColors.textDark,
      onSurfaceVariant: AppColors.mutedTextDark,
      surfaceContainerLow: AppColors.surfaceDark,
      surfaceContainerHigh: AppColors.skeletonDark,
      outlineVariant: AppColors.borderDark,
    ),
    dialogColor: AppColors.surfaceDark,
  );

  static ThemeData _build(
    ColorScheme colorScheme, {
    required Color dialogColor,
  }) {
    return ThemeData(
      fontFamily: AppFonts.quikSand,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      dialogTheme: DialogThemeData(backgroundColor: dialogColor),
    );
  }
}
