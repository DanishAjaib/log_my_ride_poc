import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:log_my_ride/views/widgets/app_container.dart';

import '../../utils/constants.dart';
import 'new_group_dialog.dart';

class GroupsWidget extends StatefulWidget {
  List<dynamic> groups;
  Function(dynamic) onChanged;
  GroupsWidget({super.key, required this.groups, required this.onChanged});

  @override
  State<GroupsWidget> createState() => _GroupsWidgetState();
}

class _GroupsWidgetState extends State<GroupsWidget> {

  var groups = [];


  @override
  void initState() {
    groups = widget.groups;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Event Groups', style: TextStyle(fontSize: 14)),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: primaryColor, elevation: 0, shadowColor: Colors.transparent),
              onPressed: () {
                //show context menu at this location

                showDialog(context: context, builder: (context) {
                  return NewGroupDialog(onGroupCreated: (groups) {
                    setState(() {
                      widget.groups.add(groups);
                    });
                    widget.onChanged(widget.groups);

                  }, onGroupUpdated: (group) {

                  },);
                });
              },
              child: const  Text('+', style: TextStyle(color: Colors.white, fontSize: 14)),
            ),
          ],

        ),
        const SizedBox(height: 10,),
        AppContainer(
          child: widget.groups.isNotEmpty ?
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.groups.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color(widget.groups[index] ['color']),
                ),
                title: Text(widget.groups[index]['skill'].toString()),
                subtitle: Row(
                  children: [
                    const Icon(Icons.people, size: 16, color: primaryColor,),
                    const SizedBox(width: 5,),
                    Text('${widget.groups[index]['capacity']}'),
                    const SizedBox(width: 10,),
                    const Icon(Icons.attach_money_outlined, size: 16, color: primaryColor,),
                    Text('${widget.groups[index]['costToEnter']}'),
                    const SizedBox(width: 10,),
                    const Icon(Icons.timer, size: 16, color: primaryColor,),
                    const SizedBox(width: 5,),
                    Text('${widget.groups[index]['extraSessionTime']}'),
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
                                  return NewGroupDialog(onGroupCreated: (group) {
                                    setState(() {
                                      widget.groups.add(group);
                                    });
                                    widget.onChanged(widget.groups);

                                  },
                                    group: widget.groups[index], onGroupUpdated: (group) {
                                      setState(() {
                                        widget.groups[index] = group;
                                      });
                                      widget.onChanged(widget.groups);
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
                                  widget.groups.removeAt(index);
                                });
                                widget.onChanged(widget.groups);
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
           const Center(child: Text('No groups created yet'),),
        )

      ],
    );
  }
}
