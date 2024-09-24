import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:log_my_ride/utils/animated_indexed_stack.dart';
import 'package:log_my_ride/utils/custom_thumb_shape.dart';
import 'package:log_my_ride/utils/utils.dart';
import 'package:log_my_ride/views/screens/main_screen.dart';
import 'package:log_my_ride/views/widgets/app_container.dart';
import 'package:log_my_ride/views/widgets/dummy_map_container.dart';
import 'package:log_my_ride/views/widgets/groups_widget.dart';
import 'package:log_my_ride/views/widgets/new_group_dialog.dart';
import 'package:log_my_ride/views/widgets/notifications_widget.dart';
import 'package:log_my_ride/views/widgets/officials_widget.dart';

import '../../utils/constants.dart';
import '../widgets/rider_skill_selector.dart';

class NewRidePromoterEventScreen extends StatefulWidget {


  const NewRidePromoterEventScreen({super.key});

  @override
  State<NewRidePromoterEventScreen> createState() => _NewRidePromoterEventScreenState();
}

class _NewRidePromoterEventScreenState extends State<NewRidePromoterEventScreen> {

  var _selectedType = {'Road'};
  var _selectedTripType = {'Return'};
  var allTripTypes = {'Return', 'One-Way'};
  var allTypes = {'Road', 'Track'};
  var currentIndex = 0;
  var _selectedSurfaceType = {'Dirt'};
  var allSurfaceTypes = {'Dirt', 'Tar'};
  var selectedRideTime = 60;
  var allRiderAllowedTypes = {'Everyone', 'Friends Only', 'Manually Approved'};
  var _selectedRiderAllowedType = {'Everyone'};
  var _selectedTripCategoryType = {'Enduro'};
  var allTripCategoryTypes = {'Enduro', 'Road', 'Sprint'};
  var _selectedTripVisibilityType = {'Public'};
  var allVisibilityTypes = {'Public', 'Private'};

  bool placesofInterest = true;
  bool registeredUsers = true;
  bool crashAlerts = true;
  bool riderDistance = true;

  String selectedImagePath = '';
  int requiredSkill = 75;

  List<String> selectedStops = [];
  List<String> selectedPlaces = [];

  late TextEditingController placeNameController;
  late TextEditingController stopNameController;

  bool markAsActive = false;
  bool isRidePublic = false;

  String openTo = 'Everyone';
  List<dynamic> eventGroups = [];
  List<dynamic> eventOfficials = [];



  TimeOfDay? selectedTime;

