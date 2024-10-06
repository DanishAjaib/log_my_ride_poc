import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:log_my_ride/views/screens/my_profile_screen.dart';

import '../../utils/constants.dart';
import '../../utils/utils.dart';

class MyCustomTuneTile extends StatefulWidget {
  Function onPressed;
  Map<String, dynamic> myCustomTune;
  MyCustomTuneTile({super.key, required this.myCustomTune, required this.onPressed});

  @override
  State<MyCustomTuneTile> createState() => _MyCustomTuneTileState();
}

class _MyCustomTuneTileState extends State<MyCustomTuneTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: ElevatedButton(
          style: ButtonStyle(
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          onPressed: () {
            widget.onPressed();
          }, child: ListTile(
          leading: CircleAvatar(
            backgroundColor: primaryColor,
            child: SvgPicture.memory(getRandomSvgCode()),
          ),

        title: Row(
          children: [

            Text(getTruncatedText(faker.vehicle.model(), 10), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
            const SizedBox(width: 10),
            getChipText(widget.myCustomTune['status'], bgColor: getTuningStatusColor(widget.myCustomTune['status'])),
          ],
        ),
        subtitle: Column(
          children: [
            const SizedBox(height: 5,),
            Row(
              children: [
                const Icon(Icons.text_fields_outlined, size: 16, color: primaryColor,),
                const SizedBox(width: 3),
                Text(getTruncatedText(widget.myCustomTune['name'].toString(), 8), style: const TextStyle(fontSize: 12),),
                const SizedBox(width: 8),
                const Icon(LineIcons.calendarAlt, size: 16, color: primaryColor,),
                const SizedBox(width: 3),
                Text(DateFormat.yMMMd().format(DateTime.parse(widget.myCustomTune['time'].toString())), style: const TextStyle(fontSize: 12),),


              ],
            ),
          ],
        ),
        ),
      ),
    );
  }

  getTuningStatusColor(myCustomTune) {
    switch (myCustomTune) {
      case 'Delivered':
        return Colors.lightGreen;
      case 'In Progress':
        return primaryColor;
      case 'Pending Submission':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
