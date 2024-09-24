import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

import '../views/widgets/random_spline_chart.dart';

class RoadPainter extends CustomPainter {
  final List<GeoPoint> geoPoints;
  final List<SpeedData> speedData;
  final double minSpeed;
  final double maxSpeed;

  RoadPainter({
    required this.geoPoints,
    required this.speedData,
    required this.minSpeed,
    required this.maxSpeed,
  });


  @override
  void paint(Canvas canvas, Size size) {
    Paint roadPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0;

    for (int i = 0; i < geoPoints.length - 1; i++) {
      GeoPoint point1 = geoPoints[i];
      GeoPoint point2 = geoPoints[i + 1];
      SpeedData speed1 = speedData[i];
      SpeedData speed2 = speedData[i + 1];

      double speedValue1 = speed1.speed;
      double speedValue2 = speed2.speed;

      Color color1 = _getColorFromSpeed(speedValue1, minSpeed, maxSpeed)!;
      Color color2 = _getColorFromSpeed(speedValue2, minSpeed, maxSpeed)!;

      roadPaint.shader = LinearGradient(
        colors: [color1, color2],
        stops: [0.0, 1.0],
      ).createShader(Rect.fromPoints(Offset(0, 0), Offset(size.width, size.height)));

      canvas.drawLine(Offset(point1.longitude, point1.latitude), Offset(point2.longitude, point2.latitude), roadPaint);
    }
  }

  Color? _getColorFromSpeed(double speedValue, double minSpeed, double maxSpeed) {
    double speedRatio = (speedValue - minSpeed) / (maxSpeed - minSpeed);
    return Color.lerp(Colors.green, Colors.red, speedRatio);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}