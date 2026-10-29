import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoply_app/core/local/local_storage.dart';
import 'package:shoply_app/core/routes/app_pages.dart';
import 'package:shoply_app/core/routes/app_routes.dart';
import 'package:shoply_app/core/utils/theme/app_theme.dart';
import 'package:shoply_app/features/app/view_model/app_settings_cubit.dart';
import 'package:shoply_app/l10n/app_localizations.dart';

class ShoplyApp extends StatelessWidget {
  const ShoplyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppSettingsCubit(LocalStorage.instance),
      child: BlocBuilder<AppSettingsCubit, AppSettingsState>(
        builder: (context, settings) {
          return MaterialApp(
            title: 'Shoply App',
            onGenerateRoute: AppRoutes.onGenerateRoute,
            initialRoute: AppPages.splashScreen,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.themeLight,
            darkTheme: AppTheme.themeDark,
            themeMode: settings.themeMode,
            locale: settings.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
          );
        },
      ),
    );
  }
}
