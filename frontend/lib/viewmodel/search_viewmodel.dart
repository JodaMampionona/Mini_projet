import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/model/place_model.dart';

class SearchViewModel extends ChangeNotifier {
  final model = PlaceModel();
  List<Place> places = [];

  bool loading = false;

  String _lastQuery = '';

  Timer? _debounce;

  final placeController = TextEditingController();
  final focusNode = FocusNode();

  SearchViewModel() {
    placeController.addListener(_onSearchChanged);
  }

  Future<void> fetchPlaces(String? query) async {
    if (query == null || query.length < 2) return;

    loading = true;
    notifyListeners();

    try {
      final result = await model.fetchPlaces(query);
      places = _uniqueByNameAndCity(result);
    } catch (e) {
      places = [];
    } finally {
      loading = false;
      print('places :: $places');
      notifyListeners();
    }
  }

  void requestInputFocus() {
    focusNode.requestFocus();
  }

  void _onSearchChanged() {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () {
      final query = placeController.text.trim();
      if (query == _lastQuery) return;
      _lastQuery = query;
      fetchPlaces(query);
    });
  }

  List<Place> _uniqueByNameAndCity(List<Place> places) {
    final seen = <String>{};
    final uniquePlaces = <Place>[];

    for (var p in places) {
      final key = '${p.name}-${p.city}';
      if (!seen.contains(key)) {
        seen.add(key);
        uniquePlaces.add(p);
      }
    }

    return uniquePlaces;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    placeController.dispose();
    focusNode.dispose();
    super.dispose();
  }
}
