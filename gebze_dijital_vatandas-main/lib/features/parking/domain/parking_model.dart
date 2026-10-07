class ParkingModel {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final int capacity;
  final int occupied;
  final String price;
  final String workingHours;
  final double distanceKm;

  const ParkingModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.capacity,
    required this.occupied,
    required this.price,
    required this.workingHours,
    required this.distanceKm,
  });

  factory ParkingModel.fromJson(Map<String, dynamic> json) {
    return ParkingModel(
      id: json['id'] as String,
      name: json['name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      capacity: json['capacity'] as int,
      occupied: json['occupied'] as int,
      price: json['price'] as String,
      workingHours: json['workingHours'] as String,
      distanceKm: (json['distanceKm'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'capacity': capacity,
      'occupied': occupied,
      'price': price,
      'workingHours': workingHours,
      'distanceKm': distanceKm,
    };
  }
}
