import 'package:shared_preferences/shared_preferences.dart';

class SessionModel {
  Future<void> setNotFirstTime() async {
    final instance = await SharedPreferences.getInstance();
    await instance.setBool('isFirstTime', false);
  }
}
