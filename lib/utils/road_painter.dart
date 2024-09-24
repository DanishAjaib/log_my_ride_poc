import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:log_my_ride/utils/utils.dart';

class RoadPainter extends CustomPainter {
  final List<GeoPoint> geoPoints;
  final Rect mapBounds;

  RoadPainter({required this.geoPoints, required this.mapBounds});

  @override
  void paint(Canvas canvas, Size size) {
    drawRoadOnCanvas(canvas, size, geoPoints, mapBounds);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Return true if you want to redraw when data changes
  }
}