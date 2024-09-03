class Session {

  int created_at;
  int session_end_time;
  String session_id;
  int session_start_time;
  String track_id;
  String user_id;
  String vehicle_id;
  String? session_type;




  Session({
    required this.created_at,
    required this.session_end_time,
    required this.session_id,
    required this.session_start_time,
    required this.track_id,
    required this.user_id,
    required this.vehicle_id,
    this.session_type = 'track'
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      created_at: json['created_at'],
      session_end_time: json['session_end_time'],
      session_id: json['session_id'],
      session_start_time: json['session_start_time'],
      track_id: json['track_id'],
      user_id: json['user_id'],
      session_type: json['session_type'],
      vehicle_id: json['vehicle_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'created_at': created_at,
      'session_end_time': session_end_time,
      'session_id': session_id,
      'session_start_time': session_start_time,
      'track_id': track_id,
      'user_id': user_id,
      'session_type': session_type,
      'vehicle_id': vehicle_id,
    };
  }


}