import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:log_my_ride/views/widgets/app_container.dart';

import '../../controllers/vehicles_controller.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';

class NewVehicleDialog extends StatefulWidget {

  NewVehicleDialog({super.key});

  @override
  State<NewVehicleDialog> createState() => _NewVehicleDialogState();
}

class _NewVehicleDialogState extends State<NewVehicleDialog> {
  var allVehicleTypes = ['Supermoto', 'Road Sport', 'Road Touring', 'Enduro', 'Adventure', 'Cruiser', 'Naked', 'Scooter', 'Classic', 'Trail', 'MX','Custom', 'Other'];
  var selectedVehicleType = 'Supermoto';

  var allVehicleCategories = ['Motorcycle', 'Car', 'Truck','Boat', 'Bicycle', 'Other'];
  var selectedVehicleCategory = 'Motorcycle';
  String selectedImagePath = '';

  //controllers
  late TextEditingController _nameController;
  late TextEditingController _frontWheelDiameterController;
  late TextEditingController _rearWheelDiameterController;
  late TextEditingController _tyreDiameterController;
  late TextEditingController _frontSuspensionController;
  late TextEditingController _rearSuspensionController;
  late TextEditingController _frontReboundController;
  late TextEditingController _rearReboundController;
  late TextEditingController _frontCompressionController;
  late TextEditingController _rearCompressionController;
  late TextEditingController _frontPreloadController;
  late TextEditingController _rearPreloadController;


  @override
  void initState() {
    _nameController = TextEditingController();
    _frontWheelDiameterController = TextEditingController();
    _rearWheelDiameterController = TextEditingController();
    _tyreDiameterController = TextEditingController();
    _frontSuspensionController = TextEditingController();
    _rearSuspensionController = TextEditingController();
    _frontReboundController = TextEditingController();
    _rearReboundController = TextEditingController();
    _frontCompressionController = TextEditingController();
    _rearCompressionController = TextEditingController();
    _frontPreloadController = TextEditingController();
    _rearPreloadController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _frontWheelDiameterController.dispose();
    _rearWheelDiameterController.dispose();
    _tyreDiameterController.dispose();
    _frontSuspensionController.dispose();
    _rearSuspensionController.dispose();
    _frontReboundController.dispose();
    _rearReboundController.dispose();
    _frontCompressionController.dispose();
    _rearCompressionController.dispose();
    _frontPreloadController.dispose();
    _rearPreloadController.dispose();

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create a new vehicle'),
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
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                    labelText: 'Vehicle Name',
                    hintText: 'Enter vehicle name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField(
                items: allVehicleCategories.map((e) => DropdownMenuItem(child: Text(e), value: e)).toList(),
                value: selectedVehicleCategory,
                onChanged: (value) {
                  setState(() {
                    selectedVehicleCategory = value!;
                  });
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField(
                items: allVehicleTypes.map((e) => DropdownMenuItem(child: Text(e), value: e)).toList(),
                value: selectedVehicleType,
                onChanged: (value) {
                  setState(() {
                    selectedVehicleType = value!;
                  });
                },
              ),
              const SizedBox(height: 10),
              const Text('Configuration'),
              const SizedBox(height: 10),
              //front/rear diameter row
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _frontWheelDiameterController,

                decoration: InputDecoration(
                    labelText: 'Front Wheel Diameter (inches)',
                    hintText: 'Enter front wheel diameter',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
              ),
              //rear wheel diameter
              TextFormField(
                controller: _rearWheelDiameterController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Rear Wheel Diameter (inches)',
                    hintText: 'Enter rear wheel diameter',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
              ),
              //tyre diameter
              const SizedBox(height: 10),
              TextFormField(
                controller: _tyreDiameterController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Tyre Diameter (inches)',
                    hintText: 'Enter tyre diameter',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
              ),
              const SizedBox(height: 10),
              // front suspension
              TextFormField(
                controller: _frontSuspensionController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Front Suspension',
                    hintText: 'Enter front suspension',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
              ),
              const SizedBox(height: 10),
              //rear suspension
              TextFormField(
                controller: _rearSuspensionController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Rear Suspension',
                    hintText: 'Enter rear suspension',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
              ),
              const SizedBox(height: 10),
              // front rebound
              TextFormField(
                controller: _frontReboundController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Front Rebound',
                    hintText: 'Enter front rebound',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
              ),
              const SizedBox(height: 10),
              //rear rebound

              TextFormField(

                controller: _rearReboundController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Rear Rebound',
                    hintText: 'Enter rear rebound',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
              ),
              //front suspension
              const SizedBox(height: 10),
              TextFormField(
                controller: _frontCompressionController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Front Compression',
                    hintText: 'Enter front compression',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
              ),
              const SizedBox(height: 10),
              //rear suspension
              TextFormField(
                controller: _rearCompressionController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Rear Compression',
                    hintText: 'Enter rear compression',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
              ),
              const SizedBox(height: 10),
              //front compression
              TextFormField(
                controller: _frontPreloadController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Front Preload',
                    hintText: 'Enter front preload',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
              ),
              const SizedBox(height: 10),
              //rear compression
              TextFormField(
                controller: _rearPreloadController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Rear Preload',
                    hintText: 'Enter rear preload',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
              ),
              const SizedBox(height: 10),
              //add button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                  onPressed: () {
                    //save vehicle
                    var vehicle = {
                      'name': _nameController.text,
                      'category': selectedVehicleCategory,
                      'type': selectedVehicleType,
                      'frontWheelDiameter': _frontWheelDiameterController.text,
                      'rearWheelDiameter': _rearWheelDiameterController.text,
                      'tyreDiameter': _tyreDiameterController.text,
                      'frontSuspension': _frontSuspensionController.text,
                      'rearSuspension': _rearSuspensionController.text,
                      'frontRebound': _frontReboundController.text,
                      'rearRebound': _rearReboundController.text,
                      'frontCompression': _frontCompressionController.text,
                      'rearCompression': _rearCompressionController.text,
                      'frontPreload': _frontPreloadController.text,
                      'rearPreload': _rearPreloadController.text,
                      'imagePath': selectedImagePath,
                    };
                    Get.find<VehiclesController>().addVehicle(vehicle);
                    Navigator.pop(context, vehicle);
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
