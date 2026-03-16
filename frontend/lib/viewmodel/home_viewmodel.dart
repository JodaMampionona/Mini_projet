import 'package:flutter/material.dart';
import 'package:frontend/model/history_model.dart';
import 'package:frontend/model/session_model.dart';
import 'package:frontend/provider/session_state_provider.dart';
import 'package:provider/provider.dart';

class HomeViewModel extends ChangeNotifier {
  final sessionModel = SessionModel();
  final historyModel = HistoryModel();

  List<HistoryEntry> _history = [];
  bool isFirstTime = false;

  List<HistoryEntry> get history => _history;

  void init(BuildContext context) async {
    isFirstTime = await context.read<SessionStateProvider>().isFirstTime;
    if (isFirstTime) await sessionModel.setNotFirstTime();

    _history = await historyModel.loadHistory();
    notifyListeners();
  }

  void loadHistory() async {
    _history = await historyModel.loadHistory();
    notifyListeners();
  }

  void deleteFromHistory(HistoryEntry entry) async {
    await historyModel.delete(entry);
    _history = await historyModel.loadHistory();
    notifyListeners();
  }
}
