import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:log_my_ride/utils/constants.dart';

import '../../controllers/user_controller.dart';
import '../../models/track.dart';
import '../../models/vehicle.dart';

class StartSessionDialog extends StatefulWidget {

  Vehicle? selectedVehicle;
  Track? selectedTrack;
  Function(Vehicle, Track) onSessionStart;
  StartSessionDialog({super.key, required this.onSessionStart});

  @override
  State<StartSessionDialog> createState() => _StartSessionDialogState();
}

class _StartSessionDialogState extends State<StartSessionDialog> {

  var userController = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Start a new session'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          const Text('Select a vehicle'),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                icon: const Icon(Icons.arrow_drop_down),
                value: widget.selectedVehicle == null ? userController.vehicles.first.vehicle_name.toString() : widget.selectedVehicle!.vehicle_name,
                items: userController.vehicles.map((vehicle) {
                  return DropdownMenuItem<String>(
                    value: vehicle!.vehicle_name.toString(),
                    child: Text(vehicle.vehicle_name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    widget.selectedVehicle = userController.vehicles.firstWhere((element) => element.vehicle_name == value);
                    if (kDebugMode) print('Selected Vehicle: $value');
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text('Select a track'),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                icon: const Icon(Icons.arrow_drop_down),
                value: widget.selectedTrack == null ? userController.tracks.first.track_name.toString() : widget.selectedTrack!.track_name,
                items: userController.tracks.map((track) {
                  return DropdownMenuItem<String>(
                    value: track.track_name.toString(),
                    child: Text(track.track_name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    widget.selectedTrack = userController.tracks.firstWhere((element) => element.track_name == value);
                    if (kDebugMode) print('Selected Track: $value');
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 30),
         SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                widget.onSessionStart(widget.selectedVehicle!, widget.selectedTrack!);
              },
              child: const Text('Start'),
            ),
         )
        ],
      ),
    );
  }
}
