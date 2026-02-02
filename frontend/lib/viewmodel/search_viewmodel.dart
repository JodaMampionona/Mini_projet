import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/model/place_model.dart';

class SearchViewModel extends ChangeNotifier {
  final model = PlaceModel();
  List<Place> places = [];
  Place? currentLocation;

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
      final result = await model.fetchPlacesByName(query);
      places = _uniqueByNameAndCity(result);
      errorMsg = null;
    } catch (e) {
      errorMsg = e.toString();
      places = [];
    } finally {
      loading = false;
      safeNotifyListeners();
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      positionLoading = true;
      errorMsg = null;
      safeNotifyListeners();
      currentLocation = await model.getCurrentLocation();
    } catch (e) {
      errorMsg = e.toString();
      safeNotifyListeners();
    } finally {
      positionLoading = false;
      safeNotifyListeners();
    }
  }

  void requestInputFocus() {
    focusNode.requestFocus();
  }

  void safeNotifyListeners() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  void _onSearchChanged() {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () {
      final query = placeController.text.trim();
      fetchPlaces(query);
    });
  }

  List<Place> _uniqueByNameAndCity(List<Place> places) {
    final seen = <String>{};
    final uniquePlaces = <Place>[];

    for (var p in places) {
      final key = '${p.name}-${p.city}';
      if (!seen.contains(key) && p.name.trim().isNotEmpty) {
        seen.add(key);
        uniquePlaces.add(p);
      }
    }

    return uniquePlaces;
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
