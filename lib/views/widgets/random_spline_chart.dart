import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:log_my_ride/utils/constants.dart';
import 'package:log_my_ride/views/widgets/app_container.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../controllers/replay_timer_controller.dart';
import '../../utils/custom_thumb_shape.dart';

class RandomSplineChart extends StatefulWidget {

  List<SplineSeries<SpeedData, String>> series;
  List<String>? selectedMetrics;
  Function(int index)? onTick;
  RandomSplineChart({super.key, required this.series, this.onTick, this.selectedMetrics});

  @override
  State<RandomSplineChart> createState() => _RandomSplineChartState();
}

class _RandomSplineChartState extends State<RandomSplineChart> {

  var replayController = Get.find<ReplayTimerController>();
  late TrackballBehavior _trackballBehavior;


/*  void replayCallback() {
    if(sliderValue < widget.series[0].dataSource.length - 1){
      setState(() {
        sliderValue++;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _trackballBehavior.showByIndex(sliderValue.round());
      });
      if(widget.onTick != null){
        widget.onTick!(sliderValue.toInt());
      }
    }else{
      replayTimer.cancel();
      setState(() {
        isReplaying = false;
      });
    }
  }*/

  @override
  void initState() {
    _trackballBehavior = TrackballBehavior(
      enable: true,
      shouldAlwaysShow: true,
      activationMode: ActivationMode.singleTap,
      lineType: TrackballLineType.vertical,
      tooltipSettings: const InteractiveTooltip(
        enable: true,
        color: Colors.white,
        textStyle: TextStyle(color: Colors.black),
        borderWidth: 1,
        borderColor: Colors.black,
        format: 'point.x : point.y',
      ),
    );
;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return AppContainer(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(

                    width: MediaQuery.of(context).size.width - 60,
                    child: Column(
                      children: [
                       Obx(() {
                         var sliderValue = replayController.sliderValue.value.toInt();
                         var isPlaying = replayController.isPlaying.value;
                         return  Row(
                           mainAxisAlignment: MainAxisAlignment.start,
                           children: [
                             ...[
                               Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   const Text('Time', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.lightGreenAccent),),
                                   Text(widget.series[0].dataSource[sliderValue].time, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.lightGreenAccent),),
                                 ],
                               ),
                               if(widget.selectedMetrics!.contains('Speed'))
                                 const SizedBox(width: 10,),
                               //divider
                               if(widget.selectedMetrics!.contains('Speed'))
                                 Container(
                                   height: 40,
                                   width: 1,
                                   color: Colors.grey.withOpacity(0.2),
                                 ),
                               const SizedBox(width: 10,),
                               if(widget.selectedMetrics!.contains('Speed'))
                                 Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     const Text('Speed', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),),
                                     Text('${widget.series.where((e) => e.name == 'Speed').first.dataSource[sliderValue].speed.toStringAsFixed(0)} km/h', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),),
                                   ],
                                 ),
                               if(widget.selectedMetrics!.contains('Lean Angle'))
                                 const SizedBox(width: 10,),
                               //lean angle
                               if(widget.selectedMetrics!.contains('Lean Angle'))
                                 Container(
                                   height: 40,
                                   width: 1,
                                   color: Colors.grey.withOpacity(0.2),
                                 ),
                               if(widget.selectedMetrics!.contains('Lean Angle'))
                                 const SizedBox(width: 10,),
                               if(widget.selectedMetrics!.contains('Lean Angle'))
                                 Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     const Text('Lean Angle', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),),
                                     Text('${widget.series.where((e) => e.name == 'Lean Angle').first.dataSource[sliderValue].speed.toStringAsFixed(0)}°', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),),
                                   ],
                                 ),
                               const SizedBox(width: 10,),
                               //rpm
                               Container(
                                 height: 40,
                                 width: 1,
                                 color: Colors.grey.withOpacity(0.2),
                               ),
                               const SizedBox(width: 10,),
                               if(widget.selectedMetrics!.contains('RPM'))
                                 Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     const Text('RPM', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),),
                                     Text( widget.series.where((e) => e.name == 'RPM').first.dataSource[sliderValue].speed.toStringAsFixed(0), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),),
                                   ],
                                 ),

                             ],
                              const Spacer(),
                             //play button
                             AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                               width: 50,
                               height: 50,
                               child: IconButton(
                                 color: primaryColor,
                                 style: ButtonStyle(
                                   shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
                                   backgroundColor: WidgetStateProperty.all(isPlaying ? Colors.red : Colors.green),
                                 ),
                                 onPressed: () {
                                    replayController.isPlaying.value = !isPlaying;

                                    if(isPlaying) {
                                      print('pause');
                                      replayController.pauseTimer();
                                    } else {
                                      replayController.startTimer();
                                    }

                                 }, icon: Icon(isPlaying ? LineIcons.pause : LineIcons.play, color: Colors.white, size: 20),),
                             ),

                           ],
                         );
                       }),
                        const SizedBox(height: 10,),
                        Obx(() {
                          var sliderValue = replayController.sliderValue.value;
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _trackballBehavior.showByIndex(sliderValue.round());
                          });
                          return SliderTheme(
                            data: SliderThemeData(
                              thumbShape: CustomSliderThumbShape(strokeWidth: 2, strokeColor: primaryColor, fillColor: Colors.black87),
                              trackHeight: 1,
                            ),
                            child: Slider(

                              min: 0,
                              max: widget.series[0].dataSource.length.toDouble() - 4,
                              label: sliderValue.round().toString(),
                              thumbColor: primaryColor,
                              activeColor: primaryColor,

                              value: sliderValue,
                              onChanged: (double value) {
                                replayController.updateSliderValue(value);
                                //replayController.sliderValue.value = value;
                                _trackballBehavior.showByIndex(value.round());

                              },),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SfCartesianChart(
              tooltipBehavior: TooltipBehavior(enable: false),
              enableAxisAnimation: true,
              trackballBehavior: _trackballBehavior,
              onTrackballPositionChanging: (TrackballArgs args) {
                replayController.sliderValue.value = args.chartPointInfo.dataPointIndex!.toDouble();
              },
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(
                majorGridLines: const MajorGridLines(width: 0),
              ),

              series: widget.series,
            )
          ],
        )
    );
  }


}

class SpeedData {
  SpeedData(this.time, this.speed,);
  final String time;
  final double speed;
}


