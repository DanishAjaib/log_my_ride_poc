import 'package:flutter/material.dart';
import 'package:log_my_ride/utils/constants.dart';
import '../models/sensor_data.dart';

class LineChartPainter extends CustomPainter {
  final List<SensorData> data;

  LineChartPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) {
      return;
    }
    final minX = data.map((e) => double.parse(e.x!)).reduce((a, b) => a < b ? a : b);
    final maxX = data.map((e) => double.parse(e.x!)).reduce((a, b) => a > b ? a : b);
    
    final paint = Paint()
      ..color = primaryColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    if (data.isNotEmpty) {
      final firstPoint = data.first;
      path.moveTo(0, size.height - double.parse(firstPoint.x!));

      for (var i = 1; i < data.length; i++) {
        final point = data[i];
        final x = i * (size.width / (data.length - 1));
        final y = size.height - double.parse(point.x!);
        path.lineTo(x, y);
      }
    }

    final gradient = LinearGradient(
      colors: const [Colors.blue, Colors.yellowAccent],
      stops: [(minX / maxX), 1.0],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    paint.shader = gradient;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}