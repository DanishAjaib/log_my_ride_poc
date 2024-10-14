import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:log_my_ride/controllers/user_controller.dart';
import 'package:log_my_ride/utils/constants.dart';
import 'package:log_my_ride/utils/utils.dart';
import 'package:log_my_ride/views/screens/current_event_screen.dart';
import 'package:log_my_ride/views/screens/events_screen.dart';
import 'package:log_my_ride/views/screens/login_screen.dart';
import 'package:log_my_ride/views/widgets/app_container.dart';
import 'package:log_my_ride/views/widgets/dummy_map_container.dart';
import 'package:log_my_ride/views/widgets/home_button.dart';

import 'complete_event_screen.dart';
import 'main_screen.dart';

class EventSummaryScreen extends StatefulWidget {

  Map<String, dynamic> event;
  EventSummaryScreen({super.key, required this.event});

  @override
  State<EventSummaryScreen> createState() => _EventSummaryScreenState();
}

class _EventSummaryScreenState extends State<EventSummaryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Event Summary' , style: TextStyle(color: Colors.white),),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(

              child: Container(
                color: primaryColor,
                height: 200,
                width: double.infinity,
                child: Image.asset('assets/images/event_image.png', fit: BoxFit.cover,),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.event['eventType'].toString().contains('Road')  ? 'Open Road Event' : 'Closed Track Event',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  //date
                  const SizedBox(height: 6),
        
                  const Row(
                    children: [
                      Icon(Icons.calendar_today, color: primaryColor, size: 13),
                      SizedBox(width: 8),
                      Text(
                        '12/12/2022 12:00 AM',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                 /* const SizedBox(height: 3),
                  //location
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: primaryColor, size: 14),
                      const SizedBox(width: 8),
                      Text(
                        'Nairobi, Kenya',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  //track
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(Icons.directions_car, color: primaryColor, size: 14),
                      const SizedBox(width: 8),
                      Text(
                        'Kasarani Track',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),*/
        
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      'Event Details',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
        
                  AppContainer(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
        
                            children: [
                              Text('Track'),
                              SizedBox(width: 8),
                              Text(
                                'Track Name',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          //surface Type
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: [
                              const Text('Surface Type'),
                              const SizedBox(width: 8),
                              Text(
                                widget.event['surfaceType'].toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
        
                            children: [
                              const Text('Trip Type'),
                              const SizedBox(width: 8),
                              Text(
                                widget.event['tripType'].toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          //event promoter
                          const SizedBox(height: 10),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
        
                            children: [
                              Text('Promoter'),
                              SizedBox(width: 8),
                              Text(
                                'Event Promoter',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: [
                              const Text('Created'),
                              const SizedBox(width: 8),
                              Text(
                                DateFormat('dd/MM/yyyy hh:mm a').format(widget.event['createdOn'].toDate()),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          if(widget.event['minRiderSkill'] != null)
                            ...[
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                children: [
                                  const Text('Min Rider Skill'),
                                  const SizedBox(width: 8),
                                  Text(
                                    widget.event['minRiderSkill'].toString(),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          if(widget.event['startLocation'] != null)
                            ...[
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                children: [
                                  const Text('Start Location'),
                                  const SizedBox(width: 8),
                                  Text(
                                    widget.event['startLocation'].toString(),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],

                          if(widget.event['endLocation'] != null)
                            ...[
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                children: [
                                  const Text('End Location'),
                                  const SizedBox(width: 8),
                                  Text(
                                    widget.event['endLocation'].toString(),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],

        
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      'Event Schedule',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),



                  const SizedBox(height: 10),
                  AppContainer(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if(widget.event['gateOpenTime'] != null)
                          ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              children: [
                                const Text('Gate Open Time'),
                                const SizedBox(width: 8),
                                Text(
                                  widget.event['gateOpenTime'].toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                          if(widget.event['signOnTime'] != null)
                          ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              children: [
                                const Text('Sign-on Time'),
                                const SizedBox(width: 8),
                                Text(
                                  widget.event['signOnTime'].toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                          if(widget.event['briefingTime'] != null)
                          ...[
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              children: [
                                Text('Briefing Time'),
                                SizedBox(width: 8),
                                Text(
                                  '12:00 PM',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            //event promoter
                            const SizedBox(height: 10),
                          ],

                          if(widget.event['plannedArrivalTime'] != null)
                          ...[
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              children: [
                                Text('Planned Arrival Time'),
                                SizedBox(width: 8),
                                Text(
                                  '12:00 PM',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: [
                              Text('Session Planned Time'),
                              SizedBox(width: 8),
                              Text(
                                '12 hours',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          //track close time
                          const SizedBox(height: 10),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: [
                              Text('Track Close Time'),
                              SizedBox(width: 8),
                              Text(
                                '12:00 PM',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          //scrutineerTime

                          const SizedBox(height: 10),
                          if(widget.event['scrutineerTime'] != null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              children: [
                                const Text('Scrutineer Time'),
                                const SizedBox(width: 8),
                                Text(
                                  widget.event['scrutineerTime'].toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                          //surface Type


                        ],
                      ),
                    ),
                  ),
                  if(Get.find<UserController>().selectedUserType.value == UserType.COACH)
                    ... [
                      const SizedBox(height: 10,),
                      const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          'Event Financials',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      AppContainer(
                        child:  HomeButton(
                            height: 100,
                            iconText: '1',
                            column2Children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(

                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Total Revenue', style: TextStyle(color: Colors.grey, fontSize: 12),),
                                      Text('\$${faker.randomGenerator.decimal(min: 1000, scale: 2).toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                  //vertical divider
                                  const SizedBox(width: 15,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Total Expenses', style: TextStyle(color: Colors.grey, fontSize: 12),),
                                      Text('\$${faker.randomGenerator.decimal(min: 1000, scale: 2).toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                  const SizedBox(width: 15,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Registrations', style: TextStyle(color: Colors.grey, fontSize: 12),),
                                      Text(faker.randomGenerator.decimal(min: 50, scale: 2).toStringAsFixed(0), style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                ],
                              )
                            ],

                            icon: null),
                      )



                    ],

                  if(Get.find<UserController>().selectedUserType.value == UserType.COACH)
                    ...[
                      const SizedBox(height: 10,),
                      const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          'Event Activities',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      AppContainer(
                        child: Column(
                          children: [
                            AppContainer(child: ListTile(

                              leading: CircleAvatar(
                                child: SvgPicture.memory(getRandomSvgCode()),
                              ),
                              title: Text('Activity A'),

                            ))
                          ],
                        ),
                      ),
                      AppContainer(
                        child: Column(
                          children: [
                            AppContainer(child: ListTile(
                              leading: CircleAvatar(
                                child: SvgPicture.memory(getRandomSvgCode()),
                              ),
                              title: Text('Activity B'),

                            ))
                          ],
                        ),
                      )
                    ],


                  if(widget.event['eventType'].toString().contains('Track'))
                    ...[
                      const SizedBox(height: 10),
                      const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          'Track Map',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      DummyMapContainer(width: double.infinity, height: 250),
                    ],

                  const SizedBox(height: 20),
                  if(widget.event['groups'] != null)
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      'Event Groups',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  //event groups
                  if(widget.event['groups'] != null)
                  AppContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.event['groups'].length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Color(widget.event['groups'][index]['color']),
                              ),
                              title: Text(widget.event['groups'][index]['skill']),
                              subtitle: Row(
                                children: [
                                  const Icon(Icons.people, size: 16, color: primaryColor,),
                                  const SizedBox(width: 5,),
                                  Text('${widget.event['groups'][index]['capacity']}'),
                                  const SizedBox(width: 10,),
                                  const Icon(Icons.attach_money_outlined, size: 16, color: primaryColor,),
                                  Text('${widget.event['groups'][index]['costToEnter']}'),
                                  const SizedBox(width: 10,),
                                  const Icon(Icons.timer, size: 16, color: primaryColor,),
                                  const SizedBox(width: 5,),
                                  Text('${widget.event['groups'][index]['extraSessionTime']} mins'),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  if(widget.event['sessions'] != null)
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      'Event Sessions',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  //event sessions
                  if(widget.event['sessions'] != null)
                  AppContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.event['sessions'].length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text('Session ${index + 1}'),
                              subtitle: Row(
                                children: [
                                  const Text('Start '),
                                  Text('${widget.event['sessions'][index]['selectedSessionStartType'].first}', style: const TextStyle(color: primaryColor),),
                                  const SizedBox(width: 10,),
                                  const Text('End '),
                                  Text('${widget.event['sessions'][index]['selectedSessionEndType'].first}', style: const TextStyle(color: primaryColor),),

                                ],
                              ),

                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  //event officials
                  if(widget.event['officials'] != null)
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      'Event Officials',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  //event officials
                  if(widget.event['officials'] != null)
                  AppContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.event['officials'].length,
                          itemBuilder: (context, index) {
                            return ListTile(

                              title: Text(widget.event['officials'][index]['type']),
                              subtitle: Row(
                                children: [
                                  const Icon(Icons.attach_money, size: 16, color: primaryColor,),
                                  const SizedBox(width: 5,),
                                  Text('${widget.event['officials'][index]['cost']}'),
                                  const SizedBox(width: 10,),
                                  const Icon(Icons.security, size: 16, color: primaryColor,),
                                  Text('${widget.event['officials'][index]['accessLevel']}'),
                                  const SizedBox(width: 10,),
                                  const Icon(Icons.text_fields_outlined, size: 16, color: primaryColor,),
                                  const SizedBox(width: 5,),
                                  Text('${widget.event['officials'][index]['lmrId']}'),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  //book event button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                      ),
                      onPressed: () {
                        //book event
                        showDialog(context: context, builder: (context) {
                          return AlertDialog(
                            title: const Text('Book Event'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Selected Payment Method'),
                                const SizedBox(height: 10,),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: primaryColor),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(LineIcons.creditCard, color: primaryColor,),
                                      SizedBox(width: 10,),
                                      Text('Visa **** 1234', style: TextStyle(color: primaryColor),),
                                      Spacer(),
                                      Icon(LineIcons.angleRight, color: primaryColor,),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 20,),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        //purchase
                                        Navigator.pop(context);
                                        Get.snackbar('Success', 'Event Booked Successfully', backgroundColor: Colors.green, colorText: Colors.white);
                                        Get.off(() => const EventsScreen());

                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: primaryColor,
                                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(50),
                                          )
                                      ), child: const Text('Purchase', style: TextStyle(color:Colors.white),),),
                                  ],
                                )
                              ],
                            ),
                          );
                        });
                      },
                      child: const Text('Book Event'),
                    ),
                  ),
                  //book event button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () {
                        //book event
                        Get.to(() => CurrentEventScreen(currentEvent: widget.event,));
                      },
                      child: const Text('Launch Event'),
                    ),
                  ),
        
        
                ],
              ),
            ),
        
            //event name
        
        
          ],
        ),
      ),
    );
  }
}

getRandomDateTime() {
  var format = DateFormat('dd/MM/yyyy HH:mm a');
  return format.format(faker.date.dateTime(minYear: 2023, maxYear: 2024));

}
