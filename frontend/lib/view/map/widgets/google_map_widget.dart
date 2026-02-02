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
  late BitmapDescriptor stopMarkerIcon;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  void initState() {
    super.initState();
    _loadMarkerIcon();
  }

  Future<void> _loadMarkerIcon() async {
    stopMarkerIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(28, 28)),
      'assets/images/bus_marker.png',
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final itineraryPolylines = _getPolylines(widget.itinerary);
    final markers = _getMarkers(widget.itinerary);

    return GoogleMap(
      mapType: MapType.normal,
      polylines: itineraryPolylines,
      markers: markers,
      zoomControlsEnabled: false,
      initialCameraPosition: const CameraPosition(
        target: LatLng(-18.907437, 47.526135),
        zoom: 12,
      ),
      style: _mapStyle,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);

        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await Future.delayed(Duration(milliseconds: 1500));

          double padding = 0;
          if (context.mounted) {
            padding = MediaQuery.of(context).size.height * 0.13;
          }

          if (widget.itinerary.isNotEmpty) {
            final bounds = _getBounds(widget.itinerary);
            await controller.animateCamera(
              CameraUpdate.newLatLngBounds(bounds, padding),
              duration: Duration(milliseconds: 400),
            );
          }
        });
      },
    );
  }

  /// Création de la polyline
  Set<Polyline> _getPolylines(List<Itinerary> itinerary) {
    if (itinerary.isEmpty) return {};

    final List<LatLng> polylinePoints = [];

    for (final segment in itinerary) {
      polylinePoints.add(LatLng(segment.startLat, segment.startLon));
    }

    // pour le dernier segment, ajouter son endLat/endLon
    final last = itinerary.last;
    polylinePoints.add(LatLng(last.endLat, last.endLon));

    return {
      Polyline(
        polylineId: const PolylineId('itinerary'),
        points: polylinePoints,
        color: AppColors.secondaryMain,
        width: 9,
      ),
    };
  }

  // Create markers for start, end, and in-between
  Set<Marker> _getMarkers(List<Itinerary> itinerary) {
    if (itinerary.isEmpty) return <Marker>{};

    final markers = <Marker>{};

    for (int i = 0; i < itinerary.length; i++) {
      final point = itinerary[i];
      var position = LatLng(point.startLat, point.startLon);

      markers.add(
        Marker(
          markerId: MarkerId('marker_${i}_${point.from}'),
          position: position,
          infoWindow: InfoWindow(title: point.from),
          icon: BitmapDescriptor.defaultMarkerWithHue(45),
        ),
      );

      if (i == itinerary.length - 1) {
        markers.add(
          Marker(
            markerId: MarkerId('marker_${i}_${point.to}'),
            position: LatLng(point.endLat, point.endLon),
            infoWindow: InfoWindow(title: point.to),
            icon: BitmapDescriptor.defaultMarkerWithHue(45),
          ),
        );
      }
    }

    return markers;
  }

  // bounds to contain all the polylines
  LatLngBounds _getBounds(List<Itinerary> itinerary) {
    double south = itinerary.first.startLat;
    double north = itinerary.first.startLat;
    double west = itinerary.first.startLon;
    double east = itinerary.first.startLon;

    for (final it in itinerary) {
      // start
      if (it.startLat < south) south = it.startLat;
      if (it.startLat > north) north = it.startLat;
      if (it.startLon < west) west = it.startLon;
      if (it.startLon > east) east = it.startLon;

      // end
      if (it.endLat < south) south = it.endLat;
      if (it.endLat > north) north = it.endLat;
      if (it.endLon < west) west = it.endLon;
      if (it.endLon > east) east = it.endLon;
    }

    final bottomPadding = (north - south) * 0.1;
    south -= bottomPadding;

    return LatLngBounds(
      southwest: LatLng(south, west),
      northeast: LatLng(north, east),
    );
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
