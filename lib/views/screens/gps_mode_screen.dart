import 'package:faker/faker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:line_icons/line_icons.dart';
import 'package:log_my_ride/views/widgets/app_container.dart';

import '../../controllers/location_controller.dart';
import '../../controllers/logging_controller.dart';
import '../../controllers/navigation_controller.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';

class GpsModeScreen extends StatefulWidget {
  const GpsModeScreen({super.key});

  @override
  State<GpsModeScreen> createState() => _GpsModeScreenState();
}

class _GpsModeScreenState extends State<GpsModeScreen> with SingleTickerProviderStateMixin {

  var navigationController = Get.put(NavigationController());
  var locationController = Get.put(LocationController());
  var loggingController = Get.put(LoggingController());
  late AnimationController _animationController;
  var svgCode = getRandomSvgCode();
  var currentStreet = faker.address.streetName();
  BoundingBox? currentBoundingBox;
  GeoPoint? currentCenter;
  var sheetExpanded = false;
  var currentGeoFence;
  Region? currentRegion ;
  bool creatingGeofence = false;
  double geofenceRadius = 200;

  double top = 200;
  double left = 200;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    currentRegion = Region(
      center: GeoPoint(latitude:  6.5244, longitude: 3.3792), boundingBox: const BoundingBox(
      east: 3.3792, north: 6.5244, south: 6.5244, west: 3.3792
    ));

    //loggingController.startSensorTimer();
    navigationController.controller = MapController(
        initPosition: GeoPoint(latitude: 6.5244, longitude: 3.3792)
    ).obs;