  @override
  void initState() {
    placeNameController = TextEditingController();
    stopNameController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            child: ElevatedButton(


              onPressed: () {
                setState(() {
                  if(currentIndex > 0) {
                    currentIndex--;
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(color: Colors.white),
                backgroundColor: currentIndex > 0 ? primaryColor : Colors.grey,
                padding: const EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
              child: const Text('Back'),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            child: ElevatedButton(

              onPressed: () {
                setState(() {
                  if(currentIndex < 2) {
                    currentIndex++;
                  } else {
                    showDialog(context: context, builder: (context) {
                      return StatefulBuilder(builder: (context, setState) {
                        return AlertDialog(
                          title: const Text('Ride Saved'),
                          content: SizedBox(
                            height: 200,
                            child: Column(
                              children: [
                                SwitchListTile(
                                    splashRadius: 10,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    title: const Text('Mark as Active'),
                                    activeColor: Colors.white,
                                    inactiveThumbColor: primaryColor,

                                    inactiveTrackColor: Colors.black,
                                    activeTrackColor: primaryColor,
                                    subtitle: const Text('Mark this ride as active'),
                                    value: markAsActive, onChanged: (value) {
                                  setState(() {
                                    markAsActive = value;
                                  });
                                }
                                ),
                                SwitchListTile(
                                    splashRadius: 10,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    title: const Text('Visibility'),
                                    activeColor: Colors.white,
                                    inactiveThumbColor: primaryColor,

                                    inactiveTrackColor: Colors.black,
                                    activeTrackColor: primaryColor,

                                    subtitle: const Text('Set to Public and Private'),
                                    value: isRidePublic, onChanged: (value) {
                                  setState(() {
                                    isRidePublic = value;
                                  });
                                }
                                ),

                              ],
                            ),
                          ),
                          actions: [

                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Get.to(() => const MainScreen());
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                FirebaseFirestore.instance.collection('rides').add({
                                  'type': _selectedType.first,
                                  'tripType': _selectedTripType.first,
                                  'eventType': 'Promoter - Road',
                                  'surfaceType': _selectedSurfaceType.first,
                                  'rideTime': selectedRideTime,
                                  'stops': selectedStops,
                                  'places': selectedPlaces,
                                  'placesOfInterest': placesofInterest,
                                  'registeredUsers': registeredUsers,
                                  'crashAlerts': crashAlerts,
                                  'riderDistance': riderDistance,
                                  'riderAllowed': _selectedRiderAllowedType.first,
                                  'requiredSkill': requiredSkill,
                                  'markAsActive': markAsActive,
                                  'isPublic': isRidePublic,
                                  'createdBy': 'user1',
                                  'createdOn': DateTime.now(),
                                  'rideName': 'Ride Name',
                                  'startLocation': 'Start Location',
                                  'endLocation': 'End Location',
                                  'eventDate': DateTime.now(),
                                  'imagePath': selectedImagePath,
                                });
                                Get.to(() => const MainScreen());

                              },
                              child: const Text('Continue'),
                            ),
                          ],
                        );
                      });
                    });
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(color: Colors.white),
                backgroundColor: currentIndex < 2 ? primaryColor : Colors.grey,
                padding: const EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
              child: const Text('Next'),
            ),
          )
        ],
      ),
      appBar: AppBar(
        title: const Text('Create a new ride'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: Row(
                    children: [
                      Text('RIDE SUMMARY', style: TextStyle(color: currentIndex == 0 ? primaryColor : Colors.grey, fontWeight: currentIndex == 0 ? FontWeight.bold : FontWeight.normal),),
                      const SizedBox(width: 20,),
                      Text('JOURNEY DETAILS', style: TextStyle(color: currentIndex == 1 ? primaryColor : Colors.grey, fontWeight: currentIndex == 1 ? FontWeight.bold : FontWeight.normal),),
                      const SizedBox(width: 20,),
                      Text('RIDE SETTINGS', style: TextStyle(color: currentIndex == 2 ? primaryColor : Colors.grey, fontWeight: currentIndex == 2 ? FontWeight.bold : FontWeight.normal),),
                      const SizedBox(width: 20,),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              AnimatedIndexedStack(
                  index: currentIndex,
                  children: [
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //event thumbnail
                          if(selectedImagePath.isEmpty)
                            AppContainer(
                              height: 180
                              ,
                              padding: 10,
                              child:  Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(LineIcons.image, size:50, color: Colors.grey),
                                    const SizedBox(height: 10),
                                    TextButton(

                                      onPressed: () async {
                                        // image picker
                                        var imagePath = await captureAndStoreImage();
                                        setState(() {
                                          selectedImagePath = imagePath;
                                        });


                                      },
                                      style: TextButton.styleFrom(backgroundColor: primaryColor, elevation: 0, shadowColor: Colors.transparent),
                                      child: const Text('Browse'),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          if(selectedImagePath.isNotEmpty)
                            InkWell(
                              onTap: () async {
                                // image picker
                                var imagePath = await captureAndStoreImage();
                                setState(() {
                                  selectedImagePath = imagePath;
                                });
                              },
                              child: AppContainer(
                                height: 200,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(File(selectedImagePath), fit: BoxFit.cover,),
                                ),
                              ),
                            ),
                          AppContainer(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Ride type'),
                                      SizedBox(
                                        height: 40,
                                        child: ToggleButtons(
                                          borderRadius: BorderRadius.circular(50),
                                          selectedBorderColor: primaryColor,
                                          isSelected: [
                                            _selectedType.contains('Road'),
                                            _selectedType.contains('Track'),
                                          ],
                                          onPressed: (value) {
                                            setState(() {
                                              _selectedType =  {allTypes.elementAt(value)};
                                            });
                                          },
                                          children: allTypes.map((e) {
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
                                          }).toList(),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 25,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Trip type'),
                                      SizedBox(
                                        height: 40,
                                        child: ToggleButtons(
                                          borderRadius: BorderRadius.circular(50),
                                          selectedBorderColor: primaryColor,
                                          isSelected: [
                                            _selectedTripType.contains('Return'),
                                            _selectedTripType.contains('One-Way'),
                                          ],
                                          onPressed: (value) {
                                            setState(() {
                                              _selectedTripType =  {allTripTypes.elementAt(value)};
                                            });
                                          },
                                          children: allTripTypes.map((e) {
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
                                          }).toList(),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 25,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Event Category'),
                                      SizedBox(
                                        height: 40,
                                        child: ToggleButtons(
                                          borderRadius: BorderRadius.circular(50),
                                          selectedBorderColor: primaryColor,
                                          isSelected: [
                                            _selectedTripCategoryType.contains('Enduro'),
                                            _selectedTripCategoryType.contains('Road'),
                                            _selectedTripCategoryType.contains('Sprint'),
                                          ],
                                          onPressed: (value) {
                                            setState(() {
                                              _selectedTripCategoryType =  {allTripCategoryTypes.elementAt(value)};
                                            });
                                          },
                                          children: allTripCategoryTypes.map((e) {
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
                                          }).toList(),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 25,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Visibility'),
                                      SizedBox(
                                        height: 40,
                                        child: ToggleButtons(
                                          borderRadius: BorderRadius.circular(50),
                                          selectedBorderColor: primaryColor,
                                          isSelected: [
                                            _selectedTripVisibilityType.contains('Public'),
                                            _selectedTripVisibilityType.contains('Private'),
                                          ],
                                          onPressed: (value) {
                                            setState(() {
                                              _selectedTripVisibilityType =  {allVisibilityTypes.elementAt(value)};
                                            });
                                          },
                                          children: allVisibilityTypes.map((e) {
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
                                          }).toList(),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height:15),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Min Rider Skill'),
                                      TextButton(
                                        onPressed: () {
                                          showDialog(context: context, builder: (context) {
                                            return RiderSkillSelector(
                                                requiredSkill: requiredSkill,
                                                callback: (skill) {
                                                  setState(() {
                                                    requiredSkill = skill;
                                                  });
                                                });
                                          });
                                        },
                                        style: TextButton.styleFrom(
                                            elevation: 0, shadowColor: Colors.transparent,
                                            textStyle: const TextStyle(color: primaryColor)),
                                        child: Text(requiredSkill.toString(), style: const TextStyle(color: primaryColor, fontSize: 22),),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height:15),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Open To'),
                                      TextButton(
                                        onPressed: () {
                                          showDialog(context: context, builder: (context) {
                                            return AlertDialog(
                                              title: const Text('Open To'),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  ListTile(
                                                    title: const Text('Everyone'),
                                                    onTap: () {
                                                      setState(() {
                                                        openTo = 'Everyone';
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text('Friends Only'),
                                                    onTap: () {
                                                      setState(() {
                                                        openTo = 'Friends Only';
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text('Manually Approved'),
                                                    onTap: () {
                                                      setState(() {
                                                        openTo = 'Manually Approved';
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          });

                                        },
                                        style: TextButton.styleFrom(
                                            elevation: 0, shadowColor: Colors.transparent,
                                            textStyle: const TextStyle(color: primaryColor)),
                                        child: Text(openTo.toString(), style: const TextStyle(color: Colors.white,),),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          AppContainer(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  TextFormField(

                                    decoration: const InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: primaryColor),
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                      ),
                                      suffixIcon: Icon(LineIcons.edit),
                                      suffixIconColor: primaryColor,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                      ),
                                      labelText: 'Ride name',
                                      hintText: 'Enter Ride name',
                                    ),
                                  ),
                                  const SizedBox(height: 10,),
                                  TextFormField(
                                    onTap: () {
                                      showDateRangePicker(
                                          context: context,
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime.now().add(const Duration(days: 365))
                                      );
                                    },
                                    readOnly: true,
                                    decoration: const InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: primaryColor),
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                      ),
                                      suffixIcon: Icon(LineIcons.calendar),
                                      suffixIconColor: primaryColor,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                      ),
                                      labelText: 'Event Date',
                                      hintText: 'Select Event Dates',
                                    ),
                                  ),
                                  const SizedBox(height: 10,),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: primaryColor),
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                      ),
                                      suffixIcon: Icon(LineIcons.mapMarker),
                                      suffixIconColor: primaryColor,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                      ),
                                      labelText: 'Start Location',
                                      hintText: 'Start Location',
                                    ),
                                  ),
                                  const SizedBox(height: 10,),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: primaryColor),
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                      ),
                                      suffixIcon: Icon(LineIcons.mapMarker),
                                      suffixIconColor: primaryColor,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                      ),
                                      labelText: 'End Location',
                                      hintText: 'End Location',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                    //journey details
                    SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          DummyMapContainer(width: double.infinity, height: 150),
                          const SizedBox(height: 10,),
                          AppContainer(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Surface Type'),
                                      SizedBox(
                                        height: 40,
                                        child: ToggleButtons(
                                          borderRadius: BorderRadius.circular(50),
                                          selectedBorderColor: primaryColor,
                                          isSelected: [
                                            _selectedSurfaceType.contains('Dirt'),
                                            _selectedSurfaceType.contains('Tar'),
                                          ],
                                          onPressed: (value) {
                                            setState(() {
                                              if(_selectedSurfaceType.contains(allSurfaceTypes.elementAt(value))) {
                                                _selectedSurfaceType.remove(allSurfaceTypes.elementAt(value));
                                              } else {
                                                _selectedSurfaceType.add(allSurfaceTypes.elementAt(value));
                                              }
                                            });
                                          },
                                          children: allSurfaceTypes.map((e) {
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
                                          }).toList(),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Planned Arrival Time'),
                                      TextButton(
                                        onPressed: () {
                                          showTimePicker(
                                              context: context,
                                              builder: (context, child) {
                                                return Theme(
                                                  data: ThemeData.dark().copyWith(
                                                    colorScheme: const ColorScheme.dark(primary: primaryColor),
                                                  ),
                                                  child: child!,
                                                );
                                              },
                                              initialTime: TimeOfDay.now()
                                          ).then((value) {
                                            setState(() {
                                              selectedTime = value;
                                            });
                                          });
                                        },
                                        style: TextButton.styleFrom(
                                            elevation: 0, shadowColor: Colors.transparent,
                                            textStyle: const TextStyle(color: primaryColor)),
                                        child: Text(selectedTime == null ? 'Select Time' : formatTimeOfDay(selectedTime)),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Add Stops'),
                              TextButton(
                                onPressed: () {
                                  //show dialog to add stops
                                  showDialog(context: context, builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Add Stops'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextFormField(
                                            controller: stopNameController,
                                            decoration: const InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: primaryColor),
                                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                              ),
                                              suffixIcon: Icon(LineIcons.mapMarker),
                                              suffixIconColor: primaryColor,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                              ),
                                              labelText: 'Stop Location',
                                              hintText: 'Stop Location',
                                            ),
                                          ),

                                          const SizedBox(height: 10,),

                                        ],
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

                                            setState(() {
                                              selectedStops.add(stopNameController.text);
                                            });
                                          },
                                          child: const Text('Add'),
                                        )
                                      ],
                                    );
                                  });
                                },
                                style: TextButton.styleFrom(backgroundColor: primaryColor, elevation: 0, shadowColor: Colors.transparent),
                                child: const Text('+'),
                              )
                            ],
                          ),
                          const SizedBox(height: 10,),
                          AppContainer(
                            child:  selectedStops.isEmpty ? const Center(child: Text('No Stops added yet'),) : ListView.builder(
                              shrinkWrap: true,
                              itemCount: selectedStops.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(selectedStops.elementAt(index)),
                                  trailing: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedStops.removeAt(index);
                                      });
                                    },
                                    icon: const Icon(LineIcons.trash, color: Colors.red,),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Add Places'),
                              TextButton(
                                onPressed: () {
                                  //show dialog to add stops
                                  showDialog(context: context, builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Add Place'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextFormField(
                                            controller: placeNameController,

                                            decoration: const InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: primaryColor),
                                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                              ),
                                              suffixIcon: Icon(LineIcons.mapMarker),
                                              suffixIconColor: primaryColor,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                              ),
                                              labelText: 'Place',
                                              hintText: 'Place',
                                            ),
                                          ),

                                          const SizedBox(height: 10,),

                                        ],
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

                                            if(placeNameController.text.isNotEmpty)
                                              {
                                                setState(() {
                                                  selectedPlaces.add(placeNameController.text);
                                                });
                                              }
                                          },
                                          child: const Text('Add'),
                                        )
                                      ],
                                    );
                                  });
                                },
                                style: TextButton.styleFrom(backgroundColor: primaryColor, elevation: 0, shadowColor: Colors.transparent),
                                child: const Text('+'),
                              )
                            ],
                          ),

                          const SizedBox(height: 10,),
                          AppContainer(
                            child:  selectedPlaces.isEmpty ? const Center(child: Text('No Places added yet'),) : ListView.builder(
                              shrinkWrap: true,
                              itemCount: selectedPlaces.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(selectedPlaces.elementAt(index)),
                                  trailing: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedPlaces.removeAt(index);
                                      });
                                    },
                                    icon: const Icon(LineIcons.trash, color: Colors.red,),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 10,),

                          //Add Groups
                          GroupsWidget(
                            groups: eventGroups,
                            onChanged: (groups) {
                              setState(() {
                                eventGroups = groups;
                              });
                            },
                          ),
                          const SizedBox(height: 10,),

                          //add officials
                          OfficialsWidget(officials: eventOfficials, onChanged: (officials) {
                            setState(() {
                              eventOfficials = officials;
                            });
                          }),



                        ],
                      ),
                    ),
                    //ride settings
                    const SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NotificationsWidget(),
                          /*AppContainer(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [


                                const SizedBox(height: 10,),

                                SwitchListTile(
                                  activeColor: Colors.white,
                                  inactiveThumbColor: primaryColor,

                                  inactiveTrackColor: Colors.black,
                                  activeTrackColor: primaryColor,

                                  subtitle: const Text('Enable/Disable Push Notifications for places of interest', style: TextStyle(color: Colors.grey),),
                                  value: placesofInterest,
                                  onChanged: (value) {
                                    setState(() {
                                      placesofInterest = value;
                                    });
                                  }, title: const Text('Places of Interest'),
                                ),
                                SwitchListTile(
                                  activeColor: Colors.white,
                                  inactiveThumbColor: primaryColor,

                                  inactiveTrackColor: Colors.black,
                                  activeTrackColor: primaryColor,

                                  subtitle: const Text('Allow organizers to send push notifications to registered users', style: TextStyle(color: Colors.grey),),
                                  value: registeredUsers,
                                  onChanged: (value) {
                                    setState(() {
                                      registeredUsers = value;
                                    });
                                  }, title: const Text('Registered Users'),
                                ),
                                SwitchListTile(
                                  activeColor: Colors.white,
                                  inactiveThumbColor: primaryColor,

                                  inactiveTrackColor: Colors.black,
                                  activeTrackColor: primaryColor,

                                  subtitle: const Text('Allow push notifications when a crash is detected', style: TextStyle(color: Colors.grey),),
                                  value: crashAlerts,
                                  onChanged: (value) {
                                    setState(() {
                                      crashAlerts = value;
                                    });
                                  }, title: const Text('Crash Alerts'),
                                ),
                                SwitchListTile(
                                  activeColor: Colors.white,
                                  inactiveThumbColor: primaryColor,

                                  inactiveTrackColor: Colors.black,
                                  activeTrackColor: primaryColor,

                                  subtitle: const Text('Allow Push notifications if a rider distance is greater than X km from the organiser', style: TextStyle(color: Colors.grey),),
                                  value: riderDistance,
                                  onChanged: (value) {
                                    setState(() {
                                      riderDistance = value;
                                    });
                                  }, title: const Text('Rider Distance'),
                                ),


                                //Allow Push notifications if a rider distance is greater than X km from the organiser



                              ],
                            ),
                          ),
                          AppContainer(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:  CrossAxisAlignment.start,
                                    children: [
                                      const Text('Riders Allowed'),
                                      const SizedBox(height: 10,),
                                      SizedBox(
                                        height: 40,
                                        child: ToggleButtons(
                                          borderRadius: BorderRadius.circular(50),
                                          selectedBorderColor: primaryColor,
                                          isSelected: [
                                            _selectedRiderAllowedType.contains('Everyone'),
                                            _selectedRiderAllowedType.contains('Friends Only'),
                                            _selectedRiderAllowedType.contains('Manually Approved'),
                                          ],
                                          onPressed: (value) {
                                            setState(() {
                                              _selectedRiderAllowedType =  {allRiderAllowedTypes.elementAt(value)};
                                            });
                                          },
                                          children: allRiderAllowedTypes.map((e) {
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
                                          }).toList(),
                                        ),
                                      )
                                    ],
                                  ),



                                ],
                              ),
                            ),
                          ),
                          AppContainer(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10,),
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
                                  ]
                              ),
                            ),
                          )*/
                        ],
                      ),
                    ),
                  ]
              ),

            ],
          ),
        ),
      ),
    );
  }

  String formatRideDuration(int selectedRideTime) {
    //format in this format: 30 mins, 1 hour, 1 hour 30 mins
    if(selectedRideTime < 60) {
      return '$selectedRideTime mins';
    } else {
      int hours = selectedRideTime ~/ 60;
      int mins = selectedRideTime % 60;
      if(mins == 0) {
        return '$hours hours';
      } else {
        return '$hours hrs $mins min';
      }
    }
  }
}
