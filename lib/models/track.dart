class Track {
  String track_id;
  int track_length;
  String track_location;
  String track_name;
  List<String> track_sections;
  String user_id;

  Track({
    required this.track_id,
    required this.track_length,
    required this.track_location,
    required this.track_name,
    required this.track_sections,
    required this.user_id,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      track_id: json['track_id'],
      track_length: json['track_length'],
      track_location: json['track_location'],
      track_name: json['track_name'],
      track_sections: List<String>.from(json['track_sections']),
      user_id: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'track_id': track_id,
      'track_length': track_length,
      'track_location': track_location,
      'track_name': track_name,
      'track_sections': track_sections,
      'user_id': user_id,
    };
  }


}