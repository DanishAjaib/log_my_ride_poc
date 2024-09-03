import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/user_controller.dart';

class MyVehiclesScreen extends StatefulWidget {
  const MyVehiclesScreen({super.key});

  @override
  State<MyVehiclesScreen> createState() => _MyVehiclesScreenState();
}

class _MyVehiclesScreenState extends State<MyVehiclesScreen> {

  var userController = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          showDialog(context: context, builder: (context) => AlertDialog(
            title: const Text('Add Vehicle'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Vehicle Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 5),
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Vehicle Image URL',
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Add your onPressed code here!
                  },
                  child: const Text('Add Vehicle'),
                ),
              ],
            ),
          ));
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      appBar: AppBar(

        title: Text('My Vehicles'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Obx(() {
          if (userController.vehicles.isEmpty) {
            return const Center(child: Text('No vehicles added yet'));
          }
          return ListView.builder(
            itemCount: userController.vehicles.length,
            itemBuilder: (context, index) {
              var vehicle = userController.vehicles[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                height: 100,
                child: ElevatedButton(
                  onLongPress: () {
                    // show edit/delete

                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  onPressed: () {},
                  child: Row(
                    children: [
                      SizedBox(
                        height: 60,
                        width: 60,
                        child: CircleAvatar(

                          backgroundImage: NetworkImage(vehicle.image),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(vehicle.vehicle_name),
                          Text(DateFormat('dd-MM-yyyy').format(DateTime.fromMicrosecondsSinceEpoch(vehicle.created_at))),
                        ],
                      ),
                      const Spacer(),
                      const Icon(Icons.edit_note),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
