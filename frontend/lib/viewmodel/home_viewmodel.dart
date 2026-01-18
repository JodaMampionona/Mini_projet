import 'package:flutter/material.dart';
import 'package:frontend/model/bus_stop_model.dart';

class HomeViewModel extends ChangeNotifier {
  final model = BusStopModel();
  bool loading = true;
  BusStop? start;
  BusStop? destination;

  final TextEditingController startController = TextEditingController();
  final TextEditingController destController = TextEditingController();

  List<BusStop> get busStops => model.busStops;

  void swapStartAndDestination() {
    // swap controller values
    var startValue = startController.text;
    startController.text = destController.text;
    destController.text = startValue;

    // swap id values
    var tmp = start;
    start = destination;
    destination = tmp;
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

  void updateBusStops(BusStop startPoint, BusStop destPoint, String name) {
    start = startPoint;
    destination = destPoint;
  }

  void updateStartController(BusStop stop) {
    startController.text = stop.name;
    start = stop;
    notifyListeners();
  }

  void updateDestController(BusStop stop) {
    destController.text = stop.name;
    destination = stop;
    notifyListeners();
  }

  @override
  void dispose() {
    startController.dispose();
    destController.dispose();
    super.dispose();
  }
}
