import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:google_fonts/google_fonts.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:log_my_ride/controllers/location_controller.dart';
import 'package:log_my_ride/controllers/logging_controller.dart';
import 'package:log_my_ride/controllers/navigation_controller.dart';
import 'package:log_my_ride/controllers/replay_timer_controller.dart';
import 'package:log_my_ride/utils/constants.dart';
import 'package:log_my_ride/views/widgets/app_container.dart';
import 'package:multiavatar/multiavatar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../utils/utils.dart';
import '../widgets/app_social.dart';
import '../widgets/random_spline_chart.dart';
import '../widgets/social_stat_tile.dart';

class SessionSummaryScreen extends StatefulWidget {
  const SessionSummaryScreen({super.key});

  @override
  State<SessionSummaryScreen> createState() => _SessionSummaryScreenState();
}

class _SessionSummaryScreenState extends State<SessionSummaryScreen> with SingleTickerProviderStateMixin {

  TabController? _tabController;
  final double _mapZoom = 15.0;

  List<String> selectedMetrics = [
    'Speed',
  ];
  List<String> allMetrics = ['Speed', 'RPM', 'Lean Angle'];
  var currentSpeed = 0.0;
  var currentRPM = 0.0;
  var currentLeanAngle = 0.0;
  bool showRoadOnly = true;
  late geo.Position _currentPosition;
  Set<String> _selected = {'Seat Time'};
  bool zoomedToBoundingBox = false;
  int mapHeight = 250;

  var navigationController = Get.put(NavigationController());
  var locationController = Get.put(LocationController());
  var logginController = Get.put(LoggingController());
  var replayController = Get.put(ReplayTimerController());

  List<Color> metricColors = [Colors.green, Colors.blue, Colors.red];
  //chart data
  List<SplineSeries<SpeedData, String>> splineData = [
    SplineSeries<SpeedData, String>(
      dataSource: generateSpeedData(20),
      xValueMapper: (SpeedData sales, _) => sales.time,
      yValueMapper: (SpeedData sales, _) => sales.speed,
      name: 'Speed',
      color: Colors.green,
    ),
  ];
  bool isReplaying = false;

