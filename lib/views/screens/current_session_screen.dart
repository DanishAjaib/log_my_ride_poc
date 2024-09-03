
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:log_my_ride/utils/constants.dart';
import 'package:log_my_ride/views/widgets/app_container.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class CurrentSessionScreen extends StatefulWidget {
  const CurrentSessionScreen({super.key,});

  @override
  State<CurrentSessionScreen> createState() => _CurrentSessionScreenState();
}

class _CurrentSessionScreenState extends State<CurrentSessionScreen> {

  @override
  void dispose() {
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return Scaffold(

      body: AppContainer(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(
              width: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  Text('engine'),
                  Text('0', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: primaryColor)),
                  Divider(),
                  Text('engine'),
                  Text('0', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: primaryColor)),

                ],
              ),
            ),
            SizedBox(
              width: 250,
              child: SfRadialGauge(
                axes: <RadialAxis>[
                  RadialAxis(
                    minimum: 0,
                    maximum: 100,
                    ranges: <GaugeRange>[
                      GaugeRange(startValue: 0, endValue: 50, color: Colors.green),
                      GaugeRange(startValue: 50, endValue: 100, color: Colors.red)
                    ],
                    pointers: const <GaugePointer>[
                      NeedlePointer(value: 60)
                    ],
                    annotations: const <GaugeAnnotation>[
                      GaugeAnnotation(
                          widget: Text('60.0',
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold)),
                          angle: 90,
                          positionFactor: 0.5)
                    ]
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  Text('engine'),
                  Text('0', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: primaryColor)),
                  Divider(),
                  Text('engine'),
                  Text('0', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: primaryColor)),

                ],
              ),
            ),
            //radial gauge

          ],
        )
      ),

    );
  }
}
