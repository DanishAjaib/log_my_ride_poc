import 'package:flutter/material.dart';
import 'package:log_my_ride/utils/constants.dart';
import 'package:log_my_ride/utils/utils.dart';
import 'package:log_my_ride/views/widgets/app_container.dart';
import 'package:log_my_ride/views/widgets/dummy_map_container.dart';
import 'package:log_my_ride/views/widgets/random_spline_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:timeline_tile/timeline_tile.dart';

class CustomTimelineTile extends StatefulWidget {
  final bool isFirst;
  final bool isLast;
  final TileSession session;


  const CustomTimelineTile({super.key,
    required this.isFirst,
    required this.isLast,
    required this.session,

  });


  @override
  State<CustomTimelineTile> createState() => _CustomTimelineTileState();
}

class _CustomTimelineTileState extends State<CustomTimelineTile> {
  @override
  Widget build(BuildContext context) {

    List<SplineSeries<SpeedData, String>> splineData = [
      SplineSeries<SpeedData, String>(
        dataSource: generateSpeedData(20),
        xValueMapper: (SpeedData sales, _) => sales.time,
        yValueMapper: (SpeedData sales, _) => sales.speed,
        name: 'Speed',
        color: Colors.green,
      ),
    ];

    List<String> selectedMetrics = [
      'Speed',
    ];


    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: TimelineTile(
        isFirst: widget.isFirst,
        isLast: widget.isLast,
        indicatorStyle: IndicatorStyle(
            width: 30,
            height: 30,
            color: widget.session.isCompleted ? primaryColor : primaryColor,
            indicator: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.session.isCompleted ? primaryColor : primaryColor,
                ),
                child: widget.session.isCompleted
                    ?const Center(child: Icon(Icons.check),)
                    :const Center(child: Icon(Icons.check),)
            )
        ),
        afterLineStyle: LineStyle(
          thickness: 1,
          color: widget.session.isCompleted ? primaryColor : primaryColor,
        ),
        beforeLineStyle: LineStyle(
          thickness: 1,
          color: widget.session.isCompleted ? primaryColor : primaryColor,
        ),
        endChild: SessionCard(session: widget.session),
      ),
    );
  }
}

class SessionCard extends StatelessWidget {
  final TileSession session;

  const SessionCard({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: double.infinity,
      child: AppContainer(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DummyMapContainer(width: 100, height: 100),

              const SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(getTruncatedText(session.title, 6), style: const TextStyle(fontSize: 16),),
                  const SizedBox(height: 5,),
                  Text(getTruncatedText(session.group, 6), style: const TextStyle(fontSize: 14, color: Colors.grey),),
                  Text('Capacity: ${session.capacity}', style: const TextStyle(fontSize: 14, color: Colors.grey),),
                ],
              ),
              /*ListTile(
                leading: const Icon(Icons.fitness_center),
                title: Text(session.title),
                subtitle: Text('${session.group}  | ${session.capacity} '),
              )*/
            ],
          ),
        ),
      ),
    );
  }
}

class TileSession {
  final String title;
  final String group;
  final int capacity;
  bool isCompleted;

  TileSession({required this.title, required this.capacity, required this.group, this.isCompleted = false});
}