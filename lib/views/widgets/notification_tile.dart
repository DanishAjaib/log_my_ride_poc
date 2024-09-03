import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../../utils/constants.dart';


enum NotificationType {
  riderPassed,
  crashDetected,
  eventNearby,
}

class NotificationTile extends StatelessWidget {

  String title;
  String message;
  NotificationType type;
  Function? onTap;

  NotificationTile(
      {super.key, required this.title, required this.message, required this.type, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(

      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: ElevatedButton(
          style: ButtonStyle(
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          onPressed: () {
            if(onTap != null) {
              onTap!();
            }
          },
          child: ListTile(
            trailing: const Icon(LineIcons.angleRight, color: primaryColor,),
            leading: CircleAvatar(
              backgroundColor: primaryColor,
              child: Icon(getNotificationIcon(type), color: Colors.white,),
            ),
            title: Text(title, style: const TextStyle(fontSize: 16),),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message, style: const TextStyle(fontSize: 12),),
              ],
            ),
          )),
    );
  }

  IconData? getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.riderPassed:
        return LineIcons.biking;
      case NotificationType.crashDetected:
        return LineIcons.ambulance;
      case NotificationType.eventNearby:
        return LineIcons.calendar;
      default:
        return LineIcons.biking;
    }
  }
}
