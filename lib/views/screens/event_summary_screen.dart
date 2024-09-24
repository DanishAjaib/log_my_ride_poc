import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:log_my_ride/utils/constants.dart';
import 'package:log_my_ride/views/screens/current_event_screen.dart';
import 'package:log_my_ride/views/widgets/app_container.dart';
import 'package:log_my_ride/views/widgets/dummy_map_container.dart';

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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              child: Container(
                color: primaryColor,
                height: 200,
                child: const Center(
                  child: Text(
                    'Event Summary',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.event['eventType'].toString(),
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
