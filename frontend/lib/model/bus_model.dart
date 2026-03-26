import 'package:frontend/model/bus_stop_model.dart';
import 'package:frontend/utils/dio_util.dart';

class Bus {
  final int id;
  final String name;
  final List<BusStop> stops;

  const Bus({required this.id, required this.name, required this.stops});

  factory Bus.fromJson(Map<String, dynamic> json) {
    final itinerary = json['itinerary'];

    return Bus(
      id: json['id'] as int,
      name: json['name'] as String,
      stops: itinerary == null || itinerary.isEmpty || itinerary[0] == null
          ? <BusStop>[]
          : (itinerary as List<dynamic>)
                .map((e) => BusStop.fromJson(e as Map<String, dynamic>))
                .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'itinerary': stops.map((e) => e.toJson()).toList(),
    };
  }
}

class BusModel {
  Future<Bus> getById(int id) async {
    final response = await dio.get('/bus?bus_id=$id');
    return Bus.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<Bus>> getAll() async {
    final response = await dio.get('/bus');
    return (response.data as List<dynamic>)
        .map((e) => Bus.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
