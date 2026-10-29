import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoply_app/core/local/local_storage.dart';
import 'package:shoply_app/core/utils/theme/app_theme.dart';
import 'package:shoply_app/features/app/view_model/app_settings_cubit.dart';
import 'package:shoply_app/features/settings/view/appearance_screen.dart';
import 'package:shoply_app/features/settings/view/language_screen.dart';
import 'package:shoply_app/l10n/app_localizations.dart';

Future<LocalStorage> _storageWith(Map<String, Object> values) async {
  SharedPreferences.setMockInitialValues(values);
  await LocalStorage.instance.initSharedPreferences();
  return LocalStorage.instance;
}

// Same MaterialApp wiring as ShoplyApp, with a test home screen.
Widget _app(AppSettingsCubit cubit, Widget home) {
  return BlocProvider.value(
    value: cubit,
    child: BlocBuilder<AppSettingsCubit, AppSettingsState>(
      builder: (context, settings) => MaterialApp(
        theme: AppTheme.themeLight,
        darkTheme: AppTheme.themeDark,
        themeMode: settings.themeMode,
        locale: settings.locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: home,
      ),
    ),
  );
}

void main() {
  test('defaults to the device language and system theme', () async {
    final cubit = AppSettingsCubit(await _storageWith({}));

    expect(cubit.state.locale, isNull);
    expect(cubit.state.themeMode, ThemeMode.system);
  });

  test('persists language and theme and restores them on restart', () async {
    final storage = await _storageWith({});
    final cubit = AppSettingsCubit(storage);

    await cubit.changeLocale(const Locale('ar'));
    await cubit.changeThemeMode(ThemeMode.dark);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('languageCode'), 'ar');
    expect(prefs.getString('themeMode'), 'dark');

    final restored = AppSettingsCubit(storage);
    expect(restored.state.locale, const Locale('ar'));
    expect(restored.state.themeMode, ThemeMode.dark);
  });

  test('ignores unsupported stored values', () async {
    final cubit = AppSettingsCubit(
      await _storageWith({'languageCode': 'fr', 'themeMode': 'sepia'}),
    );

    expect(cubit.state.locale, isNull);
    expect(cubit.state.themeMode, ThemeMode.system);
  });

  testWidgets('choosing Arabic switches the app to RTL immediately', (
    tester,
  ) async {
    final cubit = AppSettingsCubit(await _storageWith({'languageCode': 'en'}));
    await tester.pumpWidget(_app(cubit, const LanguageScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Language'), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.byType(LanguageScreen))),
      TextDirection.ltr,
    );

    await tester.tap(find.text('العربية'));
    await tester.pumpAndSettle();

    expect(find.text('اللغة'), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.byType(LanguageScreen))),
      TextDirection.rtl,
    );
  });

  testWidgets('choosing Dark Mode switches the theme immediately', (
    tester,
  ) async {
    final cubit = AppSettingsCubit(
      await _storageWith({'languageCode': 'en', 'themeMode': 'light'}),
    );
    await tester.pumpWidget(_app(cubit, const AppearanceScreen()));
    await tester.pumpAndSettle();

    Brightness brightness() =>
        Theme.of(tester.element(find.byType(AppearanceScreen))).brightness;
    expect(brightness(), Brightness.light);

    await tester.tap(find.text('Dark Mode'));
    await tester.pumpAndSettle();

    expect(brightness(), Brightness.dark);
    expect(cubit.state.themeMode, ThemeMode.dark);
  });
}
