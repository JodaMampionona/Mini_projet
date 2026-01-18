import 'package:frontend/model/bus_stop_model.dart';
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
  Future<List<Itinerary>> getItinerary(
    BusStop start,
    BusStop destination,
  ) async {
    if (start.id < 0 || destination.id < 0) return [];

    try {
      final response = await dio.get(
        '/itinerary?start_id=${start.id}&destination_id=${destination.id}',
      );

      final itinerary = (response.data as List)
          .map((jsonItem) => Itinerary.fromJson(jsonItem))
          .toList();

      return itinerary;
    } catch (e) {
      return [];
    }
  }
}
