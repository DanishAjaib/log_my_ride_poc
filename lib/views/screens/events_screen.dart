import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:log_my_ride/controllers/user_controller.dart';
import 'package:log_my_ride/utils/utils.dart';
import 'package:log_my_ride/views/screens/event_summary_screen.dart';
import 'package:log_my_ride/views/screens/login_screen.dart';
import 'package:log_my_ride/views/screens/new_road_coach_event_screen.dart';
import 'package:log_my_ride/views/screens/new_road_event_screen.dart';
import 'package:log_my_ride/views/screens/new_road_promoter_event_screen.dart';
import 'package:log_my_ride/views/screens/new_track_coach_event_screen.dart';
import 'package:log_my_ride/views/screens/new_track_event_screen.dart';
import 'package:log_my_ride/views/screens/new_track_promoter_event_screen.dart';
import 'package:log_my_ride/views/widgets/event_tile.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../controllers/events_controller.dart';
import '../../utils/constants.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  var selectedMode = 0;
  var eventsController = Get.put(EventController());

  String currentFilter = 'All';

  Set<String> selectedEventType = {'Training'};
  var allEventTypes = ['Track', 'Road', 'Coaching', 'Training'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          // select the type of event to create {Track, Road}
          showDialog(context: context, builder: (context) {
            return AlertDialog(
              title: const Text('Create a new ride'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  if(Get.find<UserController>().selectedUserType.value == UserType.RIDER)
                    ...[
                      ListTile(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        title: const Text('Track'),
                        onTap: () {
                          Get.to(() => NewTrackRideEventScreen());
                          //Navigator.pop(context);
                        },

                      ),
                      ListTile(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        title: const Text('Road'),
                        onTap: () {
                          Navigator.pop(context);
                          Get.to(() => const NewRideEventScreen());
                          //Navigator.pop(context);
                        },

                      ),
                    ],
                  if(Get.find<UserController>().selectedUserType.value == UserType.PROMOTER)
                  ...[
                    ListTile(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      title: const Text('Track'),
                      onTap: () {
                        Get.to(() => const NewTrackRidePromoterEventScreen());
                        //Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      title: const Text('Road'),
                      onTap: () {
                        Navigator.pop(context);
                        Get.to(() => const NewRidePromoterEventScreen());
                        //Navigator.pop(context);
                      },
                    ),
                  ],
                  if(Get.find<UserController>().selectedUserType.value == UserType.COACH)
                    ...[
                      ListTile(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        title: const Text('Track'),
                        onTap: () {
                          Get.to(() => const NewTrackRideCoachEventScreen());
                          //Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        title: const Text('Road'),
                        onTap: () {
                          Navigator.pop(context);
                          Get.to(() => const NewRideCoachEventScreen());
                          //Navigator.pop(context);
                        },
                      ),
                    ]


                ],
              ),
            );
          });

        },
        child: const Icon(LineIcons.plus),
      ),
      appBar: AppBar(
        title: const Text('Events'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                selectedMode = 0;
              });
            },
            icon: Icon(LineIcons.list, color: selectedMode == 0 ? primaryColor : Colors.white,),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                selectedMode = 1;
              });
            },
            icon: Icon(LineIcons.calendar, color: selectedMode == 1 ? primaryColor : Colors.white,),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: selectedMode == 0 ? SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                children: [
                  const Text('Upcoming Events', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                  const Spacer(),

                  GestureDetector(
                    onTapDown: (details) {
                      //show context menu at this location
                      showMenu(
                        context: context,
                        position: RelativeRect.fromLTRB(details.globalPosition.dx, details.globalPosition.dy, 0, 0),
                        items: [
                          PopupMenuItem(
                            child: TextButton.icon(
                                icon: const Icon(LineIcons.calendarAlt, color: primaryColor, size: 18,),
                                label: const Text('All', style: TextStyle(color: Colors.white),),
                                onPressed: () {
                                  Navigator.pop(context);
                                  setState(() {
                                    currentFilter = 'All';
                                  });
                                }),
                          ),
                          PopupMenuItem(
                            child: TextButton.icon(
                                icon: const Icon(LineIcons.calendarAlt, color: primaryColor, size: 18,),
                                label: const Text('Next 7 Days', style: TextStyle(color: Colors.white),),
                                onPressed: () {
                                  Navigator.pop(context);
                                  setState(() {
                                    currentFilter = 'Next 7 Days';
                                  });
                                }),
                          ),
                          PopupMenuItem(
                            child: TextButton.icon(
                                icon: const Icon(LineIcons.calendarAlt, color: primaryColor, size: 18,),
                                label: const Text('Next 30 Days', style: TextStyle(color: Colors.white),),
                                onPressed: () {
                                  Navigator.pop(context);
                                  setState(() {
                                    currentFilter = 'Next 30 Days';
                                  });
                                }),
                          ),
                          //custom
                          PopupMenuItem(
                            child: TextButton.icon(
                                icon: const Icon(LineIcons.calendarAlt, color: primaryColor, size: 18,),
                                label: const Text('Custom', style: TextStyle(color: Colors.white),),
                                onPressed: () {
                                  Navigator.pop(context);
                                  showDateRangePicker(
                                      context: context,
                                      firstDate:  DateTime.now(),
                                      lastDate: DateTime.now().add(const Duration(days: 365))).then((value) {

                                      setState(() {
                                        var start = DateFormat('yyyy-MM-dd').format(value!.start);
                                        var end = DateFormat('yyyy-MM-dd').format(value.end);
                                        currentFilter = '$start - $end';
                                      });
                                  });

                                }),
                          ),

                        ],
                      );
                    },
                    child: TextButton.icon(
                        icon: const Icon(LineIcons.calendarAlt, color: primaryColor, size: 18,),
                        label: Text(currentFilter, style: const TextStyle(color: Colors.white),),
                        onPressed: () {
                          //show context menu at this location


                        }),
                  )
                ],
              ),
              const SizedBox(height: 10,),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 20,),
                    SegmentedButtonTheme(
                      data: SegmentedButtonThemeData(
                       style: ButtonStyle(
                         shape: WidgetStateProperty.all(
                           RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(50),
                             side: BorderSide(color: primaryColor, width: 1),
                           ),
                         ),
                       ),
                      ),
                      child: SegmentedButton(

                        showSelectedIcon: false,
                        style: ButtonStyle(
                          side:  WidgetStateProperty.all(BorderSide(color: primaryColor)),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                              side: BorderSide(color: primaryColor, width: 1),
                            ),
                          ),
                        ),
                        segments: allEventTypes.map((e) {
                          return ButtonSegment(value: e, label: Text(e), );
                        }).toList(),
                        multiSelectionEnabled: false,
                        emptySelectionAllowed: false, selected: selectedEventType,
                        onSelectionChanged: (value) {
                          setState(() {
                            selectedEventType = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10,),

              Obx(() {
                var userTypeEvents = getUserTypeEvents(eventsController.events);

                return getEventsLength(eventsController.events) > 0 ?ListView.builder(

                  shrinkWrap: true,
                  itemCount: userTypeEvents.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: EventTile(
                        event: userTypeEvents[index],
                        onPressed: () {
                          Get.to(() => EventSummaryScreen(event: userTypeEvents[index],));
                        },
                      ),
                    );
                  },
                ) : Container(
                    height: Get.height * 0.5,
                    child: const Center(child: Text('No events found'),));
              }),

            ],
          ),
        ) : Center(
          child: SfCalendar(
            todayHighlightColor: primaryColor,
            selectionDecoration: BoxDecoration(
              color: primaryColor.withOpacity(0.3),
              border: Border.all(color: primaryColor, width: 2),
              borderRadius: BorderRadius.circular(5),
            ),

            view: CalendarView.month,
            monthViewSettings: const MonthViewSettings(showAgenda: true),
            dataSource: EventsDataSource(_getDataSource()),
          ),
        ),
      ),
    );
  }

  getUserTypeEvents(List<Map<String, dynamic>> events) {
    var userType = Get.find<UserController>().selectedUserType.value;
    switch(userType) {
      case UserType.RIDER:
        return events.where((element) => element['eventType'].toString().contains('Rider')).toList();
      case UserType.PROMOTER:
        return events.where((element) => element['eventType'].toString().contains('Promoter')).toList();
      case UserType.COACH:
        return events.where((element) => element['eventType'].toString().contains('Coach')).toList();
      case UserType.CLUB:
        return events.where((element) => element['eventType'].toString().contains('Club')).toList();
      default:
        return events.where((element) => element['eventType'].toString().contains('Rider')).toList();
    }
  }
}

getEventsLength(List<Map<String, dynamic>> events) {
  var userType = Get.find<UserController>().selectedUserType.value;
  switch(userType) {
    case UserType.RIDER:
      return events.where((element) => element['eventType'].toString().contains('Rider')).length;
    case UserType.PROMOTER:
      return events.where((element) => element['eventType'].toString().contains('Promoter')).length;
    case UserType.COACH:
      return events.where((element) => element['eventType'].toString().contains('Coach')).length;
    case UserType.CLUB:
      return events.where((element) => element['eventType'].toString().contains('Club')).length;
    default:
      return events.where((element) => element['eventType'].toString().contains('Rider')).length;
  }
}

class Event {
  Event(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}

List<Event> _getDataSource() {
  final List<Event> meetings = <Event>[];
  final DateTime today = DateTime.now();
  final DateTime startTime =
  DateTime(today.year, today.month, today.day, 9, 0, 0);
  final DateTime endTime = startTime.add(const Duration(hours: 2));
  meetings.add(Event(faker.company.name(), startTime, endTime, const Color(0xFF0F8644), false));
  return meetings;
}


class EventsDataSource extends CalendarDataSource {
  EventsDataSource(List<Event> source){
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

