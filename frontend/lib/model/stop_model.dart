class Stop {
  final int id;
  final String name;
  final double lat;
  final double lon;
  final int order;

  const Stop({
    required this.id,
    required this.name,
    required this.lat,
    required this.lon,
    required this.order,
  });

  factory Stop.fromJson(Map<String, dynamic> json) {
    return Stop(
      id: json['stop_id'] as int,
      name: json['name'] as String,
      lat: (json['latitude'] as num).toDouble(),
      lon: (json['longitude'] as num).toDouble(),
      order: json['order'] as int,
    );
  }
}
