import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:log_my_ride/models/track.dart';
import 'package:log_my_ride/utils/constants.dart';
import 'package:log_my_ride/utils/utils.dart';
import 'package:log_my_ride/views/screens/current_session_screen.dart';
import 'package:log_my_ride/views/screens/my_sessions_screen.dart';
import 'package:log_my_ride/views/widgets/app_container.dart';
import 'package:log_my_ride/views/widgets/app_social.dart';
import 'package:log_my_ride/views/widgets/chart_tile.dart';
import 'package:log_my_ride/views/widgets/random_spline_chart.dart';
import 'package:log_my_ride/views/widgets/start_session_dialog.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../controllers/user_controller.dart';
import '../widgets/dummy_map_container.dart';
import '../widgets/session_title.dart';

class TrackModeScreen extends StatefulWidget {
  bool sessionStarted = false;
  Vehicle? selectedVehicle;
  Track? selectedTrack;
  late Timer timer;
  int timeElapsed = 0;
  DateTime startTime = DateTime.now();
  TrackModeScreen({super.key});

  @override
  State<TrackModeScreen> createState() => _TrackModeScreenState();
}

class _TrackModeScreenState extends State<TrackModeScreen> {
  var userController = Get.find<UserController>();

  @override
  void dispose() {
    super.dispose();
  }
  @override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    String selectedDateRange = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

             /* Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Start a new Session'),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      print('NewSession: ${userController.currentUser.first.uid}');
                      showDialog(context: context, builder: (context) => StartSessionDialog(
                        onSessionStart: (vehicle, track) {
                          Get.to(() => CurrentSessionScreen(
                            vehicle: vehicle,
                            track: track,
                            user:userController.currentUser.first.uid!,
                            onSessionCreated: () {
                              Get.back();
                            },
                          )
                          );
                        },
                      ));
                    },
                    child: const Text('Start'),
                  ),
                ],
              ),*/
             /* const Divider(),
              const SizedBox(height: 10),
              const Text('Most Recent Session'),
              const SizedBox(height: 10),
              SessionTile(session: userController.sessions.first, onTap: () {}),
              const SizedBox(height: 20),
              const Text('Previous Rides'),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),*/
              const Padding(padding: EdgeInsets.all(10), child: Text('Previous Rides', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
              //Date Range filter
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    DropdownButtonFormField(
                      items: userController.tracks.map((track) => DropdownMenuItem(value: track, child: Text(track.track_name))).toList(),
                      decoration: InputDecoration(
                        labelText: 'Select a Track',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),

                      ),
                      onChanged: (value) {
                        setState(() {
                          widget.selectedTrack = value as Track;
                        });
                      },
                    ),
                    //date range filter
                    const SizedBox(height: 10),
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
                          onPressed: () {
                            showDateRangePicker(
                                context: context,
                                firstDate:  DateTime.now().subtract(const Duration(days: 300)),
                                lastDate: DateTime.now().add(const Duration(days: 30)),
                                builder: (context, child) => child!,
                            );
                      }, label: Text(selectedDateRange), icon: const Icon(Icons.date_range)),
                    )

                  ]
                ),
              ),
              AppContainer(
                  child: Column(
                    children: [
                      ListTile(
                      title: const Text('Session 1'),
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
                        title: const Text('Session 2'),
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
                        title: const Text('Session 3'),
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
                      title: const Text('Session 4'),
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
              ),
              const Divider(),
              const Padding(padding: EdgeInsets.all(10), child: Text('Live Session', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
              AppContainer(
                height: !widget.sessionStarted ? 100 : 430,
                child: !widget.sessionStarted ? Center(
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showDialog(context: context, builder: (context) => StartSessionDialog(
                            onSessionStart: (vehicle, track) {
                              setState(() {
                                widget.sessionStarted = true;
                                Get.to(() => CurrentSessionScreen());

                              });
                            },
                          ));

                          //widget.sessionStarted = !widget.sessionStarted;
                        });
                  }, child: const Text('Start Session')),
                ) : SingleChildScrollView(
                  child: Column(
                    children: [
                      //GPS Speed
                      const ListTile(
                        title: Text('GPS Speed'),
                        trailing: Text('0 km/h', style: TextStyle(color: primaryColor, fontSize: 20),),
                      ),
                      const Divider(),
                      // Lean Angle
                      const ListTile(
                        title: Text('Lean Angle'),
                        trailing: Text('0 deg', style: TextStyle(color: primaryColor, fontSize: 20),),
                      ),
                      const Divider(),
                      // Lean Angle
                      ListTile(
                        title: const Text('Lap Time'),
                        trailing: Text(_formatTime(widget.timeElapsed), style: const TextStyle(color: primaryColor, fontSize: 20),),
                      ),
                      const Divider(),
                      //predicted Best Time
                      const ListTile(
                        title: Text('Predicted Best Time'),
                        trailing: Text('0:00', style: TextStyle(color: primaryColor, fontSize: 20),),
                      ),
                      const Divider(),
                      //predicted Best Time
                      ListTile(
                        title: const Text('End Session'),
                        trailing: Icon(LineIcons.stopCircleAlt, color: Colors.red,),
                        onTap: () {
                          setState(() {
                            widget.timer.cancel();
                            widget.sessionStarted = false;
                            widget.timeElapsed = 0;
                            widget.selectedTrack = null;
                            widget.selectedVehicle = null;
                          });
                        },
                      ),
                      const Divider(),
                      //predicted Best Time
                      ListTile(
                        title: const Text('Launch Dash'),
                        trailing: Icon(Icons.fullscreen, color: Colors.lightGreenAccent,),
                        onTap: () {
                          setState(() {
                            widget.timer.cancel();
                            widget.sessionStarted = false;
                            widget.timeElapsed = 0;
                            widget.selectedTrack = null;
                            widget.selectedVehicle = null;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text('Analyze a Ride', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text('Please select a session to analyze')),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                    children: [
                      DropdownButtonFormField(
                        items: userController.sessions.map((session) => DropdownMenuItem(value: session, child: Text(session.session_type ?? ''))).toList(),
                        decoration: InputDecoration(
                          labelText: 'Select a Session',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            widget.selectedTrack = value as Track;
                          });
                        },
                      ),
                    ]
                ),
              ),
              //select a metric
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                    children: [
                      DropdownButtonFormField(
                        items: const [
                          DropdownMenuItem(value: Text('Speed'), child: Text('Speed')),
                          DropdownMenuItem(value: Text('Lean Angle'), child: Text('Lean Angle')),
                          DropdownMenuItem(value: Text('Lap Time'), child: Text('Lap Time')),
                        ],
                        decoration: InputDecoration(
                          labelText: 'Select a Metric',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            //widget.selectedTrack = value;
                          });
                        },
                      ),
                    ]
                ),
              ),
              DummyMapContainer(width:double.infinity, height:200),
              RandomSplineChart(),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 20),
              const AppSocial(),

              /*Obx( () {
                if (userController.sessions.isEmpty) {
                  return const Center(child: Text('No sessions recorded yet'));
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: userController.sessions.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        height: 100,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          onPressed: () {},
                          child: ListTile(
                            title: Text(userController.sessions[index].session_type.toString()),
                            subtitle: Text(
                                getSessionDuration(
                                    userController.sessions[index].session_start_time,
                                    userController.sessions[index].session_end_time
                                )
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios_outlined),
                          ),
                        ),
                      );
                    },
                  ),
                );
              })*/
            ],
          ),
        ),
      )
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