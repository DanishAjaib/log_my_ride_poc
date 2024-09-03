class User {
  String? name;
  String? email;
  String? address;
  String? phone;
  String? uid;
  List<String>? sensors;
  List<String>? tracks;
  List<String>? vehicles;
  List<String>? friends;
  List<String>? skills;

  User({this.name,this.email,this.address, this.phone, this.sensors, this.tracks, this.vehicles, this.friends, this.skills, this.uid});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      address: json['address'],
      phone: json['phone'],
      uid: json['uid'],
      sensors: json['sensors'].cast<String>(),
      tracks: json['tracks'].cast<String>(),
      vehicles: json['vehicles'].cast<String>(),
      friends: json['friends'].cast<String>(),
      skills: json['skills'].cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'address': address,
      'phone': phone,
      'uid': uid,
      'sensors': sensors,
      'tracks': tracks,
      'vehicles': vehicles,
      'friends': friends,
      'skills': skills,
    };
  }
}