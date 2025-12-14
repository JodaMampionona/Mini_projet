import 'package:flutter/cupertino.dart';
import 'package:frontend/services/app_preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingViewModel extends ChangeNotifier {
  Future<bool> isUserFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool('isFirstTime');
    return isFirstTime == null;
  }

  Future<void> logUserIn() async => AppPreferences.setNotFirstTime();
}
