import 'package:flutter/material.dart';
import 'package:frontend/model/place_model.dart';

class HomeViewModel extends ChangeNotifier {
  final model = PlaceModel();
  bool loading = true;
  Place? start;
  Place? destination;

  final TextEditingController startController = TextEditingController();
  final TextEditingController destController = TextEditingController();

  List<Place> get foundPlaces => model.places;

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

  void updateStartController(Place? place) {
    startController.text = place?.name ?? '';
    start = place;
    notifyListeners();
  }

  void updateDestController(Place? place) {
    destController.text = place?.name ?? '';
    destination = place;
    notifyListeners();
  }

  @override
  void dispose() {
    startController.dispose();
    destController.dispose();
    super.dispose();
  }
}