  @override
  void initState() {


    _tabController = TabController(length: 4, vsync: this)..addListener(() {
      if (_tabController!.index == 0) {
        setState(() {
          mapHeight = 250;
        });
      }
      if (_tabController!.index == 1) {
        setState(() {
          mapHeight = 250;
        });
      }
      if (_tabController!.index == 2) {
        setState(() {
          mapHeight = 0;
        });
      }
      if (_tabController!.index == 2) {
        setState(() {
          mapHeight = 0;
        });
      }
      if (_tabController!.index == 2) {
        setState(() {
          mapHeight = 0;
        });
      }
    });

    logginController.startSensorStreams();
    super.initState();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    replayController.pauseTimer();
    logginController.stopSensorStreams();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    var maxLeanAngleData = [
        {
          'value': 55,
        'position': 1,
        'name': getTruncatedText( faker.person.name(), 10),
        'date': DateFormat('MM/dd/yyyy').format(faker.date.dateTime(minYear: 2022, maxYear: 2022)),
       },
      {
        'value': 50,
        'position': 2,
        'name': getTruncatedText( faker.person.name(), 10),
        'date': DateFormat('MM/dd/yyyy').format(faker.date.dateTime(minYear: 2022, maxYear: 2022)),
      },
      {
        'value': 45,
        'position': 3,
        'name': getTruncatedText( faker.person.name(), 10),
        'date': DateFormat('MM/dd/yyyy').format(faker.date.dateTime(minYear: 2022, maxYear: 2022)),
      },
      {
        'value': 40,
        'position': 4,
        'name': getTruncatedText( faker.person.name(), 10),
        'date': DateFormat('MM/dd/yyyy').format(faker.date.dateTime(minYear: 2022, maxYear: 2022)),
      },
      {
        'value': 35,
        'position': 5,
        'name': getTruncatedText( faker.person.name(), 10),
        'date': DateFormat('MM/dd/yyyy').format(faker.date.dateTime(minYear: 2022, maxYear: 2022)),
      },
      {
        'value': 30,
        'position': 6,
        'name': getTruncatedText( faker.person.name(), 10),
        'date': DateFormat('MM/dd/yyyy').format(faker.date.dateTime(minYear: 2022, maxYear: 2022)),
      },
      {
        'value': 25,
        'position': 7,
        'name': getTruncatedText( faker.person.name(), 10),
        'date': DateFormat('MM/dd/yyyy').format(faker.date.dateTime(minYear: 2022, maxYear: 2022)),
      },
      {
        'value': 20,
        'position': 8,
        'name': getTruncatedText( faker.person.name(), 10),
        'date': DateFormat('MM/dd/yyyy').format(faker.date.dateTime(minYear: 2022, maxYear: 2022)),
      },
      {
        'value': 15,
        'position': 9,
        'name': getTruncatedText( faker.person.name(), 10),
        'date': DateFormat('MM/dd/yyyy').format(faker.date.dateTime(minYear: 2022, maxYear: 2022)),
      },
      {
        'value': 10,
        'position': 10,
        'name': getTruncatedText( faker.person.name(), 10),
        'date': DateFormat('MM/dd/yyyy').format(faker.date.dateTime(minYear: 2022, maxYear: 2022)),
      }
    ];

    var seatTimeData = [
      {
        'value': '01:30',
        'position': 1,
        'name': getTruncatedText( faker.person.name(), 10),
        'date': DateFormat('MM/dd/yyyy').format(faker.date.dateTime(minYear: 2022, maxYear: 2022)),
      },
      {
        'value': '01:20',
        'position': 2,
        'name': getTruncatedText( faker.person.name(), 10),
        'date': DateFormat('MM/dd/yyyy').format(faker.date.dateTime(minYear: 2022, maxYear: 2022)),
      },
      {
        'value': '01:10',
        'position': 3,
        'name': getTruncatedText( faker.person.name(), 10),
        'date': DateFormat('MM/dd/yyyy').format(faker.date.dateTime(minYear: 2022, maxYear: 2022)),
      },
      {
        'value': '01:00',
        'position': 4,
        'name': getTruncatedText( faker.person.name(), 10),
        'date': DateFormat('MM/dd/yyyy').format(faker.date.dateTime(minYear: 2022, maxYear: 2022)),
      },
      {
        'value': '00:50',
        'position': 5,
        'name': getTruncatedText( faker.person.name(), 10),
        'date': DateFormat('MM/dd/yyyy').format(faker.date.dateTime(minYear: 2022, maxYear: 2022)),
      },
      {
        'value': '00:40',
        'position': 6,
        'name': getTruncatedText( faker.person.name(), 10),
        'date': DateFormat('MM/dd/yyyy').format(faker.date.dateTime(minYear: 2022, maxYear: 2022)),
      },
      {
        'value': '00:30',
        'position': 7,
        'name': getTruncatedText( faker.person.name(), 10),
        'date': DateFormat('MM/dd/yyyy').format(faker.date.dateTime(minYear: 2022, maxYear: 2022)),
      },
      {
        'value': '00:20',
        'position': 8,
        'name': getTruncatedText( faker.person.name(), 10),
        'date': DateFormat('MM/dd/yyyy').format(faker.date.dateTime(minYear: 2022, maxYear: 2022)),
      },
      {
        'value': '00:10',
        'position': 9,
        'name': getTruncatedText( faker.person.name(), 10),
        'date': DateFormat('MM/dd/yyyy').format(faker.date.dateTime(minYear: 2022, maxYear: 2022)),
      },
      {
        'value': '00:05',
        'position': 10,
        'name': getTruncatedText( faker.person.name(), 10),
        'date': DateFormat('MM/dd/yyyy').format(faker.date.dateTime(minYear: 2022, maxYear: 2022)),
      }
      
    ];

    
    return Scaffold(
      appBar: AppBar(
          title: const Text('Ride Summary'),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  showRoadOnly = !showRoadOnly;
                });
              },
              icon: Icon(showRoadOnly ? Icons.map : Icons.map_outlined, color: primaryColor,)
          ),
        ],
      ),

      body: Column(
        children: [
          TabBar(
            isScrollable: true,
            splashBorderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            indicatorPadding: const EdgeInsets.symmetric(horizontal: -5),
            indicatorColor: primaryColor,
            labelColor: primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorSize: TabBarIndicatorSize.tab,
            controller: _tabController,
              tabs: const [
                Tab(text: 'Summary'),
                Tab(text: 'ReplayMyRide'),
                Tab(text: 'Social Stats'),
                Tab(text: 'AI Coach'),
            ]),
          Stack(
            children: [
              AppContainer(
                height: mapHeight.toDouble(),
                child: ClipRRect(
                  clipBehavior: Clip.antiAlias,
                  borderRadius: BorderRadius.circular(10),
                  child:
                  Obx(() {
                    var controller = locationController.controller.value;
                    var isPlaying = replayController.isPlaying.value;
                    return OSMFlutter(
                      onMapIsReady: (value) async {
                       /* var geoPoints = await locationController.drawRoad(startPoint: GeoPoint(
                            latitude: locationController.currentPosition.value.latitude,
                            longitude: locationController.currentPosition.value.longitude), endPoint: GeoPoint(
                            latitude: locationController.currentPosition.value.latitude + 0.03,
                            longitude: locationController.currentPosition.value.longitude + 0.01
                        ));

                        controller.addMarker(
                            GeoPoint(
                                latitude: locationController.currentPosition.value.latitude,
                                longitude: locationController.currentPosition.value.longitude),
                            markerIcon: MarkerIcon(
                              iconWidget: CircleAvatar(
                                backgroundColor: primaryColor,
                                radius: 20,
                                child: SvgPicture.memory(getRandomSvgCode()),
                              ),
                            ));

                        await addFellowRiderMarkers(geoPoints);*/
                      },
                      controller: controller,
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

                        zoomOption: ZoomOption(initZoom:  isPlaying ? 2 : _mapZoom, minZoomLevel: 2, maxZoomLevel: 19, stepZoom: 1.0),
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
                        if (locationController.roadGeoPoints.isNotEmpty) {
                          try {
                            BoundingBox bounds = await locationController.controller.value.bounds;
                            if (kDebugMode) {
                              print('Bounds: $bounds');
                            }
                            if(!zoomedToBoundingBox) {
                              await locationController.controller.value.zoomToBoundingBox(
                                  BoundingBox.fromGeoPoints(locationController.roadGeoPoints),
                                  paddinInPixel: 50
                              );

                              setState(() {
                                zoomedToBoundingBox = true;
                              });
                            } else {
                              await locationController.controller.value.setZoom(zoomLevel: 15, stepZoom: 1);
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
                            }

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
                        }
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
            Expanded(
                child: TabBarView(
                  clipBehavior: Clip.antiAlias,

                  physics: const NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    children: [
                      //summary

                     SingleChildScrollView(
                       physics: const BouncingScrollPhysics(),
                       child: Column(
                         children: [
                           const SizedBox(height: 15,),

                           Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 3),
                             child: AppContainer(
                               height: 100,
                               child: ElevatedButton(
                                   style: ButtonStyle(
                                     shape: WidgetStateProperty.all(
                                       RoundedRectangleBorder(
                                         borderRadius: BorderRadius.circular(10),
                                       ),
                                     ),
                                   ),
                                   onPressed: () {} ,
                                   child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: primaryColor,
                                        child: SvgPicture.memory(getRandomSvgCode()),
                                      ),
                                      title: Text(faker.vehicle.make()),
                                      subtitle: Row(
                                        children: [
                                          const Icon(LineIcons.calendarAlt, size: 16, color: primaryColor,),
                                          const SizedBox(width: 2),
                                          Text(DateFormat('MM/dd').format(faker.date.dateTime(minYear: 2022, maxYear: 2022)), style: const TextStyle(fontSize: 12),),
                                          const SizedBox(width: 8),
                                          const Icon(LineIcons.biking, size: 16, color: primaryColor,),
                                          const SizedBox(width: 2),
                                          Text('${faker.randomGenerator.integer(500)} Kms', style: const TextStyle(fontSize: 12),),
                                          const SizedBox(width: 8),
                                          const Icon(Icons.speed_outlined, size: 16, color: primaryColor,),
                                          const SizedBox(width: 2),
                                          Text(' ${faker.randomGenerator.integer(100)} Km/h', style: const TextStyle(fontSize: 12),),
                                        ],
                                      )
                                   )
                               ),
                             ),
                           ),

                           // places visited
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: AppContainer(
                                height: 100,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                      shape: WidgetStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      _showBottomSheet(context, 'Places Visited');
                                    } ,
                                    child: const ListTile(
                                      trailing: Icon(LineIcons.angleRight, color: primaryColor,),
                                        leading: CircleAvatar(
                                          backgroundColor: primaryColor,
                                          child: Icon(LineIcons.mapMarker, color: Colors.white,),
                                        ),
                                        title: Text('Places Visited'),
                                        subtitle: Text('2', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),),
                                    )
                                ),
                              ),
                            ),
                           // longest stop
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: AppContainer(
                                height: 100,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                      shape: WidgetStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      _showBottomSheet(context, 'Longest Stop');
                                    } ,
                                    child: ListTile(
                                      trailing: const Icon(LineIcons.angleRight, color: primaryColor,),
                                        leading: const CircleAvatar(
                                          backgroundColor: primaryColor,
                                          child: Icon(LineIcons.stopwatch, color: Colors.white,),
                                        ),
                                        title: const Text('Longest Stop'),
                                        subtitle: Text(faker.address.streetName(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),),
                                    )
                                ),
                              ),
                            ),
                           // max speed
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: AppContainer(
                                height: 100,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                      shape: WidgetStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      _showBottomSheet(context, 'Fastest Section');
                                    } ,
                                    child: ListTile(
                                        trailing: const Icon(LineIcons.angleRight, color: primaryColor,),
                                        leading: const CircleAvatar(
                                          backgroundColor: primaryColor,
                                          child: Icon(Icons.speed_outlined, color: Colors.white,),
                                        ),
                                        title: const Text('Fastest Section'),
                                        subtitle:Text(faker.address.streetName(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),),

                                    )
                                ),
                              ),
                            ),
                           // most lean angle
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: AppContainer(
                                height: 100,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                      shape: WidgetStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      _showBottomSheet(context, 'Most Lean Angle');
                                    } ,
                                    child: const ListTile(
                                        trailing: Icon(LineIcons.angleRight, color: primaryColor,),
                                        leading: CircleAvatar(
                                          backgroundColor: primaryColor,
                                          child: Icon(LineIcons.angleDoubleDown, color: Colors.white,),
                                        ),
                                        title: Text('Most Lean Angle'),
                                        subtitle: Text('55 Degrees', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),),
                                    )
                                ),
                              ),
                            ),

                         ],
                       ),
                     ),
                      //replay my ride
                      SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /* DummyMapContainer(width: double.infinity, height: 200),*/

                            /*SliderTheme(
                                  data: SliderThemeData(

                                    trackHeight: 35,
                                    thumbColor: primaryColor,
                                    activeTrackColor: primaryColor,
                                    inactiveTrackColor: Colors.grey[300],
                                  ),
                                  child: Slider(
                                      min:2,
                                      max:19,

                                      value: _mapZoom,
                                      onChanged: (value) {
                                        setState(() {
                                          _mapZoom = value;
                                          locationController.controller.value.setZoom(zoomLevel: _mapZoom);
                                          locationController.controller.value.moveTo(
                                            GeoPoint(
                                              latitude: locationController.currentPosition.value.latitude,
                                              longitude: locationController.currentPosition.value.longitude,
                                            ),
                                          );
                                        });
                                      }),
                                ),*/

                            //RoadMapWidget(width: double.infinity , height: 250, background: Colors.white, minVal: 0, maxVal: 150, length: 250, thickness: 3, trackWidget: const Icon(LineIcons.biking, size: 30, color: primaryColor,)),
                            const SizedBox(height: 10,),
                            //plot title

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 5),
                                      child: Text('Plot', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
                                  SizedBox(
                                    height: 35,
                                    child: ToggleButtons(
                                      borderRadius: BorderRadius.circular(50),
                                      selectedBorderColor: primaryColor,

                                      isSelected: [
                                        selectedMetrics.contains('Speed'),
                                        selectedMetrics.contains('RPM'),
                                        selectedMetrics.contains('Lean Angle'),

                                      ],
                                      onPressed: (value) {
                                        setState(() {
                                          if (value == 0) {
                                            if (selectedMetrics.contains('Speed')) {
                                              if(selectedMetrics.length == 1) {
                                                return;
                                              }
                                              selectedMetrics.remove('Speed');
                                              splineData.removeWhere((element) => element.name == 'Speed');

                                              if(selectedMetrics.isEmpty) {
                                                selectedMetrics.add('Speed');
                                                splineData.add(SplineSeries<SpeedData, String>(
                                                  dataSource: generateSpeedData(10),
                                                  xValueMapper: (SpeedData sales, _) => sales.time,
                                                  yValueMapper: (SpeedData sales, _) => sales.speed,
                                                  name: 'Speed',
                                                  color: Colors.green,
                                                ));
                                              }
                                            } else {
                                              selectedMetrics.add('Speed');
                                              splineData.add(SplineSeries<SpeedData, String>(
                                                dataSource: generateSpeedData(10),
                                                xValueMapper: (SpeedData sales, _) => sales.time,
                                                yValueMapper: (SpeedData sales, _) => sales.speed,
                                                name: 'Speed',
                                                color: Colors.green,
                                              ));
                                            }
                                          } else if (value == 1) {
                                            if (selectedMetrics.contains('RPM')) {
                                              selectedMetrics.remove('RPM');
                                              splineData.removeWhere((element) => element.name == 'RPM');

                                              if(selectedMetrics.isEmpty) {
                                                selectedMetrics.add('Speed');
                                                splineData.add(SplineSeries<SpeedData, String>(
                                                  dataSource: generateSpeedData(10),
                                                  xValueMapper: (SpeedData sales, _) => sales.time,
                                                  yValueMapper: (SpeedData sales, _) => sales.speed,
                                                  name: 'Speed',
                                                  color: Colors.green,
                                                ));
                                              }
                                            } else {
                                              selectedMetrics.add('RPM');
                                              splineData.add(SplineSeries<SpeedData, String>(
                                                dataSource: generateRPMData(15),
                                                xValueMapper: (SpeedData sales, _) => sales.time,
                                                yValueMapper: (SpeedData sales, _) => sales.speed,
                                                name: 'RPM',
                                                color: Colors.blue,
                                              ));
                                            }
                                          } else if (value == 2) {
                                            if (selectedMetrics.contains('Lean Angle')) {
                                              selectedMetrics.remove('Lean Angle');
                                              splineData.removeWhere((element) => element.name == 'Lean Angle');

                                              if(selectedMetrics.isEmpty) {
                                                selectedMetrics.add('Speed');
                                                splineData.add(SplineSeries<SpeedData, String>(
                                                  dataSource: generateSpeedData(10),
                                                  xValueMapper: (SpeedData sales, _) => sales.time,
                                                  yValueMapper: (SpeedData sales, _) => sales.speed,
                                                  name: 'Speed',
                                                  color: Colors.green,
                                                ));
                                              }
                                            } else {
                                              selectedMetrics.add('Lean Angle');
                                              splineData.add(SplineSeries<SpeedData, String>(
                                                dataSource: generateLeanAngleData(10),
                                                xValueMapper: (SpeedData sales, _) => sales.time,
                                                yValueMapper: (SpeedData sales, _) => sales.speed,
                                                name: 'Lean Angle',
                                                color: Colors.red,
                                              ));
                                            }
                                          }
                                        });
                                      },
                                      children: allMetrics.map((e) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 15),
                                          child: SizedBox(
                                            height: 30,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [

                                                Text(e, style: const TextStyle(fontSize: 12,),),
                                                /*
                                                Text(allMetrics.indexOf(e) == 0 ? currentSpeed.toString() : allMetrics.indexOf(e) == 1 ? currentRPM.toString() : currentLeanAngle.toString(), style: TextStyle(fontSize: 12, color: metricColors[allMetrics.indexOf(e)], fontWeight: FontWeight.bold),),
                                            */
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 10,),
                            RandomSplineChart(
                              series: splineData,
                              selectedMetrics: selectedMetrics,
                            ),
                          ],
                        ),
                      ),
                      //social stats
                      SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            const SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SegmentedButton(
                                  style: ButtonStyle(
                                    shape: WidgetStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                  ),
                                  segments: const [
                                    ButtonSegment(
                                      value: 'Seat Time',
                                      label: Text('Seat Time'),
                                      icon: Icon(Icons.event_seat),
                                    ),
                                    ButtonSegment(
                                      value: 'Avg Time',
                                      label: Text('Avg Time'),
                                      icon: Icon(Icons.timelapse_sharp),
                                    ),
                                    ButtonSegment(
                                      value: 'Lean Angle',
                                      label: Text('Lean Angle'),
                                      icon: Icon(Icons.add_road),
                                    ),
                                  ],
                                  multiSelectionEnabled: false,
                                  emptySelectionAllowed: false, selected: _selected,
                                  onSelectionChanged: (value) {
                                    setState(() {
                                      _selected = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            if(_selected.contains('Seat Time'))
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: [
                                   AppContainer(
                                     height: 190,
                                     child: Column(
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       children: [

                                         CircleAvatar(
                                           backgroundColor: primaryColor,
                                           radius: 35,
                                           child: Stack(
                                              children: [
                                                SvgPicture.memory(getRandomSvgCode()),
                                                Positioned(
                                                  right: 0,
                                                  bottom: 0,
                                                  child: CircleAvatar(
                                                    backgroundColor: Colors.deepOrange,
                                                    radius: 15,
                                                    child: RichText(text: TextSpan(
                                                      children: [
                                                        TextSpan(text: '1', style: GoogleFonts.orbitron(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold)),
                                                        TextSpan(text: 'st', style: TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.bold)),
                                                      ]
                                                    )),
                                                  ),
                                                )
                                              ],
                                           )
                                         ),
                                         const SizedBox(height: 5,),
                                         const Text('01:30', style: TextStyle(fontSize: 25),),
                                         Text(faker.person.name(), style: const TextStyle(fontSize: 16),),
                                         const SizedBox(height: 5,),
                                          const Text('AVERAGE SEAT TIME', style: TextStyle(fontSize: 10, color: primaryColor, fontWeight: FontWeight.bold),),
                                         const SizedBox(height: 5,),
                                       ],
                                     ),
                                   ),
                                    //list view
                                    Column(
                                      children: seatTimeData.map((e) {
                                        return SocialStatTile(value: e['value'].toString(), name: e['name'].toString(), position: int.parse(e['position'].toString()), date: e['date'].toString(),);
                                      }).toList(),
                                    )
                                  ],
                                ),
                              ),
                            if(_selected.contains('Avg Time'))
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: [
                                    AppContainer(
                                      height: 190,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [

                                          CircleAvatar(
                                              backgroundColor: primaryColor,
                                              radius: 35,
                                              child: Stack(
                                                children: [
                                                  SvgPicture.memory(getRandomSvgCode()),
                                                  Positioned(
                                                    right: 0,
                                                    bottom: 0,
                                                    child: CircleAvatar(
                                                      backgroundColor: Colors.deepOrange,
                                                      radius: 15,
                                                      child: RichText(text: TextSpan(
                                                          children: [
                                                            TextSpan(text: '1', style: GoogleFonts.orbitron(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold)),
                                                            TextSpan(text: 'st', style: TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.bold)),
                                                          ]
                                                      )),
                                                    ),
                                                  )
                                                ],
                                              )
                                          ),
                                          const SizedBox(height: 5,),
                                          const Text('01:30', style: TextStyle(fontSize: 25),),
                                          Text(faker.person.name(), style: const TextStyle(fontSize: 16),),
                                          const SizedBox(height: 5,),
                                          const Text('AVERAGE TIME', style: TextStyle(fontSize: 10, color: primaryColor, fontWeight: FontWeight.bold),),
                                          const SizedBox(height: 5,),
                                        ],
                                      ),
                                    ),
                                    //list view
                                    Column(
                                      children: seatTimeData.map((e) {
                                        return SocialStatTile(value: e['value'].toString(), name: e['name'].toString(), position: int.parse(e['position'].toString()), date: e['date'].toString(),);
                                      }).toList(),
                                    )
                                  ],
                                ),
                              ),
                            if(_selected.contains('Lean Angle'))
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: [
                                    AppContainer(
                                      height: 190,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [

                                          CircleAvatar(
                                              backgroundColor: primaryColor,
                                              radius: 35,
                                              child: Stack(
                                                children: [
                                                  SvgPicture.memory(getRandomSvgCode()),
                                                  Positioned(
                                                    right: 0,
                                                    bottom: 0,
                                                    child: CircleAvatar(
                                                      backgroundColor: Colors.deepOrange,
                                                      radius: 15,
                                                      child: RichText(text: TextSpan(
                                                          children: [
                                                            TextSpan(text: '1', style: GoogleFonts.orbitron(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold)),
                                                            TextSpan(text: 'st', style: TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.bold)),
                                                          ]
                                                      )),
                                                    ),
                                                  )
                                                ],
                                              )
                                          ),
                                          // degree symbol  \u00B0
                                          const SizedBox(height: 5,),
                                          const Text('27.75\u00B0', style: TextStyle(fontSize: 25),),
                                          Text(faker.person.name(), style: const TextStyle(fontSize: 16),),
                                          const SizedBox(height: 5,),
                                          const Text('MAX LEAN ANGLE', style: TextStyle(fontSize: 10, color: primaryColor, fontWeight: FontWeight.bold),),
                                          const SizedBox(height: 5,),
                                        ],
                                      ),
                                    ),
                                    //list view
                                    Column(
                                      children: maxLeanAngleData.map((e) {
                                        return SocialStatTile(
                                          value: e['value'].toString() + '°'.toString(),
                                          name: e['name'].toString(),
                                          position: int.parse(e['position'].toString()),
                                          date: e['date'].toString(),
                                        );
                                      }).toList(),
                                    )
                                  ],
                                ),
                              ),

                          ],
                        ),
                      ),
                      //AI Coach
                      SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                              const SizedBox(height: 10,),
                              Text(faker.lorem.sentences(3).join(' ')),
                              const SizedBox(height: 10,),

                              const SizedBox(height: 10,),
                              Text(faker.lorem.sentences(3).join(' ')),
                              const SizedBox(height: 20,),
                              const Divider(color: primaryColor,),
                              const SizedBox(height: 20,),

                              const Row(
                                children: [
                                  Icon(LineIcons.motorcycle, color: primaryColor, size: 30,),
                                  SizedBox(width: 10,),
                                  Text('Key improvements on Motorcycle', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                ],
                              ),
                              const SizedBox(height: 20,),
                              Text(faker.lorem.sentences(3).join(' ')),
                              const SizedBox(height: 10,),
                              const Card(
                                child: ListTile(
                                  leading: Icon(LineIcons.lightbulb, color: primaryColor,),
                                  title: Text('Suspension Tuning', style: TextStyle(fontSize: 14, color: primaryColor),),
                                  subtitle: Text(
                                    'Adjust the suspension preload and damping for smoother handling on bumpy roads. '
                                        'Softer settings increase comfort, while stiffer settings improve control during aggressive cornering.',
                                    style: TextStyle(fontSize: 12, color: Colors.white),
                                  ),
                                ),
                              ),
                              const Card(
                                child: ListTile(
                                  leading: Icon(LineIcons.lightbulb, color: primaryColor,),
                                  title: Text('Gear Ratio Tuning' , style: TextStyle(fontSize: 14, color: primaryColor),),
                                  subtitle: Text('Optimize gear ratios to match track conditions. '
                                      'Shorter gearing improves acceleration on tighter tracks, while longer gearing is ideal for high-speed sections.',
                                    style: TextStyle(fontSize: 12, color: Colors.white),
                                  ),
                                ),
                              ),
                              const Card(
                                child: ListTile(
                                  leading: Icon(LineIcons.lightbulb, color: primaryColor,),
                                  title: Text('Brake Lever Sensitivity' , style: TextStyle(fontSize: 14, color: primaryColor),),
                                  subtitle: Text('Adjust the brake lever for a shorter response time to improve braking accuracy and reduce stopping distance '
                                      'during high-speed sections.', style: TextStyle(fontSize: 12, color: Colors.white),),
                                ),
                              ),
                              const Card(
                                child: ListTile(
                                  leading: Icon(LineIcons.lightbulb, color: primaryColor,),
                                  title: Text('Tire Pressure Adjustment' , style: TextStyle(fontSize: 14, color: primaryColor),),
                                  subtitle: Text('Increase or decrease tire pressure based on the track conditions. Higher pressure improves handling on smooth tracks, '
                                      'while lower pressure offers more grip on rough surfaces.' , style: TextStyle(fontSize: 12, color: Colors.white),),
                                ),
                              ),

                              AppContainer(
                                child: Row(
                                  children: [
                                    Stack(
                                      children: [
                                        // sshow two dots with text

                                        Card(
                                          child: SvgPicture.asset('assets/images/sector_mini_map.svg', height: 200,),
                                        ),
                                        Positioned(
                                          top: 25,
                                          left: 25,
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 10,
                                                height: 10,
                                                decoration: const BoxDecoration(
                                                  color: Colors.yellowAccent,
                                                  shape: BoxShape.circle,
                                                ),

                                              ),
                                              const SizedBox(width: 10,),
                                              const Text('AI', style: TextStyle(fontSize: 12),),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          top: 40,
                                          left: 25,
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 10,
                                                height: 10,
                                                decoration: const BoxDecoration(
                                                  color: primaryColor,
                                                  shape: BoxShape.circle,
                                                ),

                                              ),
                                              const SizedBox(width: 10,),
                                              const Text('YOU', style: TextStyle(fontSize: 12),),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    //vertical divider
                                    const Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Biggest Sector Gap', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),),
                                          Divider(color: primaryColor, height: 10,),
                                          SizedBox(height: 10,),
                                          SizedBox(
                                              width: 160,
                                              child: Text('You were 2.5 seconds slower than the AI in sector 2. Focus on improving your cornering technique to close the gap.')),
                                        ]
                                    )
                                  ],
                                ),
                              ),
                              //ideal vs actual time line chart
                              const SizedBox(height: 10,),
                              const Text('Ideal vs Actual Lap Times', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                              const SizedBox(height: 10,),
                              AppContainer(
                                child: SfCartesianChart(

                                  primaryXAxis: CategoryAxis(
                                    axisLine: null,
                                    majorGridLines: const MajorGridLines(width: 0),
                                    minorGridLines: const MinorGridLines(width: 0),
                                  ),

                                  series: <ChartSeries>[
                                    SplineSeries<SpeedData, String>(
                                      dataSource: generateTrackSectorActualSpeeddata(),
                                      xValueMapper: (SpeedData sales, _) => sales.time,
                                      yValueMapper: (SpeedData sales, _) => sales.speed,
                                      name: 'Actual',
                                      color: primaryColor,
                                    ),
                                    SplineSeries<SpeedData, String>(
                                      dataSource: generateTrackSectorIdealSpeedData(),
                                      xValueMapper: (SpeedData sales, _) => sales.time,
                                      yValueMapper: (SpeedData sales, _) => sales.speed,
                                      name: 'Ideal',
                                      color: Colors.yellow,
                                    ),
                                  ],
                                ),
                              ),




                              const SizedBox(height: 10,),
                              Text(faker.lorem.sentences(3).join(' ')),
                              const SizedBox(height: 20,),
                              const Divider(color: primaryColor,),
                              const SizedBox(height: 20,),

                              const Row(
                                children: [
                                  Icon(LineIcons.stopwatch, color: primaryColor, size: 30,),
                                  SizedBox(width: 10,),
                                  Text('Key improvements on Braking', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                ],
                              ),
                              const SizedBox(height: 20,),
                              Text(faker.lorem.sentences(3).join(' ')),
                              const SizedBox(height: 10,),
                              const Card(
                                child: ListTile(
                                  leading: Icon(LineIcons.lightbulb, color: primaryColor,),
                                  title: Text('Optimal Braking Points', style: TextStyle(fontSize: 14, color: primaryColor),),
                                  subtitle: Text(
                                    'Identify and practice braking points on the track to maximize your speed through corners. '
                                        'Braking too early or too late can affect your lap times and overall control.',
                                    style: TextStyle(fontSize: 12, color: Colors.white),
                                  ),
                                ),
                              ),
                              const Card(
                                child: ListTile(
                                  leading: Icon(LineIcons.lightbulb, color: primaryColor,),
                                  title: Text('Trail Braking Technique', style: TextStyle(fontSize: 14, color: primaryColor),),
                                  subtitle: Text(
                                    'Use trail braking to maintain corner speed and balance the bike. '
                                        'Apply the brakes gradually as you enter the corner to improve grip and reduce understeer.',
                                    style: TextStyle(fontSize: 12, color: Colors.white),
                                  ),
                                ),
                              ),
                              const Card(
                                child: ListTile(
                                  leading: Icon(LineIcons.lightbulb, color: primaryColor,),
                                  title: Text('Brake Modulation', style: TextStyle(fontSize: 14, color: primaryColor),),
                                  subtitle: Text(
                                    'Learn to modulate brake pressure to avoid locking up the wheels. '
                                        'Smooth and controlled braking helps maintain traction and stability, especially in tricky conditions.',
                                    style: TextStyle(fontSize: 12, color: Colors.white),
                                  ),
                                ),
                              ),
                              const Card(
                                child: ListTile(
                                  leading: Icon(LineIcons.lightbulb, color: primaryColor,),
                                  title: Text('Brake Fade Management', style: TextStyle(fontSize: 14, color: primaryColor),),
                                  subtitle: Text(
                                    'Monitor brake performance to prevent fade during long races. '
                                        'Adjust braking strategies and cooling techniques to maintain consistent braking power.',
                                    style: TextStyle(fontSize: 12, color: Colors.white),
                                  ),
                                ),
                              ),

                              AppContainer(
                                child: Row(
                                  children: [
                                    Stack(
                                      children: [
                                        // sshow two dots with text

                                        Card(
                                          child: SvgPicture.asset('assets/images/sector_mini_map.svg', height: 200,),
                                        ),
                                        Positioned(
                                          top: 25,
                                          left: 25,
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 10,
                                                height: 10,
                                                decoration: const BoxDecoration(
                                                  color: Colors.yellowAccent,
                                                  shape: BoxShape.circle,
                                                ),

                                              ),
                                              const SizedBox(width: 10,),
                                              const Text('AI', style: TextStyle(fontSize: 12),),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          top: 40,
                                          left: 25,
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 10,
                                                height: 10,
                                                decoration: const BoxDecoration(
                                                  color: primaryColor,
                                                  shape: BoxShape.circle,
                                                ),

                                              ),
                                              const SizedBox(width: 10,),
                                              const Text('YOU', style: TextStyle(fontSize: 12),),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    //vertical divider
                                    const Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Biggest Sector Gap', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),),
                                          Divider(color: primaryColor, height: 10,),
                                          SizedBox(height: 10,),
                                          SizedBox(
                                              width: 160,
                                              child: Text('You were 2.5 seconds slower than the AI in sector 2. Focus on improving your cornering technique to close the gap.')),
                                        ]
                                    )
                                  ],
                                ),
                              ),
                              //ideal vs actual time line chart
                              const SizedBox(height: 10,),
                              const Text('Ideal vs Actual Lap Times', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                              const SizedBox(height: 10,),
                              AppContainer(
                                child: SfCartesianChart(

                                  primaryXAxis: CategoryAxis(
                                    axisLine: null,
                                    majorGridLines: const MajorGridLines(width: 0),
                                    minorGridLines: const MinorGridLines(width: 0),
                                  ),

                                  series: <ChartSeries>[
                                    SplineSeries<SpeedData, String>(
                                      dataSource: generateTrackSectorActualSpeeddata(),
                                      xValueMapper: (SpeedData sales, _) => sales.time,
                                      yValueMapper: (SpeedData sales, _) => sales.speed,
                                      name: 'Actual',
                                      color: primaryColor,
                                    ),
                                    SplineSeries<SpeedData, String>(
                                      dataSource: generateTrackSectorIdealSpeedData(),
                                      xValueMapper: (SpeedData sales, _) => sales.time,
                                      yValueMapper: (SpeedData sales, _) => sales.speed,
                                      name: 'Ideal',
                                      color: Colors.yellow,
                                    ),
                                  ],
                                ),
                              ),




                              const SizedBox(height: 10,),
                              Text(faker.lorem.sentences(3).join(' ')),
                              const SizedBox(height: 20,),
                              const Divider(color: primaryColor,),
                              const SizedBox(height: 20,),

                              const Row(
                                children: [
                                  Icon(LineIcons.lightbulbAlt, color: primaryColor, size: 30,),
                                  SizedBox(width: 10,),
                                  Text('Key improvements on Cornering', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                ],
                              ),
                              const SizedBox(height: 20,),
                              Text(faker.lorem.sentences(3).join(' ')),
                              const SizedBox(height: 10,),
                              const Card(
                                child: ListTile(
                                  leading: Icon(LineIcons.lightbulb, color: primaryColor,),
                                  title: Text('Optimal Braking Points', style: TextStyle(fontSize: 14, color: primaryColor),),
                                  subtitle: Text(
                                    'Identify and practice braking points on the track to maximize your speed through corners. '
                                        'Braking too early or too late can affect your lap times and overall control.',
                                    style: TextStyle(fontSize: 12, color: Colors.white),
                                  ),
                                ),
                              ),
                              const Card(
                                child: ListTile(
                                  leading: Icon(LineIcons.lightbulb, color: primaryColor,),
                                  title: Text('Trail Braking Technique', style: TextStyle(fontSize: 14, color: primaryColor),),
                                  subtitle: Text(
                                    'Use trail braking to maintain corner speed and balance the bike. '
                                        'Apply the brakes gradually as you enter the corner to improve grip and reduce understeer.',
                                    style: TextStyle(fontSize: 12, color: Colors.white),
                                  ),
                                ),
                              ),


                              AppContainer(
                                child: Row(
                                  children: [
                                    Stack(
                                      children: [
                                        // sshow two dots with text

                                        Card(
                                          child: SvgPicture.asset('assets/images/sector_mini_map.svg', height: 200,),
                                        ),
                                        Positioned(
                                          top: 25,
                                          left: 25,
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 10,
                                                height: 10,
                                                decoration: const BoxDecoration(
                                                  color: Colors.yellowAccent,
                                                  shape: BoxShape.circle,
                                                ),

                                              ),
                                              const SizedBox(width: 10,),
                                              const Text('AI', style: TextStyle(fontSize: 12),),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          top: 40,
                                          left: 25,
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 10,
                                                height: 10,
                                                decoration: const BoxDecoration(
                                                  color: primaryColor,
                                                  shape: BoxShape.circle,
                                                ),

                                              ),
                                              const SizedBox(width: 10,),
                                              const Text('YOU', style: TextStyle(fontSize: 12),),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    //vertical divider
                                    const Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Biggest Sector Gap', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),),
                                          Divider(color: primaryColor, height: 10,),
                                          SizedBox(height: 10,),
                                          SizedBox(
                                              width: 160,
                                              child: Text('You were 2.5 seconds slower than the AI in sector 2. Focus on improving your cornering technique to close the gap.')),
                                        ]
                                    )
                                  ],
                                ),
                              ),
                              //ideal vs actual time line chart
                              const SizedBox(height: 10,),
                              const Text('Ideal vs Actual Lap Times', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                              const SizedBox(height: 10,),
                              AppContainer(
                                child: SfCartesianChart(

                                  primaryXAxis: CategoryAxis(
                                    axisLine: null,
                                    majorGridLines: const MajorGridLines(width: 0),
                                    minorGridLines: const MinorGridLines(width: 0),
                                  ),

                                  series: <ChartSeries>[
                                    SplineSeries<SpeedData, String>(
                                      dataSource: generateTrackSectorActualSpeeddata(),
                                      xValueMapper: (SpeedData sales, _) => sales.time,
                                      yValueMapper: (SpeedData sales, _) => sales.speed,
                                      name: 'Actual',
                                      color: primaryColor,
                                    ),
                                    SplineSeries<SpeedData, String>(
                                      dataSource: generateTrackSectorIdealSpeedData(),
                                      xValueMapper: (SpeedData sales, _) => sales.time,
                                      yValueMapper: (SpeedData sales, _) => sales.speed,
                                      name: 'Ideal',
                                      color: Colors.yellow,
                                    ),
                                  ],
                                ),
                              ),




                              const SizedBox(height: 10,),
                              Text(faker.lorem.sentences(3).join(' ')),
                              const SizedBox(height: 20,),
                              const Divider(color: primaryColor,),
                              const SizedBox(height: 20,),

                              const Row(
                                children: [
                                  Icon(LineIcons.lightbulbAlt, color: primaryColor, size: 30,),
                                  SizedBox(width: 10,),
                                  Text('Key improvements to reduce Time', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                ],
                              ),

                              const SizedBox(height: 20,),
                              const SizedBox(height: 20,),
                              Text(faker.lorem.sentences(3).join(' ')),
                              const SizedBox(height: 10,),
                              const Card(
                                child: ListTile(
                                  leading: Icon(LineIcons.lightbulb, color: primaryColor,),
                                  title: Text('Optimal Braking Points', style: TextStyle(fontSize: 14, color: primaryColor),),
                                  subtitle: Text(
                                    'Identify and practice braking points on the track to maximize your speed through corners. '
                                        'Braking too early or too late can affect your lap times and overall control.',
                                    style: TextStyle(fontSize: 12, color: Colors.white),
                                  ),
                                ),
                              ),
                              const Card(
                                child: ListTile(
                                  leading: Icon(LineIcons.lightbulb, color: primaryColor,),
                                  title: Text('Trail Braking Technique', style: TextStyle(fontSize: 14, color: primaryColor),),
                                  subtitle: Text(
                                    'Use trail braking to maintain corner speed and balance the bike. '
                                        'Apply the brakes gradually as you enter the corner to improve grip and reduce understeer.',
                                    style: TextStyle(fontSize: 12, color: Colors.white),
                                  ),
                                ),
                              ),


                              AppContainer(
                                child: Row(
                                  children: [
                                    Stack(
                                      children: [
                                        // sshow two dots with text

                                        Card(
                                          child: SvgPicture.asset('assets/images/sector_mini_map.svg', height: 200,),
                                        ),
                                        Positioned(
                                          top: 25,
                                          left: 25,
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 10,
                                                height: 10,
                                                decoration: const BoxDecoration(
                                                  color: Colors.yellowAccent,
                                                  shape: BoxShape.circle,
                                                ),

                                              ),
                                              const SizedBox(width: 10,),
                                              const Text('AI', style: TextStyle(fontSize: 12),),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          top: 40,
                                          left: 25,
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 10,
                                                height: 10,
                                                decoration: const BoxDecoration(
                                                  color: primaryColor,
                                                  shape: BoxShape.circle,
                                                ),

                                              ),
                                              const SizedBox(width: 10,),
                                              const Text('YOU', style: TextStyle(fontSize: 12),),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    //vertical divider
                                    const Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Biggest Sector Gap', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),),
                                          Divider(color: primaryColor, height: 10,),
                                          SizedBox(height: 10,),
                                          SizedBox(
                                              width: 160,
                                              child: Text('You were 2.5 seconds slower than the AI in sector 2. Focus on improving your cornering technique to close the gap.')),
                                        ]
                                    )
                                  ],
                                ),
                              ),
                              //ideal vs actual time line chart
                              const SizedBox(height: 10,),
                              const Text('Ideal vs Actual Lap Times', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                              const SizedBox(height: 10,),
                              AppContainer(
                                child: SfCartesianChart(

                                  primaryXAxis: CategoryAxis(
                                    axisLine: null,
                                    majorGridLines: const MajorGridLines(width: 0),
                                    minorGridLines: const MinorGridLines(width: 0),
                                  ),

                                  series: <ChartSeries>[
                                    SplineSeries<SpeedData, String>(
                                      dataSource: generateTrackSectorActualSpeeddata(),
                                      xValueMapper: (SpeedData sales, _) => sales.time,
                                      yValueMapper: (SpeedData sales, _) => sales.speed,
                                      name: 'Actual',
                                      color: primaryColor,
                                    ),
                                    SplineSeries<SpeedData, String>(
                                      dataSource: generateTrackSectorIdealSpeedData(),
                                      xValueMapper: (SpeedData sales, _) => sales.time,
                                      yValueMapper: (SpeedData sales, _) => sales.speed,
                                      name: 'Ideal',
                                      color: Colors.yellow,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10,),
                              Text(faker.lorem.sentences(3).join(' ')),
                              const SizedBox(height:50),
                              AppSocial(),
                              const SizedBox(height:50) ,
                            ],
                          ),
                        ),
                      ),
                      /*//data
                      SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: Scrollable(
                          axisDirection: AxisDirection.down,
                          physics: const BouncingScrollPhysics(),
                          viewportBuilder: (context, viewportOffset) {
                            return SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: DataTable(
                                columns:  const [
                                  DataColumn(label: Text('timeElapsed', style: TextStyle(color: primaryColor),)),
                                  DataColumn(label: Text('latitude' , style: TextStyle(color: primaryColor),)),
                                  DataColumn(label: Text('longitude' , style: TextStyle(color: primaryColor),)),
                                  DataColumn(label: Text('speed' , style: TextStyle(color: primaryColor),)),
                                  DataColumn(label: Text('leanAngle' , style: TextStyle(color: primaryColor),)),
                                  DataColumn(label: Text('rotation' , style: TextStyle(color: primaryColor),)),
                                  DataColumn(label: Text('x' , style: TextStyle(color: primaryColor),)),
                                  DataColumn(label: Text('y' , style: TextStyle(color: primaryColor),)),
                                  DataColumn(label: Text('z' , style: TextStyle(color: primaryColor),)),
                                  DataColumn(label: Text('gyro_x' , style: TextStyle(color: primaryColor),)),
                                  DataColumn(label: Text('gyro_y' , style: TextStyle(color: primaryColor),)),
                                  DataColumn(label: Text('gyro_z' , style: TextStyle(color: primaryColor),)),
                                ],
                                rows:
                                logginController.dataRows.take(50).map((e) {
                                  return DataRow(
                                      cells: [
                                        DataCell(Text(e['timeElapsed'].toString())),
                                        DataCell(Text(e['latitude'].toString())),
                                        DataCell(Text(e['longitude'].toString())),
                                        DataCell(Text(e['speed'].toString())),
                                        DataCell(Text(e['leanAngle'].toString())),
                                        DataCell(Text(e['rotation'].toString())),
                                        DataCell(Text(e['x'].toString())),
                                        DataCell(Text(e['y'].toString())),
                                        DataCell(Text(e['z'].toString())),
                                        DataCell(Text(e['gyro_x'].toString())),
                                        DataCell(Text(e['gyro_y'].toString())),
                                        DataCell(Text(e['gyro_z'].toString())),
                                      ]
                                  );
                                }).toList(),
                              ),
                            );
                          }
                        ),
                      )*/
                    ]
                )
            )
        ],

      ),
    );
  }

  Future addFellowRiderMarkers(List<GeoPoint> geoPoints) async {

    if (kDebugMode) {
      print('Adding fellow riders ${geoPoints.length}');
    }
    if (geoPoints.length > 100) {
      for (var i = 0; i < 1; i++) {
        await locationController.controller.value.addMarker(
          geoPoints[Random().nextInt(geoPoints.length)],
          markerIcon: MarkerIcon(
            iconWidget: Column(
              children: [
                CircleAvatar(
                  backgroundColor: primaryColor,
                  radius: 20,
                  child: SvgPicture.memory(getRandomSvgCode()),
                ),
                SizedBox(
                  width: 100,
                  child: getChipText('Crash Detected!!'),
                )
              ],
            ),
          ),
        );
      }
    } else {
      if (kDebugMode) {
        print('Not enough roadGeoPoints to add markers. : ${locationController.roadGeoPoints.length}');
      }
    }
  }
}


Uint8List getRandomSvgCode() {
  String randomString = _generateRandomString(8); // Generate a random string of length 8
  return Uint8List.fromList(multiavatar(randomString).codeUnits);
}
String _generateRandomString(int length) {
  const characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final random = Random();
  return String.fromCharCodes(Iterable.generate(
    length,
        (_) => characters.codeUnitAt(random.nextInt(characters.length)),
  ));
}

void _showBottomSheet(BuildContext context, String title) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              const Divider(color: primaryColor,),
              const SizedBox(height: 15,),
              Text(faker.lorem.sentences(3).join(' ')),
              const SizedBox(height: 5,),
              Text(faker.lorem.sentences(3).join(' '))
            ],
          ),
        );
      }
  );
}