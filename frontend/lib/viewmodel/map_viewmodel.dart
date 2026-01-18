import 'package:flutter/material.dart';
import 'package:frontend/model/bus_stop_model.dart';
import 'package:frontend/model/itinerary_model.dart';

class MapViewModel extends ChangeNotifier {
  ItineraryModel model = ItineraryModel();
  List<Itinerary> itinerary = [];

  bool loading = false;
  BusStop? start;
  BusStop? dest;

  // controllers
  final TextEditingController startController = TextEditingController();
  final TextEditingController destController = TextEditingController();

  void updateControllers({String? start, String? dest}) {
    if (start != null) startController.text = start;
    if (dest != null) destController.text = dest;
  }

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  void getItinerary(BusStop start, BusStop dest) {
    model.getItinerary(start, dest).then((newItinerary) {
      itinerary = newItinerary;
      setLoading(false);
      notifyListeners();
    });
  }

  @override
  void dispose() {
    super.dispose();
    startController.dispose();
    destController.dispose();
  }
}
