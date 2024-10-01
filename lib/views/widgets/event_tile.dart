import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:log_my_ride/utils/constants.dart';
import 'package:log_my_ride/utils/utils.dart';
import 'package:log_my_ride/views/widgets/app_container.dart';

class EventTile extends StatelessWidget {
  Function? onPressed;
  Map<String, dynamic> event;
  EventTile({super.key, this.onPressed, required this.event});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(

      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
        onPressed: () {
          if(onPressed != null){
            onPressed!();
          }
        },
        child: ListTile(

          leading: CircleAvatar(
            backgroundColor: primaryColor,
            child: SvgPicture.memory(getRandomSvgCode()),
          ),
          title: Row(
            children: [
              Text(getTruncatedText(faker.company.name().toString(), 15), style: const TextStyle(fontSize: 16),)
            ],
          ),
          subtitle: Column(
            children: [
              const SizedBox(height: 5,),
              Row(
                children: [
                  const Icon(LineIcons.clock, size: 16, color: primaryColor,),
                  const SizedBox(width: 3),
                  Text(DateFormat('MMM dd').format(faker.date.dateTime(minYear: 2022, maxYear: 2022)), style: const TextStyle(fontSize: 12),),
                  const SizedBox(width: 8),
                  Icon(getEventTypeIcon(event['eventType']), size: 16, color: primaryColor,),
                  const SizedBox(width: 3),
                  Text(getEventType(event['eventType']), style: const TextStyle(fontSize: 12),),
                  const SizedBox(width: 8),
                  const Icon(LineIcons.mapMarker, size: 16, color: primaryColor,),
                  const SizedBox(width: 3),
                  Text(getTruncatedText(faker.address.city(), 10), style: const TextStyle(fontSize: 12),),


                ],
              ),
            ],
          ),
        ));
  }

  String getEventType(eventType) {
    if(eventType.contains('Road')) {
      return 'Open';
    } else {
      return 'Closed';
    }
  }

  IconData? getEventTypeIcon(event) {
    if (event.contains('Road')) {
      return LineIcons.circleNotched;
    } else {
      return LineIcons.circle;
    }
  }
}
