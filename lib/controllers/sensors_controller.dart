import 'package:faker/faker.dart';
import 'package:get/get.dart';

class SensorsController extends GetxController {
   var sensors = [
     {
       'category': 'Car',
       'type': 'WitMotion',
     },
     {
       'category': 'Motorcycle',
       'type': 'LMRBox',
       'id': faker.guid.guid(),
     },
      {
        'category': 'Bike',
        'type': 'RaceBox',
      },
      {
        'category': 'Truck',
        'type': 'LMRBox',
        'id': faker.guid.guid(),
      },



   ].obs as RxList<Map<String, dynamic>>;

    void addSensor(Map<String, dynamic> sensor){
      sensors.add(sensor);
    }

    void updateSensor(Map<String, dynamic> sensor){
      var index = sensors.indexWhere((element) => element['id'] == sensor['id']);
      sensors[index] = sensor;
    }

    void removeSensor(Map<String, dynamic> sensor){
      sensors.remove(sensor);
    }
}