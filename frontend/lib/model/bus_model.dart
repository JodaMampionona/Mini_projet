import 'package:frontend/model/stop_model.dart';
import 'package:frontend/utils/dio_util.dart';

class Bus {
  final int id;
  final String name;
  final List<Stop> stops;

  const Bus({required this.id, required this.name, required this.stops});

  factory Bus.fromJson(Map<String, dynamic> json) {
    final itinerary = json['itinerary'];

    return Bus(
      id: json['bus_id'] as int,
      name: json['bus_name'] as String,
      stops: itinerary == null || itinerary[0] == null
          ? <Stop>[]
          : (itinerary as List<dynamic>)
                .map((e) => Stop.fromJson(e as Map<String, dynamic>))
                .toList(),
    );
  }
}

class BusModel {
  Future<Bus> getBus(int id) async {
    final response = await dio.get('$apiAuthority/itinerary/bus?bus_id=$id');
    return Bus.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<Bus>> getAll() async {
    final response = await dio.get('$apiAuthority/itinerary/bus/');
    return (response.data as List<dynamic>)
        .map((e) => Bus.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
