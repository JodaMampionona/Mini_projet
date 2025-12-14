import 'package:frontend/utils/dio_util.dart';

class BusStop {
  int id;
  String name;
  String bus;

  BusStop({required this.id, required this.name, required this.bus});

  factory BusStop.fromJson(Map<String, dynamic> json) {
    return BusStop(
      id: json['stop']['id'],
      name: json['stop']['name'],
      bus: json['bus']['name'],
    );
  }
}

class BusStopModel {
  BusStopModel._internal();

  static final BusStopModel _instance = BusStopModel._internal();

  factory BusStopModel() => _instance;

  List<BusStop> busStops = [];

  Future<List<BusStop>> fetchStopsWithBuses() async {
    try {
      final response = await dio.get('/bus_stop_links');
      busStops = (response.data as List)
          .map((jsonItem) => BusStop.fromJson(jsonItem))
          .toList();
      return busStops;
    } catch (e) {
      print('Error while fetching: $e');
      return [];
    }
  }
}
