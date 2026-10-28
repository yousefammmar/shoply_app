import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoply_app/features/app/view_model/app_settings_cubit.dart';
import 'package:shoply_app/features/settings/view/widgets/settings_option_tile.dart';
import 'package:shoply_app/l10n/l10n.dart';

String themeModeLabel(AppLocalizations l10n, ThemeMode mode) {
  return switch (mode) {
    ThemeMode.light => l10n.lightMode,
    ThemeMode.dark => l10n.darkMode,
    ThemeMode.system => l10n.systemDefault,
  };
}

class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

  static const _options = [
    (mode: ThemeMode.light, icon: Icons.light_mode_outlined),
    (mode: ThemeMode.dark, icon: Icons.dark_mode_outlined),
    (mode: ThemeMode.system, icon: Icons.brightness_auto_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appearance),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: BlocBuilder<AppSettingsCubit, AppSettingsState>(
        builder: (context, settings) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              for (final option in _options)
                SettingsOptionTile(
                  icon: option.icon,
                  title: themeModeLabel(l10n, option.mode),
                  subtitle: option.mode == ThemeMode.system
                      ? l10n.systemDefaultHint
                      : null,
                  selected: settings.themeMode == option.mode,
                  onTap: () => context.read<AppSettingsCubit>().changeThemeMode(
                    option.mode,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
