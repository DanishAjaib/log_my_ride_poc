import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:log_my_ride/utils/constants.dart';
import 'package:log_my_ride/views/screens/session_summary_screen.dart';
import 'package:log_my_ride/views/widgets/road_ride_tile.dart';

import '../../controllers/user_controller.dart';
import '../../models/track.dart';
import '../../models/vehicle.dart' as AppVehicle;
import '../../utils/utils.dart';
import '../widgets/app_container.dart';
import 'current_road_ride_screen.dart';

class RoadModeScreen extends StatefulWidget {
  bool sessionStarted = true;
  AppVehicle.Vehicle? selectedVehicle;
  Track? selectedTrack;
  late Timer timer;
  int timeElapsed = 0;
  DateTime startTime = DateTime.now();

  RoadModeScreen({super.key});

  @override
  State<RoadModeScreen> createState() => _RoadModeScreenState();
}

class _RoadModeScreenState extends State<RoadModeScreen> {

  var roadRides = List.generate(5, (index) => {
    'rideName': faker.company.name(),
    'dateRecorded': DateFormat('MMM dd, yyyy').format(faker.date.dateTime(minYear: 2022, maxYear: 2022)),
    'timeTaken': faker.randomGenerator.integer(45, min: 35),
    'distanceTravelled': faker.randomGenerator.integer(45, min: 35),
  });

  @override
  Widget build(BuildContext context) {

    var selectedDateRange = null;

    var userController = Get.find<UserController>();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape:  const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        backgroundColor: primaryColor,
        onPressed: () {
          showDialog(context: context, builder: (context) {
            return AlertDialog(
              title: const Text('Select Vehicle'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: userController.vehicles.map((vehicle) => ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  title: Text(vehicle.vehicle_name),
                  onTap: () {
                    setState(() {
                      widget.selectedVehicle = vehicle;
                      widget.sessionStarted = true;
                      Navigator.pop(context);
                      Get.to(() => const CurrentRoadRideScreen());
                    });

                  },
                )).toList(),
              ),
            );
          });
        }, child: const Icon(LineIcons.play),) ,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: AppBar(
        title: const Text('Road Mode'),
        centerTitle: true,

      ),

      /* widget.selectedVehicle = vehicle;
                widget.sessionStarted = true;
                Navigator.pop(context);
                Get.to(() => const CurrentRoadRideScreen());*/
      body: Container(
        padding: const EdgeInsets.all(defaultPadding),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //start session full width elevated button
             /* ElevatedButton(
                style: ButtonStyle(
                  minimumSize: WidgetStateProperty.all(const Size(double.infinity, 100)),

                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
                ),
                onPressed: () {
                  setState(() {
                    //widget.sessionStarted = !widget.sessionStarted;
                    //show dialog to choose a vehicle
                    showDialog(context: context, builder: (context) {
                      return AlertDialog(
                        title: const Text('Select Vehicle'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: userController.vehicles.map((vehicle) => ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            title: Text(vehicle.vehicle_name),
                            onTap: () {
                              setState(() {
                                widget.selectedVehicle = vehicle;
                                widget.sessionStarted = true;
                                Navigator.pop(context);
                                Get.to(() => const CurrentRoadRideScreen());
                              });

                            },
                          )).toList(),
                        ),
                      );
                    });
                  });
                },
                child: Text('START NEW RIDE', style:GoogleFonts.orbitron(fontSize: 12, fontWeight: FontWeight.bold, color: primaryColor),),
              ),*/
              const SizedBox(height: 15,),
             Row(
               children: [
                 const Padding(padding: EdgeInsets.all(10), child: Text('Previous Rides', style: TextStyle(fontSize: subTitleSize),)),
                  const Spacer(),
                 //select date range
                  ElevatedButton(
                    onPressed: () {
                      showDateRangePicker(
                          context: context,
                          firstDate: DateTime(2022),
                          lastDate: DateTime(2023)
                      );
                    },
                    child: const Row(
                      children: [
                        Icon(LineIcons.calendarAlt, color: headingColor,),
                        SizedBox(width: 5,),
                        Text('Select Date Range', style: TextStyle(color: headingColor),),
                      ],
                    ),
                  )
               ],
             ),
              const SizedBox(height: 15,),
              ...roadRides.map(
                      (ride) => RoadRideTile(
                          rideName: ride['rideName'].toString(),
                          dateRecorded: ride['dateRecorded'].toString(),
                          timeTaken: ride['timeTaken'].toString(),
                          distanceTravelled: ride['distanceTravelled'].toString(),
                          onTap: () {
                            Get.to(() => const SessionSummaryScreen());
                          }
                      )
              ),

             /* AppContainer(
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text('Ride 1'),
                        trailing: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('17', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: primaryColor),),
                            Text('Best Time')
                          ],
                        ),
                        subtitle: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                getChipText('Date: ${DateFormat('dd/MM/2023').format(faker.date.dateTime())}', bgColor: primaryColor),
                                const SizedBox(width: 5,),
                                getChipText('Lap Time: ${ faker.randomGenerator.integer(45, min: 35)} mins', bgColor: primaryColor),

                              ],
                            )

                          ],
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        title: const Text('Ride 2'),
                        trailing: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('29', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: primaryColor),),
                            Text('Best Time')
                          ],
                        ),
                        subtitle: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                getChipText('Date: ${DateFormat('dd/MM/2023').format(faker.date.dateTime())}', bgColor: primaryColor),
                                const SizedBox(width: 5,),
                                getChipText('Lap Time: ${ faker.randomGenerator.integer(45, min: 35)} mins', bgColor: primaryColor),

                              ],
                            )

                          ],
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        title: const Text('Ride 3'),
                        trailing: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('27', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: primaryColor),),
                            Text('Best Time')
                          ],
                        ),
                        subtitle: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(LineIcons.calendar, size: 16, color: primaryColor,),
                                    const SizedBox(width: 5),
                                    Text(DateFormat('MMM dd').format(faker.date.dateTime(minYear: 2022, maxYear: 2022)), style: const TextStyle(fontSize: 12),),
                                  ],
                                ),
                                const SizedBox(width: 5,),
                                Row(
                                  children: [
                                    Icon(LineIcons.clockAlt, size: 16, color: primaryColor,),
                                    const SizedBox(width: 5),
                                    Text(faker.randomGenerator.integer(45, min: 35).toString() + ' mins', style: const TextStyle(fontSize: 12),),
                                  ],
                                ),

                              ],
                            )

                          ],
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        title: const Text('Ride 4'),
                        trailing: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('21', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: primaryColor),),
                            Text('Best Time')
                          ],
                        ),
                        subtitle: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                getChipText('Date: ${DateFormat('dd/MM/2023').format(faker.date.dateTime())}', bgColor: primaryColor),
                                const SizedBox(width: 5,),
                                getChipText('Lap Time: ${ faker.randomGenerator.integer(45, min: 35)} mins', bgColor: primaryColor),

                              ],
                            )

                          ],
                        ),
                      )
                    ],
                  )
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}

String getSessionDuration(int session_start_time, int session_end_time) {

  var duration = session_end_time - session_start_time;
  var minutes = (duration / 60).floor();
  var seconds = duration % 60;
  return '$minutes mins $seconds secs';
}


String _formatTime(int milliseconds) {
  int hours = (milliseconds / 3600000).floor();
  int minutes = ((milliseconds % 3600000) / 60000).floor();
  int seconds = ((milliseconds % 60000) / 1000).floor();
  int millis = (milliseconds % 1000).floor();

  return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${millis.toString().padLeft(3, '0')}';
}
