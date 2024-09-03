import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:log_my_ride/utils/constants.dart';
import 'package:log_my_ride/utils/utils.dart';
import 'package:log_my_ride/views/widgets/app_container.dart';

class RideTile extends StatelessWidget {
  String? trackName;
  String dateRecorded;
  String rideName;
  String? bestTime;
  String? distanceTravelled;
  String? recordingLength;

  RideTile({super.key, this.trackName, required this.dateRecorded, required this.rideName, this.bestTime, this.distanceTravelled, this.recordingLength});

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
        onPressed: () {},
        child: ListTile(
          leading: const CircleAvatar(
            backgroundColor: primaryColor,
            child: Icon(LineIcons.calendar, color: Colors.white,),
          ),
          title: Row(
            children: [
              Text(getTruncatedText(trackName ?? rideName, 15), style: const TextStyle(fontSize: 16),)
            ],
          ),
          subtitle: Column(
            children: [
              const SizedBox(height: 5,),
              Row(
                children: [
                  const Icon(LineIcons.calendar, size: 16, color: primaryColor,),
                  const SizedBox(width: 4),
                  Text(dateRecorded, style: const TextStyle(fontSize: 12),),
                  const SizedBox(width: 4),
                  const Icon(LineIcons.road, size: 16, color: primaryColor,),
                  Text(getTruncatedText(rideName, 15), style: const TextStyle(fontSize: 12),),
                  const SizedBox(width: 4),
                  const Icon(LineIcons.cloudscaleCh, size: 16, color: primaryColor,),
                  Text(bestTime ?? distanceTravelled ?? '', style: const TextStyle(fontSize: 12),),
                ],
              ),
            ],
          ),
        ));
  }
}
