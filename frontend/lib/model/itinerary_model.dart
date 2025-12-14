import 'package:frontend/utils/dio_util.dart';

class Itinerary {
  final String bus;
  final String from;
  final String to;

  Itinerary({required this.bus, required this.from, required this.to});

  factory Itinerary.fromJson(Map<String, dynamic> json) {
    return Itinerary(bus: json['bus'], from: json['from'], to: json['to']);
  }
}

class ItineraryModel {
  Future<List<Itinerary>> getItinerary(int start, int destination) async {
    if (start < 0 || destination < 0) return [];

    try {
      final response = await dio.get(
        '/itinerary?start_id=$start&destination_id=$destination',
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
