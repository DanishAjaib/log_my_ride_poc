import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:log_my_ride/utils/constants.dart';
import 'package:log_my_ride/utils/utils.dart';
import 'package:log_my_ride/views/widgets/app_container.dart';

class FriendTile extends StatelessWidget {
  Function(Map<String, dynamic>)? onPressed;
  Map<String, dynamic> friend;
  FriendTile({super.key, required this.onPressed, required this.friend});

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
            onPressed!(friend);
          }
        },
        child: ListTile(

          leading: CircleAvatar(
            backgroundColor: primaryColor,
            child: SvgPicture.memory(getRandomSvgCode()),
          ),
          title: Text(getTruncatedText(friend['name'], 15), style: const TextStyle(fontSize: 16),),
          subtitle: Column(
            children: [
              const SizedBox(height: 5,),
              Row(
                children: [
                  const Icon(LineIcons.calendarAlt, size: 16, color: primaryColor,),
                  const SizedBox(width: 5),
                  Text(DateFormat('dd/MM/yyy').format(DateTime.fromMillisecondsSinceEpoch(friend['added'])), style: const TextStyle(fontSize: 12),),
                  const SizedBox(width: 10),
                  const Icon(LineIcons.clockAlt, size: 16, color: primaryColor,),
                  const SizedBox(width: 5),
                  Text('${(friend['rideTime'] / 60).toStringAsFixed(2)} Hrs', style: const TextStyle(fontSize: 12),),

                ],
              ),
            ],
          ),
        ));
  }
}
