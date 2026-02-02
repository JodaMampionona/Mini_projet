import 'package:flutter/material.dart';
import 'package:frontend/model/place_model.dart';
import 'package:frontend/model/itinerary_model.dart';

class MapViewModel extends ChangeNotifier {
  ItineraryModel model = ItineraryModel();
  List<Itinerary> itinerary = [];

  bool loading = false;
  Place? start;
  Place? dest;

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

  void getItinerary(Place? start, Place? dest) async {
    setLoading(true);

    model.getItinerary(start, dest).then((res) {
      itinerary = res;
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
