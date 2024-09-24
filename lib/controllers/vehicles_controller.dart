import 'package:get/get.dart';

class VehiclesController extends GetxController {
  var vehicles = [
    {
      'name': 'Yamaha R1',
      'category': 'Sport',
      'type': 'Motorcycle',
      'diameter': {
        'front': 17,
        'rear': 17,
      },
      'pressure': {
        'front': 32,
        'rear': 32,
      },
      'suspension': {
        'front': 5,
        'rear': 5,
      },
      'rebound': {
        'front': 5,
        'rear': 5,
      },
      'compression': {
        'front': 5,
        'rear': 5,
      },
      'preload': {
        'front': 5,
        'rear': 5,
      },
    },
    {
      'name': 'Yamaha R6',
      'category': 'Sport',
      'type': 'Motorcycle',
      'diameter': {
        'front': 17,
        'rear': 17,
      },
      'pressure': {
        'front': 32,
        'rear': 32,
      },
      'suspension': {
        'front': 5,
        'rear': 5,
      },
      'rebound': {
        'front': 5,
        'rear': 5,
      },
      'compression': {
        'front': 5,
        'rear': 5,
      },
      'preload': {
        'front': 5,
        'rear': 5,
      },
    },
    {
      'name': 'Yamaha R3',
      'category': 'Sport',
      'type': 'Motorcycle',
      'diameter': {
        'front': 17,
        'rear': 17,
      },
      'pressure': {
        'front': 32,
        'rear': 32,
      },
      'suspension': {
        'front': 5,
        'rear': 5,
      },
      'rebound': {
        'front': 5,
        'rear': 5,
      },
      'compression': {
        'front': 5,
        'rear': 5,
      },
      'preload': {
        'front': 5,
        'rear': 5,
      },
    },



  ].obs as RxList<Map<String, dynamic>>;

  @override
  void onInit() {
    super.onInit();
  }

  void addVehicle(Map<String, dynamic> vehicle) {
    vehicles.add(vehicle);
  }

  void removeVehicle(Map<String, dynamic> vehicle) {
    vehicles.remove(vehicle);
  }

  void updateVehicle(Map<String, dynamic> vehicle) {
    var index = vehicles.indexWhere((element) => element['id'] == vehicle['id']);
    vehicles[index] = vehicle;
  }
}