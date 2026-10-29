part of 'app_settings_cubit.dart';

class AppSettingsState {
  /// Null means "follow the device language".
  final Locale? locale;
  final ThemeMode themeMode;

  const AppSettingsState({this.locale, this.themeMode = ThemeMode.system});
}
