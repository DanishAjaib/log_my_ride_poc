import 'package:flutter/material.dart';
import 'package:log_my_ride/views/widgets/app_container.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RandomSplineChart extends StatefulWidget {
  const RandomSplineChart({super.key});

  @override
  State<RandomSplineChart> createState() => _RandomSplineChartState();
}

class _RandomSplineChartState extends State<RandomSplineChart> {
  @override
  Widget build(BuildContext context) {
    return AppContainer(
        child: SfCartesianChart(
          enableAxisAnimation: true,
          borderWidth: 0,
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(
            majorGridLines: const MajorGridLines(width: 0),
            minorGridLines: const MinorGridLines(width: 0, color:Colors.transparent),
          ),
          series: <SplineSeries<SpeedData, String>>[
            SplineSeries<SpeedData, String>(
              dataSource: generateSpeedData(20),
              /*pointColorMapper: (SpeedData data, _) {
                if (data.speed < 10) {
                  return Colors.green;
                } else if (data.speed > 10 && data.speed < 35) {
                  return Colors.orange;
                } else {
                  return Colors.red;
                }
              },*/
              xValueMapper: (SpeedData data, _) => data.time,
              yValueMapper: (SpeedData data, _) => data.speed,
            ),
            SplineSeries<SpeedData, String>(
              dataSource: generateLeanAngleData(20),
              /*pointColorMapper: (SpeedData data, _) {
                if (data.speed < 10) {
                  return Colors.green;
                } else if (data.speed > 10 && data.speed < 35) {
                  return Colors.orange;
                } else {
                  return Colors.red;
                }
              },*/
              xValueMapper: (SpeedData data, _) => data.time,
              yValueMapper: (SpeedData data, _) => data.speed,
            )
          ],
        )
    );
  }

  List<SpeedData> generateLeanAngleData(int count) {
    List<SpeedData> data = [];
    double leanAngle = 0;
    for (int i = 0; i < count; i++) {
      if (i % 2 == 0) {
        leanAngle += (2 + (i % 3));
      } else {
        leanAngle -= (3 + (i % 2));
      }
      if (leanAngle < 0) leanAngle = 0;
      data.add(SpeedData('00:${i.toString().padLeft(2, '0')}', leanAngle));
    }
    return data;
  }
  List<SpeedData> generateSpeedData(int count) {
    List<SpeedData> data = [];
    double speed = 0;
    for (int i = 0; i < count; i++) {
      if (i % 2 == 0) {
        speed += (5 + (i % 3));
      } else {
        speed -= (3 + (i % 2));
      }
      if (speed < 0) speed = 0;
      data.add(SpeedData('00:${i.toString().padLeft(2, '0')}', speed));
    }

    //deccelearate sine wave
    for (int i = 0; i < count; i++) {
      if (i % 2 == 0) {
        speed -= (5 + (i % 3));
      } else {
        speed += (1 + (i % 2));
      }
      if (speed < 0) speed = 0;
      data.add(SpeedData('01:${i.toString().padLeft(2, '0')}', speed));
    }

    return data;
  }
}

class SpeedData {
  SpeedData(this.time, this.speed,);
  final String time;
  final double speed;
}
