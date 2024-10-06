import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:log_my_ride/models/session.dart';
import 'package:log_my_ride/utils/constants.dart';
import 'package:log_my_ride/utils/utils.dart';
import 'package:log_my_ride/views/screens/login_screen.dart';
import 'package:log_my_ride/views/screens/main_screen.dart';
import 'package:log_my_ride/views/widgets/custom_line_tile.dart';
import 'package:log_my_ride/views/widgets/metric_container.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:timelines/timelines.dart';

import '../../controllers/location_controller.dart';
import '../../controllers/logging_controller.dart';
import '../../controllers/navigation_controller.dart';
import '../../controllers/replay_timer_controller.dart';
import '../../controllers/user_controller.dart';
import '../widgets/app_container.dart';
import '../widgets/random_spline_chart.dart';
import 'event_participants_screen.dart';

class CompleteEventScreen extends StatefulWidget {

  Map<String, dynamic> currentEvent;
  CompleteEventScreen({super.key, required this.currentEvent});

  @override
  State<CompleteEventScreen> createState() => _CompleteEventScreenState();
}

class _CompleteEventScreenState extends State<CompleteEventScreen> with SingleTickerProviderStateMixin {
  late List<TileSession> allSessions;
  late TabController tabController;
  List<String> selectedMetrics = [
    'Speed',
  ];

  final List<Map<String, dynamic>> stops = [
    {
      'icon': Icons.start,
      'title': 'Session 1',
      'distance': 'Start',
      'time': '10 mins'
    },
    {
      'icon': LineIcons.bellAlt,
      'title': 'Notification',
      'distance': 'Sent',
      'time': '20 mins'
    },
    {
      'icon': Icons.car_crash,
      'title': 'Crash',
      'distance': 'On Track',
      'time': '30 mins'
    },
    {
      'icon': Icons.stop_circle_outlined,
      'title': 'Session 1',
      'distance': 'End',
      'time': '40 mins'
    },
  ];

  final List<Map<String, dynamic>> eventSchedules = [
    {
      'key' : 'briefingTime',
      'title': 'Briefing Time',
    },
    {
      'key' : 'gateOpenTime',
      'title': 'Gate Open Time',
    },
    {
      'key' : 'lunchTime',
      'title': 'Lunch Time',
    },
    {
      'key' : 'scrutineerTime',
      'title': 'Scrutineer Time',
    },{
      'key' : 'signOnTime',
      'title': 'Sign On Time',
    },

  ];

  var riderCountOverlays = [ 'Marketing Sent', 'Marketing Read', 'Registered Via LMR',];
  var selectedRiderCountOverlays = {'Marketing Sent'};
  var userController = Get.find<UserController>();


  var historicalAnalysisData = [
    HistoricalAnalysisDatum('Venue 1', avgCost: 1000, avgRevenue: 2000, avgRiderCount: 1000, LMRMarketingNotifications: 1500),
    HistoricalAnalysisDatum('Venue 2', avgCost: 1500, avgRevenue: 2500, avgRiderCount: 1500, LMRMarketingNotifications: 2000),
    HistoricalAnalysisDatum('Venue 3', avgCost: 2000, avgRevenue: 3000, avgRiderCount: 2000, LMRMarketingNotifications: 2500),
    HistoricalAnalysisDatum('Venue 4', avgCost: 2500, avgRevenue: 3500, avgRiderCount: 2500, LMRMarketingNotifications: 3000),
    HistoricalAnalysisDatum('Venue 5', avgCost: 3000, avgRevenue: 4000, avgRiderCount: 3000, LMRMarketingNotifications: 3500),
    HistoricalAnalysisDatum('Venue 6', avgCost: 3500, avgRevenue: 4500, avgRiderCount: 3500, LMRMarketingNotifications: 4000),
    HistoricalAnalysisDatum('Venue 7', avgCost: 4000, avgRevenue: 5000, avgRiderCount: 4000, LMRMarketingNotifications: 4500),
    HistoricalAnalysisDatum('Venue 8', avgCost: 4500, avgRevenue: 5500, avgRiderCount: 4500, LMRMarketingNotifications: 5000),
    HistoricalAnalysisDatum('Venue 9', avgCost: 5000, avgRevenue: 6000, avgRiderCount: 5000, LMRMarketingNotifications: 5500),
    HistoricalAnalysisDatum('Venue 10', avgCost: 5500, avgRevenue: 6500, avgRiderCount: 5500, LMRMarketingNotifications: 6000),
    HistoricalAnalysisDatum('Venue 11', avgCost: 6000, avgRevenue: 7000, avgRiderCount: 6000, LMRMarketingNotifications: 6500),
    HistoricalAnalysisDatum('Venue 12', avgCost: 6500, avgRevenue: 7500, avgRiderCount: 6500, LMRMarketingNotifications: 7000),



  ];

