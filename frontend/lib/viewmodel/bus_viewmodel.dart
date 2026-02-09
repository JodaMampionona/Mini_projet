import 'package:flutter/cupertino.dart';
import 'package:frontend/model/bus_model.dart';
import 'package:frontend/model/place_model.dart';

class BusViewModel extends ChangeNotifier {
  final model = BusModel();

  final searchController = TextEditingController();

  String? errorMsg;

  bool _loading = false;
  bool _busLoading = false;

  List<Bus>? _buses;
  List<Bus> _filteredBuses = [];

  List<Bus> get buses => _filteredBuses;

  bool get loading => _loading;

  bool get busLoading => _busLoading;

  List<Place> busStops = [];
  String selectedBusName = '';

  BusViewModel() {
    searchController.addListener(_onSearchChanged);
  }

  Future<void> fetchBus(int id) async {
    await model.getBus(id);
  }

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
          _filteredBuses = List.from(res); // copie initiale
          errorMsg = null;
        })
        .catchError((e) {
          errorMsg = 'Impossible de récupérer la liste des bus';
        })
        .whenComplete(() {
          setLoading(false);
        });
  }

  void _onSearchChanged() {
    final query = searchController.text.toLowerCase();

    if (_buses == null) return;

    if (query.isEmpty) {
      _filteredBuses = List.from(_buses!);
    } else {
      _filteredBuses = _buses!
          .where((bus) => bus.name.toLowerCase().contains(query))
          .toList();
    }

    notifyListeners();
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }
}
