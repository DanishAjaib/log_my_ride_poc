import 'package:flutter/material.dart';

class CustomSliderThumbShape extends SliderComponentShape {

  final double strokeWidth;
  final Color strokeColor;
  final Color fillColor;

  CustomSliderThumbShape({
    required this.strokeWidth,
    required this.strokeColor,
    required this.fillColor,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(16, 16);
  }

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        required bool isDiscrete,
        required TextPainter labelPainter,
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required TextDirection textDirection,
        required double value,
        required double textScaleFactor,
        required Size sizeWithOverflow,
      }) {
    final Canvas canvas = context.canvas;
    final Paint fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    // Paint for the stroke
    final Paint strokePaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    // Draw the filled circle
    canvas.drawCircle(center, 8, fillPaint);

    // Draw the stroke
    canvas.drawCircle(center, 8, strokePaint);
  }
}