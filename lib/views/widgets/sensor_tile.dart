import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:log_my_ride/utils/constants.dart';
import 'package:log_my_ride/utils/utils.dart';
import 'package:log_my_ride/views/widgets/app_container.dart';

class SensorTile extends StatelessWidget {
  Function(Map<String, dynamic>)? onPressed;
  Map<String, dynamic> sensor;
  SensorTile({super.key, required this.onPressed, required this.sensor});

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
            onPressed!( sensor);
          }
        },
        child: ListTile(

          leading: CircleAvatar(
            backgroundColor: primaryColor,
            child: SvgPicture.memory(getRandomSvgCode()),
          ),
          title: Text(getTruncatedText(sensor['type'], 15), style: const TextStyle(fontSize: 16),),
          subtitle: Column(
            children: [
              const SizedBox(height: 5,),
              Row(
                children: [
                  const Icon(LineIcons.shapes, size: 16, color: primaryColor,),
                  const SizedBox(width: 5),
                  Text(sensor['category'], style: const TextStyle(fontSize: 12),),
                  const SizedBox(width: 5),
                  if(sensor['type'] == 'LMR Box')
                    ...[
                      const Icon(Icons.text_fields_outlined, size: 16, color: primaryColor,),
                      const SizedBox(width: 5),
                      Text(getTruncatedText(sensor['id'], 15), style: const TextStyle(fontSize: 12),),
                    ]
                ],
              ),
            ],
          ),
        ));
  }
}
