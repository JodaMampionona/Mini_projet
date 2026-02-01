import 'package:frontend/services/photon_service.dart';

class Place {
  final String name;
  final String? city;
  final double lat;
  final double lon;

  Place({
    required this.name,
    required this.city,
    required this.lat,
    required this.lon,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      name: json['properties']['name'] ?? '',
      city: json['properties']['city'],
      lat: json['geometry']['coordinates'][1],
      lon: json['geometry']['coordinates'][0],
    );
  }
}

class PlaceModel {
  List<Place> places = [];

  Future<List<Place>> fetchPlaces(String? query) async {
    try {
      places = await PhotonService.search(query);
      return places;
    } catch (e) {
      print('Error while fetching places: $e');
      return [];
    }
  }
}
