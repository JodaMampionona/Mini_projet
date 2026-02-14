import 'package:frontend/model/bus_model.dart';
import 'package:frontend/model/place_model.dart';
import 'package:frontend/utils/dio_util.dart';

class SearchResponse {
  final String placeName;
  final double lat;
  final double lon;
  final List<Stop> stops;

  const SearchResponse({
    required this.placeName,
    required this.lat,
    required this.lon,
    required this.stops,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    return SearchResponse(
      placeName: json['search_place'] as String,
      lat: (json['coordinates']['lat'] as num).toDouble(),
      lon: (json['coordinates']['lon'] as num).toDouble(),
      stops: (json['stops'] as List<dynamic>)
          .map((e) => Stop.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  SearchResponse copyWith({
    int? distance,
    String? placeName,
    double? lat,
    double? lon,
    List<Stop>? stops,
  }) {
    return SearchResponse(
      placeName: placeName ?? this.placeName,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      stops: stops ?? List<Stop>.from(this.stops),
    );
  }
}

class Stop {
  final int id;
  final String name;
  final double lat;
  final double lon;
  final int order;
  final Bus? bus;
  final int? distance;

  const Stop({
    required this.id,
    required this.name,
    required this.lat,
    required this.lon,
    required this.order,
    required this.bus,
    required this.distance,
  });

  factory Stop.fromJson(Map<String, dynamic> json) {
    return Stop(
      id: json['id'] as int,
      name: json['name'] as String,
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      order: json['order'] ?? 0,
      bus: json['bus'] != null ? Bus.fromJson(json['bus']) : null,
      distance: json['distance'] == null ? null : json['distance'] as int,
    );
  }
}

class StopModel {
  Future<SearchResponse?> getStopsByPlaceName(String query) async {
    final response = await dio.get('/itinerary/search?q=$query');
    return SearchResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<SearchResponse?> getStopsNearPlace(Place place) async {
    final response = await dio.get(
      '/itinerary/search?lat=${place.lat}&lon=${place.lon}',
    );
    return SearchResponse.fromJson(response.data as Map<String, dynamic>);
  }
}
