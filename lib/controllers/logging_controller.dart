import 'dart:async';
import 'dart:math';
import 'package:get/get.dart' as lmrGet;
import 'package:log_my_ride/controllers/navigation_controller.dart';
import 'package:log_my_ride/views/widgets/random_spline_chart.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:io';
import 'package:rxdart/rxdart.dart';
import 'package:path_provider/path_provider.dart';

class LoggingController extends lmrGet.GetxController {
  double _x = 0.0, _y = 0.0, _z = 0.0;
  double _gyro_x = 0.0, _gyro_y = 0.0, _gyro_z = 0.0;
  lmrGet.RxDouble speed = 0.0.obs;
  lmrGet.RxDouble leanAngle = 0.0.obs;
  lmrGet.RxDouble rotation = 0.0.obs;
  double gravityValue = 9.8;
  lmrGet.RxDouble gforce = 0.0.obs;
  final double alpha = 0.8;
  List<double> gravity = [0.0, 0.0, 0.0];
  List<double> gyroscopeRotation = [0.0, 0.0, 0.0];
  double previousRotation = 0.0;
  lmrGet.RxList<SpeedData> chartData = <SpeedData>[].obs;
  double previousLeanAngle = 0.0;
  double alphaRotation = 0.1;
  double leanAngleThreshold = 0.5;

  Timer? mapRotationTimer;
  Timer? sensorTimer;

  double rotationThreshold = 5.0;
  double previousRotationAngle = 0.0;

  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;

  lmrGet.RxInt timeElapsed = 0.obs;

  List<dynamic> eventBatch = [];
  lmrGet.Rx<DateTime> startTime = DateTime.now().obs;

  lmrGet.RxList<Map<String, dynamic>> dataRows = <Map<String, dynamic>>[].obs;

  LoggingController();

  void startSensorStreams() {
    startTime.value = DateTime.now();
    sensorTimer = Timer.periodic(const Duration(milliseconds: 20), (timer) {
      timeElapsed.value = DateTime.now().difference(startTime.value).inMilliseconds;
    });
    _accelerometerSubscription = accelerometerEventStream(
      samplingPeriod: const Duration(milliseconds: 20),
    ).throttleTime(const Duration(seconds: 1)).listen((AccelerometerEvent event) {
      _processAccelerometerData(event);
    });

    _gyroscopeSubscription = gyroscopeEventStream(
      samplingPeriod: const Duration(milliseconds: 20),
    ).throttleTime(const Duration(seconds: 1)).listen((GyroscopeEvent event) {
      _processGyroscopeData(event);
    });

  }
  void stopSensorStreams() {

    _accelerometerSubscription?.cancel();
    _gyroscopeSubscription?.cancel();
    timeElapsed.value = 0;

    sensorTimer?.cancel();

  }

  /*void initializeSensors() {
    // Accelerometer
    accelerometerEventStream(
      samplingPeriod: const Duration(seconds: 2),

    ).throttleTime(const Duration(milliseconds: 500)).listen((AccelerometerEvent event) {
      // Process accelerometer data without using compute
      _processAccelerometerData(event);
      //eventBatch.add(event);
    });

    // Gyroscope
    gyroscopeEventStream(
      samplingPeriod: const Duration(seconds: 2),
    ).throttleTime(const Duration(milliseconds: 500)).listen((GyroscopeEvent event) {
      // Process gyroscope data without using compute
      _processGyroscopeData(event);
      //eventBatch.add(event);
    });

    *//*_startSensorTimer();*//*
  }*/

  @override
  void dispose() {
    mapRotationTimer?.cancel();
    sensorTimer?.cancel();
    timeElapsed.value = 0;
    super.dispose();
  }

 /* void _processSensorBatch() {


    if (eventBatch.isNotEmpty) {
      // Calculate the time elapsed from the start time for each event
      DateTime currentTime = DateTime.now();
      AccelerometerEvent? latestAccelerometerEvent;
      GyroscopeEvent? latestGyroscopeEvent;


      for (var event in eventBatch) {
        Map<String, dynamic>? eventRow;
        *//*Map<String, dynamic> eventRow = {
          'timeElapsed': timeElapsed.inMilliseconds,  // Time elapsed in milliseconds
          'latitude': Get.find<NavigationController>().currentPosition.value.latitude,
          'longitude': Get.find<NavigationController>().currentPosition.value.longitude,
          'speed': speed.value,
          'leanAngle': leanAngle.value,
          'rotation': rotation.value,
        };*//*

        // Add the accelerometer or gyroscope data to the row
        if (event is AccelerometerEvent) {
          latestAccelerometerEvent = event;
          _processAccelerometerData(event);

        } else if (event is GyroscopeEvent) {
          latestGyroscopeEvent = event;
          _processGyroscopeData(event);
        }

          latestAccelerometerEvent = null;
          latestGyroscopeEvent = null;
      }

      appendRowsToFile(dataRows);
      // Clear the event batch after processing
      eventBatch.clear();
    }
  }*/

