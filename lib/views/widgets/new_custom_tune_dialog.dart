import 'package:faker/faker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:log_my_ride/utils/constants.dart';

class NewCustomTuneDialog extends StatefulWidget {

  Function()? onTuneCreated;
  NewCustomTuneDialog({super.key , this.onTuneCreated});

  @override
  State<NewCustomTuneDialog> createState() => _NewCustomTuneDialogState();
}

class _NewCustomTuneDialogState extends State<NewCustomTuneDialog> {

  var vehicles = List.generate(5, (index) => faker.vehicle.make());
  //select  from a list of sessions

  var selectedSensorData = '';
  var selectedCSVFile = '';
  late var uniqueVehicles = vehicles.toSet().toList();
  bool sending = false;

  bool vehicleGeometry = false;
  bool riderTimes = true;
  bool includeAll = true;


  var selectedVehicle = '';

  @override
  void initState() {

    uniqueVehicles = vehicles.toSet().toList();

    selectedVehicle = uniqueVehicles[0];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Custom Tune'),
      content: SizedBox(
        width: Get.width * 0.9,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              //problem description
              TextFormField(
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Problem Description',
                ),
              ),
              //select a vehicle
              const SizedBox(height: 8,),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Select a Vehicle',
                ),
                items: uniqueVehicles.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  //do something
                  setState(() {
                    selectedVehicle = newValue!;
                  });
                },
              ),
              //select a tune
              const SizedBox(height: 15,),
              Align(
                alignment: Alignment.centerLeft,
                  child: Text('Sensor Data', style: TextStyle(color: primaryColor),),
              ),
              //upload csv
              const SizedBox(height: 15,),
              SizedBox(
                width: Get.width * 0.9,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedCSVFile.isNotEmpty ? Colors.lightGreen : null,

                  ),
                  label: Text(selectedCSVFile.isNotEmpty ? selectedCSVFile : 'Upload CSV', style: TextStyle(color: selectedCSVFile.isNotEmpty ? Colors.black : Colors.white),),
                  icon: Icon(selectedCSVFile.isNotEmpty ? LineIcons.checkCircleAlt :LineIcons.upload , color: selectedCSVFile.isNotEmpty ? Colors.black : Colors.white,),
                  onPressed: () async {
                    //do something
                    FilePickerResult? result = await FilePicker.platform.pickFiles();

                    if (result != null) {
                      setState(() {
                        selectedCSVFile = result.files.single.name;
                        selectedSensorData = '';
                      });
                    }

                  },
                ),
              ),
              const SizedBox(height: 8,),
              SizedBox(
                width: Get.width * 0.9,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedSensorData.isNotEmpty ? Colors.lightGreen : null,

                  ),

                  label: Text( selectedSensorData.isNotEmpty ? selectedSensorData : 'Select Previously Recorded', style: TextStyle(color: selectedSensorData.isNotEmpty ? Colors.black : Colors.white),),
                  icon: Icon(selectedSensorData.isNotEmpty ? LineIcons.checkCircleAlt : LineIcons.list , color: selectedSensorData.isNotEmpty ? Colors.black : Colors.white,),
                  onPressed: () {
                    //show recorded rides
                     showModalBottomSheet(context: context, builder: (context) {
                       return SizedBox(
                         height: 400,
                         child: ListView.builder(
                           itemCount: 5,
                           itemBuilder: (context, index) {
                             return ListTile(
                               title: Text('Session $index'),
                               onTap: () {
                                 setState(() {
                                   selectedSensorData = 'Session $index';
                                   selectedCSVFile = '';
                                 });
                                 Navigator.pop(context);
                               },
                             );
                           },
                         ),
                       );
                     });

                  },
                ),
              ),
              const SizedBox(height: 15,),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Vehicle Data', style: TextStyle(color: primaryColor),),
              ),
              //a lsit of switches
              const SizedBox(height: 15,),
              //vehicle geometry switch

              InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  setState(() {
                    vehicleGeometry = !vehicleGeometry;
                  });
                },
                child: Row(
                  children: [
                    const Text('Vehicle Geometry'),
                    const Spacer(),
                    Switch(
                      trackColor: vehicleGeometry ? WidgetStateProperty.all(primaryColor) :  WidgetStateProperty.all(Colors.grey),
                      thumbColor: WidgetStateProperty.all(Colors.white),
                      value: vehicleGeometry,
                      onChanged: (value) {
                        //do something
                        setState(() {
                          vehicleGeometry = value;
                        });
                      },
                    )
                  ],
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  setState(() {
                    riderTimes = !riderTimes;
                  });
                },
                child: Row(
                  children: [
                    const Text('Rider Times'),
                    const Spacer(),
                    Switch(
                      trackColor: riderTimes ? WidgetStateProperty.all(primaryColor) :  WidgetStateProperty.all(Colors.grey),
                      thumbColor: WidgetStateProperty.all(Colors.white),
                      value: riderTimes,
                      onChanged: (value) {
                        //do something
                        setState(() {
                          riderTimes = value;
                        });
                      },
                    )
                  ],
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  setState(() {
                    includeAll = !includeAll;
                    riderTimes = includeAll;
                    vehicleGeometry = includeAll;
                  });
                },
                child: Row(
                  children: [
                    const Text('Include All'),
                    const Spacer(),
                    Switch(
                      trackColor: includeAll ? WidgetStateProperty.all(primaryColor) :  WidgetStateProperty.all(Colors.grey),
                      thumbColor: WidgetStateProperty.all(Colors.white),
                      value: includeAll,
                      onChanged: (value) {
                        //do something
                        setState(() {
                          includeAll = value;
                          riderTimes = value;
                          vehicleGeometry = value;
                        });
                      },
                    )
                  ],
                ),
              ),


              const SizedBox(height: 80,),
              SizedBox(
                width: Get.width * 0.9,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                  ),
                  onPressed: () {
                    setState(() {
                      sending = true;
                    });
                    Future.delayed(const Duration(seconds: 2), () {
                      setState(() {
                        sending = false;
                        widget.onTuneCreated!();

                        Navigator.pop(context);
                      });
                    });

                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if(sending) const SizedBox(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator(color: Colors.white,),
                      ) else
                      const Text('Send to Tuner' , style: TextStyle(color: Colors.black),)
                    ],
                  ),
                ),
              )


            ],
          ),
        ),
      ),
    );
  }
}
