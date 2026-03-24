import 'package:frontend/model/stop_model.dart';

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