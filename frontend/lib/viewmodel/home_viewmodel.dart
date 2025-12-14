import 'package:flutter/material.dart';
import 'package:frontend/model/bus_stop_model.dart';

class HomeViewModel extends ChangeNotifier {
  final model = BusStopModel();
  bool loading = true;
  int startId = -1;
  int destId = -1;

  final TextEditingController startController = TextEditingController();
  final TextEditingController destController = TextEditingController();

  List<BusStop> get busStops => model.busStops;

  void swapStartAndDestination() {
    // swap controller values
    var startValue = startController.text;
    startController.text = destController.text;
    destController.text = startValue;

    // swap id values
    var tmp = startId;
    startId = destId;
    destId = tmp;
    notifyListeners();
  }

  void fetchStopsWithBuses() {
    if (loading == false) {
      loading = true;
      notifyListeners();
    }
    model.fetchStopsWithBuses().then((stops) {
      loading = false;
      notifyListeners();
    });
  }

  void updateIds(int start, int dest, String name) {
    startId = start;
    destId = dest;
  }

  void updateStartController(BusStop stop) {
    startController.text = stop.name;
    startId = stop.id;
    notifyListeners();
  }

  void updateDestController(BusStop stop) {
    destController.text = stop.name;
    destId = stop.id;
    notifyListeners();
  }
}
