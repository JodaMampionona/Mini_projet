import 'package:flutter/material.dart';
import 'package:frontend/model/history_model.dart';
import 'package:frontend/model/itinerary_model.dart';
import 'package:frontend/model/bus_stop_model.dart';

class MapViewModel extends ChangeNotifier {
  final itineraryModel = ItineraryModel();
  final historyModel = HistoryModel();
  List<Itinerary> itinerary = [];

  bool loading = false;
  BusStop? start;
  BusStop? end;

  // controllers
  final TextEditingController startController = TextEditingController();
  final TextEditingController destController = TextEditingController();

  void swapStartAndDestination() {
    // swap controller values
    final startValue = startController.text;
    startController.text = destController.text;
    destController.text = startValue;

    final tmp = start;
    start = end;
    end = tmp;
    notifyListeners();
  }

  void updateStart(BusStop? busStop) {
    if (busStop == null) return;
    startController.text = busStop.name;
    start = busStop;
    notifyListeners();
  }

  void updateEnd(BusStop? busStop) {
    if (busStop == null) return;
    destController.text = busStop.name;
    end = busStop;
    notifyListeners();
  }

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  void getItinerary() {
    if (start == null || end == null) return;

    setLoading(true);

    final historyEntry = HistoryEntry(
      searchedAt: DateTime.now(),
      start: start!,
      end: end!,
    );
    itineraryModel
        .getItineraryByStopIds(start!, end!)
        .then((result) {
          if (result != null) {
            itinerary = result;
          }
        })
        .whenComplete(() {
          setLoading(false);
          historyModel.add(historyEntry);
        });
  }

  @override
  void dispose() {
    super.dispose();
    startController.dispose();
    destController.dispose();
  }
}
