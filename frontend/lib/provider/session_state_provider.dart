import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionStateProvider extends ChangeNotifier {
  Future<bool> get isFirstTime async {
    final instance = await SharedPreferences.getInstance();
    return instance.getBool('isFirstTime') ?? true;
  }
}
