import 'package:flutter/cupertino.dart';
import 'package:frontend/model/itinerary_model.dart';

class ItineraryViewModel extends ChangeNotifier {
  List<Itinerary> itinerary = [];
  bool loading = true;
  final model = ItineraryModel();

  void getItinerary(int start, int dest) {
    model.getItinerary(start, dest).then((newItinerary) {
      itinerary = newItinerary;
      loading = false;
      notifyListeners();
    });
  }
}
