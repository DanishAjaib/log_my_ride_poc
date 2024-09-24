import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:log_my_ride/views/widgets/app_container.dart';
import 'package:log_my_ride/views/widgets/new_official_dialog.dart';

import '../../utils/constants.dart';
import 'new_group_dialog.dart';

class OfficialsWidget extends StatefulWidget {
  List<dynamic> officials;
  Function(dynamic) onChanged;
  OfficialsWidget({super.key, required this.officials, required this.onChanged});

  @override
  State<OfficialsWidget> createState() => _GroupsWidgetState();
}

class _GroupsWidgetState extends State<OfficialsWidget> {

  var officials = [];


  @override
  void initState() {
    officials = widget.officials;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Event Officials', style: TextStyle(fontSize: 14)),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: primaryColor, elevation: 0, shadowColor: Colors.transparent),
              onPressed: () {
                //show context menu at this location

                showDialog(context: context, builder: (context) {
                  return NewOfficialDialog(onOfficialCreated: (official) {
                    setState(() {
                      widget.officials.add(official);
                    });
                    widget.onChanged(widget.officials);

                  }, onOfficialUpdated: (group) {

                  },);
                });
              },
              child: const  Text('+', style: TextStyle(color: Colors.white, fontSize: 14)),
            ),
          ],

        ),
        const SizedBox(height: 10,),
        AppContainer(
          child: widget.officials.isNotEmpty ?
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.officials.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(widget.officials[index]['type'].toString()),
                subtitle: Row(
                  children: [
                    const Icon(Icons.attach_money, size: 16, color: primaryColor,),
                    Text('${widget.officials[index]['cost']}'),
                    const SizedBox(width: 10,),
                    const Icon(Icons.text_fields_rounded, size: 16, color: primaryColor,),
                    const SizedBox(width: 5,),
                    Text('${widget.officials[index]['lmrId']}'),
                    const SizedBox(width: 10,),
                    const Icon(Icons.security, size: 16, color: primaryColor,),
                    const SizedBox(width: 5,),
                    Text('${widget.officials[index]['accessLevel']}'),
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
                              title: const Text('Edit Official'),
                              onTap: () {
                                Navigator.pop(context);
                                //edit group
                                showDialog(context: context, builder: (context) {
                                  return NewOfficialDialog(onOfficialCreated: (group) {
                                    setState(() {
                                      widget.officials.add(group);
                                    });
                                    widget.onChanged(widget.officials);

                                  },
                                    official: widget.officials[index], onOfficialUpdated: (group) {
                                      setState(() {
                                        widget.officials[index] = group;
                                      });
                                      widget.onChanged(widget.officials);
                                    },
                                  );
                                });
                              },

                            ),
                            ListTile(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              title: const Text('Delete Official'),
                              onTap: () {
                                setState(() {
                                  widget.officials.removeAt(index);
                                });
                                widget.onChanged(widget.officials);
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
           const Center(child: Text('No officials added yet'),),
        )

      ],
    );
  }
}
