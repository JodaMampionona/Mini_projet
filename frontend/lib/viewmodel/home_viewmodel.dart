import 'package:flutter/material.dart';
import 'package:frontend/model/session_model.dart';
import 'package:frontend/services/app_preferences_service.dart';

class HomeViewModel extends ChangeNotifier {
  bool isFirstTime = false;

  void init() {
    final prefs = AppPreferencesService.instance;
    isFirstTime = prefs.getBool('isFirstTime') ?? true;
    SessionModel.setNotFirstTime().then((_) {
      notifyListeners();
    });
  }
}
