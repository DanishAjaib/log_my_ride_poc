import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:log_my_ride/controllers/events_controller.dart';
import 'package:log_my_ride/views/screens/event_summary_screen.dart';

import '../../utils/constants.dart';
import '../../utils/utils.dart';

class FriendProfileScreen extends StatefulWidget {
  const FriendProfileScreen({super.key});

  @override
  State<FriendProfileScreen> createState() => _FriendProfileScreenState();
}

class _FriendProfileScreenState extends State<FriendProfileScreen> {

  bool sendingFriendRequest = false;
  var recentActivity = [
    {
      'title' : 'Event',
      'date' : DateFormat.yMMMd().format(faker.date.dateTime(minYear: 2022, maxYear: 2022)),
      'icon' : LineIcons.calendarAlt,
      'avgSpeed' : '30',
      'distance' : '200.5km',
      'maxLeanAngle' : '45',
    },
    {
      'title' : 'Road',
      'date' : DateFormat.yMMMd().format(faker.date.dateTime(minYear: 2022, maxYear: 2022)),
      'icon' : LineIcons.road,
      'avgSpeed' : '30',
      'distance' : '2.5km',
      'maxLeanAngle' : '30',
    },
    {
      'title' : 'Ride',
      'date' : DateFormat.yMMMd().format(faker.date.dateTime(minYear: 2022, maxYear: 2022)),
      'time' : '11:30',
      'icon' : LineIcons.car,
      'avgSpeed' : '30',
      'distance' : '2.5km',
      'maxLeanAngle' : '30',

    },
    {
      'title' : 'Ride',
      'date' : DateFormat.yMMMd().format(faker.date.dateTime(minYear: 2022, maxYear: 2022)),
      'time' : '11:30',
      'icon' : LineIcons.car,
      'avgSpeed' : '30',
      'distance' : '2.5km',
      'maxLeanAngle' : '30',

    },


  ];
  @override
  Widget build(BuildContext context) {

    var eventsController = Get.put(EventController());
    return Scaffold(
      appBar:   AppBar(
        title: const Text('User Profile'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.blue,
            child: SvgPicture.memory(getRandomSvgCode()),
          ),
          const SizedBox(height: 20),
          Text(faker.company.name(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          Text(faker.address.city(), style: const TextStyle(fontSize: 16),),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  const Text('Rank', style: TextStyle(fontSize: 12, color: Colors.grey),),
                  Text(faker.randomGenerator.integer(5, min: 1).toString(), style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),),
                ],
              ),
              const SizedBox(width: 10),
              const VerticalDivider(color: Colors.grey),
              const SizedBox(width: 10),
              Column(
                children: [
                  const Text('Rides', style: TextStyle(fontSize: 12, color: Colors.grey),),
                  Text(' ${faker.randomGenerator.integer(100, min: 1)}', style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),),
                ],
              ),
              const SizedBox(width: 10),
              const VerticalDivider(color: Colors.red, thickness: 5,),
              const SizedBox(width: 10),
              Column(
                children: [
                  const Text('Vehicles', style: TextStyle(fontSize: 12, color: Colors.grey),),
                  Text(faker.randomGenerator.integer(50, min: 1).toString(), style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),),
                ],
              ),



            ],
          ),
          const SizedBox(height: 5),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(faker.lorem.sentences(4).join(' '), style: const TextStyle(fontSize: 12,  color: Colors.grey, fontStyle: FontStyle.italic), textAlign: TextAlign.center, )),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            label: const Text('Add Friend', style: TextStyle(color: Colors.white),),
            icon: const Icon(LineIcons.userAlt, color: Colors.white,),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(primaryColor),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
            onPressed: (){
              //send friend request?
              showDialog(context: context, builder: (context) {
                return AlertDialog(
                  title: const Text('Send Friend Request'),
                  content: const Text('Do you really want to send a friend request to this user.'),
                  actions: [
                    TextButton(onPressed: (){
                      Navigator.pop(context);
                    }, child: const Text('Cancel')),
                    TextButton(onPressed: (){
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Friend Request Sent'), ));
                    }, child: sendingFriendRequest ? const CircularProgressIndicator() : const Text('Send'))
                  ],
                );
              });
            },
          ),
          const SizedBox(height: 20),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text('Recent Activity'),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount:  recentActivity.length,
                itemBuilder: (context, index) {

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                child: ElevatedButton(
                  style:  ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                    onPressed: () {
                       Get.to(() => EventSummaryScreen(event: eventsController.events[0]));
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundColor: primaryColor,
                        child: Icon(recentActivity[index]['icon']as IconData, color: Colors.white,),
                      ),
                      title: Text(recentActivity[index]['title'].toString()),
                      subtitle: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.calendar_month, color: primaryColor, size: 18,),
                          const SizedBox(width: 5,),
                          Text(recentActivity[index]['date'].toString(), style: const TextStyle(color: Colors.grey, fontSize: 14),),
                          const SizedBox(width: 15,),
                          const Icon(Icons.timer, color: primaryColor, size: 18,),
                          const SizedBox(width: 5,),
                          Text(recentActivity[index]['distance'].toString(), style: const TextStyle(color: Colors.grey, fontSize: 14),),



                        ],
                      ),
                    )),
              );
            }),
          ),


        ],
      ),
    );
  }
}
