
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:log_my_ride/utils/constants.dart';
import 'package:log_my_ride/views/screens/main_screen.dart';
import 'package:log_my_ride/views/screens/session_summary_screen.dart';
import 'package:log_my_ride/views/screens/splash_screen.dart';
import 'package:log_my_ride/views/screens/track_ride_summary_screen.dart';
import 'package:log_my_ride/views/widgets/app_container.dart';
import 'package:log_my_ride/views/widgets/random_spline_chart.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../controllers/logging_controller.dart';

class CurrentSessionScreen extends StatefulWidget {
  const CurrentSessionScreen({super.key,});

  @override
  State<CurrentSessionScreen> createState() => _CurrentSessionScreenState();
}

class _CurrentSessionScreenState extends State<CurrentSessionScreen> {

  var loggingController = Get.put(LoggingController());
  int _countdown = 5;
  bool showReady = true;
  int timeElapsed = 0;
  Timer? _countdownTimer;

  @override
  void dispose() {
    loggingController.stopSensorStreams();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }
  @override
  void initState() {
    _startCountdownTimer();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:  !showReady ? Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.red,
            onPressed: () {
              showDialog(context: context, builder: (context) {
                return AlertDialog(
                  title: const Text('End Session'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: const Text('Yes'),
                        onTap: () {
                          loggingController.stopSensorStreams();
                          loggingController.sensorTimer?.cancel();
                          Get.offAll(() => const SplashScreen());
                          Future.delayed(Duration.zero, () {
                            // Once HomeScreen is loaded, navigate to the second screen
                            Get.to(() => const TrackRideSummaryScreen());
                          });
/*
                         Get.offAll(() => const TrackRideSummaryScreen());
*/
                        },
                      ),
                      ListTile(
                        title: const Text('No'),
                        onTap: () {
                          // loggingController.discardSession();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              });
            },
            child: const Icon(Icons.stop),
          ),
          /*const SizedBox(width: 8,),
          FloatingActionButton(
            backgroundColor: primaryColor,
            onPressed: () {
              showDialog(context: context, builder: (context) {
                return AlertDialog(
                  title: const Text('Dash Settings'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: const Text('Save'),
                        onTap: () {
                          //loggingController.saveSession();
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: const Text('Discard'),
                        onTap: () {
                          // loggingController.discardSession();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              });
            },
            child: const Icon(Icons.settings),
          ),*/
        ]
      ) : null,

      body: Stack(
        children: [
          AppContainer(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: [
                        const Text('LEAN ANGLE'),
                        Obx(() => Text('${loggingController.leanAngle.value.toStringAsFixed(1)}°', style: GoogleFonts.orbitron(fontSize: 40, fontWeight: FontWeight.bold, color: primaryColor)),),
                        const Divider(),
                        const Text('Gravity'),
                        Obx(() => Text('${loggingController.gforce.value.toStringAsFixed(1)}'
                            ''
                            '°', style: GoogleFonts.orbitron(fontSize: 40, fontWeight: FontWeight.bold, color: primaryColor)),),

                      ],
                    ),
                  ),
                  SizedBox(
                      width: 250,
                      child: Obx(() {
                        return SfRadialGauge(
                          enableLoadingAnimation: true,

                          axes: <RadialAxis>[
                            RadialAxis(
                                minimum: 0,
                                maximum: 100,
                                ranges: <GaugeRange>[
                                  GaugeRange(startValue: 0, endValue: 40, color: Colors.green),
                                  GaugeRange(startValue: 40, endValue: 70, color: Colors.yellowAccent),
                                  GaugeRange(startValue: 70, endValue: 100, color: Colors.deepOrange),
                                  GaugeRange(startValue: 100, endValue: 150, color: Colors.red)
                                ],
                                pointers: <GaugePointer>[
                                  NeedlePointer(value: loggingController.speed.value.roundToDouble())
                                ],
                                annotations: <GaugeAnnotation>[
                                  GaugeAnnotation(
                                      widget: RichText(text: TextSpan(
                                          text: '${loggingController.speed.value.roundToDouble()}',
                                          style: GoogleFonts.orbitron(fontSize: 35, fontWeight: FontWeight.bold, color: primaryColor),
                                          children: <TextSpan>[
                                            const TextSpan(text: 'km/h', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))
                                          ]
                                      )),
                                      angle: 90,
                                      positionFactor: 0.5)
                                ]
                            )
                          ],
                        );
                      })
                  ),
                  SizedBox(
                    width: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: [
                        const Text('BEST'),
                        Text('00:35', style: GoogleFonts.orbitron(fontSize: 40, fontWeight: FontWeight.bold, color: primaryColor)),
                        const Divider(),
                        const Text('LAP'),
                        Text('0', style: GoogleFonts.orbitron(fontSize: 40, fontWeight: FontWeight.bold, color: primaryColor)),

                      ],
                    ),
                  ),
                  //radial gauge

                ],
              )
          ),
         /* if(!showReady)
          Positioned(
            bottom: 10,
            right: 10,
            child: Row(
              children: [
                FloatingActionButton(
                  backgroundColor: primaryColor,
                  onPressed: () {
                    try {
                      showDialog(context: context, builder: (context) {
                        return AlertDialog(
                          title: const Text('Settings'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: const Text('Calibrate'),
                                onTap: () {
                                  //loggingController.calibrate();
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                title: const Text('Reset'),
                                onTap: () {
                                  // loggingController.reset();
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      });
                    } catch (e) {
                      print(e);
                    }

                  },
                  child: const Icon(Icons.settings),
                ),
                const SizedBox(width: 10,),
                FloatingActionButton(
                  backgroundColor: Colors.red,
                  onPressed: () {
                    showDialog(context: context, builder: (context) {
                      return AlertDialog(
                        title: const Text('End Session'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: const Text('Save'),
                              onTap: () {
                                //loggingController.saveSession();
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: const Text('Discard'),
                              onTap: () {
                                // loggingController.discardSession();
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    });
                  },
                  child: const Icon(Icons.stop),
                ),
              ],
            ),
          ),*/
          //ready text at bottom center
          if(showReady)
            Positioned(
              bottom: 10,
              left: 250,
              right: 250,
              child: Container(
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.lightGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text('READY $_countdown', style: GoogleFonts.orbitron(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ),

          if(!showReady)
            //scrolling bar chart
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Container(
                height: 100,
                child: Obx(() {
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    children: loggingController.chartData.value.map((row) {
                      return Container(
                        width: 5,
                        height: scaleHeight(row),
                        margin: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),

                      );

                    }).toList(),

                  );
                })
              ),
            ),

          if(!showReady)
            Positioned(
              top: 15,
              left: MediaQuery.of(context).size.width / 2 - 100,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Lottie.asset('assets/animations/recording.json', width: 25, height: 25),
                    const SizedBox(width: 10,),
                    Obx(() => Text(formatMillis(loggingController.timeElapsed.value), style: GoogleFonts.orbitron(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _startCountdownTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        _countdownTimer?.cancel();
        setState(() {
          showReady = false;
        });
        loggingController.startSensorStreams();
      }
    });
  }

  formatMillis(int timeElapsed) {
    int minutes = timeElapsed ~/ 60000;
    int seconds = (timeElapsed % 60000) ~/ 1000;
    int milliseconds = timeElapsed % 1000 ~/ 10;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${milliseconds.toString().padLeft(2, '0')}';

  }

  void _updateChartData() {
    final data = loggingController.dataRows.map((row) {
      return SpeedData(row['timeElapsed'], row['speed'], // or any other sensor data
      );
    }).toList();

    loggingController.chartData.value = data;
  }

  scaleHeight(dataRow) {
    var min = 1;
    var max = loggingController.dataRows.value.map((row) => row[dataRow]).reduce((value, element) => value.speed > element.speed ? value : element.speed);
    var value = dataRow.speed;
    return (value - min) / (max - min) * 100;
  }
}
