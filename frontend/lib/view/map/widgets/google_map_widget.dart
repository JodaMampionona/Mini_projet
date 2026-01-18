import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/model/itinerary_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapWidget extends StatefulWidget {
  final List<Itinerary> itinerary;

  const GoogleMapWidget({super.key, required this.itinerary});

  @override
  State<GoogleMapWidget> createState() => GoogleMapWidgetState();
}

class GoogleMapWidgetState extends State<GoogleMapWidget> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    final itineraryPolylines = _getPolylines(widget.itinerary);
    final markers = _getMarkers(widget.itinerary);

    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        polylines: itineraryPolylines,
        markers: markers,
        initialCameraPosition: const CameraPosition(
          target: LatLng(-18.907437, 47.526135),
          zoom: 12,
        ),
        style: _mapStyle,
        onMapCreated: (GoogleMapController controller) async {
          _controller.complete(controller);

          if (widget.itinerary.isNotEmpty) {
            final bounds = _getBounds(widget.itinerary);

            // délai pour que la map soit rendue
            await Future.delayed(const Duration(milliseconds: 300));

            controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
          }
        },
      ),
    );
  }

  /// Création de la polyline
  Set<Polyline> _getPolylines(List<Itinerary> itinerary) {
    final polylinePoints = itinerary.map((e) => LatLng(e.lat, e.lon)).toList();

    return {
      Polyline(
        polylineId: const PolylineId('itinerary'),
        points: polylinePoints,
        color: AppColors.secondaryMain,
        width: 10,
      ),
    };
  }

  /// Calcul des bounds pour contenir toute la polyline
  LatLngBounds _getBounds(List<Itinerary> itinerary) {
    double south = itinerary.first.lat;
    double north = itinerary.first.lat;
    double west = itinerary.first.lon;
    double east = itinerary.first.lon;

    for (final point in itinerary) {
      south = south < point.lat ? south : point.lat;
      north = north > point.lat ? north : point.lat;
      west = west < point.lon ? west : point.lon;
      east = east > point.lon ? east : point.lon;
    }

    return LatLngBounds(
      southwest: LatLng(south, west),
      northeast: LatLng(north, east),
    );
  }

  // Create markers for start, end, and in-between
  Set<Marker> _getMarkers(List<Itinerary> itinerary) {
    final markers = <Marker>{};

    for (int i = 0; i < itinerary.length; i++) {
      final point = itinerary[i];
      String label;
      BitmapDescriptor icon;

      if (i == 0) {
        // start
        label = itinerary[i].from;
        icon = BitmapDescriptor.defaultMarkerWithHue(200);
      } else if (i == itinerary.length - 1) {
        // end
        label = itinerary[i].to;
        icon = BitmapDescriptor.defaultMarkerWithHue(200);
      } else {
        // in between
        label = itinerary[i].from;
        icon = BitmapDescriptor.defaultMarkerWithHue(44);
      }

      markers.add(
        Marker(
          markerId: MarkerId('marker_$i'),
          position: LatLng(point.lat, point.lon),
          infoWindow: InfoWindow(title: label),
          icon: icon,
        ),
      );
    }

    return markers;
  }
}

const _mapStyle = '''
[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ebe3cd"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#523735"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#f5f1e6"
      }
    ]
  },
  {
    "featureType": "administrative",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#c9b2a6"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#dcd2be"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#ae9e90"
      }
    ]
  },
  {
    "featureType": "landscape.natural",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dfd2ae"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dfd2ae"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#93817c"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#a5b076"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#447530"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f5f1e6"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#fdfcf8"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f8c967"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#e9bc62"
      }
    ]
  },
  {
    "featureType": "road.highway.controlled_access",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e98d58"
      }
    ]
  },
  {
    "featureType": "road.highway.controlled_access",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#db8555"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#806b63"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dfd2ae"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#8f7d77"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#ebe3cd"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dfd2ae"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#b9d3c2"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#92998d"
      }
    ]
  }
]
''';
