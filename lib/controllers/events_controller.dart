import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class EventController extends GetxController {

  EventController();

  final _events = <Map<String, dynamic>>[].obs;
  List<Map<String, dynamic>> get events => _events;

  StreamSubscription? _subscription;

  @override
  void onInit() {
    super.onInit();
    listenToEvents();
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }



  void publishEvent(Map<String, dynamic> event) {
    print('Publishing : ${event['eventId']}');
    FirebaseFirestore.instance.collection('rides').doc(event['eventId']).update({
      'published': true,
    });
  }

  void listenToEvents() {
    _subscription = FirebaseFirestore.instance.collection('rides').snapshots().listen((snapshot) {
      _events.value = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }
}