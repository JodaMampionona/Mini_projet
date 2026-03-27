import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:frontend/constants/app_assets.dart';

class MarkerIconService {
  static BitmapDescriptor? startMarkerIcon;
  static BitmapDescriptor? endMarkerIcon;
  static BitmapDescriptor? transferMarker;

  static Future<void> preload() async {
    startMarkerIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(28, 28)),
      AppImages.startMarker,
    );
    endMarkerIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(28, 28)),
      AppImages.endMarker,
    );
    transferMarker = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(28, 28)),
      AppImages.transferMarker,
    );
  }
}
