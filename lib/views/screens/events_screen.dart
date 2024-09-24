import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:log_my_ride/views/screens/event_summary_screen.dart';
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
                  ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    title: const Text('Track'),
                    onTap: () {
                      Get.to(() => const NewTrackRideEventScreen());
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
                  const Divider(),
                  ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    title: const Text('Track - Promoter'),
                    onTap: () {
                      Get.to(() => const NewTrackRidePromoterEventScreen());
                      //Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    title: const Text('Road - Promoter'),
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(() => const NewRidePromoterEventScreen());
                      //Navigator.pop(context);
                    },
                  ),
                  const Divider(),
                  ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    title: const Text('Track - Coach'),
                    onTap: () {
                      Get.to(() => const NewTrackRideCoachEventScreen());
                      //Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    title: const Text('Road - Coach'),
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(() => const NewRideCoachEventScreen());
                      //Navigator.pop(context);
                    },
                  ),

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
              const Text('Upcoming Events', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              const SizedBox(height: 10,),
              Obx(() {

                return ListView.builder(

                  shrinkWrap: true,
                  itemCount: eventsController.events.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: EventTile(
                        onPressed: () {
                          Get.to(() => EventSummaryScreen(event: eventsController.events[index],));
                        },
                      ),
                    );
                  },
                );
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

