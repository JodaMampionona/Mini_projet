import 'package:flutter/cupertino.dart';
import 'package:frontend/model/stop_model.dart';

class StopDetailsViewModel extends ChangeNotifier {
  final stopModel = StopModel();
  BusStop? stop;

  bool loading = true;

  void setLoading(bool val) {
    loading = val;
    notifyListeners();
  }

  void fetchStop(int id) {
    setLoading(true);
    stopModel
        .getById(id)
        .then((res) {
          stop = res;
        })
        .catchError((e) {})
        .whenComplete(() {
          setLoading(false);
        });
  }
}
