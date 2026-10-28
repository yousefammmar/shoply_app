import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoply_app/core/local/local_storage.dart';
import 'package:shoply_app/l10n/app_localizations.dart';

part 'app_settings_state.dart';

/// App-wide language and appearance, persisted in SharedPreferences.
class AppSettingsCubit extends Cubit<AppSettingsState> {
  final LocalStorage _storage;

  AppSettingsCubit(this._storage)
    : super(
        AppSettingsState(
          locale: _localeFrom(_storage.getLanguageCode()),
          themeMode:
              ThemeMode.values.asNameMap()[_storage.getThemeMode()] ??
              ThemeMode.system,
        ),
      );

  static Locale? _localeFrom(String? languageCode) {
    final supported = AppLocalizations.supportedLocales.any(
      (locale) => locale.languageCode == languageCode,
    );
    return supported ? Locale(languageCode!) : null;
  }

  Future<void> changeLocale(Locale locale) async {
    emit(AppSettingsState(locale: locale, themeMode: state.themeMode));
    await _storage.setLanguageCode(languageCode: locale.languageCode);
  }

  Future<void> changeThemeMode(ThemeMode themeMode) async {
    emit(AppSettingsState(locale: state.locale, themeMode: themeMode));
    await _storage.setThemeMode(themeMode: themeMode.name);
  }
}
