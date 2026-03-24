import 'package:frontend/model/bus_model.dart';
import 'package:frontend/model/place_model.dart';
import 'package:frontend/model/search_response.dart';
import 'package:frontend/utils/dio_util.dart';

class StopResponse {
  final int page;
  final int pageSize;
  final int total;
  final int totalPages;
  final List<Stop> data;

  StopResponse(
    this.page,
    this.pageSize,
    this.total,
    this.totalPages,
    this.data,
  );

  factory StopResponse.fromJson(Map<String, dynamic> json) {
    return StopResponse(
      json['pagination']['page'] as int,
      json['pagination']['page_size'] as int,
      json['pagination']['total'] as int,
      json['pagination']['total_pages'] as int,
      (json['data'] as List<dynamic>)
          .map((e) => Stop.fromJson(e as Map<String, dynamic>))
          .toList(),
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

  Future<StopResponse?> getAll({int? page}) async {
    final pageQuery = page != null ? '?page=$page' : '';
    final response = await dio.get('/bus_stops/$pageQuery');

    if (response.statusCode == 200) {
      final jsonData = response.data as Map<String, dynamic>;

      final stopsList = (jsonData['data'] as List<dynamic>)
          .map((e) => Stop.fromJson(e as Map<String, dynamic>))
          .toList();

      final pagination = jsonData['pagination'] as Map<String, dynamic>;

      return StopResponse(
        pagination['page'] as int,
        pagination['page_size'] as int,
        pagination['total'] as int,
        pagination['total_pages'] as int,
        stopsList,
      );
    } else {
      return null;
    }
  }
}
