import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:log_my_ride/views/screens/splash_screen.dart';
import 'package:log_my_ride/views/widgets/app_container.dart';
import 'package:log_my_ride/views/widgets/dummy_map_container.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../utils/constants.dart';
import '../../utils/utils.dart';
import '../widgets/timer_builder.dart';
import 'complete_event_screen.dart';
import 'main_screen.dart';

class CurrentEventScreen extends StatefulWidget {

  var allUpcomingNotification = [
    {
      'title': 'Session 2 is about to start',
      'subtitle': 'in 35 minutes',
    },
    {
      'title': 'Session 3 is about to start',
      'subtitle': 'in 75 minutes',
    },
    {
      'title': 'Session 4 is about to start',
      'subtitle': 'in 115 minutes',
    },
    {
      'title': 'Session 5 is about to start',
      'subtitle': 'in 215 minutes',
    },

  ];


  var allSessions = [

    {
      'Session': 2,
      'Time': DateTime.now().add(const Duration(minutes: 45)),
    },
    // add 45 minutes
    {
      'Session': 3,
      'Time': DateTime.now().add(const Duration(minutes: 90)),
    },
    // add 45 minutes
    {
      'Session': 4,
      'Time': DateTime.now().add(const Duration(minutes: 135)),
    },
    // add 45 minutes
    {
      'Session': 5,
      'Time': DateTime.now().add(const Duration(minutes: 180)),
    },
  ];

  final List<Map<String, dynamic>> stops = [
    {
      'icon': Icons.local_gas_station,
      'title': 'Gas Station',
      'distance': '5 km',
      'time': '10 mins'
    },
    {
      'icon': Icons.restaurant,
      'title': 'Restaurant',
      'distance': '15 km',
      'time': '20 mins'
    },
    {
      'icon': Icons.hotel,
      'title': 'Hotel',
      'distance': '25 km',
      'time': '30 mins'
    },
    {
      'icon': Icons.local_parking,
      'title': 'Parking',
      'distance': '35 km',
      'time': '40 mins'
    },
  ];

  late List<Map<String, dynamic>> allRiders;


  Map<String, dynamic> currentEvent;
  CurrentEventScreen({super.key, required this.currentEvent});

  @override
  State<CurrentEventScreen> createState() => _CurrentEventScreenState();
}

class _CurrentEventScreenState extends State<CurrentEventScreen> {



  var openTrack = false;
  var floatingButtonVisible = false;
  late ScrollController _scrollController;

