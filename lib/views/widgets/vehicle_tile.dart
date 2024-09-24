import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:log_my_ride/utils/constants.dart';
import 'package:log_my_ride/utils/utils.dart';
import 'package:log_my_ride/views/widgets/app_container.dart';

class VehicleTile extends StatelessWidget {
  Function(Map<String, dynamic>)? onPressed;
  Map<String, dynamic> vehicle;
  VehicleTile({super.key, required this.onPressed, required this.vehicle});

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
            onPressed!( vehicle);
          }
        },
        child: ListTile(
          trailing: const Icon(LineIcons.angleRight, color: primaryColor,),
          leading: CircleAvatar(
            backgroundColor: primaryColor,
            child: SvgPicture.memory(getRandomSvgCode()),
          ),
          title: Text(getTruncatedText(vehicle['name'], 15), style: const TextStyle(fontSize: 16),),
          subtitle: Column(
            children: [
              const SizedBox(height: 5,),
              Row(
                children: [
                  const Icon(LineIcons.shapes, size: 16, color: primaryColor,),
                  const SizedBox(width: 5),
                  Text(vehicle['category'], style: const TextStyle(fontSize: 12),),
                  const SizedBox(width: 5),
                  const Icon(LineIcons.biking, size: 16, color: primaryColor,),
                  Text(getTruncatedText(vehicle['type'], 15), style: const TextStyle(fontSize: 12),),

                ],
              ),
            ],
          ),
        ));
  }
}
