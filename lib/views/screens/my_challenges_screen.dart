
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:log_my_ride/utils/utils.dart';
import 'package:log_my_ride/views/screens/find_a_challenge_screen.dart';
import 'package:log_my_ride/views/widgets/app_container.dart';
import 'package:log_my_ride/views/widgets/random_spline_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../controllers/replay_timer_controller.dart';
import '../../controllers/user_controller.dart';
import '../../utils/constants.dart';

class MyChallengesScreen extends StatefulWidget {

  const MyChallengesScreen({super.key});

  @override
  State<MyChallengesScreen> createState() => _MyChallengesScreenState();
}

class _MyChallengesScreenState extends State<MyChallengesScreen> with SingleTickerProviderStateMixin {
  var selectedTrack;

  var latestChallenge = {
    'Rider': 'John Doe',
    'Track': 'Track 6',
    'Date': '2022-01-01',
    'Challenge Type': 'Time Trial',
    'Venue': 'Venue 1',
  };

  var averageSpeedChallenge = {
    'Rider': 'John Doe',
    'Track': 'Track 6',
    'Date': '2022-01-01',
    'Challenge Type': 'Average Speed',
    'Venue': 'Venue 1',
  };

  var maxLeanAngleChallenge = {
    'Rider': 'John Doe',
    'Track': 'Track 6',
    'Date': '2022-01-01',
    'Challenge Type': 'Max Lean Angle',
    'Venue': 'Venue 1',
  };

  var allChallenges = [
    {
      'Rider': faker.person.name(),
      'Time/Score': '01:30:00',
      'Rank': '1',
      'Track': 'Track 4',
      'Date': '2022-01-01',
      'Challenge Type': 'Time Trial',
      'Venue': 'Venue 1',
    },
    {
      'Rider': faker.person.name(),
      'Time/Score': '01:30:00',
      'Rank': '2',
      'Track': 'Track 5',
      'Date': '2022-01-01',
      'Challenge Type': 'Time Trial',
      'Venue': 'Venue 1',
    },
    {
      'Rider': faker.person.name(),
      'Time/Score': '01:30:00',
      'Rank': '3',
      'Track': 'Track 1',
      'Date': '2022-01-01',
      'Challenge Type': 'Time Trial',
      'Venue': 'Venue 1',
    },
    {
      'Rider': faker.person.name(),
      'Time/Score': '01:30:00',
      'Rank': '4',
      'Track': 'Track 2',
      'Date': '2022-01-01',
      'Challenge Type': 'Time Trial',
      'Venue': 'Venue 2',
    },
    {
      'Rider': faker.person.name(),
      'Time/Score': '01:30:00',
      'Rank': '5',
      'Track': 'Track 3',
      'Date': '2022-01-01',
      'Challenge Type': 'Time Trial',
      'Venue': 'Venue 3',
    },
    {
      'Rider': faker.person.name(),
      'Time/Score': '01:30:00',
      'Rank': '6',
      'Track': 'Track 3',
      'Date': '2022-01-01',
      'Challenge Type': 'Time Trial',
      'Venue': 'Venue 1',
    }
  ];

  late TabController latestChallengesTabController;


