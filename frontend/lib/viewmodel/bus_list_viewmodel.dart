import 'package:flutter/material.dart';
import 'package:frontend/model/bus_model.dart';
import 'package:frontend/model/stop_model.dart';

class BusListViewModel extends ChangeNotifier {
  final busModel = BusModel();
  final stopModel = StopModel();

  bool isBusTabActive = true;
  final searchController = TextEditingController();

  String? busErrorMsg;
  String? stopErrorMsg;

  bool _busLoading = false;
  bool _stopLoading = false;
  bool _stopFetchInProgress = false;

  List<Bus>? _buses;
  List<Bus> _filteredBuses = [];

  List<BusStop>? _stops;
  List<BusStop> _uniqueStops = [];
  List<BusStop> _filteredStops = [];

  int _currentPage = 1;
  int _lastPage = 1;

  int lastBusId = 0;

  List<Bus> get buses => _filteredBuses;

  List<BusStop> get stops => _filteredStops;

  bool get busLoading => _busLoading;

  bool get stopLoading => _stopLoading;

  BusListViewModel() {
    searchController.addListener(_onSearchChanged);
  }

  void setActiveTab(bool isBus) {
    isBusTabActive = isBus;
    searchController.clear();
    _onSearchChanged();
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

  Future<void> fetchStops({bool reset = false}) async {
    if (_stopFetchInProgress) return;
    _stopFetchInProgress = true;

    if (reset) {
      _currentPage = 1;
      _lastPage = 1;
      _stops = null;
      _uniqueStops = [];
      _filteredStops = [];
    }

    _setStopLoading(true);

    try {
      final seen = <String>{};
      String? lastZone;

      do {
        final res = await stopModel.getAll(page: _currentPage);
        _lastPage = res?.totalPages ?? 1;

        final newStops = res?.data ?? [];
        _stops == null ? _stops = newStops : _stops!.addAll(newStops);

        final uniqueNewStops = newStops.where((stop) {
          final isNewZone = stop.zone != lastZone;
          if (isNewZone) {
            lastZone = stop.zone;
            seen.clear();
            seen.add(stop.name);
            return true;
          }
          return seen.add(stop.name);
        }).toList();

        _uniqueStops.addAll(uniqueNewStops);
        _filteredStops = List.from(_uniqueStops);
        stopErrorMsg = null;
        notifyListeners();

        _currentPage++;
      } while (_currentPage <= _lastPage);
    } finally {
      _stopFetchInProgress = false;
      _setStopLoading(false);
    }
  }

  void _onSearchChanged() {
    final query = searchController.text.toLowerCase();

    if (isBusTabActive) {
      _filteredBuses =
          _buses
              ?.where(
                (b) => query.isEmpty || b.name.toLowerCase().contains(query),
              )
              .toList() ??
          [];
    } else {
      _filteredStops = _uniqueStops
          .where(
            (s) =>
                query.isEmpty ||
                s.name.toLowerCase().contains(query) ||
                s.zone?.toLowerCase().contains(query) == true,
          )
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

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }
}
