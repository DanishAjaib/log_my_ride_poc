import 'package:flutter/material.dart';
import 'package:log_my_ride/utils/constants.dart';

class NewGroupDialog extends StatefulWidget {
  Function(dynamic) onGroupCreated;
  Function(dynamic) onGroupUpdated;
  Map<String, dynamic>? group;
  NewGroupDialog({super.key, required this.onGroupCreated, required this.onGroupUpdated, this.group});

  @override
  State<NewGroupDialog> createState() => _NewGroupDialogState();
}

class _NewGroupDialogState extends State<NewGroupDialog> {

  var groupName = '';
  var groupColor = Colors.blue;
  var groupSkill = 'Beginner';
  var groupCapacity = 10;
  var extraSessionTime = 0;
  var costToEnter = 0;

  late TextEditingController _nameController;
  late TextEditingController _skillController;
  late TextEditingController _capacityController;
  late TextEditingController _extraSessionTimeController;
  late TextEditingController _costToEnterController;


  var allSkills = [
    'Complete Beginner',
    'Beginner',
    'Intermediate',
    'Experienced Intermediate',
    'Advanced',
    'Highly Advanced',
    'Expert',
    'Master',
  ];

  var allColors = [
    {
      'name': 'Blue',
      'color': Colors.blue
    },
    {
      'name': 'Red',
      'color': Colors.red
    },
    {
      'name': 'Green',
      'color': Colors.green
    },
    {
      'name': 'Purple',
      'color': Colors.deepPurple
    },
    {
      'name': 'Yellow',
      'color': Colors.yellow
    }
  ];


  @override
  void initState() {
    _nameController = TextEditingController(text: widget.group != null ? widget.group!['name'] : groupName)..addListener(() {
      setState(() {
        groupName = _nameController.text;
      });
    });
    _skillController = TextEditingController(text:  widget.group != null ? widget.group!['skill'] : groupSkill )..addListener(() {
      setState(() {
        groupSkill = _skillController.text;
      });
    });
    _capacityController = TextEditingController(text:   widget.group != null ? widget.group!['capacity'].toString() : groupCapacity.toString())..addListener(() {
      setState(() {
        groupCapacity = int.parse(_capacityController.text);
      });
    });
    _extraSessionTimeController = TextEditingController(text:   widget.group != null ? widget.group!['extraSessionTime'].toString() : groupName.toString())..addListener(() {
      setState(() {
        extraSessionTime = int.parse(_extraSessionTimeController.text);
      });
    });
    _costToEnterController = TextEditingController(text: widget.group != null ? widget.group!['costToEnter'].toString() : costToEnter.toString())..addListener(() {
      setState(() {
        costToEnter = int.parse(_costToEnterController.text);
      });
    });
    groupSkill = widget.group != null ? widget.group!['skill'] : groupSkill;
    groupColor = widget.group != null ? widget.group!['color'] : groupColor;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(

      actions: [
        TextButton(
          onPressed: () {
            if(widget.group != null) {
              //update
              widget.onGroupUpdated({
                'name': groupName,
                'color': groupColor.value,
                'skill': groupSkill,
                'capacity': groupCapacity,
                'extraSessionTime': extraSessionTime,
                'costToEnter': costToEnter
              });
            } else {
              //create group
              widget.onGroupCreated({
                'name': groupName,
                'color': groupColor.value,
                'skill': groupSkill,
                'capacity': groupCapacity,
                'extraSessionTime': extraSessionTime,
                'costToEnter': costToEnter
              });
            }

            Navigator.pop(context);
          },
          child: const Text('Create Group', style: TextStyle(color: primaryColor),),
        )
      ],
      content: SizedBox(
        height: 450,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Create a new group', style: TextStyle(fontSize: 16)),
          
              const SizedBox(height: 25,),
              TextField(
                controller: _nameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: 'Group Name',
                    hintText: 'Enter group name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
              ),
              const SizedBox(height: 10,),

              TextField(
                controller: _capacityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Group Capacity',
                    hintText: 'Enter group capacity',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                  )
                ),
              ),
              const SizedBox(height: 10,),
              TextField(
                controller: _extraSessionTimeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Extra Session Time (mins)',
                    hintText: 'Time(mins)',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
              ),
              const SizedBox(height: 10,),
              TextField(
                controller: _costToEnterController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Cost to Enter (\$)',
                    hintText: 'Cost(\$)',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
              ),
              const SizedBox(height: 10,),
              DropdownButtonFormField(

                decoration: InputDecoration(
                    labelText: 'Group Skill',
                    hintText: 'Select group skill',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
                items: allSkills.map((skill) {
                  return DropdownMenuItem(
                    value: skill,
                    child: Text(skill),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    groupSkill = value.toString();
                  });
                },
              ),
              const SizedBox(height: 10,),
              DropdownButtonFormField(
                decoration: InputDecoration(
                    labelText: 'Group Color',
                    hintText: 'Select group color',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                    )
                ),
                items: allColors.map((color) {
                  return DropdownMenuItem(
                    value: color['color'],
                    child: Text(color['name'].toString(), style: TextStyle(color: color['color'] as MaterialColor)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    groupColor = value as MaterialColor;
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
