import 'package:frontend/model/place_model.dart';
import 'package:frontend/model/bus_stop_model.dart';
import 'package:frontend/utils/dio_util.dart';

class Itinerary {
  final String bus;
  final String from;
  final String to;
  final double startLat;
  final double startLon;
  final double endLat;
  final double endLon;
  final List<BusStop> busStops;

  Itinerary({
    required this.bus,
    required this.from,
    required this.to,
    required this.startLat,
    required this.startLon,
    required this.endLat,
    required this.endLon,
    required this.busStops,
  });

  factory Itinerary.fromJson(Map<String, dynamic> json) {
    return Itinerary(
      bus: json['bus'],
      from: json['from'],
      to: json['to'],
      startLat: json['start_lat'],
      startLon: json['start_lon'],
      endLat: json['end_lat'],
      endLon: json['end_lon'],
      busStops: (json['bus_stops'] as List)
          .map((bs) => BusStop.fromJson(bs))
          .toList(),
    );
  }
}

class ItineraryModel {
  Future<List<Itinerary>?> getItineraryByGps(
    Place start,
    Place destination,
  ) async {
    try {
      final response = await dio.get(
        '/itinerary/by_gps',
        queryParameters: {
          'start_lat': start.lat,
          'start_lon': start.lon,
          'destination_lat': destination.lat,
          'destination_lon': destination.lon,
        },
      );

      final data = response.data;

      if (data is! List) return [];

      return data.map<Itinerary>((json) => Itinerary.fromJson(json)).toList();
    } catch (e) {
      return null;
    }
  }

  Future<List<Itinerary>?> getItineraryByStopIds(
    BusStop start,
    BusStop destination,
  ) async {
    try {
      final response = await dio.get(
        '/itinerary/by_stop_ids',
        queryParameters: {
          'start_id': start.id,
          'destination_id': destination.id,
        },
      );

      final data = response.data;

      if (data is! List) return [];

      return data.map<Itinerary>((json) => Itinerary.fromJson(json)).toList();
    } catch (e) {
      return null;
    }
  }
}
