import 'package:flutter/material.dart';
import 'dart:math';

class RoadMapWidget extends StatelessWidget {
  final double width;
  final double height;
  final Color background;
  final double minVal;
  final double maxVal;
  final double length;
  final double thickness;
  final Widget trackWidget;

  RoadMapWidget({
    required this.width,
    required this.height,
    required this.background,
    required this.minVal,
    required this.maxVal,
    required this.length,
    required this.thickness,
    required this.trackWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: background,
      child: CustomPaint(
        painter: RoadPainter(
          minVal: minVal,
          maxVal: maxVal,
          length: length,
          thickness: thickness,
        ),
        child: Center(child: trackWidget),
      ),
    );
  }
}

class RoadPainter extends CustomPainter {
  final double minVal;
  final double maxVal;
  final double length;
  final double thickness;

  RoadPainter({
    required this.minVal,
    required this.maxVal,
    required this.length,
    required this.thickness,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint roadPaint = Paint()
      ..color = Colors.grey[800]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round;

    Path roadPath = Path();
    double currentX = 0;
    double currentY = size.height / 2;
    Random random = Random();

    roadPath.moveTo(currentX, currentY);

    while (currentX < size.width) {
      double controlPointX = currentX + (size.width / length) / 2;
      double controlPointY = currentY + random.nextDouble() * (maxVal - minVal) + minVal;

      double endPointX = currentX + size.width / length;
      double endPointY = size.height / 2;

      roadPath.quadraticBezierTo(controlPointX, controlPointY, endPointX, endPointY);

      currentX = endPointX;
      currentY = endPointY;
    }

    canvas.drawPath(roadPath, roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
