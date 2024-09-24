import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:log_my_ride/controllers/navigation_controller.dart';
import 'package:log_my_ride/utils/utils.dart';
import 'package:log_my_ride/views/screens/session_summary_screen.dart';
import 'package:log_my_ride/views/widgets/dummy_map_container.dart';
import 'package:log_my_ride/views/widgets/metric_container.dart';
import 'package:log_my_ride/views/widgets/notification_tile.dart';
import 'package:multiavatar/multiavatar.dart';
import '../../controllers/location_controller.dart';
import '../../controllers/logging_controller.dart';
import '../../utils/constants.dart';
import 'package:audioplayers/audioplayers.dart';

import '../widgets/app_container.dart';

class CurrentRoadRideScreen extends StatefulWidget {

  const CurrentRoadRideScreen({super.key});

  @override
  State<CurrentRoadRideScreen> createState() => _CurrentRoadRideScreenState();
}

class _CurrentRoadRideScreenState extends State<CurrentRoadRideScreen> {

  var svgCode = Uint8List.fromList(multiavatar('X-SLAYER').codeUnits);
  Timer? _timer;
  Timer? _rideTimer;
  int _countdown = 5;
  bool showReady = true;
  int timeElapsed = 0;
  bool showDash = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  var logginController = Get.find<LoggingController>();


  var notifications = [

  ];

  bool zoomedToBoundingBox = false;

  @override
  void initState() {

    //show select address dialog
    _showSelectAddressDialog();





    super.initState();
  }