  @override
  void initState() {
    latestChallengesTabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Get.find<UserController>();
    Get.put(ReplayTimerController());


    return Scaffold(
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton.extended(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          onPressed: () {
            // start new challenge
            Get.to(() => const FindAChallengeScreen());
          },
          label: const Text('Find A Challenge', style: TextStyle(color: Colors.white),),
          icon: const Icon(LineIcons.search),
        ),
      ),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20,),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text('Latest Completed Challenge', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),)),
              TabBar(
                isScrollable: true,
                indicatorColor: primaryColor,
                labelColor: primaryColor,
                controller: latestChallengesTabController,
                tabs: const [
                  Tab(text: 'Time Trial',),
                  Tab(text: 'Average Speed',),
                  Tab(text: 'Max Lean Angle',),
                ],
                onTap: (index) {
                  //change challenge type
                },
              ),
              const SizedBox(height: 10,),
              SizedBox(
                height: 430,
                child: TabBarView(

                  controller: latestChallengesTabController,
                  children: [
                    AppContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: latestChallenge.entries.map((entry) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(entry.key,),
                                  Text(entry.value,),
                                ],
                              ),
                            ),
                            const Divider(),
                          ],
                        ),).toList(),
                      ),
                    ),
                    AppContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: averageSpeedChallenge.entries.map((entry) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(entry.key,),
                                  Text(entry.value,),
                                ],
                              ),
                            ),
                            const Divider(),
                          ],
                        ),).toList(),
                      ),
                    ),
                    AppContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: maxLeanAngleChallenge.entries.map((entry) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(entry.key,),
                                  Text(entry.value,),
                                ],
                              ),
                            ),
                            const Divider(),
                          ],
                        ),).toList(),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10,),

              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      const Text('Challenges', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                      const Spacer(),
                      //Reset
                      ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              selectedTrack = null;
                            });
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reset', style: TextStyle(color: primaryColor),)
                      )
                    ],
                  )
              ),
              const SizedBox(height: 10,),
              DropdownButtonFormField(
                items: ['Track 1', 'Track 2', 'Track 3', 'Track 4', 'Track 5', 'Track 6'].map((track) => DropdownMenuItem(value: track,child: Text(track),)).toList(),
                decoration: InputDecoration(
                  labelText: 'Select a Track',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),

                ),
                onChanged: (value) {
                  setState(() {
                    selectedTrack = value;
                  });
                },
              ),
              const SizedBox(height: 20,),
              //filter for challenge types

              // multiple choice challenge type dropdown
              DropdownButtonFormField(
                items: ['Time Trial', 'Score Challenge'].map((track) => DropdownMenuItem(value: track,child: Text(track),)).toList(),
                decoration: InputDecoration(
                  labelText: 'Select a Challenge Type',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),

                ),
                onChanged: (value) {
                  setState(() {
                    selectedTrack = value;
                  });
                },
              ),
              const SizedBox(height: 20,),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: allChallenges.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ElevatedButton(onPressed: () {},
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: primaryColor,
                          child: SvgPicture.memory(getRandomSvgCode()),
                        ),
                        title: Row(
                          children: [
                            Text(getTruncatedText(allChallenges[index]['Rider'].toString(), 15), style: const TextStyle(fontSize: 16),)
                          ],
                        ),
                        subtitle: Column(
                          children: [
                            const SizedBox(height: 5,),
                            Row(
                              children: [
                                const Icon(LineIcons.clock, size: 16, color: primaryColor,),
                                const SizedBox(width: 3),
                                Text(DateFormat('MMM dd').format(faker.date.dateTime(minYear: 2022, maxYear: 2022)), style: const TextStyle(fontSize: 12),),
                                const SizedBox(width: 8),
                                Text(allChallenges[index]['Track'].toString(), style: const TextStyle(fontSize: 12),),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )

             /* AppContainer(
                child: Column(
                  children:   allChallenges.where((challenge) => selectedTrack != null ? challenge['Track'] == selectedTrack : true)
                      .map((challenge) => ListTile(

                    onTap: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                          context: context,
                          builder: (context) {
                        return Container(
                          padding: const EdgeInsets.all(defaultPadding),
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20,),
                                const Text('Challenge Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                const SizedBox(height: 20,),

                                ...challenge.entries.map((entry) => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(entry.key,),
                                    Text(entry.value,),
                                    const Divider(),
                                  ],
                                )),
                                const SizedBox(height: 20,),
                                Row(
                                  children: [
                                    const Text('Graph', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                    const Spacer(),
                                    //Reset
                                    ElevatedButton.icon(
                                       style: ButtonStyle(
                                         backgroundColor: WidgetStateProperty.all(primaryColor),
                                          ),
                                        onPressed: () {
                                        },
                                        icon: const Icon(Icons.refresh_rounded),
                                        label: const Text('Replay', style: TextStyle(color: Colors.white),)
                                    )
                                  ],
                                ),

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
                                const SizedBox(height: 20,),
                                // share challenge elevated icon button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStateProperty.all(primaryColor),
                                    ),
                                      onPressed: () {
                                        // share challenge

                                      },
                                      icon: const Icon(LineIcons.share),
                                      label: const Text('Share Challenge', style: TextStyle(color: Colors.white),)
                                  ),
                                ),
                                const SizedBox(height: 20,),

                              ]
                            ),
                          ),
                        );
                      });
                    },
                    leading: CircleAvatar(
                      backgroundColor: primaryColor,
                      child: SvgPicture.memory(getRandomSvgCode()),
                    ),
                    title: Text(challenge['Rider'].toString()),
                    subtitle: Text(challenge['Time/Score'].toString()),
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
                ),*/

            ],
          ),
        ),
      ),
    );
  }
}
