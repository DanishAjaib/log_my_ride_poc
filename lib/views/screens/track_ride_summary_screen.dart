import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:log_my_ride/controllers/replay_timer_controller.dart';
import 'package:log_my_ride/views/widgets/app_social.dart';
import 'package:log_my_ride/views/widgets/random_spline_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../controllers/location_controller.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';
import '../widgets/app_container.dart';
import '../widgets/heatmap.dart';

class TrackRideSummaryScreen extends StatefulWidget {
  const TrackRideSummaryScreen({super.key});

  @override
  State<TrackRideSummaryScreen> createState() => _TrackRideSummaryScreenState();
}

class _TrackRideSummaryScreenState extends State<TrackRideSummaryScreen> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  late ScrollController _scrollController;
  late ScrollController _scrollControllerDetail;
  double mapHeight = 200.0;
  var date = DateFormat('MM/dd/yyyy').format(faker.date.dateTime(minYear: 2022, maxYear: 2022));
  var trackName = faker.vehicle.make();
  var vehiclename = getTruncatedText(faker.company.name(), 8);
  var svgCode = getRandomSvgCode();
  var longestStop = faker.address.streetName();
  var fastestSection = faker.address.streetName();
  var mostLeanAngle = '55 deg';
  var scrollPadding = 0;
  var selectedMap = faker.lorem.word();
  var _selectedLap = {1};
  var dataExpanded = false;
  List<Color> metricColors = [Colors.green, Colors.blue, Colors.red];
  List<String> selectedMetrics = [
    'Speed',
  ];

  final GlobalKey _menuKey = GlobalKey();

  int selectedLap = 1;
  int compareToSelectedLap = 2;

  List<String> allMetrics = ['Speed', 'RPM', 'Lean Angle'];
  List<int> allLaps=  [1, 2,3,4, 5];
  //chart data
  List<SplineSeries<SpeedData, String>> splineData = [
    SplineSeries<SpeedData, String>(
      dataSource: generateSpeedData(20),
      xValueMapper: (SpeedData sales, _) => sales.time,
      yValueMapper: (SpeedData sales, _) => sales.speed,
      name: 'Speed',
      color: Colors.green,
    ),
  ];
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this)..addListener(() {
      if (_tabController!.index == 0) {
        setState(() {
          mapHeight = 200.0;
        });
      }

      if (_tabController!.index == 1) {
        setState(() {
          mapHeight = 200.0;
        });
      }

      if (_tabController!.index == 2) {
        setState(() {
          mapHeight = 0.0;
        });
      }
    });
    _scrollController = ScrollController()..addListener(() {
      setState(() {
       mapHeight  = (200.0 - _scrollController.offset).clamp(0.0, 200.0);
      });
    });
    _scrollControllerDetail = ScrollController()..addListener(() {
      setState(() {
        mapHeight  = (200.0 - _scrollControllerDetail.offset).clamp(0.0, 200.0);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var locationController = Get.put(LocationController());
    Get.put(ReplayTimerController());

    var mapZoom = 12;


    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Ride Summary'),
      ),
      body: Column(
        children: [
          TabBar(
              splashBorderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              indicatorPadding: const EdgeInsets.symmetric(horizontal: -5),
              indicatorColor: primaryColor,
              labelColor: primaryColor,

              unselectedLabelColor: Colors.grey,
              indicatorSize: TabBarIndicatorSize.tab,

              controller: _tabController,
              tabs: const [
                Tab(text: 'Summary'),
                Tab(text: 'Detail'),
                Tab(text: 'AI Coach'),
              ]),
          AppContainer(
            height: mapHeight.toDouble(),
            child: ClipRRect(
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(10),
              child:
              Obx(() {
                var controller = locationController.controller.value;

                return OSMFlutter(
                  onMapIsReady: (value) async {
                    var geoPoints = await locationController.drawRoad(startPoint: GeoPoint(
                        latitude: locationController.currentPosition.value.latitude,
                        longitude: locationController.currentPosition.value.longitude), endPoint: GeoPoint(
                        latitude: locationController.currentPosition.value.latitude + 0.03,
                        longitude: locationController.currentPosition.value.longitude + 0.01
                    ));

                    controller.addMarker(
                        GeoPoint(
                            latitude: locationController.currentPosition.value.latitude,
                            longitude: locationController.currentPosition.value.longitude),
                        markerIcon: MarkerIcon(
                          iconWidget: CircleAvatar(
                            backgroundColor: primaryColor,
                            radius: 20,
                            child: SvgPicture.memory(getRandomSvgCode()),
                          ),
                        ));

                    /* await addFellowRiderMarkers(geoPoints);*/
                  },
                  controller: controller,
                  mapIsLoading: const Center(child: CircularProgressIndicator(color: primaryColor, strokeWidth: 2,)),
                  osmOption:  OSMOption(

                    enableRotationByGesture: true,
                    showZoomController: true,
                    userLocationMarker: UserLocationMaker(
                      personMarker: const MarkerIcon(
                        icon: Icon(
                            LineIcons.biking,
                            color: primaryColor, size: 30
                        ),
                      ),
                      directionArrowMarker: const MarkerIcon(
                        icon: Icon(
                            LineIcons.arrowCircleUp,
                            color: primaryColor, size: 30
                        ),
                      ),
                    ),
                    roadConfiguration: RoadOption(roadColor: Colors.grey[800]!, roadWidth: 5),

                    zoomOption: ZoomOption(initZoom:  mapZoom.toDouble(), minZoomLevel: 2, maxZoomLevel: 19, stepZoom: 1.0),
                  ),
                );
              }),
            ),),
          Expanded(
            child: TabBarView(

              controller: _tabController,
              children: [
                SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const SizedBox(height: 15,),

                      //heatmap
                      HeatmapWidget(

                        sectorData: const [
                          [50.0, 60.0, 70.0, 80.0],
                          [55.0, 65.0, 75.0, 85.0],
                          [52.0, 58.0, 80.0, 90.0],
                          [45.0, 65.0, 75.0, 85.0],
                        ],
                        bestLapIndex: 2, // Highlight the 3rd lap as the best
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          'Other Metrics',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: AppContainer(
                          height: 100,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              onPressed: () {} ,
                              child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: primaryColor,
                                    child: SvgPicture.memory(svgCode),
                                  ),
                                  title: Text(vehiclename),
                                  subtitle: Row(
                                    children: [
                                      const Icon(LineIcons.calendarAlt, size: 16, color: primaryColor,),
                                      const SizedBox(width: 2),
                                      Text(date, style: const TextStyle(fontSize: 12),),
                                      const SizedBox(width: 8),
                                      const Icon(LineIcons.biking, size: 16, color: primaryColor,),
                                      const SizedBox(width: 2),
                                      Text('${getTruncatedText(trackName, 8)}', style: const TextStyle(fontSize: 12),),
                                      const SizedBox(width: 8),

                                    ],
                                  )
                              )
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: AppContainer(
                          height: 100,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              onPressed: () {
                               /* _showBottomSheet(context, 'Places Visited');*/
                              } ,
                              child: const ListTile(
                                trailing: Icon(LineIcons.angleRight, color: primaryColor,),
                                leading: CircleAvatar(
                                  backgroundColor: primaryColor,
                                  child: Icon(LineIcons.mapMarker, color: Colors.white,),
                                ),
                                title: Text('Places Visited'),
                                subtitle: Text('2', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),),
                              )
                          ),
                        ),
                      ),

                      // longest stop
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: AppContainer(
                          height: 100,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              onPressed: () {
                               /* _showBottomSheet(context, 'Longest Stop');*/
                              } ,
                              child: ListTile(
                                trailing: const Icon(LineIcons.angleRight, color: primaryColor,),
                                leading: const CircleAvatar(
                                  backgroundColor: primaryColor,
                                  child: Icon(LineIcons.stopwatch, color: Colors.white,),
                                ),
                                title: const Text('Longest Stop'),
                                subtitle: Text(longestStop, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),),
                              )
                          ),
                        ),
                      ),
                      // max speed
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: AppContainer(
                          height: 100,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              onPressed: () {
                               /* _showBottomSheet(context, 'Fastest Section');*/
                              } ,
                              child: ListTile(
                                trailing: const Icon(LineIcons.angleRight, color: primaryColor,),
                                leading: const CircleAvatar(
                                  backgroundColor: primaryColor,
                                  child: Icon(Icons.speed_outlined, color: Colors.white,),
                                ),
                                title: const Text('Fastest Section'),
                                subtitle:Text(fastestSection, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),),

                              )
                          ),
                        ),
                      ),
                      // most lean angle
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: AppContainer(
                          height: 100,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                /*showBottomSheet(context, 'Most Lean Angle');*/
                              } ,
                              child: const ListTile(
                                trailing: Icon(LineIcons.angleRight, color: primaryColor,),
                                leading: CircleAvatar(
                                  backgroundColor: primaryColor,
                                  child: Icon(LineIcons.angleDoubleDown, color: Colors.white,),
                                ),
                                title: Text('Most Lean Angle'),
                                subtitle: Text('55 Degrees', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),),
                              )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  controller: _scrollControllerDetail,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      AppContainer(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Select a map to compare', style:TextStyle(color: Colors.grey)),
                              //dropdown
                              DropdownButton(

                                items: [
                                  DropdownMenuItem(value: 1,child: Text(faker.lorem.word()),),
                                  DropdownMenuItem(value: 2,child: Text( faker.lorem.word()),),
                                  DropdownMenuItem(value: 3,child: Text( faker.lorem.word()),),
                                ],
                                onChanged: (value) {},
                                hint: Text(selectedMap),
                              ),
                            ],
                          ),
                        ),
                      ),
                      AppContainer(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Lap', style: TextStyle(color: Colors.grey)),
                                SizedBox(
                                  height: 35,
                                  child: ToggleButtons(
                                    borderRadius: BorderRadius.circular(50),
                                    selectedBorderColor: primaryColor,

                                    isSelected: [
                                      _selectedLap.contains(1),
                                      _selectedLap.contains(2),
                                      _selectedLap.contains(3),
                                      _selectedLap.contains(4),
                                      _selectedLap.contains(5),
                                    ],
                                    onPressed: (value) {
                                      setState(() {
                                        _selectedLap = {value + 1};
                                      });
                                    },
                                    children: allLaps.map((e) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15),
                                        child: SizedBox(
                                          height: 30,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(e.toString(), style: const TextStyle(fontSize: 12,),),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          )
                      ),
                      AppContainer(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Metrics', style: TextStyle(color: Colors.grey)),
                              SizedBox(
                                height: 35,
                                child: ToggleButtons(
                                  borderRadius: BorderRadius.circular(50),
                                  selectedBorderColor: primaryColor,

                                  isSelected: [
                                    selectedMetrics.contains('Speed'),
                                    selectedMetrics.contains('RPM'),
                                    selectedMetrics.contains('Lean Angle'),

                                  ],
                                  onPressed: (value) {
                                    setState(() {
                                      if (value == 0) {
                                        if (selectedMetrics.contains('Speed')) {
                                          if(selectedMetrics.length == 1) {
                                            return;
                                          }
                                          selectedMetrics.remove('Speed');
                                          splineData.removeWhere((element) => element.name == 'Speed');

                                          if(selectedMetrics.isEmpty) {
                                            selectedMetrics.add('Speed');
                                            splineData.add(SplineSeries<SpeedData, String>(
                                              dataSource: generateSpeedData(10),
                                              xValueMapper: (SpeedData sales, _) => sales.time,
                                              yValueMapper: (SpeedData sales, _) => sales.speed,
                                              name: 'Speed',
                                              color: Colors.green,
                                            ));
                                          }
                                        } else {
                                          selectedMetrics.add('Speed');
                                          splineData.add(SplineSeries<SpeedData, String>(
                                            dataSource: generateSpeedData(10),
                                            xValueMapper: (SpeedData sales, _) => sales.time,
                                            yValueMapper: (SpeedData sales, _) => sales.speed,
                                            name: 'Speed',
                                            color: Colors.green,
                                          ));
                                        }
                                      } else if (value == 1) {
                                        if (selectedMetrics.contains('RPM')) {
                                          selectedMetrics.remove('RPM');
                                          splineData.removeWhere((element) => element.name == 'RPM');

                                          if(selectedMetrics.isEmpty) {
                                            selectedMetrics.add('Speed');
                                            splineData.add(SplineSeries<SpeedData, String>(
                                              dataSource: generateSpeedData(10),
                                              xValueMapper: (SpeedData sales, _) => sales.time,
                                              yValueMapper: (SpeedData sales, _) => sales.speed,
                                              name: 'Speed',
                                              color: Colors.green,
                                            ));
                                          }
                                        } else {
                                          selectedMetrics.add('RPM');
                                          splineData.add(SplineSeries<SpeedData, String>(
                                            dataSource: generateRPMData(15),
                                            xValueMapper: (SpeedData sales, _) => sales.time,
                                            yValueMapper: (SpeedData sales, _) => sales.speed,
                                            name: 'RPM',
                                            color: Colors.blue,
                                          ));
                                        }
                                      } else if (value == 2) {
                                        if (selectedMetrics.contains('Lean Angle')) {
                                          selectedMetrics.remove('Lean Angle');
                                          splineData.removeWhere((element) => element.name == 'Lean Angle');

                                          if(selectedMetrics.isEmpty) {
                                            selectedMetrics.add('Speed');
                                            splineData.add(SplineSeries<SpeedData, String>(
                                              dataSource: generateSpeedData(10),
                                              xValueMapper: (SpeedData sales, _) => sales.time,
                                              yValueMapper: (SpeedData sales, _) => sales.speed,
                                              name: 'Speed',
                                              color: Colors.green,
                                            ));
                                          }
                                        } else {
                                          selectedMetrics.add('Lean Angle');
                                          splineData.add(SplineSeries<SpeedData, String>(
                                            dataSource: generateLeanAngleData(10),
                                            xValueMapper: (SpeedData sales, _) => sales.time,
                                            yValueMapper: (SpeedData sales, _) => sales.speed,
                                            name: 'Lean Angle',
                                            color: Colors.red,
                                          ));
                                        }
                                      }
                                    });
                                  },
                                  children: allMetrics.map((e) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 15),
                                      child: SizedBox(
                                        height: 30,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [

                                            Text(e, style: const TextStyle(fontSize: 12,),),
                                            /*
                                                Text(allMetrics.indexOf(e) == 0 ? currentSpeed.toString() : allMetrics.indexOf(e) == 1 ? currentRPM.toString() : currentLeanAngle.toString(), style: TextStyle(fontSize: 12, color: metricColors[allMetrics.indexOf(e)], fontWeight: FontWeight.bold),),
                                            */
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        )
                      ),

                      RandomSplineChart(
                        series: splineData,
                        selectedMetrics: selectedMetrics,
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Sector wise lap comparison', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, ),),
                                Row(
                                  children: [
                                    getChipText('Lap ${_selectedLap.first}', textSize: 12, ),
                                    const SizedBox(width: 5,),
                                    const Text('VS',),
                                    const SizedBox(width: 5,),
                                    InkWell(
                                      key: _menuKey,
                                      onTap: () {
                                        final RenderBox renderBox = _menuKey.currentContext!.findRenderObject() as RenderBox;
                                        final position = renderBox.localToGlobal(Offset.zero);
                                        final size = renderBox.size;

                                        showMenu(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          context: context,
                                          position: RelativeRect.fromLTRB(
                                            position.dx,
                                            position.dy + size.height,
                                            position.dx + size.width,
                                            position.dy,
                                          ),
                                          items: allLaps.map((e) {
                                            return PopupMenuItem(value: e,child: Text('Lap $e'),);
                                          }).toList(),
                                        ).then((value) {
                                          if (value != null) {
                                            setState(() {
                                              compareToSelectedLap = value;
                                            });
                                          }
                                        });
                                      },
                                      child: getChipText('Lap $compareToSelectedLap', textSize: 12, icon: const Icon(LineIcons.arrowDown, color: Colors.white, size: 15, ), bgColor: Colors.green),
                                    ),

                                    //getChipText('Lap ${_selectedLap.first}', textSize: 12),
                                    /*DropdownButton(
                                      items:  allLaps.map((e) {
                                        return DropdownMenuItem(child: Text(e.toString()), value: e,);
                                      }).toList(),
                                      onChanged: (value) {}, hint: const Text('Lap 2'),),*/
                                  ],
                                )
                              ],
                            ),
                            const Spacer(),
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    dataExpanded = !dataExpanded;
                                    _scrollControllerDetail.animateTo(dataExpanded ? 500 : 400, duration: defaultDuration, curve: Curves.easeIn);
                                  });
                                },
                                style: ButtonStyle(
                                  shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                child: Icon(dataExpanded ? LineIcons.arrowUp : LineIcons.arrowDown, color: Colors.white,)
                            ),
                          ],
                        ),
                      ),
                      AppContainer(
                        height: dataExpanded ? 500 : 0,
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Scrollable(
                            axisDirection: AxisDirection.down,
                            physics: const BouncingScrollPhysics(),
                            viewportBuilder: (context, offset) {
                              return SingleChildScrollView(
                                child: DataTable(

                                  headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
                                  dataTextStyle: GoogleFonts.sourceCodePro(),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  columnSpacing: 60,

                                  columns: ['Sector', 'Sector Time', 'Avg Lean Angle', 'Avg Speed',].map((e) => DataColumn(label: Text(e, style: const TextStyle(color: Colors.white),))).toList(),
                                  rows: List.generate(10, (index) => DataRow(cells: [
                                    DataCell(Text('${index + 1}')),
                                    DataCell(
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text('00:${ faker.randomGenerator.integer(59, min: 10)}:${faker.randomGenerator.integer(59, min: 10)}', style: const TextStyle(color: primaryColor),),
                                            Text('00:${ faker.randomGenerator.integer(59, min: 10)}:${faker.randomGenerator.integer(59, min: 10)}', style: const TextStyle( color: Colors.green),),
                                          ],
                                        )
                                    ),
                                    DataCell(
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text('${faker.randomGenerator.integer(90, min: 10)}\u00B0', style: const TextStyle(color: primaryColor),),
                                            Text('${faker.randomGenerator.integer(90, min: 10)}\u00B0', style: const TextStyle( color: Colors.green),),
                                          ],
                                        )
                                    ),
                                    DataCell(
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text('${faker.randomGenerator.integer(200, min: 100)} km/h', style: const TextStyle(color: primaryColor),),
                                            Text('${faker.randomGenerator.integer(200, min: 100)} km/h', style: const TextStyle( color: Colors.green),),
                                          ],
                                        )
                                    ),

                                  ])),
                                ),

                              );
                            },

                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                        const SizedBox(height: 10,),
                        Text(faker.lorem.sentences(3).join(' ')),
                        const SizedBox(height: 10,),

                        const SizedBox(height: 10,),
                        Text(faker.lorem.sentences(3).join(' ')),
                        const SizedBox(height: 20,),
                        const Divider(color: primaryColor,),
                        const SizedBox(height: 20,),

                        const Row(
                          children: [
                            Icon(LineIcons.motorcycle, color: primaryColor, size: 30,),
                            SizedBox(width: 10,),
                            Text('Key improvements on Motorcycle', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Text(faker.lorem.sentences(3).join(' ')),
                        const SizedBox(height: 10,),
                        const Card(
                          child: ListTile(
                            leading: Icon(LineIcons.lightbulb, color: primaryColor,),
                            title: Text('Suspension Tuning', style: TextStyle(fontSize: 14, color: primaryColor),),
                            subtitle: Text(
                                'Adjust the suspension preload and damping for smoother handling on bumpy roads. '
                                    'Softer settings increase comfort, while stiffer settings improve control during aggressive cornering.',
                              style: TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ),
                        ),
                        const Card(
                          child: ListTile(
                            leading: Icon(LineIcons.lightbulb, color: primaryColor,),
                            title: Text('Gear Ratio Tuning' , style: TextStyle(fontSize: 14, color: primaryColor),),
                            subtitle: Text('Optimize gear ratios to match track conditions. '
                                'Shorter gearing improves acceleration on tighter tracks, while longer gearing is ideal for high-speed sections.',
                              style: TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ),
                        ),
                        const Card(
                          child: ListTile(
                            leading: Icon(LineIcons.lightbulb, color: primaryColor,),
                            title: Text('Brake Lever Sensitivity' , style: TextStyle(fontSize: 14, color: primaryColor),),
                            subtitle: Text('Adjust the brake lever for a shorter response time to improve braking accuracy and reduce stopping distance '
                                'during high-speed sections.', style: TextStyle(fontSize: 12, color: Colors.white),),
                          ),
                        ),
                        const Card(
                          child: ListTile(
                            leading: Icon(LineIcons.lightbulb, color: primaryColor,),
                            title: Text('Tire Pressure Adjustment' , style: TextStyle(fontSize: 14, color: primaryColor),),
                            subtitle: Text('Increase or decrease tire pressure based on the track conditions. Higher pressure improves handling on smooth tracks, '
                                'while lower pressure offers more grip on rough surfaces.' , style: TextStyle(fontSize: 12, color: Colors.white),),
                          ),
                        ),

                        AppContainer(
                          child: Row(
                            children: [
                              Stack(
                                children: [

                                  Card(
                                    child: SvgPicture.asset('assets/images/sector_mini_map.svg', height: 200,),
                                  ),
                                  Positioned(
                                    top: 25,
                                    left: 25,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 10,
                                          height: 10,
                                          decoration: const BoxDecoration(
                                            color: Colors.yellowAccent,
                                            shape: BoxShape.circle,
                                          ),
                          
                                        ),
                                        const SizedBox(width: 10,),
                                        const Text('AI', style: TextStyle(fontSize: 12),),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 40,
                                    left: 25,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 10,
                                          height: 10,
                                          decoration: const BoxDecoration(
                                            color: primaryColor,
                                            shape: BoxShape.circle,
                                          ),
                          
                                        ),
                                        const SizedBox(width: 10,),
                                        const Text('YOU', style: TextStyle(fontSize: 12),),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              //vertical divider
                              const Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Biggest Sector Gap', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),),
                                  Divider(color: primaryColor, height: 10,),
                                  SizedBox(height: 10,),
                                  SizedBox(
                                    width: 160,
                                      child: Text('You were 2.5 seconds slower than the AI in sector 2. Focus on improving your cornering technique to close the gap.')),
                                ]
                              )
                            ],
                          ),
                        ),
                        //ideal vs actual time line chart
                        const SizedBox(height: 10,),
                        const Text('Ideal vs Actual Lap Times', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                        const SizedBox(height: 10,),
                        AppContainer(
                          child: SfCartesianChart(

                            primaryXAxis: CategoryAxis(
                              axisLine: null,
                              majorGridLines: const MajorGridLines(width: 0),
                              minorGridLines: const MinorGridLines(width: 0),
                            ),

                            series: <ChartSeries>[
                              SplineSeries<SpeedData, String>(
                                dataSource: generateTrackSectorActualSpeeddata(),
                                xValueMapper: (SpeedData sales, _) => sales.time,
                                yValueMapper: (SpeedData sales, _) => sales.speed,
                                name: 'Actual',
                                color: primaryColor,
                              ),
                              SplineSeries<SpeedData, String>(
                                dataSource: generateTrackSectorIdealSpeedData(),
                                xValueMapper: (SpeedData sales, _) => sales.time,
                                yValueMapper: (SpeedData sales, _) => sales.speed,
                                name: 'Ideal',
                                color: Colors.yellow,
                              ),
                            ],
                          ),
                        ),




                        const SizedBox(height: 10,),
                        Text(faker.lorem.sentences(3).join(' ')),
                        const SizedBox(height: 20,),
                        const Divider(color: primaryColor,),
                        const SizedBox(height: 20,),

                        const Row(
                          children: [
                            Icon(LineIcons.stopwatch, color: primaryColor, size: 30,),
                            SizedBox(width: 10,),
                            Text('Key improvements on Braking', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Text(faker.lorem.sentences(3).join(' ')),
                        const SizedBox(height: 10,),
                        const Card(
                          child: ListTile(
                            leading: Icon(LineIcons.lightbulb, color: primaryColor,),
                            title: Text('Optimal Braking Points', style: TextStyle(fontSize: 14, color: primaryColor),),
                            subtitle: Text(
                              'Identify and practice braking points on the track to maximize your speed through corners. '
                                  'Braking too early or too late can affect your lap times and overall control.',
                              style: TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ),
                        ),
                        const Card(
                          child: ListTile(
                            leading: Icon(LineIcons.lightbulb, color: primaryColor,),
                            title: Text('Trail Braking Technique', style: TextStyle(fontSize: 14, color: primaryColor),),
                            subtitle: Text(
                              'Use trail braking to maintain corner speed and balance the bike. '
                                  'Apply the brakes gradually as you enter the corner to improve grip and reduce under-steer.',
                              style: TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ),
                        ),
                        const Card(
                          child: ListTile(
                            leading: Icon(LineIcons.lightbulb, color: primaryColor,),
                            title: Text('Brake Modulation', style: TextStyle(fontSize: 14, color: primaryColor),),
                            subtitle: Text(
                              'Learn to modulate brake pressure to avoid locking up the wheels. '
                                  'Smooth and controlled braking helps maintain traction and stability, especially in tricky conditions.',
                              style: TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ),
                        ),
                        const Card(
                          child: ListTile(
                            leading: Icon(LineIcons.lightbulb, color: primaryColor,),
                            title: Text('Brake Fade Management', style: TextStyle(fontSize: 14, color: primaryColor),),
                            subtitle: Text(
                              'Monitor brake performance to prevent fade during long races. '
                                  'Adjust braking strategies and cooling techniques to maintain consistent braking power.',
                              style: TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ),
                        ),

                        AppContainer(
                          child: Row(
                            children: [
                              Stack(
                                children: [

                                  Card(
                                    child: SvgPicture.asset('assets/images/sector_mini_map.svg', height: 200,),
                                  ),
                                  Positioned(
                                    top: 25,
                                    left: 25,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 10,
                                          height: 10,
                                          decoration: const BoxDecoration(
                                            color: Colors.yellowAccent,
                                            shape: BoxShape.circle,
                                          ),

                                        ),
                                        const SizedBox(width: 10,),
                                        const Text('AI', style: TextStyle(fontSize: 12),),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 40,
                                    left: 25,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 10,
                                          height: 10,
                                          decoration: const BoxDecoration(
                                            color: primaryColor,
                                            shape: BoxShape.circle,
                                          ),

                                        ),
                                        const SizedBox(width: 10,),
                                        const Text('YOU', style: TextStyle(fontSize: 12),),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              //vertical divider
                              const Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Biggest Sector Gap', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),),
                                    Divider(color: primaryColor, height: 10,),
                                    SizedBox(height: 10,),
                                    SizedBox(
                                        width: 160,
                                        child: Text('You were 2.5 seconds slower than the AI in sector 2. Focus on improving your cornering technique to close the gap.')),
                                  ]
                              )
                            ],
                          ),
                        ),
                        //ideal vs actual time line chart
                        const SizedBox(height: 10,),
                        const Text('Ideal vs Actual Lap Times', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                        const SizedBox(height: 10,),
                        AppContainer(
                          child: SfCartesianChart(

                            primaryXAxis: CategoryAxis(
                              axisLine: null,
                              majorGridLines: const MajorGridLines(width: 0),
                              minorGridLines: const MinorGridLines(width: 0),
                            ),

                            series: <ChartSeries>[
                              SplineSeries<SpeedData, String>(
                                dataSource: generateTrackSectorActualSpeeddata(),
                                xValueMapper: (SpeedData sales, _) => sales.time,
                                yValueMapper: (SpeedData sales, _) => sales.speed,
                                name: 'Actual',
                                color: primaryColor,
                              ),
                              SplineSeries<SpeedData, String>(
                                dataSource: generateTrackSectorIdealSpeedData(),
                                xValueMapper: (SpeedData sales, _) => sales.time,
                                yValueMapper: (SpeedData sales, _) => sales.speed,
                                name: 'Ideal',
                                color: Colors.yellow,
                              ),
                            ],
                          ),
                        ),




                        const SizedBox(height: 10,),
                        Text(faker.lorem.sentences(3).join(' ')),
                        const SizedBox(height: 20,),
                        const Divider(color: primaryColor,),
                        const SizedBox(height: 20,),

                        const Row(
                          children: [
                            Icon(LineIcons.lightbulbAlt, color: primaryColor, size: 30,),
                            SizedBox(width: 10,),
                            Text('Key improvements on Cornering', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Text(faker.lorem.sentences(3).join(' ')),
                        const SizedBox(height: 10,),
                        const Card(
                          child: ListTile(
                            leading: Icon(LineIcons.lightbulb, color: primaryColor,),
                            title: Text('Optimal Braking Points', style: TextStyle(fontSize: 14, color: primaryColor),),
                            subtitle: Text(
                              'Identify and practice braking points on the track to maximize your speed through corners. '
                                  'Braking too early or too late can affect your lap times and overall control.',
                              style: TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ),
                        ),
                        const Card(
                          child: ListTile(
                            leading: Icon(LineIcons.lightbulb, color: primaryColor,),
                            title: Text('Trail Braking Technique', style: TextStyle(fontSize: 14, color: primaryColor),),
                            subtitle: Text(
                              'Use trail braking to maintain corner speed and balance the bike. '
                                  'Apply the brakes gradually as you enter the corner to improve grip and reduce under-steer.',
                              style: TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ),
                        ),


                        AppContainer(
                          child: Row(
                            children: [
                              Stack(
                                children: [

                                  Card(
                                    child: SvgPicture.asset('assets/images/sector_mini_map.svg', height: 200,),
                                  ),
                                  Positioned(
                                    top: 25,
                                    left: 25,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 10,
                                          height: 10,
                                          decoration: const BoxDecoration(
                                            color: Colors.yellowAccent,
                                            shape: BoxShape.circle,
                                          ),

                                        ),
                                        const SizedBox(width: 10,),
                                        const Text('AI', style: TextStyle(fontSize: 12),),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 40,
                                    left: 25,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 10,
                                          height: 10,
                                          decoration: const BoxDecoration(
                                            color: primaryColor,
                                            shape: BoxShape.circle,
                                          ),

                                        ),
                                        const SizedBox(width: 10,),
                                        const Text('YOU', style: TextStyle(fontSize: 12),),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              //vertical divider
                              const Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Biggest Sector Gap', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),),
                                    Divider(color: primaryColor, height: 10,),
                                    SizedBox(height: 10,),
                                    SizedBox(
                                        width: 160,
                                        child: Text('You were 2.5 seconds slower than the AI in sector 2. Focus on improving your cornering technique to close the gap.')),
                                  ]
                              )
                            ],
                          ),
                        ),
                        //ideal vs actual time line chart
                        const SizedBox(height: 10,),
                        const Text('Ideal vs Actual Lap Times', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                        const SizedBox(height: 10,),
                        AppContainer(
                          child: SfCartesianChart(

                            primaryXAxis: CategoryAxis(
                              axisLine: null,
                              majorGridLines: const MajorGridLines(width: 0),
                              minorGridLines: const MinorGridLines(width: 0),
                            ),

                            series: <ChartSeries>[
                              SplineSeries<SpeedData, String>(
                                dataSource: generateTrackSectorActualSpeeddata(),
                                xValueMapper: (SpeedData sales, _) => sales.time,
                                yValueMapper: (SpeedData sales, _) => sales.speed,
                                name: 'Actual',
                                color: primaryColor,
                              ),
                              SplineSeries<SpeedData, String>(
                                dataSource: generateTrackSectorIdealSpeedData(),
                                xValueMapper: (SpeedData sales, _) => sales.time,
                                yValueMapper: (SpeedData sales, _) => sales.speed,
                                name: 'Ideal',
                                color: Colors.yellow,
                              ),
                            ],
                          ),
                        ),




                        const SizedBox(height: 10,),
                        Text(faker.lorem.sentences(3).join(' ')),
                        const SizedBox(height: 20,),
                        const Divider(color: primaryColor,),
                        const SizedBox(height: 20,),

                        const Row(
                          children: [
                            Icon(LineIcons.lightbulbAlt, color: primaryColor, size: 30,),
                            SizedBox(width: 10,),
                            Text('Key improvements to reduce Time', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                          ],
                        ),

                        const SizedBox(height: 20,),
                        const SizedBox(height: 20,),
                        Text(faker.lorem.sentences(3).join(' ')),
                        const SizedBox(height: 10,),
                        const Card(
                          child: ListTile(
                            leading: Icon(LineIcons.lightbulb, color: primaryColor,),
                            title: Text('Optimal Braking Points', style: TextStyle(fontSize: 14, color: primaryColor),),
                            subtitle: Text(
                              'Identify and practice braking points on the track to maximize your speed through corners. '
                                  'Braking too early or too late can affect your lap times and overall control.',
                              style: TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ),
                        ),
                        const Card(
                          child: ListTile(
                            leading: Icon(LineIcons.lightbulb, color: primaryColor,),
                            title: Text('Trail Braking Technique', style: TextStyle(fontSize: 14, color: primaryColor),),
                            subtitle: Text(
                              'Use trail braking to maintain corner speed and balance the bike. '
                                  'Apply the brakes gradually as you enter the corner to improve grip and reduce under-steer.',
                              style: TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ),
                        ),
                        AppContainer(
                          child: Row(
                            children: [
                              Stack(
                                children: [
                                  Card(child: SvgPicture.asset('assets/images/sector_mini_map.svg', height: 200,),),
                                  Positioned(
                                    top: 25,
                                    left: 25,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 10,
                                          height: 10,
                                          decoration: const BoxDecoration(
                                            color: Colors.yellowAccent,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 10,),
                                        const Text('AI', style: TextStyle(fontSize: 12),),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 40,
                                    left: 25,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 10,
                                          height: 10,
                                          decoration: const BoxDecoration(
                                            color: primaryColor,
                                            shape: BoxShape.circle,
                                          ),

                                        ),
                                        const SizedBox(width: 10,),
                                        const Text('YOU', style: TextStyle(fontSize: 12),),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              //vertical divider
                              const Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Biggest Sector Gap', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),),
                                    Divider(color: primaryColor, height: 10,),
                                    SizedBox(height: 10,),
                                    SizedBox(
                                        width: 160,
                                        child: Text('You were 2.5 seconds slower than the AI in sector 2. Focus on improving your cornering technique to close the gap.')),
                                  ]
                              )
                            ],
                          ),
                        ),
                        //ideal vs actual time line chart
                        const SizedBox(height: 10,),
                        const Text('Ideal vs Actual Lap Times', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                        const SizedBox(height: 10,),
                        AppContainer(
                          child: SfCartesianChart(

                            primaryXAxis: CategoryAxis(
                              axisLine: null,
                              majorGridLines: const MajorGridLines(width: 0),
                              minorGridLines: const MinorGridLines(width: 0),
                            ),

                            series: <ChartSeries>[
                              SplineSeries<SpeedData, String>(
                                dataSource: generateTrackSectorActualSpeeddata(),
                                xValueMapper: (SpeedData sales, _) => sales.time,
                                yValueMapper: (SpeedData sales, _) => sales.speed,
                                name: 'Actual',
                                color: primaryColor,
                              ),
                              SplineSeries<SpeedData, String>(
                                dataSource: generateTrackSectorIdealSpeedData(),
                                xValueMapper: (SpeedData sales, _) => sales.time,
                                yValueMapper: (SpeedData sales, _) => sales.speed,
                                name: 'Ideal',
                                color: Colors.yellow,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Text(faker.lorem.sentences(3).join(' ')),
                        const SizedBox(height:50),
                        const AppSocial(),
                        const SizedBox(height:50) ,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