    loggingController.startSensorStreams();
  }
  @override
  void dispose() {

    //loggingController.sensorTimer?.cancel();
    //loggingController.cancelSensorTimer();
    //locationController.controller.value.stopLocationUpdating();
    loggingController.stopSensorStreams();

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Obx(() {
        return Stack(
          children: [
            OSMFlutter(


              onMapMoved: (geoPoint) {
                setState(() {
                  currentBoundingBox = geoPoint.boundingBox;
                  currentCenter = geoPoint.center;
                  currentRegion = Region(center:  geoPoint.center, boundingBox: currentBoundingBox!);
                });
              },


              onGeoPointClicked: (geoPoint) {
                print('GeoPoint clicked: $geoPoint');
                navigationController.controller.value.addMarker(
                    geoPoint,
                    markerIcon: MarkerIcon(
                      iconWidget: CircleAvatar(
                        radius: 20,
                        backgroundColor: primaryColor,
                        child: SvgPicture.memory(svgCode),
                      ),
                    )
                );
              },

              onMapIsReady: (value) {
                locationController.controller.value.setZoom(zoomLevel: 15);
                locationController.controller.value.moveTo(
                    GeoPoint(
                        latitude: locationController.currentPosition.value.latitude,
                        longitude: locationController.currentPosition.value.longitude
                    ),
                    animate: true
                );
                locationController.controller.value.startLocationUpdating();
                locationController.controller.value.listenerMapSingleTapping.addListener(() {
                  //get geoPoint
                  var geoPoint = locationController.controller.value.listenerMapSingleTapping.value;
                  if(kDebugMode) print('GeoPoint tapped: $geoPoint');
                });
                //locationController.controller.value.rotateMapCamera(logginController.rotation.value);

                /*locationController.drawRoad(startPoint: GeoPoint(
                    latitude: locationController.currentPosition.value.latitude,
                    longitude: locationController.currentPosition.value.longitude), endPoint: GeoPoint(
                    latitude: locationController.currentPosition.value.latitude + 0.03,



                    longitude: locationController.currentPosition.value.longitude + 0.01
                ));
                locationController.controller.value.addMarker(
                    GeoPoint(
                        latitude:  locationController.currentPosition.value.latitude,
                        longitude:  locationController.currentPosition.value.longitude
                    ),
                    markerIcon: MarkerIcon(
                      iconWidget: CircleAvatar(
                        radius: 20,
                        backgroundColor: primaryColor,
                        child: SvgPicture.memory(svgCode),
                      ),
                    )
                );*/

              },
              controller: locationController.controller.value,
              mapIsLoading: const Center(child: CircularProgressIndicator(color: primaryColor, strokeWidth: 2,)),

              osmOption:  OSMOption(

                showDefaultInfoWindow: true,


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


                zoomOption: const ZoomOption(initZoom:  12, minZoomLevel: 2, maxZoomLevel: 19, stepZoom: 1.0),

              ),
            ),

            Positioned(
              top: 20,
              left: 20,
              child: Column(
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      locationController.controller.value.moveTo(
                          GeoPoint(
                              latitude: locationController.currentPosition.value.latitude,
                              longitude: locationController.currentPosition.value.longitude
                          ),
                          animate: true
                      );
                    },
                    backgroundColor: primaryColor,
                    child: const Icon(LineIcons.crosshairs),
                  ),
                  const SizedBox(height: 20,),

                  FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        sheetExpanded = !sheetExpanded;
                      });
                    },
                    backgroundColor: primaryColor,
                    child: const Icon(Icons.settings),
                  ),
                ],
              )
            ),
            Positioned(
              top: top,
              left: left,
              child: Draggable(
                feedback: Container(
                  width: geofenceRadius,
                  height: geofenceRadius,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                    border: Border.all(color: primaryColor, width: 2),
                  ),
                ),
                childWhenDragging: Container(), // Optionally, you can provide a different widget when dragging
                child: Container(
                  width: geofenceRadius,
                  height: geofenceRadius,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.deepOrange.withOpacity(0.3),
                    border: Border.all(color: primaryColor, width: 2),
                  ),
                ),
                onDragEnd: (details) {
                  setState(() {
                    // Update the position of the circle based on the drag details
                    // Adjust the top and left values as needed
                    top = details.offset.dy - 88;
                    left = details.offset.dx;
                  });
                },
              ),
            ),


            Positioned(
              bottom: 200,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: sheetExpanded ? 1 : 0,
                child: AppContainer(
                  height: sheetExpanded ? 200 : 0,
                  color: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //draw circle

                      if(creatingGeofence) Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FloatingActionButton(onPressed: () {
                                setState(() {
                                  creatingGeofence = false;
                                });
                              }, backgroundColor: primaryColor, child: const Icon(Icons.close),),


                              FloatingActionButton(onPressed: () {
                                setState(() {
                                  creatingGeofence = false;
                                });
                              }, backgroundColor: Colors.green, child: const Icon(Icons.check),),
                            ],
                          ),
                          SliderTheme(

                            data:  const SliderThemeData(
                              thumbColor: primaryColor,
                              activeTrackColor: primaryColor,
                              inactiveTrackColor: Colors.grey,
                              trackHeight: 5,
                              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10),
                              overlayShape: RoundSliderOverlayShape(overlayRadius: 20),
                            ),
                            child: Slider(
                            value: geofenceRadius,
                            min: 100,
                            max: 400,
                            onChanged: (value) {
                              setState(() {
                                geofenceRadius = value;
                              });

                            },
                          ),),
                        ],
                      ),
                      if(!creatingGeofence)
                        ...[
                          FloatingActionButton(onPressed: () async {
                            setState(() {
                              creatingGeofence = true;
                            });
                          }, backgroundColor: primaryColor, child: const Icon(Icons.add),),
                          const SizedBox(height: 10,),
                          const Text('Create a new Geofence', style: TextStyle(color: Colors.black, fontSize: 15),),
                        ]
                    ],
                  ),
                ),
              ),
            ),

            //botom fullwidth
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              bottom: 0,
              left: 0,
              right: 0,
              child: AppContainer(
                height: 200,
                child: Obx(() {
                  var speed = loggingController.speed.value;
                  var angle = loggingController.leanAngle.value;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              const Text('CURRENT SPEED', style: const TextStyle(color: Colors.grey, fontSize: 10),),
                              //Text(loggingController.speed.value.toString() + ' Km/h', style: const TextStyle(color: primaryColor, fontSize: 35),),
                              RichText(text: TextSpan(
                                  text: speed.toStringAsFixed(2),
                                  style: const TextStyle(color: primaryColor, fontSize: 35),
                                  children: const [
                                    TextSpan(
                                        text: ' Km/h',
                                        style: TextStyle(color: Colors.grey, fontSize: 15)
                                    )
                                  ]
                              )),
                            ],
                          ),
                          Column(
                            children: [
                              const Text('LEAN ANGLE', style: const TextStyle(color: Colors.grey, fontSize: 10),),
                              //Text(loggingController.speed.value.toString() + ' Km/h', style: const TextStyle(color: primaryColor, fontSize: 35),),
                              Text(angle.toStringAsFixed(2) + '°', style: const TextStyle(color: primaryColor, fontSize: 35),),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 10,),
                      Divider(color: Colors.grey.withOpacity(0.1), thickness: 1, ),
                      const SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(LineIcons.mapMarker, color: primaryColor,),
                          const SizedBox(width: 10,),
                          Text(currentStreet, style: const TextStyle(color: Colors.white, fontSize: 15),),
                        ],
                      )

                    ],
                  );
                }),
              ),
            )
          ],
        );
      }),
    );
  }

}
