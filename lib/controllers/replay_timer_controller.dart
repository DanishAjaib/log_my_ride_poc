import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:log_my_ride/controllers/location_controller.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../utils/utils.dart';
import '../views/widgets/random_spline_chart.dart';

class ReplayTimerController extends GetxController {

  final Rx<Timer> timer = Timer(const Duration(milliseconds: 30), (){}).obs;
  final Rx<double> sliderValue = 0.0.obs;
  final Rx<bool> isPlaying = false.obs;
  final int interval = 30;

  List<SplineSeries<SpeedData, String>> splineData = [
    SplineSeries<SpeedData, String>(
      dataSource: generateSpeedData(20),
      xValueMapper: (SpeedData sales, _) => sales.time,
      yValueMapper: (SpeedData sales, _) => sales.speed,
      name: 'Speed',
      color: Colors.green,
    ),
    SplineSeries<SpeedData, String>(
      dataSource: generateRPMData(20),
      xValueMapper: (SpeedData sales, _) => sales.time,
      yValueMapper: (SpeedData sales, _) => sales.speed,
      name: 'RPM',
      color: Colors.green,
    ),
    SplineSeries<SpeedData, String>(
      dataSource: generateLeanAngleData(20),
      xValueMapper: (SpeedData sales, _) => sales.time,
      yValueMapper: (SpeedData sales, _) => sales.speed,
      name: 'Lean Angle',
      color: Colors.green,
    ),
  ];



  ReplayTimerController() {
   // _initializeTimer();
  }

  void updateSliderValue(double value) {
    print('updateSliderValue: $value');
    sliderValue.value = value;
    Get.find<LocationController>().updateUserMarker(Get.find<LocationController>().roadGeoPoints[sliderValue.value.toInt()]);
    //center map
    Get.find<LocationController>().controller.value.moveTo(Get.find<LocationController>().roadGeoPoints[sliderValue.value.toInt()]);
  }



  void startTimer() {
    timer.value = Timer.periodic(Duration(milliseconds: interval), (timer) {
      if(sliderValue.value <  splineData[0].dataSource.length - 1) {
        updateSliderValue(sliderValue.value + 1);
        Get.find<LocationController>().updateUserMarker(Get.find<LocationController>().roadGeoPoints[sliderValue.value.toInt()]);
        //center map
        Get.find<LocationController>().controller.value.moveTo(Get.find<LocationController>().roadGeoPoints[sliderValue.value.toInt()]);
      } else {
        timer.cancel();
        isPlaying.value = false;
      }
    });
  }

  void pauseTimer() {
    print('RideSessionSummary:pauseTimer');

    timer.value.cancel();
    isPlaying.value = false;

    //updateSliderValue(0.0);
  }

  void restartTimer() {
    print('RideSessionSummary:restartTimer');
    timer.value.cancel();
    isPlaying.value = false;
    updateSliderValue(0.0);
    startTimer();
  }



}