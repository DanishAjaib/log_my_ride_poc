import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:log_my_ride/controllers/sensors_controller.dart';
import 'package:log_my_ride/views/widgets/app_container.dart';

import '../../controllers/vehicles_controller.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';

class NewSensorDialog extends StatefulWidget {

  NewSensorDialog({super.key});

  @override
  State<NewSensorDialog> createState() => _NewVehicleDialogState();
}

class _NewVehicleDialogState extends State<NewSensorDialog> {
  var allSensorCategories  = ['Car', 'Bike', 'Truck', 'Boat', 'Motorcycle', 'Other'];
  var selectedSensorCategory = 'Car';
  var allSensorTypes = ['LMR Box', 'RaceBox', 'WitMotion', 'Phone', 'BT', 'Other'];
  var selectedSensorType = 'LMR Box';


  String selectedImagePath = '';
  var sensorId = '';



  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create a new sensor'),
      content: SizedBox(
        width: 350,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,

            children: [
              //vehicle thumbnail
              if(selectedImagePath.isEmpty)
                AppContainer(
                  height: 100,
                  padding: 10,
                  child:  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        TextButton(

                          onPressed: () async {
                            // image picker
                            var imagePath = await captureAndStoreImage();
                            setState(() {
                              selectedImagePath = imagePath;
                            });


                          },
                          style: TextButton.styleFrom(backgroundColor: primaryColor, elevation: 0, shadowColor: Colors.transparent),
                          child: const Icon(LineIcons.camera, color: Colors.white, size: 30,),
                        )
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 10),
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
                    height: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(File(selectedImagePath), fit: BoxFit.cover,),
                    ),
                  ),
                ),

              const SizedBox(height: 10),
              //sensor type
              DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: 'Sensor Category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                value: selectedSensorCategory,
                onChanged: (String? value) {
                  setState(() {
                    selectedSensorCategory = value!;
                  });
                },
                items: allSensorCategories.map((String category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              //sensor type
              DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: 'Sensor Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                value: selectedSensorType,
                onChanged: (String? value) {
                  setState(() {
                    selectedSensorType = value!;
                  });
                },
                items: allSensorTypes.map((String type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
              ),
              if(selectedSensorType == 'LMR Box')
                ...[
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Sensor ID',
                      hintText: 'Sensor ID',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (String value) {
                      setState(() {
                        sensorId = value;
                      });
                    },
                  ),
                ],
              const SizedBox(height: 10),
              //add button


              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                  onPressed: () {
                    //save sensor
                    var sensor = {
                      'category': selectedSensorCategory,
                      'type': selectedSensorType,
                      'id': sensorId.isNotEmpty ? sensorId : '',
                      'imagePath': selectedImagePath,
                    } as Map<String, dynamic>;
                    Get.find<SensorsController>().

                    addSensor(sensor);
                    Navigator.pop(context);
                  },
                  child: const Text('Add Vehicle', style: TextStyle(color: Colors.white),),
                ),
              )


            ],
          ),
        ),
      ),
    );
  }
}
