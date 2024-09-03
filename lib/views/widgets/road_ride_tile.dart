import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';

class RoadRideTile extends StatelessWidget {
  final String rideName;
  final String dateRecorded;
  final String timeTaken;
  final String distanceTravelled;
  const RoadRideTile({super.key, required this.rideName, required this.dateRecorded, required this.timeTaken, required this.distanceTravelled});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
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

              title: Text(getTruncatedText(rideName, 15), style: const TextStyle(fontSize: 16),),
              subtitle: Column(
                children: [
                  const SizedBox(height: 5,),
                  Row(
                    children: [
                      const Icon(LineIcons.calendarAlt, size: 16, color: primaryColor,),
                      const SizedBox(width: 5),
                      Text(dateRecorded, style: const TextStyle(fontSize: 12),),
                      const SizedBox(width: 8),
                      const Icon(LineIcons.stopwatch, size: 16, color: primaryColor,),
                      Text( '$timeTaken mins', style: const TextStyle(fontSize: 12),),
                      const SizedBox(width: 8),
                      const Icon(Icons.directions_bike_outlined, size: 16, color: primaryColor,),
                      const SizedBox(width: 5),
                      Text( '$distanceTravelled kms', style: const TextStyle(fontSize: 12),),

                    ],
                  ),
                ],
              ),
            )),
        const SizedBox(height: 5,),
      ],
    );
  }
}
