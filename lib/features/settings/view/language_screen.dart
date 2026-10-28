import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoply_app/features/app/view_model/app_settings_cubit.dart';
import 'package:shoply_app/features/settings/view/widgets/settings_option_tile.dart';
import 'package:shoply_app/l10n/l10n.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  // Native names stay untranslated so every user can find their language.
  static const languages = [
    (code: 'en', name: 'English'),
    (code: 'ar', name: 'العربية'),
  ];

  static String currentLanguageName(BuildContext context) {
    final code = Localizations.localeOf(context).languageCode;
    return languages.firstWhere((language) => language.code == code).name;
  }

  @override
  Widget build(BuildContext context) {
    final current = Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.language),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          for (final language in languages)
            SettingsOptionTile(
              icon: Icons.translate_rounded,
              title: language.name,
              selected: language.code == current,
              onTap: () => context.read<AppSettingsCubit>().changeLocale(
                Locale(language.code),
              ),
            ),
        ],
      ),
    );
  }
}
