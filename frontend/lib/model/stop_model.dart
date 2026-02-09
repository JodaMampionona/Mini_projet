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
    final order = json['order'];
    return Stop(
      id: json['id'] as int,
      name: json['name'] as String,
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      order: order == null ? 0 : order as int,
    );
  }
}
