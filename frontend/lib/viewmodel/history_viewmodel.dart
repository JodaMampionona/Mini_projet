import 'package:flutter/foundation.dart';
import 'package:frontend/model/history_model.dart';

class HistoryViewModel extends ChangeNotifier {
  final historyModel = HistoryModel();

  List<HistoryEntry> _history = [];

  List<HistoryEntry> get history => _history;

  void loadHistory() async {
    _history = await historyModel.loadHistory();
    notifyListeners();
  }

  void deleteFromHistory(HistoryEntry entry) async {
    await historyModel.delete(entry);
    _history = await historyModel.loadHistory();
    notifyListeners();
  }

  void clearHistory() async {
    await historyModel.clearHistory();
    _history = await historyModel.loadHistory();
    notifyListeners();
  }
}
