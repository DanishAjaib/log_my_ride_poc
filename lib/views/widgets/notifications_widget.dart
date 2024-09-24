import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:log_my_ride/utils/constants.dart';
import 'package:log_my_ride/views/widgets/app_container.dart';

class NotificationsWidget extends StatefulWidget {

  const NotificationsWidget({super.key});

  @override
  State<NotificationsWidget> createState() => _NotificationsWidgetState();
}

class _NotificationsWidgetState extends State<NotificationsWidget> {

  var notifications = [];
  var riderCrashDistance = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Notifications', style: TextStyle(fontSize: 14)),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: primaryColor, elevation: 0, shadowColor: Colors.transparent),
              onPressed: () {
                //show context menu at this location

                showDialog(context: context, builder: (context) {
                  return AlertDialog(
                    title: const Text('Notification Type'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          title: const Text('Notify a Rider Crash'),
                          onTap: () {
                            setState(() {
                              notifications.add({
                                'type': 'crash',
                                'message': 'Notify when a rider crashes'
                              });
                            });
                            //pop
                            Navigator.pop(context);
                          },

                        ),
                        ListTile(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          title: const Text('Notify if a rider is X kms from organizer'),
                          onTap: () {
                           // get value of X
                            Navigator.pop(context);
                            showDialog(context: context, builder: (context) {
                              return AlertDialog(
                                title: const Text('Distance from Organizer'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Enter distance in kms'),
                                    const SizedBox(height: 16),
                                    TextField(
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        riderCrashDistance = int.parse(value);
                                      },
                                      decoration: const InputDecoration(
                                        hintText: 'Distance in kms'
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    TextButton(
                                      onPressed: () {
                                        // get the value of distance
                                        setState(() {
                                          notifications.add({
                                            'type': 'distance',
                                            'message': 'Notify when a rider is $riderCrashDistance kms from organizer'
                                          });
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Save', style: TextStyle(color: Colors.grey)),
                                    )
                                  ],
                                ),
                              );
                            });
                          },

                        ),

                      ],
                    ),
                  );
                });
              },
              child: const  Text('+', style: TextStyle(color: Colors.white, fontSize: 14)),
            ),
          ],

        ),
        const SizedBox(height: 16),
        AppContainer(

          child: notifications.isNotEmpty ? ListView.builder(
            shrinkWrap: true,
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(notifications[index]['message']),
                trailing: IconButton(
                  onPressed: () {
                    setState(() {
                      notifications.removeAt(index);
                    });
                  },
                  icon: Icon(Icons.delete_outline, color: Colors.red,),
                ),
              );
            },
          ) : const Center(
            child: Text('No notifications set', style: TextStyle(color: Colors.grey),),
          ),
        ),
      ],
    );
  }
}
