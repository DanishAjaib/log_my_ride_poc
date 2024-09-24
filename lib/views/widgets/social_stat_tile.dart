import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:log_my_ride/utils/constants.dart';
import 'package:log_my_ride/utils/utils.dart';
import 'package:log_my_ride/views/widgets/app_container.dart';

class SocialStatTile extends StatefulWidget {

  String value;
  String name;
  String date;
  int position;
  SocialStatTile({super.key, required this.value, required this.name, required this.position, required this.date});

  @override
  State<SocialStatTile> createState() => _SocialStatTileState();
}

class _SocialStatTileState extends State<SocialStatTile> {
  @override
  Widget build(BuildContext context) {
    return AppContainer(

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //avatar
            Stack(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: primaryColor,
                  child: CircleAvatar(
                    radius: 28,
                    child: SvgPicture.memory(
                      getRandomSvgCode(),
                  ),
                ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: primaryColor,
                    child: Text('${widget.position}', style: const TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.name, style: const TextStyle(fontSize: 16),),
                Text(widget.date, style: const TextStyle(fontSize: 12, color: Colors.grey), ),
                //dash
              ],
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.value, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