  void _initializeNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _scheduleNotifications() {

    List<Map<String, dynamic>> notificationData = [
      {
        'title': 'A rider just passed you',
        'message': 'A rider just passed you at 30 km/h',
        'type': NotificationType.riderPassed,
      },
      {
        'title': 'Crash detected',
        'message': 'A crash was detected near you',
        'type': NotificationType.crashDetected,
      },
      {
        'title': 'Event near you',
        'message': 'An event 45 kms away from you is starting in 1 hour',
        'type': NotificationType.eventNearby,
      },
      {
        'title': 'Crash detected',
        'message': 'A crash was detected near you',
        'type': NotificationType.crashDetected,
      },
    ];

    for (int i = 0; i < notificationData.length; i++) {
      Timer(Duration(seconds: (i + 5) * 5), () {
        setState(() {
          notifications.insert(0, notificationData[i]);
          _showNotification(notificationData[i]['title'], notificationData[i]['message']);

        });
      });
    }


  }
  Future<void> _showNotification(String title, String message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, title, message, platformChannelSpecifics, payload: 'item x');
  }

  void _playNotificationSound() async {
    await _audioPlayer.play(AssetSource('sounds/notification.wav'));
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          color: Colors.black54,
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  const Padding(padding: EdgeInsets.all(10), child: Text('Ride Notifications', style: TextStyle(fontSize: subTitleSize, fontWeight: FontWeight.bold),)),
                  const Spacer(),
                  IconButton(onPressed: () {
                    Navigator.pop(context);
                  }, icon: const Icon(LineIcons.times, color: primaryColor, size: 30,),),
                ],
              ),
              notifications.isEmpty ? const Center(child: CircularProgressIndicator(),) : Column(
                children: [
                  for (var notification in notifications) NotificationTile(
                      title: notification['title'],
                      message: notification['message'],
                      type: notification['type'],
                      onTap: (){

                      }
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          showReady = false;
          _startRideTimer();
          _timer?.cancel();
        }
      });
    });


  }

  void _startRideTimer() {
    _rideTimer = Timer.periodic(const Duration(milliseconds: 1), (timer) {
      setState(() {
        timeElapsed++;
      });
    });

    logginController.startSensorStreams();
  }
  @override
  void dispose() {
    _timer?.cancel();
    _rideTimer?.cancel();
    //logginController.sensorTimer?.cancel();
    //logginController.cancelSensorTimer();
    logginController.stopSensorStreams();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var locationController = Get.put(NavigationController());

    return Scaffold(

      appBar: AppBar(

        actions: [

          const SizedBox(width: 80,),

          TextButton.icon(
            onPressed: () {
              showDialog(context: context, builder: (context) {
                return AlertDialog(
                  title: const Text('End Ride'),
                  content: const Text('Are you sure you want to end the ride?'),
                  actions: [
                    TextButton(onPressed: () {
                      Navigator.pop(context);
                    }, child: const Text('No')),
                    TextButton(onPressed: () {
                      _rideTimer?.cancel();
                      Navigator.pop(context);
                      Get.to(() => const SessionSummaryScreen());

                    }, child: const Text('Yes')),
                  ],
                );
              });

            },
              icon: const Icon(Icons.stop_circle_outlined, color: Colors.red,),
              label: getChipText(getFormattedRideTime(timeElapsed), bgColor: Colors.red, textSize: 15),
          ),
        ],
      ),
      body: showDash ? Container() : SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            //DummyMapContainer(width: double.infinity, height: 350),
            Stack(
              children: [
                AppContainer(
                  height: 250,
                  child: ClipRRect(
                    clipBehavior: Clip.antiAlias,
                    borderRadius: BorderRadius.circular(10),
                    child:
                    Obx(() {
                      /*var isPlaying = replayController.isPlaying.value;*/

                      return OSMFlutter(



                        onMapIsReady: (value) {
                          locationController.controller.value.setZoom(zoomLevel: 15);
                          locationController.controller.value.moveTo(
                              GeoPoint(
                                  latitude: locationController.currentPosition.value.latitude,
                                  longitude: locationController.currentPosition.value.longitude
                              ),
                              animate: true
                          );
/*
                          locationController.controller.value.rotateMapCamera(logginController.rotation.value);
*/
                          locationController.drawRoad(startPoint: GeoPoint(
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
                          );



                          /*controller.addMarker(
                              GeoPoint(
                                  latitude: locationController.currentPosition.value.latitude,
                                  longitude: locationController.currentPosition.value.longitude),
                              markerIcon: const MarkerIcon(
                                icon: Icon(
                                  Icons.arrow_circle_up_sharp,
                                  color: Colors.black,
                                  size: 40,
                                ),
                              ));*/
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


                          zoomOption: const ZoomOption(initZoom:  12, minZoomLevel: 2, maxZoomLevel: 19, stepZoom: 1.0),

                        ),
                      );
                    }),
                  ),),

                //maximize map button
                Positioned(
                  right: 10,
                  top: 10,
                  child: SizedBox(
                    width: 70,
                    height: 30,
                    child: ElevatedButton(
                        onPressed: () async {
                          if (kDebugMode) {
                            print('Maximizing map');
                          }
                          var currentZoom = await locationController.controller.value.getZoom();
                          if(currentZoom < 15) {
                            await locationController.controller.value.setZoom(zoomLevel: currentZoom + 1, stepZoom: 1);
                            currentZoom = await locationController.controller.value.getZoom();
                          } else {
                            await locationController.controller.value.setZoom(zoomLevel: currentZoom - 1, stepZoom: 1);
                            currentZoom = await locationController.controller.value.getZoom();
                          }

                          await locationController.controller.value.moveTo(
                              GeoPoint(
                                  latitude: locationController.currentPosition.value.latitude,
                                  longitude: locationController.currentPosition.value.longitude
                              ),
                              animate: true
                          );
                          /*if (locationController.roadGeoPoints.isNotEmpty) {
                            try {
                              BoundingBox bounds = await locationController.controller.value.bounds;
                              if (kDebugMode) {
                                print('Bounds: $bounds');
                              }
                              await locationController.controller.value.setZoom(zoomLevel: 12, stepZoom: 1);
                              locationController.controller.value.moveTo(
                                  GeoPoint(
                                      latitude: locationController.currentPosition.value.latitude,
                                      longitude: locationController.currentPosition.value.longitude
                                  ),
                                  animate: true
                              );
                              *//*if(!zoomedToBoundingBox) {
                                await locationController.controller.value.zoomToBoundingBox(
                                    BoundingBox.fromGeoPoints(locationController.roadGeoPoints),
                                    paddinInPixel: 50
                                );

                                setState(() {
                                  zoomedToBoundingBox = true;
                                });
                              } else {
                                await locationController.controller.value.setZoom(zoomLevel: 10, stepZoom: 1);
                                locationController.controller.value.moveTo(
                                    GeoPoint(
                                        latitude: locationController.currentPosition.value.latitude,
                                        longitude: locationController.currentPosition.value.longitude
                                    ),
                                    animate: true
                                );
                                setState(() {
                                  zoomedToBoundingBox = false;
                                });
                              }*//*

                              if (kDebugMode) {
                                print('Zoomed to bounding box');
                              }
                            } catch (e) {
                              if (kDebugMode) {
                                print('Error zooming to bounding box: $e');
                              }
                            }
                          } else {
                            if (kDebugMode) {
                              print('No road points');
                            }
                          }*/
                        },
                        style: ButtonStyle(
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                        child: Icon( zoomedToBoundingBox ?  LineIcons.alternateCompressArrows:LineIcons.alternateExpandArrows, color: Colors.white,)
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            _countdown == 0 ?
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Obx(() {

                var speed = logginController.speed.value;
                var leanAngle = logginController.leanAngle.value;
                var rotation = logginController.rotation.value;

                return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MetricContainer(value: '${speed.toStringAsFixed(2)} Km/h', icon: Icons.speed, label: 'Speed',),
                  MetricContainer(value: '${leanAngle.toStringAsFixed(2)}°', icon: Icons.text_rotation_angleup, label: 'Lean Angle',),
                  MetricContainer(value: '54th', icon: Icons.leaderboard, label: 'Ride Rank', ),
                ],
                );
              }),
            ) : Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 120,
              child: ElevatedButton(

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {},
                child: Text('READY $_countdown', style: GoogleFonts.orbitron(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),),
            ),

            const SizedBox(height: 10),
            Row(
              children: [
                const Padding(padding: EdgeInsets.all(10), child: Text('Ride Activity', style: TextStyle(fontSize: subTitleSize, fontWeight: FontWeight.bold),)),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {
                    _showBottomSheet(context);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: primaryColor,
                  ),
                  label: const Text('View All',),
                  icon: const Icon(LineIcons.alternateListAlt, color: Colors.white,),),
                const SizedBox(width: 8,)
              ],
            ),
            const SizedBox(height: 10),
            if (notifications.isEmpty) const Center(child: Text('No Notifications'),) else Column(
              children: [
                for (var notification in notifications.getRange(notifications.length - (notifications.length >= 2 ? 2: 1), notifications.length)) NotificationTile(
                    title: notification['title'],
                    message: notification['message'],
                    type: notification['type'],
                    onTap: (){

                    }
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }


  String getFormattedRideTime(int timeElapsedInMillis) {

    int seconds = (timeElapsedInMillis / 1000).floor();
    int minutes = (seconds / 60).floor();
    int hours = (minutes / 60).floor();
    int milliseconds = timeElapsedInMillis % 1000;
    seconds = seconds % 60;

    minutes = minutes % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}:${milliseconds.toString().padLeft(3, '0')}';
  }

  void _showSelectAddressDialog() {

    //on post frame callback
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      showDialog(context: context, builder: (context) {
        return AlertDialog(
          title: const Text('Select Address'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Select the address where you want to start the ride'),
              const SizedBox(height: 10),
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Enter Address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(onPressed: () {
                Navigator.pop(context);
                _initializeNotifications();
                _scheduleNotifications();
                _startCountdown();
              }, child: const Text('Start Ride')),
            ],
          ),
        );
      });
    });

  }
}


