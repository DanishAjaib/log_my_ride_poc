class Vehicle {
  int created_at;
  String vehicle_id;
  String vehicle_name;
  String vehicle_type;
  String image;
  String user_id;

  Vehicle({
    required this.created_at,
    required this.vehicle_id,
    required this.vehicle_name,
    required this.vehicle_type,
    required this.image,
    required this.user_id,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      created_at: json['created_at'],
      vehicle_id: json['vehicle_id'],
      vehicle_name: json['vehicle_name'],
      vehicle_type: json['vehicle_type'],
      image: json['image'],
      user_id: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'created_at': created_at,
      'vehicle_id': vehicle_id,
      'vehicle_name': vehicle_name,
      'vehicle_type': vehicle_type,
      'image': image,
      'user_id': user_id,
    };
  }
}