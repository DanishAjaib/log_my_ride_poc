import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:log_my_ride/utils/constants.dart';
import 'package:log_my_ride/utils/utils.dart';
import 'package:log_my_ride/views/widgets/app_container.dart';

class EventTile extends StatelessWidget {
  const EventTile({super.key});

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
          trailing: const Icon(LineIcons.angleRight, color: primaryColor,),
          leading: const CircleAvatar(
            backgroundColor: primaryColor,
            child: Icon(LineIcons.calendar, color: Colors.white,),
          ),
          title: Text(getTruncatedText(faker.company.name().toString(), 15), style: const TextStyle(fontSize: 16),),
          subtitle: Column(
            children: [
              const SizedBox(height: 5,),
              Row(
                children: [
                  const Icon(LineIcons.clock, size: 16, color: primaryColor,),
                  const SizedBox(width: 5),
                  Text(DateFormat('MMM dd').format(faker.date.dateTime(minYear: 2022, maxYear: 2022)), style: const TextStyle(fontSize: 12),),
                  const SizedBox(width: 5),
                  const Icon(LineIcons.mapMarker, size: 16, color: primaryColor,),
                  Text(getTruncatedText(faker.address.city(), 15), style: const TextStyle(fontSize: 12),),

                ],
              ),
            ],
          ),
        ));
  }
}
