import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:log_my_ride/utils/constants.dart';
import 'package:log_my_ride/utils/line_chart_painter.dart';
import 'package:log_my_ride/views/widgets/app_container.dart';
import 'package:log_my_ride/views/widgets/dummy_map_container.dart';
import 'package:log_my_ride/views/widgets/metric_container.dart';
import 'package:log_my_ride/views/widgets/ride_tile.dart';
import 'package:log_my_ride/views/widgets/session_title.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../controllers/user_controller.dart';
import '../../models/sensor_data.dart';

class TrackMyBikeScreen extends StatefulWidget {
  const TrackMyBikeScreen({super.key});

  @override
  State<TrackMyBikeScreen> createState() => _TrackMyBikeScreenState();
}

class _TrackMyBikeScreenState extends State<TrackMyBikeScreen> with SingleTickerProviderStateMixin {
  late GoogleMapController mapController;
  Set<String> _selected = {'Track'};

  final LatLng _center = const LatLng(37.7749, -122.4194);
  final Set<Polyline> _polylines = {};
  static const Duration _ignoreDuration = Duration(milliseconds: 20);
  double metricOpacity = 0.0;
  double mapWidth = 350;

  DateTime? _userAccelerometerUpdateTime;

  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  Duration sensorInterval = SensorInterval.normalInterval;
  DateTime? _lastUpdateTime;

  var userController  = Get.find<UserController>();

  late String selectedDateRange;


  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  void initState() {
    // if (kDebugMode) print(_speedData);

    selectedDateRange = 'Select Date Range';
  /*  _streamSubscriptions.add(
      userAccelerometerEventStream(samplingPeriod: sensorInterval).listen(
            (UserAccelerometerEvent event) {
          final now = event.timestamp;
          setState(() {
            // print('User Accelerometer: $event');
            _userAccelerometerEvent = event;
            _accelerationMagnitude = _calculateMagnitude(event);
            calculateSpeed(event);
            if (_userAccelerometerUpdateTime != null) {
              final interval = now.difference(_userAccelerometerUpdateTime!);
              if (interval > _ignoreDuration) {
                _userAccelerometerLastInterval = interval.inMilliseconds;
              }
            }
          });
          _userAccelerometerUpdateTime = now;
        },
        onError: (e) {
          showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Text("Sensor Not Found"),
                  content: Text(
                      "It seems that your device doesn't support User Accelerometer Sensor"),
                );
              });
        },
        cancelOnError: true,
      ),
    );*/

    super.initState();
    _setPolylines();

  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {

    var trackRides = List.generate(5, (index) => {
      'ride_name': faker.company.name(),
      'date_recorded': DateFormat('MM/dd').format(faker.date.dateTime(minYear: 2022, maxYear: 2022)),
      'track_name': faker.company.name(),
      'best_time': faker.randomGenerator.integer(100).toString()
    });

    var roadRides = List.generate(5, (index) => {
      'ride_name': faker.company.name(),
      'date_recorded': DateFormat('MM/dd').format(faker.date.dateTime(minYear: 2022, maxYear: 2022)),
      'distance_travelled': faker.randomGenerator.integer(100).toString(),
      'recording_length': faker.randomGenerator.integer(100).toString()
    });

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          showDialog(context: context, builder: (context) {
            return AlertDialog(

              title: const Text('Select Ride Type'),
              content: SizedBox(
                height: 100,
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                        child: ElevatedButton(onPressed: () {}, child: const Text('Track'))
                    ),
                    SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(onPressed: () {}, child: const Text('Road'))
                    ),
                  ],
                ),
              ),
            );
          });

        },
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.all(10),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //map container
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SegmentedButton(
                    segments: const [
                      ButtonSegment(
                        value: 'Track',
                        label: Text('Track'),
                        icon: Icon(Icons.track_changes),
                      ),
                      ButtonSegment(
                        value: 'Road',
                        label: Text('Road'),
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
              AppContainer(
                padding: 10,
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20,),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                  style: ButtonStyle(
                                    shape: WidgetStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  onPressed: () async {
                                    final DateTimeRange? picked = await showDateRangePicker(
                                      context: context,
                                      firstDate: DateTime.now().subtract(const Duration(days: 300)),
                                      lastDate: DateTime.now().add(const Duration(days: 30)),
                                      builder: (context, child) => child!,
                                    );

                                    if (picked != null) {
                                      setState(() {
                                        selectedDateRange = '${DateFormat('MM/dd/yyyy').format(picked.start)} - ${DateFormat('MM/dd/yyyy').format(picked.end)}';
                                      });
                                    }
                                  }, label: Text(selectedDateRange), icon: const Icon(Icons.date_range)),
                            )

                          ]
                      ),

                      const SizedBox(height: 10,),
                      const TextField(
                        decoration: InputDecoration(
                          hintText: 'Track Name',
                          hintStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20,),
                      const TextField(
                        decoration: InputDecoration(
                          hintText: 'Sensor Name',
                          hintStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      )

                    ],
                  ),
                ) ,
              ),
              const SizedBox(height: 10,),
              //padded title
              Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Text('${_selected.contains('Road') ? 'Road ' : 'Track '} Rides', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),)),
              //rides
              AppContainer(
                padding: 10,
                child: Column(
                  children: _selected.contains('Track') ? trackRides.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: RideTile(
                      trackName: e['track_name']!,
                      dateRecorded: e['date_recorded']!,
                      rideName: e['ride_name']!,
                      bestTime: e['best_time']!,
                    ),
                  ),
                  ).toList() : roadRides.map((e) => RideTile(
                    rideName: e['ride_name']!,
                    dateRecorded: e['date_recorded']!,
                    recordingLength: e['distance_travelled']!,
                    distanceTravelled: e['recording_length']!,
                  )).toList(),
                ),
              ),
              //RandomLineChart(data: _speedData),
             // SessionTile(session: userController.sessions.first, onTap: () {})
            ],
          ),
        ),
      ),
    );
  }

  void _setPolylines() {
    List<LatLng> polylineCoordinates = [
      const LatLng(37.7749, -122.4194),
      const LatLng(37.7849, -122.4294),
      const LatLng(37.7949, -122.4394),
    ];

    setState(() {
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('roadTrack'),
          points: polylineCoordinates,
          color: Colors.blue,
          width: 5,
        ),
      );
    });
  }

  fetchSensorDataForSession(String session_id) async {
    var sessions = await FirebaseFirestore.instance.collection('sensor_data').where('session_id', isEqualTo: session_id).get();
    if(kDebugMode) print('fetchSensorDataForSession : ${sessions.docs.length}');
    return sessions.docs.map((e) => SensorData.fromJson(e.data())).toList();

  }

  /*double calculateSpeed(UserAccelerometerEvent event, ) {
    final now = DateTime.now();
    if (_lastUpdateTime != null) {
      final deltaTime = (now.millisecondsSinceEpoch - _lastUpdateTime!.millisecondsSinceEpoch) / 1000.0; // in seconds
      final accelerationMagnitude = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
      const double noiseThreshold = 0.1;

      if (accelerationMagnitude > noiseThreshold) {
        final speed = event.x * deltaTime + event.y * deltaTime + event.z * deltaTime; // m/s
        return speed.abs();
      } else {
        return 0.0;
      }
    } else {
      return 0.0;
    }
  }*/
}

/*double _calculateMagnitude(UserAccelerometerEvent event) {
  return sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
}*/


