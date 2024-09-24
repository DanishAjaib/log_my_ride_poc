import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:get/get.dart';
import 'package:log_my_ride/utils/constants.dart';
import 'package:log_my_ride/utils/utils.dart';

import '../utils/road_painter.dart';
import '../views/widgets/random_spline_chart.dart';

class LocationController extends GetxController {

  final Rx<MapController> controller = MapController(
      initPosition: GeoPoint(latitude: 0, longitude: 0)
  ).obs;
  final RxList<GeoPoint> roadGeoPoints = <GeoPoint>[].obs;
  final Rx<GeoPoint> roadStartPoint = GeoPoint(latitude: 0, longitude: 0).obs;
  final Rx<GeoPoint> roadEndPoint = GeoPoint(latitude: 0, longitude: 0).obs;
  final Rx<GeoPoint?> currentMarkerPosition = GeoPoint(latitude: 0, longitude: 0).obs;
  final Rx<CustomPaint> roadCustomPaint = CustomPaint().obs;

  final Rx<geo.Position> currentPosition = geo.Position(
      latitude: 0,
      longitude: 0,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speedAccuracy: 1.0,
      altitudeAccuracy: 1.0,
      headingAccuracy: 1.0,
      speed: 1.0
  ).obs;

  LocationController() {
    _initializeLocation();
  }

