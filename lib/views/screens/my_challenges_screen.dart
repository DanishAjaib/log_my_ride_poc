
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:log_my_ride/utils/utils.dart';
import 'package:log_my_ride/views/widgets/app_container.dart';
import 'package:log_my_ride/views/widgets/random_spline_chart.dart';
import '../../controllers/user_controller.dart';
import '../../utils/constants.dart';

class MyChallengesScreen extends StatefulWidget {

  const MyChallengesScreen({super.key});

  @override
  State<MyChallengesScreen> createState() => _MyChallengesScreenState();
}

class _MyChallengesScreenState extends State<MyChallengesScreen> {
  var selectedTrack;

  var latestChallenge = {
    'Rider': 'John Doe',
    'Track': 'Track 6',
    'Date': '2022-01-01',
    'Challenge Type': 'Time Trial',
  };

  var allChallenges = [
    {
      'Rider': faker.person.name(),
      'Time/Score': '01:30:00',
      'Rank': '1',
      'Track': 'Track 4',
      'Date': '2022-01-01',
      'Challenge Type': 'Time Trial',
    },
    {
      'Rider': faker.person.name(),
      'Time/Score': '01:30:00',
      'Rank': '2',
      'Track': 'Track 5',
      'Date': '2022-01-01',
      'Challenge Type': 'Time Trial',
    },
    {
      'Rider': faker.person.name(),
      'Time/Score': '01:30:00',
      'Rank': '3',
      'Track': 'Track 1',
      'Date': '2022-01-01',
      'Challenge Type': 'Time Trial',
    },
    {
      'Rider': faker.person.name(),
      'Time/Score': '01:30:00',
      'Rank': '4',
      'Track': 'Track 2',
      'Date': '2022-01-01',
      'Challenge Type': 'Time Trial',
    },
    {
      'Rider': faker.person.name(),
      'Time/Score': '01:30:00',
      'Rank': '5',
      'Track': 'Track 3',
      'Date': '2022-01-01',
      'Challenge Type': 'Time Trial',
    },
    {
      'Rider': faker.person.name(),
      'Time/Score': '01:30:00',
      'Rank': '6',
      'Track': 'Track 3',
      'Date': '2022-01-01',
      'Challenge Type': 'Time Trial',
    }
  ];



  @override
  Widget build(BuildContext context) {

    Get.find<UserController>();


    return Scaffold(
      appBar: AppBar(
        title: const Text('My Challenges'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20,),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text('Latest Completed Challenge', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)),
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
              const SizedBox(height: 20,),

              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      const Text('Challenges', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
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
              const SizedBox(height: 20,),
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

              AppContainer(
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

                                const RandomSplineChart(),
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
                ),

            ],
          ),
        ),
      ),
    );
  }
}