  var alLChallenges = [
    {
      'Rider': faker.person.name(),
      'value': ['01:30:00', '45', '75 Km/h'],
      'Rank': '1',
      'Date': '2022-01-01',
      'Challenge Type': 'Time Trial',
    },
    {
      'Rider': faker.person.name(),
      'value': ['01:25:00', '44', '71 Km/h'],
      'Rank': '2',
      'Date': '2022-01-01',
      'Challenge Type': 'Time Trial',
    },
    {
      'Rider': faker.person.name(),
      'value': ['01:20:00', '43', '70 Km/h'],
      'Rank': '3',
      'Date': '2022-01-01',
      'Challenge Type': 'Time Trial',
    },
    {
      'Rider': faker.person.name(),
      'value': ['01:15:00', '42', '69 Km/h'],
      'Rank': '4',
      'Date': '2022-01-01',
      'Challenge Type': 'Time Trial',
    },
    {
      'Rider': faker.person.name(),
      'value': ['01:10:00', '41', '68 Km/h'],
      'Rank': '5',
      'Date': '2022-01-01',
      'Challenge Type': 'Time Trial',
    },
    {
      'Rider': faker.person.name(),
      'value': ['01:05:00', '40', '67 Km/h'],
      'Rank': '6',
      'Date': '2022-01-01',
      'Challenge Type': 'Time Trial',
    }
  ];
  List<String> allMetrics = ['Speed', 'RPM', 'Lean Angle'];

  var riderCountData = [
    RiderCountDatum('Jan', 25, 35, 25, 10, 15),
    RiderCountDatum('Feb', 35, 25, 30, 25, 25),
    RiderCountDatum('Mar', 50, 35, 35, 15, 35),
    RiderCountDatum('Apr', 45, 50, 55, 35, 55),
    RiderCountDatum('May', 25, 35, 36, 55, 15),
    RiderCountDatum('Jun', 23, 60, 77, 66, 15),
    RiderCountDatum('Jul', 35, 65, 65, 45, 15),
    RiderCountDatum('Aug', 60, 70, 55, 55, 15),
    RiderCountDatum('Sep', 45, 45, 65, 75, 15),
    RiderCountDatum('Oct', 63, 66, 70, 55, 15),
    RiderCountDatum('Nov', 75, 85, 75, 60, 15),
    RiderCountDatum('Dec', 120, 111, 80, 65, 15),
  ];

  var participants = [
    {
      'name': faker.person.name(),
      'activities': 5,
    },
    {
      'name': faker.person.name(),
      'activities': 4,
    },
    {
      'name': faker.person.name(),
      'activities': 3,
    },
    {
      'name': faker.person.name(),
      'activities': 6,
    },
    {
      'name': faker.person.name(),
      'activities': 5,
    },
  ];

  var eventParticipants = [
    {
      'Rider': faker.person.name(),
      'Image': SvgPicture.memory(getRandomSvgCode()),
      'Skill': faker.randomGenerator.integer(100),
      'Day Score': faker.randomGenerator.integer(100),
      'Challenge Won': 'Max Lean Angle',
    },
    {
      'Rider': faker.person.name(),
      'Image': SvgPicture.memory(getRandomSvgCode()),
      'Skill': faker.randomGenerator.integer(100),
      'Day Score': faker.randomGenerator.integer(100),
      'Challenge Won': 'Time Trial',
    },
    {
      'Rider': faker.person.name(),
      'Image': SvgPicture.memory(getRandomSvgCode()),
      'Skill': faker.randomGenerator.integer(100),
      'Day Score': faker.randomGenerator.integer(100),
      'Challenge Won': 'Average Speed',
    },
    {
      'Rider': faker.person.name(),
      'Image': SvgPicture.memory(getRandomSvgCode()),
      'Skill': faker.randomGenerator.integer(100),
      'Day Score': faker.randomGenerator.integer(100),
      'Challenge Won': 'Max Lean Angle',
    },
    {
      'Rider': faker.person.name(),
      'Image': SvgPicture.memory(getRandomSvgCode()),
      'Skill': faker.randomGenerator.integer(100),
      'Day Score': faker.randomGenerator.integer(100),
      'Challenge Won': 'Time Trial',
    },
    {
      'Rider': faker.person.name(),
      'Image': SvgPicture.memory(getRandomSvgCode()),
      'Skill': faker.randomGenerator.integer(100),
      'Day Score': faker.randomGenerator.integer(100),
      'Challenge Won': 'Average Speed',
    },
    {
      'Rider': faker.person.name(),
      'Image': SvgPicture.memory(getRandomSvgCode()),
      'Skill': faker.randomGenerator.integer(100),
      'Day Score': faker.randomGenerator.integer(100),
      'Challenge Won': 'Max Lean Angle',
    },
    {
      'Rider': faker.person.name(),
      'Image': SvgPicture.memory(getRandomSvgCode()),
      'Skill': faker.randomGenerator.integer(100),
      'Day Score': faker.randomGenerator.integer(100),
      'Challenge Won': 'Time Trial',
    },
    {
      'Rider': faker.person.name(),
      'Image': SvgPicture.memory(getRandomSvgCode()),
      'Skill': faker.randomGenerator.integer(100),
      'Day Score': faker.randomGenerator.integer(100),
      'Challenge Won': 'Average Speed',
    },



  ];

