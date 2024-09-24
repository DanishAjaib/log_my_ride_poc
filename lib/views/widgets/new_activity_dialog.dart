import 'package:flutter/material.dart';
import 'package:log_my_ride/utils/constants.dart';
import 'package:log_my_ride/utils/utils.dart';

class NewActivityDialog extends StatefulWidget {
  Function(dynamic) onActivityCreated;
  Function(dynamic) onActivityUpdated;
  Map<String, dynamic>? activity;
  NewActivityDialog({super.key, required this.onActivityCreated, required this.onActivityUpdated, this.activity});

  @override
  State<NewActivityDialog> createState() => _NewGroupDialogState();
}

class _NewGroupDialogState extends State<NewActivityDialog> {

  var activityname = '';
  var activityStartTime = '';
  var activityEndTime = '';
  var activityStartLocation = '';
  var activityEndLocation = '';


  late TextEditingController _nameController;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;
  late TextEditingController _startLocationController;
  late TextEditingController _endLocationController;






  @override
  void initState() {

    _nameController = TextEditingController(text: activityname)..addListener(() {
      activityname = _nameController.text;
    });

    _startTimeController = TextEditingController(text: activityStartTime)..addListener(() {
      activityStartTime = _startTimeController.text;
    });

    _endTimeController = TextEditingController(text: activityEndTime)..addListener(() {
      activityEndTime = _endTimeController.text;
    });

    _startLocationController = TextEditingController(text: activityStartLocation)..addListener(() {
      activityStartLocation = _startLocationController.text;
    });

    _endLocationController = TextEditingController(text: activityEndLocation)..addListener(() {
      activityEndLocation = _endLocationController.text;
    });


    if(widget.activity != null) {
      activityname = widget.activity!['name'];
      activityStartTime = widget.activity!['startTime'];
      activityEndTime = widget.activity!['endTime'];
      activityStartLocation = widget.activity!['startLocation'];
      activityEndLocation = widget.activity!['endLocation'];
    }


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(

      actions: [
        TextButton(
          onPressed: () {
            if(widget.activity != null) {
              //update
              widget.onActivityUpdated({
                'name': activityname,
                'startTime': activityStartTime,
                'endTime': activityEndTime,
                'startLocation': activityStartLocation,
                'endLocation': activityEndLocation,
              });
            } else {
              //create group
              widget.onActivityCreated({
                'name': activityname,
                'startTime': activityStartTime,
                'endTime': activityEndTime,
                'startLocation': activityStartLocation,
                'endLocation': activityEndLocation,
              });
            }

            Navigator.pop(context);
          },
          child: const Text('Create Activity', style: TextStyle(color: primaryColor),),
        )
      ],
      content: SizedBox(
        height: 450,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Create a new activity', style: TextStyle(fontSize: 16)),
          
              const SizedBox(height: 25,),
              TextField(
                controller: _nameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: 'Activity Name',
                    hintText: 'Enter activity name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
              ),
              const SizedBox(height: 10,),

              //activity start time
              TextField(
                readOnly: true,
                controller: _startTimeController,
                onTap: () async {
                  showTimePicker(context: context, initialTime: TimeOfDay.now()).then((value) {
                    if(value != null) {
                      setState(() {
                        activityStartTime = formatTimeOfDay(value);
                        _startTimeController.text = activityStartTime;
                      });
                    }
                  });

                },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: 'Activity Start Time',
                    hintText: 'Enter start time',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
              ),
              const SizedBox(height: 10,),
              //activity end time
              TextField(
                readOnly: true,
                controller: _endTimeController,
                onTap: () async {
                  showTimePicker(context: context, initialTime: TimeOfDay.now())
                  .then((time) {
                    if(time != null) {
                      setState(() {
                        activityEndTime = formatTimeOfDay(time);
                        _endTimeController.text = activityEndTime;
                      });
                    }
                  });

                },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: 'Activity End Time',
                    hintText: 'Enter end time',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
              ),
              const SizedBox(height: 10,),
              TextField(
                controller: _startLocationController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: 'Activity Start Location',
                    hintText: 'Enter start location',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
              ),
              const SizedBox(height: 10,),
              //end location
              TextField(
                controller: _endLocationController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: 'Activity End Location',
                    hintText: 'Enter end location',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
              ),


          
            ],
          ),
        ),
      ),
    );
  }
}
