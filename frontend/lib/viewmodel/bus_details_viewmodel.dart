import 'package:flutter/cupertino.dart';
import 'package:frontend/model/bus_model.dart';

class BusDetailsViewModel extends ChangeNotifier {
  final busModel = BusModel();
  Bus? bus;

  bool loading = true;

  void setLoading(bool val) {
    loading = val;
    notifyListeners();
  }

  void fetchBus(int id) {
    setLoading(true);
    busModel
        .getById(id)
        .then((res) {
          bus = res;
        })
        .catchError((e) {})
        .whenComplete(() {
          setLoading(false);
        });
  }
}
