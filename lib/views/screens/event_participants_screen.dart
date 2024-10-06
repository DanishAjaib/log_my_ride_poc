import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:log_my_ride/utils/constants.dart';
import 'package:log_my_ride/views/widgets/rating_bar.dart';

import '../../utils/utils.dart';

class EventParticipantsScreen extends StatefulWidget {
  const EventParticipantsScreen({super.key});

  @override
  State<EventParticipantsScreen> createState() => _EventParticipantsScreenState();
}

class _EventParticipantsScreenState extends State<EventParticipantsScreen> with TickerProviderStateMixin {
  late TabController tabController;

  var activities = [
    {
      'name': 'Cornering',
      'rating': 4.5,
    },
    {
      'name': 'Racing',
      'rating': 3.5,
    },
    {
      'name': 'Throttling',
      'rating': 3.5,
    },
    {
      'name': 'Endurance',
      'rating': 3.5,
    },
    {
      'name': 'Lap Time Challenge',
      'rating': 3.5,
    },
  ];

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(faker.person.name()),),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TabBar(
                splashBorderRadius:  BorderRadius.circular(10),
                indicatorColor: primaryColor,
                labelColor: primaryColor,
                controller: tabController,
                tabs: [
                  Tab(text: 'Activities',),
                  Tab(text: 'Analyze My Ride',),
                ],
              ),
              const SizedBox(height: 10,),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    _activities(activities),
                    _analyzeMyRide(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget _activities(List<Map<String, dynamic>> activities) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,

    children: [
      ...activities.map((activity) {
        return Padding(

          padding: const EdgeInsets.only(bottom:4.0),
          child: ElevatedButton(
            style:  ButtonStyle(
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
              onPressed: () {},
              child: ListTile(
                leading: CircleAvatar(
                  child: SvgPicture.memory(getRandomSvgCode()),
                ),
                title: Text(activity['name']),
                subtitle: Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      size: 20,
                      index < 3 ? Icons.star : Icons.star_border,
                      color: primaryColor,
                    );
                  }),
                )
              )
          ),
        );
      })


    ],
  );
}

Widget _analyzeMyRide() {
  return const Column(
    children: [

    ],
  );
}