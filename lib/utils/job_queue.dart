import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class JobQueue {
  List<String> _queue = [];

  Future<void> addJob(String job) async {
    _queue.add(job);
    await _saveQueue();
  }

  String? getJob() {
    if (_queue.isNotEmpty) {
      return _queue.removeAt(0);
    }
    return null;
  }

  Future<void> _saveQueue() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('job_queue', _queue);
  }

  Future<void> loadQueue() async {
    final prefs = await SharedPreferences.getInstance();
    _queue = prefs.getStringList('job_queue') ?? [];
  }
}