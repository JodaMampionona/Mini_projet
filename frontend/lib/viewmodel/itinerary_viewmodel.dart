import 'package:flutter/cupertino.dart';
import 'package:frontend/model/history_model.dart';
import 'package:frontend/model/itinerary_model.dart';

class ItineraryViewModel extends ChangeNotifier {
  final itineraryModel = ItineraryModel();
  final historyModel = HistoryModel();

  List<Itinerary> itinerary = [];
  bool loading = false;

  void setLoading(bool value) {
    if (loading == value) return;
    loading = value;
    notifyListeners();
  }

  void setItinerary(List<Itinerary> newItinerary) {
    itinerary = newItinerary;
    notifyListeners();
  }
}
