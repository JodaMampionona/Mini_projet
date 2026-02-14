import 'package:geolocator/geolocator.dart';

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
}

class PlaceModel {
  List<Place> places = [];

  Future<Place> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Impossible d\' accéder à votre localisation.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Impossible d\' accéder à votre localisation.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
        'Veuillez autoriser la localisation dans les paramètres',
      );
    }

    final position = await Geolocator.getCurrentPosition();

    return Place(
      name: 'ma position',
      city: 'Antananarivo',
      lat: position.latitude,
      lon: position.longitude,
    );
  }
}
