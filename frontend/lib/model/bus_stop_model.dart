import 'package:frontend/model/bus_model.dart';
import 'package:frontend/model/place_model.dart';
import 'package:frontend/model/search_response.dart';
import 'package:frontend/utils/dio_util.dart';

class StopListResponse {
  final int page;
  final int pageSize;
  final int total;
  final int totalPages;
  final List<BusStop> data;

  StopListResponse(
    this.page,
    this.pageSize,
    this.total,
    this.totalPages,
    this.data,
  );

  factory StopListResponse.fromJson(Map<String, dynamic> json) {
    return StopListResponse(
      json['pagination']['page'] as int,
      json['pagination']['page_size'] as int,
      json['pagination']['total_stops'] as int,
      json['pagination']['total_pages'] as int,
      (json['data'] as List<dynamic>)
          .map((e) => BusStop.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class BusStop {
  final int id;
  final String name;
  final double lat;
  final double lon;
  final String? zone;
  final List<Bus>? bus;
  final int? rank;

  const BusStop({
    required this.id,
    required this.name,
    required this.lat,
    required this.lon,
    this.zone,
    this.bus,
    this.rank,
  });

  BusStop copyWith({
    int? id,
    String? name,
    double? lat,
    double? lon,
    String? zone,
    List<Bus>? bus,
    int? rank,
  }) {
    return BusStop(
      id: id ?? this.id,
      name: name ?? this.name,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      zone: zone ?? this.zone,
      bus: bus ?? this.bus,
      rank: rank ?? this.rank,
    );
  }

  factory BusStop.fromJson(Map<String, dynamic> json) {
    return BusStop(
      id: json['id'] as int,
      name: json['name'] as String,
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      zone: json['zone'] == null ? null : json['zone'] as String,
      bus: json['bus'] == null
          ? null
          : (json['bus'] as List<dynamic>)
                .map((e) => Bus.fromJson(e as Map<String, dynamic>))
                .toList(),
      rank: json['rank'] == null ? null : json['rank'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'lat': lat,
    'lon': lon,
    if (rank != null) 'rank': rank,
    if (zone != null) 'zone': zone,
    if (bus != null) 'bus': bus!.map((b) => b.toJson()).toList(),
  };
}

class BusStopModel {
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

  Future<StopListResponse?> getAll({int? page}) async {
    final pageQuery = page != null ? '?page=$page' : '';
    final response = await dio.get('/bus_stops/$pageQuery');

    if (response.statusCode == 200) {
      final jsonData = response.data as Map<String, dynamic>;
      return StopListResponse.fromJson(jsonData);
    } else {
      return null;
    }
  }

  Future<BusStop?> getById(int id) async {
    final response = await dio.get('/bus_stops/?id=$id');
    return BusStop.fromJson(response.data as Map<String, dynamic>);
  }
}
