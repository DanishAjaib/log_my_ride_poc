import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:log_my_ride/models/track.dart';
import 'package:log_my_ride/utils/constants.dart';
import 'package:log_my_ride/utils/utils.dart';
import 'package:log_my_ride/views/widgets/dummy_map_container.dart';

import '../../models/sensor_data.dart';
import '../../models/session.dart';
import '../../utils/line_chart_painter.dart';

class SessionTile extends StatelessWidget {
  final Session session;
  final Function onTap;

  SessionTile({required this.session, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(primaryColor),
        padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 10)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      onPressed: () { onTap(); },
      child: Row(
        children: [
          DummyMapContainer(width: 100, height: 120),
          const SizedBox(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(faker.lorem.word().toUpperCase(), style: const TextStyle( fontWeight: FontWeight.bold, color: Colors.white),),
              SingleChildScrollView(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    iconText(Icons.add_road, faker.lorem.word(), (){}),
                    iconText(Icons.directions_bike_rounded, faker.lorem.word(), (){}),
                    iconText(Icons.timelapse_rounded, '75 mins', (){}),
                    iconText(Icons.speed, '80 kph', (){})
                  ],
                ),
              ),
              const SizedBox(height: 20,),

              FutureBuilder(
                  future: fetchSensorDataForSession(session.session_id),
                  builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.done) {
                  var sensorData = snapshot.data as List<SensorData>;
                  print('fetchSensorDataForSession loaded : ${sensorData.where((element) => element.sensor == 'Accelerometer').length}');

                  return CustomPaint(
                    painter: LineChartPainter(data: sensorData.where((element) => element.sensor == 'TotalAcceleration').toList()),
                    child: Container(
                      width: MediaQuery.of(context).size.width - 200,
                    ),
                  );
                } else {
                  print('fetchSensorDataForSession loading');
                  return const CircularProgressIndicator();
                }
              })


            ],
          )


        ],
      )
    );
  }
}

fetchSensorDataForSession(String session_id) async {
  print('fetchSensorDataForSession');
  var sessions = await FirebaseFirestore.instance.collection('sensor_data').where('session_id', isEqualTo: session_id).get();
  print('fetchSensorDataForSession : ${sessions.docs.length}');
  return sessions.docs.map((e) => SensorData.fromJson(e.data())).toList();

}

fetchTrack(String track_id) {
  FirebaseFirestore.instance.collection('tracks').doc(track_id).get().then((value) {
    return Track.fromJson(value.data()!);
  });
}