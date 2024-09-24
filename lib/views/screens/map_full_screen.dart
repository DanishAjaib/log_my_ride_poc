import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:log_my_ride/controllers/location_controller.dart';

import '../../utils/constants.dart';

class MapFullScreen extends StatefulWidget {
  const MapFullScreen({super.key});

  @override
  State<MapFullScreen> createState() => _MapFullScreenState();
}

class _MapFullScreenState extends State<MapFullScreen> {

  var locationController = Get.find<LocationController>();
  @override
  Widget build(BuildContext context) {

    locationController.drawRoad(startPoint: GeoPoint(
        latitude: locationController.currentPosition.value.latitude,
        longitude: locationController.currentPosition.value.longitude),
        endPoint: GeoPoint(
            latitude: locationController.currentPosition.value.latitude + 0.03,
            longitude: locationController.currentPosition.value.longitude + 0.01
        )
    );
    return OSMFlutter(


      onMapIsReady: (value) {
        locationController.controller.value.addMarker(GeoPoint(latitude:  locationController.currentPosition.value.latitude, longitude: locationController.currentPosition.value.longitude), markerIcon: const MarkerIcon(
          icon: Icon(
            Icons.location_on,
            color: primaryColor,
            size: 40,
          ),
        ));

      },

      controller: locationController.controller.value,
      mapIsLoading: const Center(child: CircularProgressIndicator(color: primaryColor, strokeWidth: 2,)),
      osmOption:  OSMOption(


        enableRotationByGesture: true,
        showZoomController: true,
        userLocationMarker: UserLocationMaker(
          personMarker: const MarkerIcon(
            icon: Icon(
                LineIcons.biking,
                color: primaryColor, size: 30
            ),
          ),
          directionArrowMarker: const MarkerIcon(
            icon: Icon(
                LineIcons.arrowCircleUp,
                color: primaryColor, size: 30
            ),
          ),
        ),

        roadConfiguration: RoadOption(roadColor: Colors.grey[800]!, roadWidth: 5),
        zoomOption: ZoomOption(initZoom: 15,minZoomLevel: 2, maxZoomLevel: 19, stepZoom: 1.0),

      ),
    );
  }
}
