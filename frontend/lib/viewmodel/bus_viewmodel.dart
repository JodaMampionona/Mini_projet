import 'package:flutter/foundation.dart';
import 'package:frontend/model/bus_model.dart';

class BusViewModel extends ChangeNotifier {
  final model = BusModel();

  String errorMsg = '';

  bool _loading = false;

  List<Bus>? _buses;

  List<Bus> get buses => _buses ?? [];

  bool get loading => _loading;

  void setLoading(bool val) {
    _loading = val;
    notifyListeners();
  }

  void fetchBuses() {
    setLoading(true);
    model
        .getAll()
        .then((res) {
          _buses = res;
          errorMsg = '';
        })
        .catchError((e) {
          print('Oh no!');
          errorMsg = 'Impossible de récupérer la liste des bus';
        })
        .whenComplete(() {
          setLoading(false);
        });
  }
}
