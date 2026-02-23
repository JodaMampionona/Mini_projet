import 'package:flutter/material.dart';
import 'package:frontend/model/session_model.dart';
import 'package:frontend/provider/session_state_provider.dart';
import 'package:provider/provider.dart';

class HomeViewModel extends ChangeNotifier {
  final model = SessionModel();
  bool isFirstTime = false;

  void init(BuildContext context) async {
    isFirstTime = await context.read<SessionStateProvider>().isFirstTime;
    if (isFirstTime) await model.setNotFirstTime();
    notifyListeners();
  }
}
