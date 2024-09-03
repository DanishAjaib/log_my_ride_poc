import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:log_my_ride/models/session.dart';
import 'package:log_my_ride/models/track.dart';
import 'package:log_my_ride/models/user.dart';

import '../models/vehicle.dart';

class UserController extends GetxController {

  final RxString email = ''.obs;
  final RxString password = ''.obs;
  final RxBool rememberMe = false.obs;
  final RxList<User> currentUser = <User>[].obs;
  final RxList<Vehicle> vehicles = <Vehicle>[].obs;
  final RxList<Session> sessions = <Session>[].obs;
  final RxList<Track> tracks = <Track>[].obs;

  UserController(){
    onInit();
  }

  //init
  @override
  void onInit() {
    print('UserController onInit');
    getCurrentUser();

    super.onInit();
  }

  void setEmail(String value) {
    email.value = value;
  }

  void setPassword(String value) {
    password.value = value;
  }

  void setRememberMe(bool value) {
    rememberMe.value = value;
  }



  getCurrentUser() async {
    var allUsers = await FirebaseFirestore.instance.collection('users').get();
    //return random user
    var randomUser = User.fromJson(allUsers.docs[Random().nextInt(allUsers.docs.length)].data());
    currentUser.value = [randomUser];
    getUserVehicles(currentUser.first);
    getUserSessions(currentUser.value.first);
    getUserTracks(currentUser.value.first);

  }

  void getUserVehicles(User user) async {
    if(kDebugMode) print('getUserVehicles');
    var allVehicles = await FirebaseFirestore.instance.collection('vehicles').where('user_id', isEqualTo: currentUser.first.uid).get();

    for (var element in allVehicles.docs) {
      vehicles.add(Vehicle.fromJson(element.data()));
    }
  }

  void getUserSessions(User first) async {
     if(kDebugMode) print('getUserSessions');
    var userSessions = await FirebaseFirestore.instance.collection('sessions').where('user_id', isEqualTo: currentUser.first.uid).get();
    for (var element in userSessions.docs) {
      sessions.add(Session.fromJson(element.data()));
    }
  }

  void getUserTracks(User first) async {
    if(kDebugMode) print('getUserTracks');
    var userTracks = await FirebaseFirestore.instance.collection('tracks').where('user_id', isEqualTo: currentUser.first.uid).get();
    for (var element in userTracks.docs) {
      tracks.add(Track.fromJson(element.data()));
    }

  }
}