  Future<void> _requestPermission() async {
   /* if (kDebugMode) {
      print('MAP: Checking Permission');
    }*/
    geo.LocationPermission permission = await geo.Geolocator.checkPermission();
    if (permission == geo.LocationPermission.denied) {
      /*if (kDebugMode) {
        print('MAP: Permission , requesting');
      }*/
      permission = await geo.Geolocator.requestPermission();
      if (permission == geo.LocationPermission.denied) {
        // Permissions are denied, next time you could try requesting permissions again
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == geo.LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
  }


  Future<geo.Position> _getCurrentLocation() async {
   /* if (kDebugMode) {
      print('MAP: Getting current Location');
    }*/
    await _requestPermission();
    return await geo.Geolocator.getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.high);
  }

  Future<List<GeoPoint>> drawRoad({required GeoPoint startPoint, required GeoPoint endPoint}) async {

    var speeds = generateSpeedData(roadGeoPoints.length);
    var minSpeed = speeds.map((s) => s.speed).reduce((a, b) => a < b ? a : b);
    var maxSpeed = speeds.map((s) => s.speed).reduce((a, b) => a > b ? a : b);
    var roadInfo = RoadInfo(route: []);


    try {



      RoadInfo roadInfo = await controller.value.drawRoad(
        startPoint,
        endPoint,
        roadOption: const RoadOption(
          roadColor: primaryColor,
          roadWidth: 15.0,
          zoomInto: false,
        ),
      );

      roadStartPoint.value = startPoint;
      roadEndPoint.value = endPoint;
      roadGeoPoints.value = roadInfo.route;
      //divide the road into 3 segments
      int segmentCount = 5; // Adjust this based on your needs
      int totalPoints = roadGeoPoints.length;

      // Ensure there are enough points for the segments
      if (totalPoints < segmentCount + 1) {
        throw Exception("Not enough points to create the desired number of segments.");
      }

      // List to hold road drawing futures
      List<Future<RoadInfo>> roadFutures = [];

      // Divide the road into segments
      for (int i = 0; i < roadGeoPoints.value.length; i++) {
        GeoPoint start = roadGeoPoints[i * (totalPoints ~/ segmentCount)];
        GeoPoint end = roadGeoPoints[(i + 1) * (totalPoints ~/ segmentCount)];

        // Color based on the segment index (for demo purposes)
        Color segmentColor = interpolateColor( i <= speeds.length ?speeds[i].speed : speeds[speeds.length - 1].speed, minSpeed, maxSpeed);

        // Draw each segment and add the future to the list
        roadFutures.add(controller.value.drawRoad(
          start,
          end,
          roadOption: RoadOption(
            roadColor: segmentColor,
            roadWidth: 15.0,
            zoomInto: false,
          ),
        ));
      }

      // Await all segment drawing futures
      await Future.wait(roadFutures);



      var roadBoundingBox = calculateBoundingBox(roadInfo.route);

      roadCustomPaint.value = CustomPaint(
        size: Size.infinite,
        painter: RoadPainter(
          geoPoints: roadInfo.route, // List of GeoPoints (lat/lng)
          mapBounds: roadBoundingBox, // Geographic bounds
        ),
      );

    } catch (e) {
      /*if (kDebugMode) {
        print('Error drawing road: $e');
      }*/
    }

    return roadGeoPoints.value;
  }

  double normalize(double value, double min, double max) {
    return (value - min) / (max - min);
  }

// interpolate color between two colors
  Color interpolateColor(double value, double min, double max) {
    // normalize the value between 0 and 1
    double normalizedValue = normalize(value, min, max);

    // colors for the gradient (blue to red)
    Color startColor = Colors.blue;
    Color endColor = Colors.red;

    // interpolate between the start and end colors
    int red = (startColor.red + (endColor.red - startColor.red) * normalizedValue).toInt();
    int green = (startColor.green + (endColor.green - startColor.green) * normalizedValue).toInt();
    int blue = (startColor.blue + (endColor.blue - startColor.blue) * normalizedValue).toInt();

    return Color.fromARGB(255, red, green, blue);
  }

  Future<void> drawRoadWithSpeed({required GeoPoint startPoint, required GeoPoint endPoint, required List<SpeedData> speedDataList,}) async {

    try {

      // Get min and max speeds for color interpolation
      double minSpeed = speedDataList.map((s) => s.speed).reduce((a, b) => a < b ? a : b);
      double maxSpeed = speedDataList.map((s) => s.speed).reduce((a, b) => a > b ? a : b);
      print('minSpeed: $minSpeed');
      print('maxSpeed: $maxSpeed');
      controller.value = MapController(
        initPosition: GeoPoint( latitude: currentPosition.value.latitude, longitude: currentPosition.value.longitude),
      );

      try {


        RoadInfo roadInfo = await controller.value.drawRoad(
          startPoint,
          endPoint,
          roadOption: const RoadOption(
            roadColor: primaryColor,
            roadWidth: 15.0,
            zoomInto: false,
          ),
        );

        roadStartPoint.value = startPoint;
        roadEndPoint.value = endPoint;
        roadGeoPoints.value = roadInfo.route;

      } catch (e) {
        if (kDebugMode) {
          print('Error drawing road: $e');
        }
      }


      // Draw roads between consecutive GeoPoints with speed-based color
      for (int i = 0; i < roadGeoPoints.length - 1; i++) {
        GeoPoint startPoint = roadGeoPoints[i];
        GeoPoint endPoint = roadGeoPoints[i + 1];

        // Get speed for the current segment (use corresponding speed data)
        double segmentSpeed = speedDataList[i].speed;
        /*print('segmentSpeed: $segmentSpeed');
        print('minSpeed: $minSpeed');*/
        // Interpolate the color based on speed
        Color segmentColor = interpolateColor(segmentSpeed, minSpeed, maxSpeed);

        // Draw the road segment with the interpolated color
        RoadInfo roadInfo = await controller.value.drawRoad(
          startPoint,
          endPoint,
          roadOption: RoadOption(
            roadColor: segmentColor,
            roadWidth: 15.0,
            zoomInto: false,
          ),
        );

      }


    } catch (e) {
      if (kDebugMode) {
        print('Error drawing road with speed data: $e');
      }
    }
  }

  //listen to user location
  void listenToLocation() {
    geo.Geolocator.getPositionStream(
      locationSettings: const geo.LocationSettings(
        accuracy: geo.LocationAccuracy.high,
        distanceFilter: 10,
      ),

    ).listen((geo.Position position) {
      currentPosition.value = position;
    });
  }

  //update user marker
  void updateUserMarker(GeoPoint newLocation) {
    if (currentMarkerPosition.value != null) {
      // Move the existing marker
      controller.value.changeLocationMarker(
        oldLocation: currentMarkerPosition.value!,
        newLocation: newLocation,
        markerIcon: const MarkerIcon(
          icon: Icon(
            Icons.location_on,
            color: primaryColor,
            size: 40,
          ),
        ),
        angle: 45,
      );
    } else {
      // If the marker doesn't exist yet, create it
      controller.value.addMarker(newLocation, markerIcon: const MarkerIcon(
        icon: Icon(
          Icons.location_on,
          color: primaryColor,
          size: 40,
        ),
      ));
    }

    // Update the current marker position
    currentMarkerPosition.value = newLocation;


    // Move the map to the new location
    controller.value.moveTo(newLocation, animate: true);
  }

  Future<void> _initializeLocation() async {
    try {

      currentPosition.value = await _getCurrentLocation();

     /* if (kDebugMode) {
        print('MAP: Current Position: $currentPosition');
      }*/
      controller.value = MapController(
        initPosition: GeoPoint( latitude: currentPosition.value.latitude, longitude: currentPosition.value.longitude),
      );
      //await drawRoadWithSpeed(startPoint: roadStartPoint.value, endPoint:  roadEndPoint.value, speedDataList: generateSpeedData(roadGeoPoints.length));
      //await drawRoad(startPoint: roadStartPoint.value, endPoint:  roadEndPoint.value);
      currentMarkerPosition.value = GeoPoint(
        latitude: currentPosition.value.latitude,
        longitude: currentPosition.value.longitude,
      );

     /* controller.value.addMarker(
          GeoPoint(
              latitude:  currentPosition.value.latitude,
              longitude:  currentPosition.value.longitude
          ),
          markerIcon: const MarkerIcon(
            icon: Icon(
              Icons.location_on,
              color: primaryColor,
              size: 40,
            ),
          )
      );*/

      currentMarkerPosition.value = GeoPoint(
        latitude: currentPosition.value.latitude,
        longitude: currentPosition.value.longitude,
      );

    } catch (e) {
      if (kDebugMode) {
        print('Error initializing location: $e');
      }
    }
  }

  Rect calculateBoundingBox(List<GeoPoint> geoPoints) {
    double minLat = geoPoints.first.latitude;
    double maxLat = geoPoints.first.latitude;
    double minLng = geoPoints.first.longitude;
    double maxLng = geoPoints.first.longitude;

    for (var point in geoPoints) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    return Rect.fromLTRB(minLng, maxLat, maxLng, minLat);
  }


/*  CustomPaint? getRoadPaint() {
    if (kDebugMode) {
      print('MAP: Getting Road Paint : ${roadGeoPoints.length}');
    }
    try {
      if (roadGeoPoints.isNotEmpty) {
        return CustomPaint(
          painter: RoadPainter(
            geoPoints: roadGeoPoints,
            roadPaint: Paint()
              ..color = primaryColor
              ..strokeWidth = 5.0
              ..style = PaintingStyle.stroke,
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting road paint: $e');
      }
      return null;
    }
    return null;
  }*/

}