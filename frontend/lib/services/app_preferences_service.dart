import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static bool get isFirstTime => _prefs.getBool('isFirstTime') ?? true;

  static Future<void> setNotFirstTime() async {
    await _prefs.setBool('isFirstTime', false);
  }
}
