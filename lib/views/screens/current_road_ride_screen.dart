import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
/*
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
*/
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:log_my_ride/utils/utils.dart';
import 'package:log_my_ride/views/screens/current_session_screen.dart';
import 'package:log_my_ride/views/screens/session_summary_screen.dart';
import 'package:log_my_ride/views/widgets/app_container.dart';
import 'package:log_my_ride/views/widgets/dummy_map_container.dart';
import 'package:log_my_ride/views/widgets/metric_container.dart';
import 'package:log_my_ride/views/widgets/notification_tile.dart';
import '../../utils/constants.dart';
import 'package:audioplayers/audioplayers.dart';

class CurrentRoadRideScreen extends StatefulWidget {

  const CurrentRoadRideScreen({super.key});

  @override
  State<CurrentRoadRideScreen> createState() => _CurrentRoadRideScreenState();
}

class _CurrentRoadRideScreenState extends State<CurrentRoadRideScreen> {

  Timer? _timer;
  Timer? _rideTimer;
  int _countdown = 5;
  bool showReady = true;
  int timeElapsed = 0;
  bool showDash = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

/*  MapController controller = MapController(
      initPosition: GeoPoint(latitude: 47.4358055, longitude: 8.4737324),
      areaLimit: BoundingBox(
          east: 10.4922941,
          north: 47.8084648,
          south: 45.817995,
          west:  5.9559113,
      ),
  );*/

  var notifications = [

  ];

  @override
  void initState() {
    _initializeNotifications();
    _startCountdown();
    _scheduleNotifications();

    super.initState();
  }

  void _initializeNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings = const InitializationSettings(android: initializationSettingsAndroid);
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
      Timer(Duration(seconds: (i + 1) * 5), () {
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
  }
  @override
  void dispose() {
    _timer?.cancel();
    _rideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(

        actions: [
      /*    TextButton.icon(
            onPressed: () {
              Get.to(() => CurrentSessionScreen());

            },
            label: const Text('Show Dash', style: TextStyle(color: Colors.white),), icon: const Icon(Icons.speed, color: Colors.red,),),*/
          const SizedBox(width: 80,),

          TextButton.icon(
            onPressed: () {
              _rideTimer?.cancel();
              Navigator.pop(context);
              Get.to(() => SessionSummaryScreen());

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
/*            AppContainer(
              height: 50,
              child: Row(
                children: [
                  const Icon(LineIcons.alternateListAlt, color: primaryColor,),
                  const SizedBox(width: 10,),
                  const Text('Current Road Ride', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                ],
              ),
            ),*/
            DummyMapContainer(width: double.infinity, height: 350),
/*
            AppContainer(child: OSMFlutter(controller: controller),),
*/
            const SizedBox(height: 10),
            _countdown == 0 ?
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MetricContainer(value: '25 Km/h', icon: Icons.speed, label: 'Speed',),
                  MetricContainer(value: '235', icon: Icons.text_rotation_angleup, label: 'Lean Angle',),
/*
                  MetricContainer(value: '1 hr 15 min', icon: LineIcons.clockAlt, label: 'Ride Time', ),
*/
                  MetricContainer(value: '54th', icon: Icons.leaderboard, label: 'Ride Rank', ),
                ],
              ),
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
            if (notifications.isEmpty) const Center(child: CircularProgressIndicator(),) else Column(
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
/*            NotificationTile(
                title: 'A rider just passed you',
                message: 'A rider just passed you at 30 km/h',
                type: NotificationType.riderPassed,
                onTap: (){

                }
            ),
            NotificationTile( title: 'Crash detected', message: 'A crash was detected near you', type: NotificationType.crashDetected, onTap: (){}),
            NotificationTile( title: 'Event near you', message: 'An event 45 kms away from you is starting in 1 hour', type: NotificationType.eventNearby, onTap: (){}),
            NotificationTile( title: 'Crash detected', message: 'A crash was detected near you', type: NotificationType.crashDetected, onTap: (){}),*/
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
}


