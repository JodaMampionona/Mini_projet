import 'package:flutter/cupertino.dart';
import 'package:frontend/model/bus_model.dart';
import 'package:frontend/model/stop_model.dart';

class BusListViewModel extends ChangeNotifier {
  final busModel = BusModel();
  final stopModel = StopModel();
  int activeTab = 0;

  final searchController = TextEditingController();

  String? busErrorMsg;
  String? stopErrorMsg;

  bool _busLoading = false;

  bool _stopLoading = false;
  bool _newStopLoading = false;

  List<Bus>? _buses;
  List<Bus> _filteredBuses = [];

  List<Stop>? _stops;
  List<Stop> _filteredStops = [];

  List<Bus> get buses => _filteredBuses;

  List<Stop> get stops => _filteredStops;

  bool get busLoading => _busLoading;

  bool get stopLoading => _stopLoading;

  bool get newStopLoading => _newStopLoading;

  List<Stop> busStops = [];
  String? selectedBusName;

  BusListViewModel() {
    searchController.addListener(_onSearchChanged);
  }

  void fetchBuses() {
    _setBusLoading(true);
    busModel
        .getAll()
        .then((res) {
          _buses = res;
          _filteredBuses = List.from(res);
          busErrorMsg = null;
        })
        .catchError((e) {
          busErrorMsg = 'Impossible de récupérer les bus.';
        })
        .whenComplete(() {
          _setBusLoading(false);
        });
  }

  Future<void> fetchBus(int id) async {
    try {
      _setBusLoading(true);
      final result = await busModel.getBus(id);
      busStops = result.stops;
      selectedBusName = result.name;
      busErrorMsg = null;
    } catch (e) {
      selectedBusName = null;
      busErrorMsg = 'Impossible de récupérer les informations de ce bus';
    } finally {
      _setBusLoading(false);
    }
  }

  void fetchStops() {
    _setStopLoading(true);
    stopModel
        .getAll()
        .then((res) {
          _stops = res?.data;

          // TODO : garder les stops avec même nom ?

          final seen = <String>{};
          final uniqueStops = _stops?.where((user) {
            return seen.add(user.name);
          }).toList();

          _filteredStops = List.from(uniqueStops ?? []);
          stopErrorMsg = null;
        })
        .catchError((e) {
          stopErrorMsg = 'Impossible de récupérer les arrêts pour le moment.';
        })
        .whenComplete(() {
          _setStopLoading(false);
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

  void _setBusLoading(bool val) {
    _busLoading = val;
    notifyListeners();
  }

  void _setStopLoading(bool val) {
    _stopLoading = val;
    notifyListeners();
  }

  void _setNewStopLoading(bool val) {
    _newStopLoading = val;
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }
}
