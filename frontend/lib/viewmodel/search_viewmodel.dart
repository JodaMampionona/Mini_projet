import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/model/place_model.dart';
import 'package:frontend/model/stop_model.dart';

class SearchViewModel extends ChangeNotifier {
  final placeModel = PlaceModel();
  final stopModel = StopModel();

  SearchResponse? searchResponse;

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
        searchResponse = result.copyWith(stops: _unique(result.stops));
      }
      errorMsg = null;
    } catch (e) {
      errorMsg = e.toString();
      searchResponse = null;
    } finally {
      loading = false;
      safeNotifyListeners();
    }
  }

  Future<void> fetchPlacesByPosition() async {
    try {
      final position = await _getCurrentLocation();
      if (position != null) {
        searchResponse = await stopModel.getStopsNearPlace(position);
      }
    } catch (e) {
      errorMsg = 'Impossible de récupérer les arrêts proches de vous.';
    } finally {
      safeNotifyListeners();
    }
  }

  Future<Place?> _getCurrentLocation() async {
    try {
      positionLoading = true;
      errorMsg = null;
      safeNotifyListeners();
      return await placeModel.getCurrentLocation();
    } catch (e) {
      errorMsg = e.toString();
      safeNotifyListeners();
    } finally {
      positionLoading = false;
      safeNotifyListeners();
    }
    return null;
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
    if (currentText == _previousText) return; // pas de changement réel

    _debounce = Timer(const Duration(milliseconds: 400), () {
      _previousText = currentText;
      fetchPlaces(currentText);
    });
  }

  List<Stop> _unique(List<Stop> stops) {
    final seen = <String>{};
    final uniqueStops = <Stop>[];

    for (final stop in stops) {
      final key = '${stop.name}_${stop.bus?.id ?? 'null'}';
      if (!seen.contains(key)) {
        seen.add(key);
        uniqueStops.add(stop);
      }
    }

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
