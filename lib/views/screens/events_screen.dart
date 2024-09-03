import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:log_my_ride/views/widgets/event_tile.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../utils/constants.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  var selectedMode = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: selectedMode == 0 ? const SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Upcoming Events', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              Text('Events you might be interested in based on your location', style: TextStyle(fontSize: 12, color: Colors.grey),),
              SizedBox(height: 20,),
              EventTile(),
              SizedBox(height: 5,),
              EventTile(),
              SizedBox(height: 5,),
              EventTile(),
              SizedBox(height: 15,),
              Text('Previous Events', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              Text('Events you have participated in the past', style: TextStyle(fontSize: 12, color: Colors.grey),),
              SizedBox(height: 20,),
              EventTile(),
              SizedBox(height: 5,),
              EventTile(),
              SizedBox(height: 5,),
              EventTile(),
              SizedBox(height: 5,),
              EventTile(),
              SizedBox(height: 5,),
              EventTile(),
              SizedBox(height: 5,),
              EventTile(),
              SizedBox(height: 5,),
              EventTile(),
              SizedBox(height: 5,),
              EventTile(),
              SizedBox(height: 15,),
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
            monthViewSettings: MonthViewSettings(showAgenda: true),
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