  var navigationController = Get.put(NavigationController());
  var locationController = Get.put(LocationController());
  var logginController = Get.put(LoggingController());
  var replayController = Get.put(ReplayTimerController());

  List<Color> metricColors = [Colors.green, Colors.blue, Colors.red];
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
  bool isReplaying = false;

  var eventFinancials = [
    EventFinancialDatum('Jan',cost: 1000, revenue: 2000, recieved: 1000, refunds:1500),
    EventFinancialDatum('Feb',cost: 1500, revenue: 2500, recieved: 1500, refunds:2000),
    EventFinancialDatum('Mar',cost: 2000, revenue: 3000, recieved: 2000, refunds:2500),
    EventFinancialDatum('Apr',cost: 2500, revenue: 3500, recieved: 2500, refunds:3000),
    EventFinancialDatum('May',cost: 3000, revenue: 4000, recieved: 3000, refunds:3500),
    EventFinancialDatum('Jun',cost: 3500, revenue: 4500, recieved: 3500, refunds:4000),
    EventFinancialDatum('Jul',cost: 4000, revenue: 5000, recieved: 4000, refunds:4500),
    EventFinancialDatum('Aug',cost: 4500, revenue: 5500, recieved: 4500, refunds:5000),
    EventFinancialDatum('Sep',cost: 5000, revenue: 6000, recieved: 5000, refunds:5500),
    EventFinancialDatum('Oct',cost: 5500, revenue: 6500, recieved: 5500, refunds:6000),
    EventFinancialDatum('Nov',cost: 6000, revenue: 7000, recieved: 6000, refunds:6500),
    EventFinancialDatum('Dec',cost: 6500, revenue: 7500, recieved: 6500, refunds:7000),
  ];

  var selectedChallengeCategory = 'Time Trial';
  var allChallengeCategories = ['Time Trial', 'Average Speed', 'Max Lean Angle', 'All'];
  String selefctedTimeRange = 'Last 3 Months';
  var selectedFinancialOverlays = {'Revenue'};
  var allFinancialOverlays = ['Revenue', 'Cost', 'Received', 'Refunds'];

  @override
  void dispose() {
    replayController.pauseTimer();
    logginController.stopSensorStreams();
    super.dispose();
  }

