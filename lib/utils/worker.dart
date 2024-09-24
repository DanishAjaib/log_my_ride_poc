import 'dart:isolate';
import 'job_queue.dart';

class Worker {
  final JobQueue _jobQueue = JobQueue();
  Isolate? _isolate;
  ReceivePort _receivePort = ReceivePort();

  Future<void> start() async {
    await _jobQueue.loadQueue();
    _isolate = await Isolate.spawn(_processJobs, _receivePort.sendPort);
    _receivePort.listen((message) {
      if (message == 'done') {
        _processNextJob();
      }
    });
    _processNextJob();
  }

  void _processNextJob() {
    final job = _jobQueue.getJob();
    if (job != null) {
      _isolate?.controlPort.send(job);
    }
  }

  static void _processJobs(SendPort sendPort) {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    receivePort.listen((message) {
      // Simulate job processing
      print('Processing job: $message');
      Future.delayed(Duration(seconds: 2), () {
        sendPort.send('done');
      });
    });
  }

  Future<void> stop() async {
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
  }
}