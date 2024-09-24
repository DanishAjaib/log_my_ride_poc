import 'package:flutter/material.dart';
import 'package:log_my_ride/views/widgets/app_container.dart';

import '../../utils/constants.dart';
import '../../utils/custom_thumb_shape.dart';

class RiderSkillSelector extends StatefulWidget {
  Function(int) callback;
  int requiredSkill;
  RiderSkillSelector({super.key, required this.callback, required this.requiredSkill});

  @override
  State<RiderSkillSelector> createState() => _RiderSkillSelectorState();
}

class _RiderSkillSelectorState extends State<RiderSkillSelector> {

  var requiredSkill = 15;

  @override
  void initState() {
    setState(() {
      requiredSkill = widget.requiredSkill;
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel', style: TextStyle(color: primaryColor),),
        ),
        TextButton(
          onPressed: () {
            widget.callback(requiredSkill);
            Navigator.pop(context);
          },
          child: const Text('Save', style: TextStyle(color: primaryColor),),
        )
      ],

      content: SizedBox(
        height: 100,
        child: Column(
          children: [
            Row(
              children: [
                const Text('Required Skill Level'),
                const Spacer(),
                Text(requiredSkill.toString(), style: TextStyle(color: requiredSkill < 35 ? Colors.green :(requiredSkill < 75 ? Colors.yellow : Colors.red), fontSize: 22),)
              ],
            ),
            const SizedBox(height: 10,),
            SliderTheme(
              data: SliderThemeData(
                thumbShape: CustomSliderThumbShape(strokeWidth: 2, strokeColor: requiredSkill < 35 ? Colors.green :(requiredSkill < 75 ? Colors.yellow : Colors.red), fillColor: Colors.black),
                thumbColor: primaryColor,
                activeTrackColor: requiredSkill < 35 ? Colors.green :(requiredSkill < 75 ? Colors.yellow : Colors.red),
                inactiveTrackColor: Colors.grey,
                showValueIndicator: ShowValueIndicator.always,
                valueIndicatorColor: primaryColor,
              ),
              child: Slider(
                min: 1,
                max: 100,
                value: requiredSkill.toDouble(),
                onChanged: (value) {
                  setState(() {
                    requiredSkill = value.toInt();
                  });
                },
                activeColor: primaryColor,
                inactiveColor: Colors.grey,

              ),
            ),
          ],
        ),
      ),
    );
  }
}
