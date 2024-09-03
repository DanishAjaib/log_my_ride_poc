class SensorData {
   String? sensor;
   String? sensor_data_id;
   String? session_id;
   String? time;
   String? x;
   String? y;
   String? z;
   String? seconds_elapsed;

    SensorData({
      this.sensor,
      this.sensor_data_id,
      this.session_id,
      this.time,
      this.x,
      this.y,
      this.z,
      this.seconds_elapsed,
    });

    factory SensorData.fromJson(Map<String, dynamic> json) {
      return SensorData(
        sensor: json['sensor'],
        sensor_data_id: json['sensor_data_id'],
        session_id: json['session_id'],
        time: json['time'],
        x: json['x'],
        y: json['y'],
        z: json['z'],
        seconds_elapsed: json['seconds_elapsed'],
      );
    }

    Map<String, dynamic> toJson() {
      return {
        'sensor': sensor,
        'sensor_data_id': sensor_data_id,
        'session_id': session_id,
        'time': time,
        'x': x,
        'y': y,
        'z': z,
        'seconds_elapsed': seconds_elapsed,
      };
    }

    @override
  String toString() {

    return 'SensorData{sensor: $sensor, sensor_data_id: $sensor_data_id, session_id: $session_id, time: $time, x: $x, y: $y, z: $z, seconds_elapsed: $seconds_elapsed}';
  }

}