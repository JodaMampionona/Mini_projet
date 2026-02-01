import 'package:flutter/cupertino.dart';
import 'package:frontend/model/place_model.dart';
import 'package:frontend/model/itinerary_model.dart';

class ItineraryViewModel extends ChangeNotifier {
  List<Itinerary> itinerary = [];
  bool loading = false;
  final model = ItineraryModel();

  void setLoading(bool value) {
    if (loading == value) return;
    loading = value;
    notifyListeners();
  }

  void getItinerary(Place start, Place dest) {
    model.getItinerary(start, dest).then((newItinerary) {
      itinerary = newItinerary;
      setLoading(false);
      notifyListeners();
    });
  }

  void setItinerary(List<Itinerary> newItinerary) {
    itinerary = newItinerary;
    notifyListeners();
  }

}
