import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:log_my_ride/views/widgets/app_container.dart';
import 'package:log_my_ride/views/widgets/new_official_dialog.dart';
import 'package:log_my_ride/views/widgets/new_session_dialog.dart';

import '../../utils/constants.dart';
import 'new_group_dialog.dart';

class SessionsWidget extends StatefulWidget {
  List<dynamic> sessions;
  Function(dynamic) onChanged;
  SessionsWidget({super.key, required this.sessions, required this.onChanged});

  @override
  State<SessionsWidget> createState() => _GroupsWidgetState();
}

class _GroupsWidgetState extends State<SessionsWidget> {

  var officials = [];


  @override
  void initState() {
    officials = widget.sessions;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Add Sessions', style: TextStyle(fontSize: 14)),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: primaryColor, elevation: 0, shadowColor: Colors.transparent),
              onPressed: () {
                //show context menu at this location

                showDialog(context: context, builder: (context) {
                  return NewSessionDialog(onSessionCreated: (session) {
                    setState(() {
                      widget.sessions.add(session);
                    });
                    widget.onChanged(widget.sessions);

                  }, onSessionUpdated: (group) {

                  },);
                });
              },
              child: const  Text('+', style: TextStyle(color: Colors.white, fontSize: 14)),
            ),
          ],

        ),
        const SizedBox(height: 10,),
        AppContainer(
          child: widget.sessions.isNotEmpty ?
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.sessions.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Session ${index + 1}'),
                subtitle: Row(
                  children: [
                    const Text('Start '),
                    Text('${widget.sessions[index]['selectedSessionStartType'].first}', style: const TextStyle(color: primaryColor),),
                    const SizedBox(width: 10,),
                    const Text('End '),
                    Text('${widget.sessions[index]['selectedSessionEndType'].first}', style: const TextStyle(color: primaryColor),),

                  ],
                ),
                trailing: TextButton(
                  onPressed: () {

                    showDialog(context: context, builder: (context) {
                      return AlertDialog(
                        title: const Text('Session Options'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              title: const Text('Edit Session'),
                              onTap: () {
                                Navigator.pop(context);
                                //edit group
                                showDialog(context: context, builder: (context) {
                                  return NewSessionDialog(
                                      onSessionCreated: (session) {

                                      },
                                      onSessionUpdated: (session) {
                                        setState(() {
                                          widget.sessions[index] = session;
                                        });
                                        widget.onChanged(widget.sessions);

                                      });
                                });
                              },

                            ),
                            ListTile(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              title: const Text('Delete Session'),
                              onTap: () {
                                setState(() {
                                  widget.sessions.removeAt(index);
                                });
                                widget.onChanged(widget.sessions);
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
           const Center(child: Text('No sessions added yet'),),
        )

      ],
    );
  }
}
