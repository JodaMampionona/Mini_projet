import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:frontend/model/itinerary_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ItineraryViewModel extends ChangeNotifier {
  final itineraryModel = ItineraryModel();

  List<Itinerary> itinerary = [];
  double? _distance;
  int _currentIndex = 0;

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  int get currentIndex => _currentIndex;

  double get distance {
    double totalDistance = 0;
    LatLng? previous;

    for (int i = _currentIndex; i < itinerary.length; i++) {
      final segment = itinerary[i];

      if (segment.busStops.isNotEmpty) {
        for (final stop in segment.busStops) {
          final current = LatLng(stop.lat, stop.lon);

          if (previous != null) {
            totalDistance += _euclideanDistance(previous, current);
          }

          previous = current;
        }
      } else {
        // si bus stops []
        final start = LatLng(segment.startLat, segment.startLon);
        final end = LatLng(segment.endLat, segment.endLon);

        if (previous != null) {
          totalDistance += _euclideanDistance(previous, start);
        }

        totalDistance += _euclideanDistance(start, end);
        previous = end;
      }
    }

    _distance = totalDistance;
    return _distance!;
  }

  double _euclideanDistance(LatLng p1, LatLng p2) {
    const double kx = 111.32;
    const double ky = 110.57;

    final dx = (p2.longitude - p1.longitude) * kx;
    final dy = (p2.latitude - p1.latitude) * ky;

    return sqrt(dx * dx + dy * dy);
  }

  int get durationInSeconds {
    double totalDistanceKm = distance;

    // TODO : change speed ?
    const double busSpeedKmH = 25;
    const int stopDelaySeconds = 30;

    double travelTimeSeconds = (totalDistanceKm / busSpeedKmH) * 3600;

    int totalStops = 0;
    for (int i = currentIndex; i < itinerary.length; i++) {
      totalStops += itinerary[i].busStops.length;
    }

    final totalTime = travelTimeSeconds + (totalStops * stopDelaySeconds);

    return totalTime.round();
  }

  String get durationFormatted {
    final seconds = durationInSeconds;

    final minutes = (seconds / 60).floor();
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (hours > 0) {
      return "${hours}h ${remainingMinutes}min";
    } else {
      return "$minutes min";
    }
  }

  void setItinerary(List<Itinerary> newItinerary) {
    itinerary = newItinerary;
    notifyListeners();
  }
}
