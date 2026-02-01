import 'package:frontend/model/place_model.dart';
import 'package:frontend/utils/dio_util.dart';

class Itinerary {
  final String bus;
  final String from;
  final String to;
  final double lat;
  final double lon;

  Itinerary({
    required this.bus,
    required this.from,
    required this.to,
    required this.lat,
    required this.lon,
  });

  factory Itinerary.fromJson(Map<String, dynamic> json) {
    return Itinerary(
      bus: json['bus'],
      from: json['from'],
      to: json['to'],
      lat: json['lat'],
      lon: json['lon'],
    );
  }
}

class ItineraryModel {
  Future<List<Itinerary>> getItinerary(Place start, Place destination) async {
    try {
      final response = await dio.get(
        '$apiAuthority${apiPrefix}itinerary',
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
      return [];
    }
  }
}
