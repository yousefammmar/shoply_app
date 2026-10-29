import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static LocalStorage? _instance;
  static SharedPreferences? _preferences;

  LocalStorage._init() {
    _instance = this;
  }

  static LocalStorage get instance {
    if (_instance == null) {
      LocalStorage._init();
    }
    return _instance!;
  }

  Future<SharedPreferences?> initSharedPreferences() async {
    return _preferences = await SharedPreferences.getInstance();
  }

  Future<void> setShowOnboard({required bool isShowOnboard}) async {
    await _preferences?.setBool('showOnboard', isShowOnboard);
  }

  bool? getShowOnBoard() {
    return _preferences?.getBool('showOnboard');
  }

  Future<void> setIsLogin({required bool isLogin}) async {
    await _preferences?.setBool('isLogin', isLogin);
  }

  bool? getIsLogin() {
    return _preferences?.getBool('isLogin');
  }

  Future<void> setLanguageCode({required String languageCode}) async {
    await _preferences?.setString('languageCode', languageCode);
  }

  String? getLanguageCode() {
    return _preferences?.getString('languageCode');
  }

  Future<void> setThemeMode({required String themeMode}) async {
    await _preferences?.setString('themeMode', themeMode);
  }

  String? getThemeMode() {
    return _preferences?.getString('themeMode');
  }
}