  @override
  void initState() {

    allSessions = List.generate(10, (index) => TileSession(
      title: faker.company.name(),
      isCompleted: index.isEven,
      capacity: 10,
      group: faker.company.name(),
    ));

    tabController = TabController(length: userController.selectedUserType.value == UserType.PROMOTER ? 5 : 7, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Event'),

        actions: [
          //publish
          ElevatedButton.icon(

            onPressed: () {
              showDialog(context: context, builder: (context) {
                return AlertDialog(
                  title: const Text('Publish Event'),
                  content: const Text('Are you sure you want to publish this event?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                       Get.back();
                      },
                      child: const Text('No'),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.offAll(MainScreen());
                      },
                      child: const Text('Yes'),
                    ),
                  ],
                );
              });


            },
            icon: const Icon(LineIcons.upload),
            label: const Text('Publish' , style: TextStyle(color: Colors.white),),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(primaryColor),
              shape: WidgetStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              )),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(faker.company.name(), style: const TextStyle(fontSize: 18)),
                  Row(
                    children: [
                      // map pin
                      const Icon(Icons.location_on, color: primaryColor),
                      const SizedBox(width: 5),
                      getSkewedChipText(-0.3, faker.address.city(), textStyle: const TextStyle(color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            const SizedBox(height: 10),
            TabBar(
              isScrollable: true,
              controller: tabController,
              splashBorderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              indicatorColor: primaryColor,



              indicatorPadding: const EdgeInsets.symmetric(horizontal: -25),
              dividerColor: primaryColor,

              labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
              tabs: [
                const Tab(text: 'Overview'),
                const Tab(text: 'Challenges'),
                const Tab(text: 'Event Performance'),
                const Tab(text: 'Financials'),
                const Tab(text: 'Historical Analysis'),
                if(userController.selectedUserType.value == UserType.COACH)
                  const Tab(text: 'Event Participants'),
                if(userController.selectedUserType.value == UserType.CLUB)
                  const Tab(text: 'Event Members'),
                /*if(userController.selectedUserType.value == UserType.COACH)
                  const Tab(text: 'Analyse My Ride'),*/
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  // Overview
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Points of interest
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MetricContainer(value: '5', text: 'Registered Riders', height: 110,),
                            MetricContainer(value: '5', text: 'LMR Riders', height: 110,),
                            MetricContainer(value: '5', text: 'Laps/Session', height: 110,),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(

                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Event Timeline', style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children:
                            stops.map((e) => Row(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 3,
                                      color: primaryColor,
                                    ),
                                    const SizedBox(height: 5,),
                                  ],
                                ),
                                AppContainer(
                                  width: 120,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Icon(e['icon'] as IconData, color: primaryColor,),
                                        const SizedBox(height: 2,),
                                        Text(e['title'].toString(), style: const TextStyle(fontSize: 12),),
                                        Text('${e['distance']}', style: const TextStyle(fontSize: 12),),
                                      ],
                                    ),
                                  ),
                                ),
                                //dotted line with distance above it


                              ],
                            )).toList(),

                          ),
                        ),
                        const SizedBox(height: 10),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(

                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Event Schedule', style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                        AppContainer(
                          child: Column(

                            children: eventSchedules.map((e) {
                              return ListTile(
                                leading: const Icon(Icons.schedule, color: primaryColor,),
                                title: Text(e['title'].toString(), style: const TextStyle(fontSize: 16),),
                                subtitle: Text(faker.date.justTime(), style: const TextStyle(fontSize: 14),),
                              );
                            }).toList(),

                          ),
                        ),
                        /*Expanded(
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return CustomTimelineTile(
                                isFirst: index == 0,
                                isLast: index == allSessions.length - 1,
                                session: allSessions[index],
                              );
                            },
                            itemCount: allSessions.length,
                            shrinkWrap: true,
                          ),
                        ),*/
                      ],
                    ),
                  ),
                  // Challenges
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //segmented buttons
                        Row(
                          children: [
                            const Text('Category'),
                            const Spacer(),
                            GestureDetector(
                              onTapDown: (details) {
                                //show modal bottom sheet
                                showMenu(
                                    context: context,
                                    position:   RelativeRect.fromLTRB(details.globalPosition.dx, details.globalPosition.dy, 0, 0),
                                    items: allChallengeCategories.map((e) {
                                  return PopupMenuItem(
                                    value: e,
                                    onTap: () {
                                      setState(() {
                                        selectedChallengeCategory = e;
                                      });
                                    },
                                    child: Text(e),
                                  );
                                }).toList());
                              },
                              child: TextButton.icon(
                                  onPressed: () {},
                                  label: Text(selectedChallengeCategory, style: const TextStyle(color: Colors.grey),),
                                  icon: const Icon(LineIcons.filter, color: Colors.grey, size: 20,),
                              ),
                            ),
                          ],

                        ),
                        //table
                        AppContainer(
                          child: Column(
                            children:   alLChallenges
                                .map((challenge) => ListTile(
                              onTap: () {
                                Get.to(() => const EventParticipantsScreen());
                              },
                              leading: CircleAvatar(
                                backgroundColor: primaryColor,
                                child: SvgPicture.memory(getRandomSvgCode()),
                              ),
                              title: Text(challenge['Rider'].toString()),
                              subtitle: Text('${(challenge['value'] as List<String>)[
                                selectedChallengeCategory == 'Time Trial' ? 0 : selectedChallengeCategory == 'Average Speed' ? 2 : 1
                              ]}${selectedChallengeCategory == 'Average Speed' ? '' : (selectedChallengeCategory == 'Max Lean Angle' ? '°' : '')}'),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      challenge['Rank'].toString(),
                                      style: const TextStyle(
                                          color: primaryColor,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold
                                      )
                                  ),
                                  const Text('Rank')
                                ],
                              ),
                            ),).toList(),),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text('Rider Count', style: TextStyle(fontSize: 14),),
                              const Spacer(),
                              GestureDetector(
                                onTapDown: (details) {
                                  //show modal bottom sheet
                                  showMenu(
                                      context: context,
                                      position:   RelativeRect.fromLTRB(details.globalPosition.dx, details.globalPosition.dy, 0, 0),
                                      items: ['Last 3 Months', 'Last 6 Months', 'Last 12 Months'].map((e) {
                                        return PopupMenuItem(
                                          value: e,
                                          onTap: () {
                                            setState(() {
                                              selefctedTimeRange = e;
                                            });
                                          },
                                          child: Text(e),
                                        );
                                      }).toList());
                                },
                                child: TextButton.icon(
                                  onPressed: () {

                                  },
                                  icon: const Icon(LineIcons.filter, color: Colors.grey, size: 20,),
                                  label: Text( selefctedTimeRange, style: const TextStyle(color: Colors.grey),),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8,),
                          Row(
                              children: [
                                if(selectedRiderCountOverlays.contains('Marketing Sent'))
                                  ...[ const Row(children: [CircleAvatar(backgroundColor: Colors.green, radius:8), SizedBox(width: 5,), Text('Marketing Sent', style: TextStyle(fontSize: 12),), SizedBox(width:5)],)],
                                if(selectedRiderCountOverlays.contains('Marketing Read'))
                                  ...[ const Row(children: [CircleAvatar(backgroundColor: Colors.blue, radius:6), SizedBox(width: 5,), Text('Marketing Read', style: TextStyle(fontSize: 12)), SizedBox(width:5)],)],
                                if(selectedRiderCountOverlays.contains('Registered Via LMR'))
                                  ...[ const Row(children: [CircleAvatar(backgroundColor: Colors.yellow, radius:6), SizedBox(width: 5,), Text('Registered Via LMR', style: TextStyle(fontSize: 12)), SizedBox(width:5)],)],

                              ]
                          ),
                          const SizedBox(height: 8,),

                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SegmentedButton(
                                  style: ButtonStyle(
                                    shape: WidgetStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        side: const BorderSide(color: primaryColor),
                                      ),
                                    ),
                                  ),
                                  segments:  riderCountOverlays.map((e) => ButtonSegment(value: e, label: Text(e))).toList(),
                                  multiSelectionEnabled: true,
                                  emptySelectionAllowed: true,
                                  showSelectedIcon: false,
                                  selected: selectedRiderCountOverlays,
                                  onSelectionChanged: (value) {
                                    setState(() {
                                      selectedRiderCountOverlays = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8,),

                          AppContainer(
                            child: SfCartesianChart(
                              primaryXAxis: CategoryAxis(
                                majorGridLines: const MajorGridLines(width: 0),
                                minorGridLines: const MinorGridLines(width: 0),
                              ),
                              series: <ChartSeries>[

                                  ColumnSeries<RiderCountDatum, String>(
                                    dataSource: riderCountData.sublist(0, selefctedTimeRange == 'Last 3 Months' ? 3 : selefctedTimeRange == 'Last 6 Months' ? 6 : 12),
                                    xValueMapper: (RiderCountDatum sales, _) => sales.month,
                                    yValueMapper: (RiderCountDatum sales, _) => sales.riders,
                                    color:  selectedRiderCountOverlays.isEmpty ? primaryColor : Colors.grey,
                                    dataLabelSettings: const DataLabelSettings(isVisible: false),
                                  ),
                                if (selectedRiderCountOverlays.contains('Marketing Sent'))
                                  //line series
                                  LineSeries<RiderCountDatum, String>(
                                    markerSettings: const MarkerSettings(isVisible: true),
                                    dataSource: riderCountData.sublist(0, selefctedTimeRange == 'Last 3 Months' ? 3 : selefctedTimeRange == 'Last 6 Months' ? 6 : 12),
                                    xValueMapper: (RiderCountDatum sales, _) => sales.month,
                                    yValueMapper: (RiderCountDatum sales, _) => sales.marketingSent,
                                    color: Colors.green,
                                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                                  ),
                                if (selectedRiderCountOverlays.contains('Marketing Read'))
                                  //line series
                                  LineSeries<RiderCountDatum, String>(
                                    markerSettings: const MarkerSettings(isVisible: true),
                                    dataSource: riderCountData.sublist(0, selefctedTimeRange == 'Last 3 Months' ? 3 : selefctedTimeRange == 'Last 6 Months' ? 6 : 12),
                                    xValueMapper: (RiderCountDatum sales, _) => sales.month,
                                    yValueMapper: (RiderCountDatum sales, _) => sales.marketingRead,
                                    color: Colors.blue,
                                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                                  ),
                                if (selectedRiderCountOverlays.contains('Registered Via LMR'))
                                  //line series
                                  LineSeries<RiderCountDatum, String>(
                                    markerSettings: const MarkerSettings(isVisible: true),
                                    dataSource: riderCountData.sublist(0, selefctedTimeRange == 'Last 3 Months' ? 3 : selefctedTimeRange == 'Last 6 Months' ? 6 : 12),
                                    xValueMapper: (RiderCountDatum sales, _) => sales.month,
                                    yValueMapper: (RiderCountDatum sales, _) => sales.registeredViaLmr,
                                    color: Colors.yellow,
                                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                                  ),
                              ],
                            )
                          ),
                          const SizedBox(height: 8,),
                          SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection:  Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                MetricContainer(value: '+15% ', label: 'Vs Last Month', valueColor:Colors.green, icon: LineIcons.arrowUp,),
                                const SizedBox(width: 8,),
                                MetricContainer(value: '+25%', label: 'Vs Last 3 Months', valueColor:Colors.green, icon: LineIcons.arrowUp,),
                                const SizedBox(width: 8,),
                                MetricContainer(value: '-1.5%', label: 'Vs Last 6 Months', valueColor:Colors.red, icon: LineIcons.arrowDown,),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  // Financials
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Text('Overview', style: TextStyle(fontSize: 14),),
                              const Spacer(),
                              GestureDetector(
                                onTapDown: (details) {
                                  //show modal bottom sheet
                                  showMenu(
                                      context: context,
                                      position:   RelativeRect.fromLTRB(details.globalPosition.dx, details.globalPosition.dy, 0, 0),
                                      items: ['Last 3 Months', 'Last 6 Months', 'Last 12 Months'].map((e) {
                                        return PopupMenuItem(
                                          value: e,
                                          onTap: () {
                                            setState(() {
                                              selefctedTimeRange = e;
                                            });
                                          },
                                          child: Text(e),
                                        );
                                      }).toList());
                                },
                                child: TextButton.icon(
                                  onPressed: () {

                                  },
                                  icon: const Icon(LineIcons.filter, color: Colors.grey, size: 20,),
                                  label: Text( selefctedTimeRange, style: const TextStyle(color: Colors.grey),),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8,),
                          const SizedBox(height: 8,),
                          Row(
                              children: [
                                if(selectedFinancialOverlays.contains('Revenue'))
                                  ...[ const Row(children: [CircleAvatar(backgroundColor: Colors.red, radius:6), SizedBox(width: 5,), Text('Revenue', style: TextStyle(fontSize: 12),), SizedBox(width:5)],)],
                                if(selectedFinancialOverlays.contains('Cost'))
                                  ...[ const Row(children: [CircleAvatar(backgroundColor: Colors.green, radius:6), SizedBox(width: 5,), Text('Cost', style: TextStyle(fontSize: 12)), SizedBox(width:5)],)],
                                if(selectedFinancialOverlays.contains('Received'))
                                  ...[ const Row(children: [CircleAvatar(backgroundColor: Colors.blue, radius:6), SizedBox(width: 5,), Text('Received', style: TextStyle(fontSize: 12)), SizedBox(width:5)],)],
                                if(selectedFinancialOverlays.contains('Refunds'))
                                  ...[ const Row(children: [CircleAvatar(backgroundColor: Colors.yellow, radius:6), SizedBox(width: 5,), Text('Refunds', style: TextStyle(fontSize: 12)), SizedBox(width:5)],)],

                              ]
                          ),
                          const SizedBox(height: 8,),

                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SegmentedButton(

                                  style: ButtonStyle(
                                    shape: WidgetStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        side: const BorderSide(color: primaryColor),
                                      ),
                                    ),
                                  ),
                                  segments:  allFinancialOverlays.map((e) => ButtonSegment(value: e, label: Text(e))).toList(),
                                  multiSelectionEnabled: true,
                                  emptySelectionAllowed: false,
                                  showSelectedIcon: false,
                                  selected: selectedFinancialOverlays,
                                  onSelectionChanged: (value) {
                                    setState(() {
                                      selectedFinancialOverlays = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8,),
                          AppContainer(
                            child: SfCartesianChart(

                              primaryXAxis: CategoryAxis(
                                majorGridLines: const MajorGridLines(width: 0),
                                minorGridLines: const MinorGridLines(width: 0),
                              ),
                              series: <ChartSeries>[
                                //bar chart

                                if(selectedFinancialOverlays.contains('Revenue'))
                                  StackedColumnSeries<EventFinancialDatum, String>(
                                    dataSource: eventFinancials.sublist(0, selefctedTimeRange == 'Last 3 Months' ? 3 : selefctedTimeRange == 'Last 6 Months' ? 6 : 12),
                                    xValueMapper: (EventFinancialDatum sales, _) => sales.month,
                                    yValueMapper: (EventFinancialDatum sales, _) => sales.revenue,
                                    color: Colors.red,
                                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                                  ),
                                if(selectedFinancialOverlays.contains('Cost'))
                                  StackedColumnSeries<EventFinancialDatum, String>(
                                    dataSource: eventFinancials.sublist(0, selefctedTimeRange == 'Last 3 Months' ? 3 : selefctedTimeRange == 'Last 6 Months' ? 6 : 12),
                                    xValueMapper: (EventFinancialDatum sales, _) => sales.month,
                                    yValueMapper: (EventFinancialDatum sales, _) => sales.cost,
                                    color: Colors.green,
                                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                                  ),
                                if(selectedFinancialOverlays.contains('Received'))
                                  StackedColumnSeries<EventFinancialDatum, String>(
                                    dataSource: eventFinancials.sublist(0, selefctedTimeRange == 'Last 3 Months' ? 3 : selefctedTimeRange == 'Last 6 Months' ? 6 : 12),
                                    xValueMapper: (EventFinancialDatum sales, _) => sales.month,
                                    yValueMapper: (EventFinancialDatum sales, _) => sales.recieved,
                                    color: Colors.blue,
                                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                                  ),
                                if(selectedFinancialOverlays.contains('Refunds'))
                                  StackedColumnSeries<EventFinancialDatum, String>(
                                    dataSource: eventFinancials.sublist(0, selefctedTimeRange == 'Last 3 Months' ? 3 : selefctedTimeRange == 'Last 6 Months' ? 6 : 12),
                                    xValueMapper: (EventFinancialDatum sales, _) => sales.month,
                                    yValueMapper: (EventFinancialDatum sales, _) => sales.refunds,
                                    color: Colors.yellow,
                                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8,),
                          SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection:  Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                MetricContainer(value: '+15% ', label: 'Vs Last Month', valueColor:Colors.green, icon: LineIcons.arrowUp,),
                                const SizedBox(width: 8,),
                                MetricContainer(value: '+25%', label: 'Vs Last 3 Months', valueColor:Colors.green, icon: LineIcons.arrowUp,),
                                const SizedBox(width: 8,),
                                MetricContainer(value: '-1.5%', label: 'Vs Last 6 Months', valueColor:Colors.red, icon: LineIcons.arrowDown,),
                              ],
                            ),
                          )

                        ],
                      ),
                    ),
                  ),
                  // Historical Analysis
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Text('Historical Financial Analysis', style: TextStyle(fontSize: 14),),
                              const Spacer(),
                              GestureDetector(
                                onTapDown: (details) {
                                  //show modal bottom sheet
                                  showMenu(
                                      context: context,
                                      position:   RelativeRect.fromLTRB(details.globalPosition.dx, details.globalPosition.dy, 0, 0),
                                      items: ['Last 3 Months', 'Last 6 Months', 'Last 12 Months'].map((e) {
                                        return PopupMenuItem(
                                          value: e,
                                          onTap: () {
                                            setState(() {
                                              selefctedTimeRange = e;
                                            });
                                          },
                                          child: Text(e),
                                        );
                                      }).toList());
                                },
                                child: TextButton.icon(
                                  onPressed: () {

                                  },
                                  icon: const Icon(LineIcons.filter, color: Colors.grey, size: 20,),
                                  label: Text( selefctedTimeRange, style: const TextStyle(color: Colors.grey),),
                                ),
                              ),

                            ],
                          ),
                          const SizedBox(height: 8,),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            child: DataTable(
                              showCheckboxColumn: false,

                              dividerThickness: 3,
                              columnSpacing: 15,

                                columns:  const [
                                  DataColumn(label: Text('Venue', style: TextStyle(fontSize: 14, color: primaryColor),)),
                                  DataColumn(label: Text('Avg Cost', style: TextStyle(fontSize: 14, color: primaryColor))),
                                  DataColumn(label: Text('Avg Revenue', style: TextStyle(fontSize: 14, color: primaryColor))),
                                  DataColumn(label: Text('Avg Rider Count', style: TextStyle(fontSize: 14, color: primaryColor))),
                                  DataColumn(label: Text('LMR Marketing Notifications', style: TextStyle(fontSize: 14, color: primaryColor))),
                                ],
                                rows: historicalAnalysisData.sublist(0, selefctedTimeRange == 'Last 3 Months' ? 3 : selefctedTimeRange == 'Last 6 Months' ? 6 : 12).map((e) {
                                  return DataRow(
                                    onSelectChanged: (value) {
                                      //show modal bottom sheet
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return Container(
                                              padding: const EdgeInsets.all(8),
                                              child: Column(
                                                children: [
                                                  Text('${e.venue}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                                  const SizedBox(height: 8,),
                                                  //pie chart
                                                  SfCircularChart(

                                                    legend: Legend(isVisible: false),
                                                    palette: const [
                                                      Colors.red,
                                                      Colors.green,
                                                      Colors.blue,
                                                      Colors.pink,
                                                    ],
                                                    series: <CircularSeries>[
                                                      DoughnutSeries<ChartData, String>(
                                                        cornerStyle: CornerStyle.bothFlat,
                                                        explodeAll: true,
                                                        dataSource: [
                                                          ChartData('Avg Cost', e.avgCost),
                                                          ChartData('Avg Revenue', e.avgRevenue),
                                                          ChartData('Avg Rider Count', e.avgRiderCount),
                                                          ChartData('LMR Marketing Notifications', e.LMRMarketingNotifications),
                                                        ],
                                                        xValueMapper: (ChartData data, _) => data.label,
                                                        yValueMapper: (ChartData data, _) => data.value,
                                                        dataLabelMapper: (ChartData data, _) => '${data.label}: \$${data.value}',
                                                        dataLabelSettings: const DataLabelSettings(isVisible: true),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          });
                                    },
                                    cells: [
                                      DataCell(Text(e.venue)),
                                      DataCell(Text('\$${e.avgCost}')),
                                      DataCell(Text('\$${e.avgRevenue}')),
                                      DataCell(Text('${e.avgRiderCount}')),
                                      DataCell(Text('${e.LMRMarketingNotifications}')),
                                    ],
                                  );
                                }).toList()
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  if(userController.selectedUserType.value == UserType.COACH || userController.selectedUserType.value == UserType.CLUB)
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            if(userController.selectedUserType.value == UserType.COACH)
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    MetricContainer(value: '${eventParticipants.length - 3}', label: 'Interested',),
                                    MetricContainer(value: '${eventParticipants.length}', label: 'Notified',),
                                    MetricContainer(value: '65%', label: 'Clicked',),
                                    MetricContainer(value: '25', label: 'Registered',),
                                  ],
                                ),
                              ),
                            Column(
                              children: eventParticipants.map((e) {
                                return AppContainer(
                                  child: ListTile(

                                    onTap: () {
                                      showModalBottomSheet(
                                        isScrollControlled: true,
                                          context: context, builder: (context) {
                                        return SizedBox(
                                          width: double.infinity,
                                          height: 800,
                                          child: SingleChildScrollView(
                                            physics: const BouncingScrollPhysics(),
                                            child: Column(
                                              children: [
                                                Stack(
                                                  children: [
                                                    AppContainer(
                                                      height: 0,
                                                      child: ClipRRect(
                                                        clipBehavior: Clip.antiAlias,
                                                        borderRadius: BorderRadius.circular(10),
                                                        child:
                                                        Obx(() {
                                                          var controller = locationController.controller.value;
                                                          var isPlaying = replayController.isPlaying.value;
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

                                                            ),
                                                          );
                                                        }),
                                                      ),),


                                                  ],
                                                ),
                                                const SizedBox(height: 10,),
                                                //plot title

                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      const Text('AnalyseMyRide', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
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
                                                ),

                                                const SizedBox(height: 10,),
                                                RandomSplineChart(
                                                  series: splineData,
                                                  selectedMetrics: selectedMetrics,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      });

                                    },
                                    leading: CircleAvatar(
                                      backgroundColor: primaryColor,
                                      child: e['Image'] as SvgPicture,
                                    ),
                                    title: Text(e['Rider'].toString()),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.star, color: primaryColor, size: 15,),
                                            Text('Skill: ${e['Skill']}', style: TextStyle(fontSize: 12),),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Icon(Icons.star, color: primaryColor, size: 15,),
                                            Text('Day Score: ${e['Day Score']}', style: TextStyle(fontSize: 12)),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Icon(Icons.star, color: primaryColor, size: 15,),
                                            Text('Challenge Won: ${e['Challenge Won']}', style: TextStyle(fontSize: 12)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            )
                          ],
                        ),
                      ),
                    ),
                  /*if(userController.selectedUserType.value == UserType.COACH)
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              AppContainer(
                                height: 0,
                                child: ClipRRect(
                                  clipBehavior: Clip.antiAlias,
                                  borderRadius: BorderRadius.circular(10),
                                  child:
                                  Obx(() {
                                    var controller = locationController.controller.value;
                                    var isPlaying = replayController.isPlaying.value;
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

                                      ),
                                    );
                                  }),
                                ),),


                            ],
                          ),
                          const SizedBox(height: 10,),
                          //plot title

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Plot', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
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
                                              *//*
                                              Text(allMetrics.indexOf(e) == 0 ? currentSpeed.toString() : allMetrics.indexOf(e) == 1 ? currentRPM.toString() : currentLeanAngle.toString(), style: TextStyle(fontSize: 12, color: metricColors[allMetrics.indexOf(e)], fontWeight: FontWeight.bold),),
                                          *//*
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 10,),
                          RandomSplineChart(
                            series: splineData,
                            selectedMetrics: selectedMetrics,
                          ),
                        ],
                      ),
                    )*/

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HistoricalAnalysisDatum {
  final String venue;
  final int avgCost;
  final int avgRevenue;
  final int avgRiderCount;
  final int LMRMarketingNotifications;

  HistoricalAnalysisDatum(this.venue, {required this.avgCost, required this.avgRevenue, required this.avgRiderCount, required this.LMRMarketingNotifications});
}

class EventFinancialDatum {
  final String month;
  final int cost;
  final int revenue;
  final int recieved;
  final int refunds;

  EventFinancialDatum(this.month, {required this.cost, required this.revenue, required this.recieved, required this.refunds});
}

class RiderCountDatum {
  final String month;
  final int riders;
  final int marketingSent;
  final int marketingRead;
  final int registeredViaLmr;
  final int registeredCash;


  RiderCountDatum(this.month, this.riders, this.marketingSent, this.marketingRead, this.registeredViaLmr, this.registeredCash);
}

class ChartData {
  final String label;
  final int value;

  ChartData(this.label, this.value);
}
