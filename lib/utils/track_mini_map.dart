import 'package:flutter/material.dart';
import 'package:log_my_ride/utils/constants.dart';

class TrackPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Paint for the track
    final trackPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    //paint 2
    final trackPaint2 = Paint()
      ..color = Colors.lightGreenAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    //paint 3
    final trackPaint3 = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    //paint 4
    final trackPaint4 = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    // Create a path from the SVG data
    // Create paths for different sectors
    Path path1 = Path();
    Path path2 = Path();
    Path path3 = Path();

    // Scaling factors to fit the path within the available canvas size
    double scaleX = size.width / 400;  // Original width: 400
    double scaleY = size.height / 500; // Original height: 500

    // Define the first sector
    path1.moveTo(374 * scaleX, 123 * scaleY);
    path1.cubicTo(330 * scaleX, -33.8 * scaleY, 173.667 * scaleX, -1.66666 * scaleY, 101 * scaleX, 34 * scaleY);

    // Define the second sector
    path2.moveTo(101 * scaleX, 34 * scaleY);
    path2.cubicTo(48.2 * scaleX, 57.2 * scaleY, 17 * scaleX, 98.3333 * scaleY, 8 * scaleX, 116 * scaleY);
    path2.cubicTo(-0.333332 * scaleX, 137.333 * scaleY, 4.2 * scaleX, 173.6 * scaleY, 89 * scaleX, 148 * scaleY);

    // Define the third sector
    path3.moveTo(89 * scaleX, 148 * scaleY);
    path3.cubicTo(217 * scaleX, 183.667 * scaleY, 218.2 * scaleX, 229.6 * scaleY, 167 * scaleX, 272 * scaleY);
    path3.cubicTo(103 * scaleX, 325 * scaleY, 126 * scaleX, 366 * scaleY, 131 * scaleX, 379 * scaleY);
    path3.cubicTo(136 * scaleX, 392 * scaleY, 192 * scaleX, 441 * scaleY, 262 * scaleX, 444 * scaleY);
    path3.cubicTo(318 * scaleX, 446.4 * scaleY, 360 * scaleX, 411.667 * scaleY, 374 * scaleX, 394 * scaleY);
    path3.cubicTo(392.333 * scaleX, 369 * scaleY, 418 * scaleX, 279.8 * scaleY, 374 * scaleX, 123 * scaleY);

    // Draw the paths on the canvas
    canvas.drawPath(path1, trackPaint);
    canvas.drawPath(path2, trackPaint2);
    canvas.drawPath(path3, trackPaint3);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}