import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/model/place_model.dart';
import 'package:frontend/model/search_response.dart';
import 'package:frontend/model/bus_stop_model.dart';

class SearchViewModel extends ChangeNotifier {
  final stopModel = BusStopModel();

  SearchResponse? _searchResponse;

  SearchResponse? get searchResponse => _searchResponse;

  String? errorMsg;

  bool _disposed = false;
  bool loading = false;
  bool positionLoading = false;

  Timer? _debounce;

  final placeController = TextEditingController();
  final focusNode = FocusNode();

  SearchViewModel() {
    placeController.addListener(_onSearchChanged);
  }

  Future<void> fetchPlaces(String? query) async {
    if (query == null || query.length < 2) return;

    loading = true;
    safeNotifyListeners();

    try {
      SearchResponse? result = await stopModel.getStopsByPlaceName(query);
      if (result != null) {
        _searchResponse = result.copyWith(stops: _unique(result.stops));
      }
      errorMsg = null;
    } catch (e) {
      errorMsg = "Connexion internet instable.";
    } finally {
      loading = false;
      safeNotifyListeners();
    }
  }

  Future<void> fetchPlacesByPosition() async {
    try {
      final position = await _getCurrentLocation();
      positionLoading = true;
      safeNotifyListeners();

      if (position != null) {
        _searchResponse = await stopModel.getStopsNearPlace(position);
      }
      errorMsg = null;
    } catch (e) {
      errorMsg =
          'Impossible de récupérer les arrêts proches de votre position.\nActivez la localisation ou vérifiez votre connexion internet.';
    } finally {
      positionLoading = false;
      safeNotifyListeners();
    }
  }

  Future<Place?> _getCurrentLocation() async {
    return await PlaceModel.getCurrentLocation();
  }

  void requestInputFocus() {
    focusNode.requestFocus();
  }

  void safeNotifyListeners() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  String _previousText = '';

  void _onSearchChanged() {
    _debounce?.cancel();

    final currentText = placeController.text.trim();
    if (currentText == _previousText) {
      return; // pas de changement réel
    }

    _debounce = Timer(const Duration(milliseconds: 400), () {
      _previousText = currentText;
      fetchPlaces(currentText);
    });
  }

  List<BusStop> _unique(List<BusStop> stops) {
    final seenNames = <String>{};
    final uniqueStops = <BusStop>[];

    for (final stop in stops) {
      if (!seenNames.contains(stop.name)) {
        seenNames.add(stop.name);
        uniqueStops.add(stop);
      }
    }

    uniqueStops.sort((a, b) {
      if (a.zone == null) return 1;
      if (b.zone == null) return -1;
      return a.zone!.compareTo(b.zone!);
    });

    return uniqueStops;
  }

  @override
  void dispose() {
    _disposed = true;
    _debounce?.cancel();
    placeController.dispose();
    focusNode.dispose();
    super.dispose();
  }
}