  @override
  void initState() {
    widget.allRiders = [
      {
        'Rider': faker.person.name(),
        'Time/Score': '01:30:00',
        'Rank': '1',
        'Crash': 'No',
        'Fastest': true,
        'Image': SvgPicture.memory(getRandomSvgCode()),
        'Skill': 'Beginner',
        'Challenge Type': 'Time Trial',

      },
      {
        'Rider': faker.person.name(),
        'Time/Score': '01:30:00',
        'Rank': '2',
        'Image': SvgPicture.memory(getRandomSvgCode()),
        'Crash': 'No',

        'Skill': 'Intermediate',
        'Challenge Type': 'Time Trial',
      },
      {
        'Rider': faker.person.name(),
        'Time/Score': '01:30:00',
        'Rank': '3',
        'Image': SvgPicture.memory(getRandomSvgCode()),
        'Crash': 'No',
        'Skill': 'Expert',
        'Challenge Type': 'Time Trial',
      },
      {
        'Rider': faker.person.name(),
        'Time/Score': '01:30:00',
        'Rank': '4',
        'Image': SvgPicture.memory(getRandomSvgCode()),
        'Crash': 'No',
        'Skill': 'Intermediate',
        'Challenge Type': 'Time Trial',
      },
      {
        'Rider': faker.person.name(),
        'Time/Score': '01:30:00',
        'Rank': '5',
        'Crash': 'No',
        'Image': SvgPicture.memory(getRandomSvgCode()),
        'Skill': 'Beginner',
        'Challenge Type': 'Time Trial',
      },
      {
        'Rider': faker.person.name(),
        'Time/Score': '01:30:00',
        'Rank': '6',
        'Crash': 'Yes',
        'Skill': 'Master',
        'Image': SvgPicture.memory(getRandomSvgCode()),
        'Challenge Type': 'Time Trial',
      },
      {
        'Rider': faker.person.name(),
        'Time/Score': '01:30:00',
        'Rank': '7',
        'Crash': 'No',
        'Skill': 'Beginner',
        'Image': SvgPicture.memory(getRandomSvgCode()),
        'Challenge Type': 'Time Trial',
      },
      {
        'Rider': faker.person.name(),
        'Time/Score': '01:30:00',
        'Rank': '8',
        'Crash': 'No',
        'Slowest': true,
        'Skill': 'Beginner',
        'Image': SvgPicture.memory(getRandomSvgCode()),
        'Challenge Type': 'Time Trial',
      },

    ];

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if(_scrollController.offset > 100){
        setState(() {
          floatingButtonVisible = true;
        });
      }else{
        setState(() {
          floatingButtonVisible = false;
        });
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Current Event'),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 15),
            child: Row(
              children: [
                Lottie.asset('assets/animations/recording.json', width: 25, height: 25),
                getChipText('02:45:00', bgColor: Colors.red[900], textSize: 15),
              ],
            ),
          ),
          //notifications icon
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
              onPressed: () {
                showModalBottomSheet(
                  showDragHandle: true,
                  sheetAnimationStyle: AnimationStyle(curve: Curves.easeInOut, duration: const Duration(milliseconds: 500)),
                  isScrollControlled: true,
                    context: context, builder: (context) {
                  return Column(
                    children: [
                      Column(
                        children: [
                            const Text('Upcoming Notifications', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                            //previous, next, play, pause
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                    ),

                                    onPressed: () {},
                                    child: const Icon(LineIcons.alternateArrowCircleLeftAlt, color: Colors.white,)
                                ),
                                const SizedBox(width: 3,),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                    ),

                                    onPressed: () {

                                    },
                                    child: const Icon(LineIcons.pause, color: Colors.white,)
                                ),
                                const SizedBox(width: 3,),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                    ),
                                    onPressed: () {

                                    },
                                    child: const Icon(LineIcons.alternateArrowCircleRightAlt, color: Colors.white,)
                                ),
                              ],
                            )
                        ],
                      ),
                      const Divider(),
                      Expanded(
                        child: ListView.builder(

                          itemCount: widget.allUpcomingNotification.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: const CircleAvatar(
                                backgroundColor: primaryColor,
                                child: Icon(Icons.notifications, color: Colors.white,),
                              ),
                              title: Text(widget.allUpcomingNotification[index]['title'].toString()),
                              subtitle: Text(widget.allUpcomingNotification[index]['subtitle'].toString()),
                            );
                          },
                        ),
                      )

                    ],
                  );
                });
              },
              icon: const Icon(Icons.notifications),
            )
          )

        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: double.infinity,
        height: floatingButtonVisible ? 60 : 0,
        child: ElevatedButton(
          onPressed:  () {
            showDialog(context: context, builder: (context) {
              return AlertDialog(
                title: const Text('End Event'),
                content: const Text('Are you sure you want to end the event?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel', style: TextStyle(color: primaryColor),),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Get.off(() => CompleteEventScreen(currentEvent: widget.currentEvent ,));

                    },
                    child: const Text('End Event', style: TextStyle(color: Colors.red),),
                  )
                ],
              );
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightGreen[900],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
          ), child: const Text('End Event'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          controller: _scrollController,

          physics: const BouncingScrollPhysics(),
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    AppContainer(
                      width: 100,
                      height: 70,

                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Time Left', style: TextStyle(fontSize: 12),),
                            const SizedBox(height: 5,),
                            SizedBox(
                              width: 70,
                              child: TimerBuilder.periodic(const Duration(seconds: 1), builder: (context) {
                                return getChipText(getHHMMSS(widget.allSessions[0]['Time'] as DateTime), bgColor: Colors.green[900]);
                              }),
                            )
                          ],
                        ),
                      ),
                    ),
                    AppContainer(
                      width: 120,
                      height: 70,

                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Schedule', style: TextStyle(fontSize: 12),),
                            const SizedBox(height: 5,),
                            SizedBox(
                              width: 80,
                              child: getChipText('5mins behind', bgColor: Colors.red[900]),
                            )
                          ],
                        ),
                      ),
                    ),
                    AppContainer(
                      width: 120,
                      height: 70,

                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('LMR Data Sync', style: TextStyle(fontSize: 12),),
                            const SizedBox(height: 5,),
                            SizedBox(
                              width: 70,
                              child: getChipText('No Issues', bgColor: Colors.green[900]),
                            )
                          ],
                        ),
                      ),
                    ),
                    AppContainer(
                      width: 130,
                      height: 70,

                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Group Speed Diff', style: TextStyle(fontSize: 12),),
                            const SizedBox(height: 5,),
                            SizedBox(
                              width: 70,
                              child: getChipText('Under Avg', bgColor: Colors.red[900]),
                            )
                          ],
                        ),
                      ),
                    ),
                    AppContainer(
                      width: 120,
                      height: 70,

                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Crashes', style: TextStyle(fontSize: 12),),
                            const SizedBox(height: 5,),
                            SizedBox(
                              width: 70,
                              child: getChipText('None', bgColor: Colors.green[900]),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              //current session title

              /*TabBar(tabs: [
                Tab(text: 'Session 1',),
                Tab(text: 'Session 2',),
                Tab(text: 'Session 3',),
                Tab(text: 'Session 4',),
                Tab(text: 'Session 5',),
                Tab(text: 'Session 6',),
              ]),*/

              if(widget.currentEvent['eventType'].toString().contains('Track'))
                ...[
                  Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,

                        children: [
                          const Text('Session 1', style: TextStyle(fontSize: 14),),
                          /*SizedBox(width: 10,),
                    getChipText('00:30:45'),
                    Spacer(),*/
                          const SizedBox(width: 10,),
                          getChipText('Active', bgColor: Colors.green, textSize: 11),
                        ],
                      )

                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        AppContainer(
                          width: 100,
                          height: 70,

                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Schedule', style: TextStyle(fontSize: 12),),
                                const SizedBox(height: 5,),
                                SizedBox(
                                  width: 70,
                                  child: getChipText('Ahead', bgColor: Colors.green[900]),
                                )
                              ],
                            ),
                          ),
                        ),
                        AppContainer(
                          width: 120,
                          height: 70,

                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Session Flow', style: TextStyle(fontSize: 12),),
                                const SizedBox(height: 5,),
                                SizedBox(
                                  width: 90,
                                  child: getChipText('0 Interruptions', bgColor: Colors.green[900]),
                                )
                              ],
                            ),
                          ),
                        ),
                        AppContainer(
                          width: 120,
                          height: 70,

                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Session Quality', style: TextStyle(fontSize: 12),),
                                const SizedBox(height: 5,),
                                SizedBox(
                                  width: 70,
                                  child: getChipText('No Traffic', bgColor: Colors.green[900]),
                                )
                              ],
                            ),
                          ),
                        ),
                        AppContainer(
                          width: 150,
                          height: 70,

                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Session Optimization', style: TextStyle(fontSize: 12),),
                                const SizedBox(height: 5,),
                                SizedBox(
                                  width: 70,
                                  child: getChipText('Rider Style', bgColor: Colors.red[900]),
                                )
                              ],
                            ),
                          ),
                        ),
                        AppContainer(
                          width: 120,
                          height: 70,

                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Crashes', style: TextStyle(fontSize: 12),),
                                const SizedBox(height: 5,),
                                SizedBox(
                                  width: 70,
                                  child: getChipText('None', bgColor: Colors.green[900]),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10,),



                  AppContainer(
                    borderColor: Colors.yellow,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.yellow,
                                radius: 6,
                              ),
                              SizedBox(width: 5,),
                              Text('Group 1', style: TextStyle(fontSize: 14),),
                              Spacer(),
                              Icon(Icons.people, size: 16, color: primaryColor,),
                              SizedBox(width: 5,),
                              Text('10'),
                            ],
                          ),
                          const SizedBox(height: 10,),
                          const Row(
                            children: [

                              Text('Laps', style: TextStyle(fontSize: 14),),

                              Spacer(),
                              SizedBox(
                                width: 15,
                                height:15,
                                child: CircularProgressIndicator(
                                  value: 0.3,
                                  backgroundColor: Colors.grey,
                                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                                  strokeWidth: 2,),
                              ),
                              SizedBox(width: 8,),
                              Text('3/7'),
                            ],
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            children: [

                              const Text('Time Left', style: TextStyle(fontSize: 14),),
                              const Spacer(),
                              getChipText('00:30:45', bgColor: Colors.yellow, textStyle: TextStyle(color: Colors.black)),
                            ],
                          ),
                          const SizedBox(height: 10,),
                          //upcoming session times
                          const Divider(),
                          const Row(
                            children: [
                              Text('UPCOMING SESSIONS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                            ],
                          ),
                          const SizedBox(height: 10,),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            child: Row(
                              children: widget.allSessions.map((e) => Padding(
                                padding: const EdgeInsets.all(5),
                                child: InkWell(
                                  onTap: () {
                                    showTimePicker
                                      (
                                        context: context,
                                        initialTime: TimeOfDay.fromDateTime(e['Time'] as DateTime)
                                    ).then((value) {
                                      if(value != null){
                                        setState(() {

                                          e['Time'] = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, value.hour, value.minute);

                                          for (var i = widget.allSessions.indexOf(e) + 1; i < widget.allSessions.length; i++) {
                                            widget.allSessions[i]['Time'] = (widget.allSessions[i - 1]['Time'] as DateTime).add(const Duration(minutes: 45));
                                          }
                                        });
                                      }
                                    });
                                  },
                                  child: AppContainer(


                                    width: 80,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Session ' + e['Session'].toString(), style: const TextStyle(fontSize: 12),),
                                        const SizedBox(height: 5,),
                                        SizedBox(
                                          width: 100,
                                          child: TimerBuilder.periodic(const Duration(seconds: 1), builder: (context) {
                                          return  getChipText(getHHMMSS(e['Time'] as DateTime), bgColor: Colors.green[900]);
                                            }),

                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )).toList(),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),

              ],
              const Divider(),

              if(widget.currentEvent['eventType'].toString().contains('Road'))
                ...[
                  const Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Journey', style: TextStyle(fontSize: 14),),
                        ],
                      )

                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [

                        AppContainer(
                          width: 120,
                          height: 70,

                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Schedule', style: TextStyle(fontSize: 12),),
                                const SizedBox(height: 5,),
                                SizedBox(
                                  width: 80,
                                  child: getChipText('5mins behind', bgColor: Colors.red[900]),
                                )
                              ],
                            ),
                          ),
                        ),
                        AppContainer(
                          width: 120,
                          height: 70,

                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('LMR Data Sync', style: TextStyle(fontSize: 12),),
                                const SizedBox(height: 5,),
                                SizedBox(
                                  width: 70,
                                  child: getChipText('No Issues', bgColor: Colors.green[900]),
                                )
                              ],
                            ),
                          ),
                        ),
                        AppContainer(
                          width: 130,
                          height: 70,

                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Group Speed Diff', style: TextStyle(fontSize: 12),),
                                const SizedBox(height: 5,),
                                SizedBox(
                                  width: 70,
                                  child: getChipText('Under Avg', bgColor: Colors.red[900]),
                                )
                              ],
                            ),
                          ),
                        ),
                        AppContainer(
                          width: 120,
                          height: 70,

                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Crashes', style: TextStyle(fontSize: 12),),
                                const SizedBox(height: 5,),
                                SizedBox(
                                  width: 70,
                                  child: getChipText('None', bgColor: Colors.green[900]),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Stack(
                    children: [
                      DummyMapContainer(width:  double.infinity, height: 200),
                      //time left to destination at bottom center
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          color: Colors.black.withOpacity(0.5),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.location_on, color: Colors.white,),
                                const SizedBox(width: 5,),
                                const Text('Time to Destination', style: TextStyle(color: Colors.white),),
                                const SizedBox(width: 5,),
                                getChipText('00:30:45 - 28 Kms', bgColor: Colors.green[900], textSize: 15),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),


                ],
              const SizedBox(height: 10,),

              //stops
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                  widget.stops.map((e) => Row(
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 100,
                              height: 3,
                              color: primaryColor,
                            ),
                            const SizedBox(height: 5,),
                            Text('5 Kms', style: const TextStyle(fontSize: 12),),
                          ],
                        ),
                        AppContainer(
                          width: 120,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Icon(e['icon'] as IconData, color: primaryColor,),
                                const SizedBox(height: 5,),
                                Text(e['title'].toString(), style: const TextStyle(fontSize: 12),),
                                Text('${e['time']}', style: const TextStyle(fontSize: 12),),
                              ],
                            ),
                          ),
                        ),
                        //dotted line with distance above it


                      ],
                    )).toList(),

                ),
              ),

              const Divider(),


              const Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,

                    children: [
                      Text('Group', style: TextStyle(fontSize: 14),),
                      /*SizedBox(width: 10,),
                    getChipText('00:30:45'),
                    Spacer(),*/
                      /*const SizedBox(width: 10,),
                      getChipText('Active', bgColor: Colors.green, textSize: 11),*/
                    ],
                  )

              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    AppContainer(
                      width: 150,
                      height: 70,

                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Optimization', style: TextStyle(fontSize: 12),),
                            const SizedBox(height: 5,),
                            SizedBox(
                              width: 100,
                              child: getChipText('Avg Rider Time', bgColor: Colors.green[900]),
                            )
                          ],
                        ),
                      ),
                    ),
                    AppContainer(
                      width: 120,
                      height: 70,

                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Engagement', style: TextStyle(fontSize: 12),),
                            const SizedBox(height: 5,),
                            SizedBox(
                              width: 80,
                              child: getChipText('5/10', bgColor: Colors.red[900]),
                            )
                          ],
                        ),
                      ),
                    ),
                    AppContainer(
                      width: 120,
                      height: 70,

                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Sign-In', style: TextStyle(fontSize: 12),),
                            const SizedBox(height: 5,),
                            SizedBox(
                              width: 100,
                              child: getChipText('5/10 Checked In', bgColor: Colors.green[900]),
                            )
                          ],
                        ),
                      ),
                    ),
                    AppContainer(
                      width: 130,
                      height: 70,

                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('LMR Devices', style: TextStyle(fontSize: 12),),
                            const SizedBox(height: 5,),
                            SizedBox(
                              width: 70,
                              child: getChipText('13', bgColor: Colors.red[900]),
                            )
                          ],
                        ),
                      ),
                    ),
                    AppContainer(
                      width: 120,
                      height: 70,

                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Happiness', style: TextStyle(fontSize: 12),),
                            const SizedBox(height: 5,),
                            SizedBox(
                              width: 70,
                              child: getChipText('90/100', bgColor: Colors.green[900]),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              //fastest rider
              AppContainer(
                  child: SingleChildScrollView(
                    child:Column(
                      children: widget.allRiders.map((e) => ListTile(

                        leading: CircleAvatar(
                          backgroundColor: primaryColor,
                          child: e['Image'] as SvgPicture,
                        ),
                        title: Row(
                          children: [
                            Text(getTruncatedText(e['Rider'].toString(), 6)),
                            if(e['Fastest'] == true) ...[
                              const SizedBox(width: 15,),
                              getSkewedChipText(-0.3, 'FASTEST', bgColor: Colors.lightGreenAccent, textStyle: GoogleFonts.orbitron( fontStyle: FontStyle.italic, textStyle: const TextStyle(color: Colors.black, fontStyle: FontStyle.italic , fontSize: 10, fontWeight: FontWeight.bold)),),


                            ],
                            if(e['Slowest'] == true) ...[
                              const SizedBox(width: 15,),
                              //italic
                              Transform(
                                  transform: Matrix4.skewX(-0.3),
                                child: getSkewedChipText(-0.3, 'SLOWEST', bgColor: Colors.redAccent, textStyle: GoogleFonts.orbitron( fontStyle: FontStyle.italic, textStyle: const TextStyle(color: Colors.black, fontStyle: FontStyle.italic , fontSize: 10, fontWeight: FontWeight.bold)), ),
                              ),

                            ],
                          ],
                        ),
                        subtitle: Row(
                          children: [

                            Text(e['Time/Score'].toString()),
                            const SizedBox(width: 10,),
                            getChipText(e['Skill'].toString(), bgColor: Colors.deepOrange[600]),
                            if(e['Crash'] == 'Yes') ...[
                              const SizedBox(width: 5,),
                              getChipText('Crash!!', bgColor: Colors.red),
                            ]
                          ],
                        ),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                e['Rank'].toString(),
                                style: const TextStyle(
                                    color: primaryColor,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold
                                )
                            ),
                            const Text('Rank')
                          ],
                        ),
                      )).toList(),
                    ),
                  )
              )
            ],
          )
        ),
      ),
    );
  }

  String getHHMMSS(DateTime e) {
    var seconds = e.difference(DateTime.now()).inSeconds;
    var hours = (seconds / 3600).floor();
    var minutes = ((seconds % 3600) / 60).floor();
    var sec = (seconds % 60).floor();
    return hours.toString().padLeft(2, '0') + ':' + minutes.toString().padLeft(2, '0') + ':' + sec.toString().padLeft(2, '0');
  }
}
