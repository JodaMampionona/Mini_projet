import 'package:flutter/material.dart';
import 'package:frontend/model/itinerary_model.dart';
import 'package:frontend/model/place_model.dart';

class HomeViewModel extends ChangeNotifier {
  final model = ItineraryModel();
  bool loading = true;
  Place? start;
  Place? destination;
  List<Itinerary> itinerary = [];

  final TextEditingController startController = TextEditingController();
  final TextEditingController destController = TextEditingController();

  Future<void> getItinerary(Place? start, Place? dest) async {
    setLoading(true);

    final result = await model.getItinerary(start, dest);
    itinerary = result;

    setLoading(false);
  }

  void setLoading(bool val) {
    loading = val;
    notifyListeners();
  }

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
