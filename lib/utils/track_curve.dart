import 'dart:math';

import 'package:flutter/material.dart';

class TrackCurve extends CustomPainter {
  final bool isClosed;
  final double minDistance;

  TrackCurve({this.isClosed = true, this.minDistance = 50});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    final path = Path();
    final random = Random();

    double startX = size.width * 0.1;
    double startY = size.height * 0.1;
    path.moveTo(startX, startY);

    for (int i = 0; i < 2; i++) {
      double x1, y1, x2, y2;
      do {
        x1 = random.nextDouble() * size.width;
        y1 = random.nextDouble() * size.height;
      } while (_distance(startX, startY, x1, y1) < minDistance);

      do {
        x2 = random.nextDouble() * size.width;
        y2 = random.nextDouble() * size.height;
      } while (_distance(x1, y1, x2, y2) < minDistance);

      path.quadraticBezierTo(x1, y1, x2, y2);
      startX = x2;
      startY = y2;
    }

    if (isClosed) {
      path.close();
    }

    canvas.drawPath(path, paint);
  }

  double _distance(double x1, double y1, double x2, double y2) {
    return sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}