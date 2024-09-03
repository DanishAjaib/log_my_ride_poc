import 'dart:math';
import 'dart:typed_data';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_svg/svg.dart';
import 'package:line_icons/line_icons.dart';
import 'package:log_my_ride/utils/constants.dart';
import 'package:log_my_ride/views/widgets/app_container.dart';
import 'package:log_my_ride/views/widgets/dummy_map_container.dart';
import 'package:multiavatar/multiavatar.dart';

import '../widgets/random_spline_chart.dart';

class SessionSummaryScreen extends StatefulWidget {



  const SessionSummaryScreen({super.key});

  @override
  State<SessionSummaryScreen> createState() => _SessionSummaryScreenState();
}

class _SessionSummaryScreenState extends State<SessionSummaryScreen> with SingleTickerProviderStateMixin {

  TabController? _tabController;
  MapController? controller;
  List<String> selectedMetrics = [];
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);

    controller = MapController(
      initPosition: GeoPoint(latitude: 47.4358055, longitude: 8.4737324),
      areaLimit: const BoundingBox(
        east: 10.4922941,
        north: 47.8084648,
        south: 45.817995,
        west:  5.9559113,
      ),
    );

    super.initState();
  }




  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(title: const Text('Ride Summary')),

      body: Column(
        children: [
          TabBar(
            indicatorPadding: const EdgeInsets.symmetric(horizontal: -5),
            indicatorColor: primaryColor,
            labelColor: primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorSize: TabBarIndicatorSize.tab,

            controller: _tabController,
              tabs: const [
                Tab(text: 'Summary'),
                Tab(text: 'ReplayMyRide'),
                Tab(text: 'Social Stats'),
                Tab(text: 'AI Coach'),
            ]),
            Expanded(
                child: TabBarView(
                    controller: _tabController,
                    children: [
                     SingleChildScrollView(
                       physics: const BouncingScrollPhysics(),
                       child: Column(
                         children: [
                           const SizedBox(height: 15,),
                           DummyMapContainer(width: double.infinity, height: 200),
                            const SizedBox(height: 15,),
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
                                        child: SvgPicture.memory(getRandomSvgCode()),
                                      ),
                                      title: const Text('Vehicle Name'),
                                      subtitle: const Row(
                                        children: [
                                          Icon(LineIcons.calendarAlt, size: 16, color: primaryColor,),
                                          SizedBox(width: 2),
                                          Text('Date', style: TextStyle(fontSize: 12),),
                                          SizedBox(width: 8),
                                          Icon(LineIcons.biking, size: 16, color: primaryColor,),
                                          SizedBox(width: 2),
                                          Text('Distance', style: TextStyle(fontSize: 12),),
                                          SizedBox(width: 8),
                                          Icon(Icons.speed_outlined, size: 16, color: primaryColor,),
                                          SizedBox(width: 2),
                                          Text('Avg Speed', style: TextStyle(fontSize: 12),),
                                        ],
                                      )
                                   )
                               ),
                             ),
                           ),

                           // places visited
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
                                      _showBottomSheet(context, 'Places Visited');
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
                                      _showBottomSheet(context, 'Longest Stop');
                                    } ,
                                    child: ListTile(
                                      trailing: const Icon(LineIcons.angleRight, color: primaryColor,),
                                        leading: const CircleAvatar(
                                          backgroundColor: primaryColor,
                                          child: Icon(LineIcons.stopwatch, color: Colors.white,),
                                        ),
                                        title: const Text('Longest Stop'),
                                        subtitle: Text(faker.address.streetName(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),),
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
                                      _showBottomSheet(context, 'Fastest Section');
                                    } ,
                                    child: ListTile(
                                        trailing: const Icon(LineIcons.angleRight, color: primaryColor,),
                                        leading: const CircleAvatar(
                                          backgroundColor: primaryColor,
                                          child: Icon(Icons.speed_outlined, color: Colors.white,),
                                        ),
                                        title: const Text('Fastest Section'),
                                        subtitle:Text(faker.address.streetName(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),),

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
                                      _showBottomSheet(context, 'Most Lean Angle');
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
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20,),
                            DummyMapContainer(width: double.infinity, height: 200),
                            const SizedBox(height: 10,),
                            //plot title
                            Row(
                              children: [
                                const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5),
                                    child: Text('Plot', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
                                const Spacer(),
                                //filter button
                                TextButton.icon(onPressed: () {
                                  //show multi9ple choise dialog
                                  showDialog(context: context, builder: (context) {
                                    return StatefulBuilder(builder: (context, setState) {
                                      return AlertDialog(
                                        title: const Text('Select Metrics'),

                                        content: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              CheckboxListTile(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                value: selectedMetrics.contains('Speed'),
                                                onChanged: (value) {


                                                  if (value!) {
                                                    setState(() {
                                                      selectedMetrics.add('Speed');
                                                    });
                                                  } else {
                                                    setState(() {
                                                      selectedMetrics.remove('Speed');
                                                    });
                                                  }

                                                },
                                                title: const Text('Speed'),
                                              ),
                                              CheckboxListTile(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                value: selectedMetrics.contains('RPM'),
                                                onChanged: (value) {
                                                  if (value!) {
                                                    setState(() {
                                                      selectedMetrics.add('RPM');
                                                    });
                                                  } else {
                                                    setState(() {
                                                      selectedMetrics.remove('RPM');
                                                    });
                                                  }
                                                  setState(() {});
                                                },
                                                title: const Text('RPM'),
                                              ),
                                              CheckboxListTile(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                value: selectedMetrics.contains('Lean Angle'),
                                                onChanged: (value) {
                                                  if (value!) {
                                                    selectedMetrics.add('Lean Angle');
                                                  } else {
                                                    selectedMetrics.remove('Lean Angle');
                                                  }
                                                  setState(() {});
                                                },
                                                title: const Text('Lean Angle'),
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(onPressed: () {
                                            Navigator.pop(context);
                                          }, child: const Text('Cancel')),
                                          TextButton(onPressed: () {
                                            Navigator.pop(context);
                                          }, child: const Text('Apply')),
                                        ],
                                      );
                                    });
                                  });
                                }, label: const Text('Filter'), icon: const Icon(LineIcons.filter, color: primaryColor, size: 16),),
                              ],
                            ),

                            const SizedBox(height: 10,),
                            const RandomSplineChart(),



                          ],
                        ),
                      ),
                      const Center(child: Text('AI Coach')),
                      const Center(child: Text('AI Coach')),
                    ]
                )
            )
        ],

      ),
    );
  }
}
Uint8List getRandomSvgCode() {
  String randomString = _generateRandomString(8); // Generate a random string of length 8
  return Uint8List.fromList(multiavatar(randomString).codeUnits);
}
String _generateRandomString(int length) {
  const characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final random = Random();
  return String.fromCharCodes(Iterable.generate(
    length,
        (_) => characters.codeUnitAt(random.nextInt(characters.length)),
  ));
}

void _showBottomSheet(BuildContext context, String title) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              const Divider(color: primaryColor,),
              const SizedBox(height: 15,),
              Text(faker.lorem.sentences(3).join(' ')),
              const SizedBox(height: 5,),
              Text(faker.lorem.sentences(3).join(' '))
            ],
          ),
        );
      }
  );
}