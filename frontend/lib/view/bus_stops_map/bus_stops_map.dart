import 'package:flutter/material.dart';
import 'package:frontend/model/stop_model.dart';

class BusStopsMap extends StatelessWidget {
  final List<Stop> stops;
  final String busName;

  const BusStopsMap({super.key, required this.stops, required this.busName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: BackButton(), title: Text('Bus "$busName"')),
      body: Column(children: []),
    );
  }
}
