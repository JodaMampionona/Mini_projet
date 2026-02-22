import 'package:frontend/services/app_preferences_service.dart';

class SessionModel {
  static bool get isFirstTime =>
      AppPreferencesService.instance.getBool('isFirstTime') ?? true;

  static Future<void> setNotFirstTime() async {
    await AppPreferencesService.instance.setBool('isFirstTime', false);
  }
}
