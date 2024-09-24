import 'package:flutter/material.dart';
import 'package:log_my_ride/utils/constants.dart';

class NewOfficialDialog extends StatefulWidget {
  Function(dynamic) onOfficialCreated;
  Function(dynamic) onOfficialUpdated;
  Map<String, dynamic>? official;
  NewOfficialDialog({super.key, required this.onOfficialCreated, required this.onOfficialUpdated, this.official});

  @override
  State<NewOfficialDialog> createState() => _NewGroupDialogState();
}

class _NewGroupDialogState extends State<NewOfficialDialog> {

  var lmrId = '';
  var cost = 0;
  String type = 'Clerk';
  String accessLevel = 'View Only';

  late TextEditingController _lmrIdController;
  late TextEditingController _costController;


  var accessLevels = [
    'View Only',
    'Session Mgt',
    'Notification Mgt',
    'Rider Mgt',
    'Admin',

  ];

  var officialTypes = [
    'Clerk',
    'Flag',
    'Medical',
    'Secretary',
    'Volunteer',
    'Coach',
  ];


  @override
  void initState() {
    _lmrIdController = TextEditingController(text: widget.official != null ? widget.official!['lmrId'] : lmrId)..addListener(() {
      setState(() {
        lmrId = _lmrIdController.text;
      });
    });
    _costController = TextEditingController(text:  widget.official != null ? widget.official!['cost'].toString() : cost.toString() )..addListener(() {
      setState(() {
        cost = int.parse(_costController.text);
      });
    });


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(

      actions: [
        TextButton(
          onPressed: () {
            if(widget.official != null) {
              //update
              widget.onOfficialUpdated({
                'lmrId': lmrId,
                'type': type,
                'accessLevel': accessLevel,
                'cost': cost,

              });
            } else {
              //create group
              widget.onOfficialCreated({
                'lmrId': lmrId,
                'type': type,
                'accessLevel': accessLevel,
                'cost': cost,

              });
            }

            Navigator.pop(context);
          },
          child: const Text('Create Group', style: TextStyle(color: primaryColor),),
        )
      ],
      content: SizedBox(
        height: 340,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Create a new group', style: TextStyle(fontSize: 16)),
          
              const SizedBox(height: 25,),
              TextField(
                controller: _lmrIdController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: 'LMR ID',
                    hintText: 'LMR ID',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
              ),
              const SizedBox(height: 10,),

              TextField(
                controller: _costController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Official Cost(\$)',
                    hintText: 'Official Cost(\$)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                  )
                ),
              ),
              const SizedBox(height: 10,),

              DropdownButtonFormField(

                decoration: InputDecoration(
                    labelText: 'Official Type',
                    hintText: 'Official Type',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
                items: officialTypes.map((skill) {
                  return DropdownMenuItem(
                    value: skill,
                    child: Text(skill),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    type = value.toString();
                  });
                },
              ),
              const SizedBox(height: 10,),
              DropdownButtonFormField(
                decoration: InputDecoration(
                    labelText: 'Access Level',
                    hintText: 'Access Level',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                    )
                ),
                items: accessLevels.map((level) {
                  return DropdownMenuItem(
                    value: level, child: Text(level),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    accessLevel = value.toString();
                  });
                },
              ),
          
            ],
          ),
        ),
      ),
    );
  }
}
