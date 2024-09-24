import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../../utils/constants.dart';

class NewSessionDialog extends StatefulWidget {

  Function onSessionCreated;
  Function onSessionUpdated;
  Map<String, dynamic>? session;
  NewSessionDialog({super.key, required this.onSessionCreated, required this.onSessionUpdated, this.session});

  @override
  State<NewSessionDialog> createState() => _NewSessionDialogState();
}

class _NewSessionDialogState extends State<NewSessionDialog> {
  var selectedSessionStartType = {'Manual'};
  var allSessionStartTypes = ['Manual', 'Auto', 'Last Rider via Gps'];
  var selectedSessionEndType = {'Manual'};
  var allSessionEndTypes = ['Manual', 'Last Rider via Gps'];
  var sessionDuration = 30;
  var autoStartDelay = 15;

  @override
  void initState() {

    if(widget.session != null) {
      sessionDuration = widget.session!['sessionDuration'];
      autoStartDelay = widget.session!['autoStartDelay'];
      selectedSessionStartType = widget.session!['selectedSessionStartType'];
      selectedSessionEndType = widget.session!['selectedSessionEndType'];
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Session'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            //Session Duration
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                suffixIcon: Icon(LineIcons.stopwatch),
                suffixIconColor: primaryColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                labelText: 'Session Duration(mins)',
                hintText: 'Enter Session Duration',
              ),
            ),
            const SizedBox(height: 10,),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                suffixIcon: Icon(LineIcons.stopwatch),
                suffixIconColor: primaryColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                labelText: 'Auto Start Delay(mins)',
                hintText: 'Start Delay in mins',
              ),
            ),
            const SizedBox(height: 10,),
            //Session Start : Manual, Auto, Last Rider via Gps
            Text('Session Start'),
            const SizedBox(height: 10,),
            ToggleButtons(
                borderRadius: BorderRadius.circular(50),
                selectedBorderColor: primaryColor,
                isSelected:  [
                  selectedSessionStartType.contains('Manual'),
                  selectedSessionStartType.contains('Auto'),
                  selectedSessionStartType.contains('Last Rider via Gps')
                ] ,
                onPressed: (value) {
                  setState(() {
                    selectedSessionStartType = {allSessionStartTypes.elementAt(value)};
                  });
                },
                children:  allSessionStartTypes.map((e) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: SizedBox(
                      height: 30,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(e.toString(), style: const TextStyle(fontSize: 12,),),
                        ],
                      ),
                    ),
                  );
                }).toList()),

            const SizedBox(height: 10,),
            //Session Start : Manual, Auto, Last Rider via Gps
            Text('Session End'),
            const SizedBox(height: 10,),
            ToggleButtons(
                borderRadius: BorderRadius.circular(50),
                selectedBorderColor: primaryColor,
                isSelected:  [
                  selectedSessionEndType.contains('Manual'),
                  selectedSessionEndType.contains('Last Rider via Gps')
                ] ,
                onPressed: (value) {
                  setState(() {
                    selectedSessionEndType = {allSessionEndTypes.elementAt(value)};
                  });
                },
                children:  allSessionEndTypes.map((e) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: SizedBox(
                      height: 30,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(e.toString(), style: const TextStyle(fontSize: 12,),),
                        ],
                      ),
                    ),
                  );
                }).toList()),


            const SizedBox(height: 10,),

          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);

          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);

            widget.onSessionCreated({
              'sessionDuration': sessionDuration,
              'autoStartDelay': autoStartDelay,
              'selectedSessionStartType': selectedSessionStartType,
              'selectedSessionEndType': selectedSessionEndType,
            });
          },
          child: const Text('Add'),
        )
      ],
    );
  }
}
