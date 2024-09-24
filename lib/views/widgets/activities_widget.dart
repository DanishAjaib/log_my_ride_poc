import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:log_my_ride/views/widgets/app_container.dart';
import 'package:log_my_ride/views/widgets/new_activity_dialog.dart';

import '../../utils/constants.dart';
import 'new_group_dialog.dart';

class ActivitiesWidget extends StatefulWidget {
  List<dynamic> activities;
  Function(dynamic) onChanged;

  ActivitiesWidget({super.key, required this.activities, required this.onChanged});

  @override
  State<ActivitiesWidget> createState() => _GroupsWidgetState();
}

class _GroupsWidgetState extends State<ActivitiesWidget> {

  var activities = [];


  @override
  void initState() {
    activities = widget.activities;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Event Activities', style: TextStyle(fontSize: 14)),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: primaryColor, elevation: 0, shadowColor: Colors.transparent),
              onPressed: () {
                //show context menu at this location

                showDialog(context: context, builder: (context) {
                  return NewActivityDialog(onActivityCreated: (activity) {
                    setState(() {
                      widget.activities.add(activity);
                    });
                    widget.onChanged(widget.activities);

                  }, onActivityUpdated: (activity) {

                  },);
                });
              },
              child: const  Text('+', style: TextStyle(color: Colors.white, fontSize: 14)),
            ),
          ],

        ),
        const SizedBox(height: 10,),
        AppContainer(
          child: widget.activities.isNotEmpty ?
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.activities.length,
            itemBuilder: (context, index) {
              return ListTile(

                title: Text(widget.activities[index]['name'].toString()),
                subtitle: Row(
                  children: [
                    const Icon(LineIcons.clockAlt, size: 16, color: primaryColor,),
                    const SizedBox(width: 5,),
                    Text('${widget.activities[index]['startTime']}', style: const TextStyle(fontSize: 10),),
                    //horizontal line

                    const SizedBox(
                      width: 50,
                      child: Divider(
                        color: primaryColor,
                        thickness: 1,
                        height: 1,
                        indent: 5,
                        endIndent: 5,
                      ),
                    ),

                    Text('${widget.activities[index]['endTime']}' , style: const TextStyle(fontSize: 10),),

                  ],
                ),

                trailing: TextButton(
                  onPressed: () {

                    showDialog(context: context, builder: (context) {
                      return AlertDialog(
                        title: const Text('Group Options'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              title: const Text('Edit Group'),
                              onTap: () {
                                Navigator.pop(context);
                                //edit group
                                showDialog(context: context, builder: (context) {
                                  return NewActivityDialog(onActivityCreated: (activity) {
                                    setState(() {
                                      widget.activities.add(activity);
                                    });
                                    widget.onChanged(widget.activities);

                                  },
                                    activity: widget.activities[index], onActivityUpdated: (activity) {
                                      setState(() {
                                        widget.activities[index] = activity;
                                      });
                                      widget.onChanged(widget.activities);
                                    },
                                  );
                                });


                              },

                            ),
                            ListTile(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              title: const Text('Delete Group'),
                              onTap: () {
                                setState(() {
                                  widget.activities.removeAt(index);
                                });
                                widget.onChanged(widget.activities);
                                Navigator.pop(context);
                              },

                            ),
                          ],
                        ),
                      );
                    });
                  },
                  child: const Text('...'),
                ),
              );
            },
          ) :
           const Center(child: Text('No activities created yet'),),
        )

      ],
    );
  }
}