  void _processAccelerometerData(AccelerometerEvent event) {

    _x = event.x;
    _y = event.y;
    _z = event.z;

    gforce.value = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
    // Subtract gravity from the Z-axis to account for Earth's gravity
    final double adjustedZ = event.z - gravityValue;

    // Calculate the raw lean angle using the adjusted Z value
    final double rawLeanAngle = atan2(event.y, adjustedZ) * (180 / pi);

    // Apply the low-pass filter and update the lean angle
    final double filteredLeanAngle = alpha * rawLeanAngle + (1 - alpha) * previousLeanAngle;

    // Update lean angle only if it changed significantly
    if ((filteredLeanAngle - previousLeanAngle).abs() > leanAngleThreshold) {
      leanAngle.value = filteredLeanAngle;
      previousLeanAngle = filteredLeanAngle;

      // Check if we should rotate the camera (only if angle changes by rotationThreshold)
      if ((filteredLeanAngle - previousRotationAngle).abs() > rotationThreshold) {
        // Rotate the camera based on the lean angle
        //Get.find<NavigationController>().controller.value.rotateMapCamera(leanAngle.value);
        previousRotationAngle = filteredLeanAngle; // Update previous rotation angle
      }
    }

    // Calculate the speed
    final double currentSpeed = sqrt(event.x * event.x + event.y * event.y + adjustedZ * adjustedZ);
    if (currentSpeed < 1.0) {
      speed.value = 0.0;
    } else {
      speed.value = currentSpeed;
    }

    Map<String, dynamic> eventRow = {
      'timeElapsed': (DateTime.now().difference(startTime.value).inMilliseconds), // Time elapsed in milliseconds
      'latitude': lmrGet.Get.find<NavigationController>().currentPosition.value.latitude,
      'longitude': lmrGet.Get.find<NavigationController>().currentPosition.value.longitude,
      'speed': speed.value,
      'leanAngle': leanAngle.value,
      'rotation': rotation.value,
      'x': event.x,
      'y': event.y,
      'z': event.z,
      'gyro_x': null,
      'gyro_y': null,
      'gyro_z': null,
    };
    dataRows.add(eventRow);
    dataRows.refresh();
  }

  void _processGyroscopeData(GyroscopeEvent event) {

    _gyro_x = event.x;
    _gyro_y = event.y;
    _gyro_z = event.z;

    // Calculate the raw rotation value
    final double rawRotation = atan2(event.y, event.x) * (180 / pi);

    // Apply low-pass filter
    final double filteredRotation = alpha * rawRotation + (1 - alpha) * previousRotation;

    // Update the observable value
    rotation.value = filteredRotation;

    // Save the filtered value for the next iteration
    previousRotation = filteredRotation;
    //Get.find<NavigationController>().controller.value.rotateMapCamera(rotation.value);

    Map<String, dynamic> eventRow = {
      'timeElapsed': (DateTime.now().difference(startTime.value).inMilliseconds), // Time elapsed in milliseconds
      'latitude': lmrGet.Get.find<NavigationController>().currentPosition.value.latitude,
      'longitude': lmrGet.Get.find<NavigationController>().currentPosition.value.longitude,
      'speed': speed.value,
      'leanAngle': leanAngle.value,
      'rotation': rotation.value,
      'x': null,
      'y': null,
      'z': null,
      'gyro_x': event.x,
      'gyro_y': event.y,
      'gyro_z': event.z,
    };
    if(dataRows.length > 1000){
      appendRowsToFile(dataRows);
      dataRows.clear();
    } else {
      dataRows.add(eventRow);
      dataRows.refresh();
    }

  }
  }

/*  void startSensorTimer() {
    startTime = DateTime.now();


    sensorTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      _processSensorBatch();
    });
  }

  void cancelSensorTimer() {
    sensorTimer?.cancel();
  }*/

  void appendRowsToFile(List<Map<String, dynamic>> dataRows) async{

    if (dataRows.isNotEmpty) {
      // Append the data rows to the file
      final appDir = await getApplicationDocumentsDirectory();
      final logsDir = Directory('${appDir.path}/logs');
      await logsDir.create(recursive: true);

      final file = File('${logsDir.path}/session_logs.csv');
      if(await file.exists()) {
        await file.delete();
      }
      await file.writeAsString(dataRows.map((row) => row.values.join(',')).join('\n'));

    }
  }



