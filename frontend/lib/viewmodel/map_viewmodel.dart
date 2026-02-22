import 'package:flutter/material.dart';
import 'package:frontend/model/place_model.dart';
import 'package:frontend/model/itinerary_model.dart';

class MapViewModel extends ChangeNotifier {
  ItineraryModel model = ItineraryModel();
  List<Itinerary> itinerary = [];

  bool loading = false;
  Place? start;
  Place? end;

  // controllers
  final TextEditingController startController = TextEditingController();
  final TextEditingController destController = TextEditingController();

  void updateControllers({String? start, String? dest}) {
    if (start != null) startController.text = start;
    if (dest != null) destController.text = dest;
  }

  void swapStartAndDestination() {
    // swap controller values
    var startValue = startController.text;
    startController.text = destController.text;
    destController.text = startValue;

    // swap id values
    var tmp = start;
    start = end;
    end = tmp;
    notifyListeners();
  }

  void updateStartController(Place? place) {
    if (place == null) return;
    startController.text = place.name;
    start = place;
    notifyListeners();
  }

  void updateDestController(Place? place) {
    if (place == null) return;
    destController.text = place.name;
    end = place;
    notifyListeners();
  }

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  void getItinerary() {
    if (start == null || end == null) return;
    setLoading(true);
    model
        .getItinerary(start!, end!)
        .then((result) {
          if (result != null) {
            itinerary = result;
          }
        })
        .whenComplete(() {
          setLoading(false);
        });
  }

  @override
  void dispose() {
    super.dispose();
    startController.dispose();
    destController.dispose();
  }
}
