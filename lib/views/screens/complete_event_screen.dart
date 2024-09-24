import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:log_my_ride/models/session.dart';
import 'package:log_my_ride/utils/constants.dart';
import 'package:log_my_ride/utils/utils.dart';
import 'package:log_my_ride/views/widgets/custom_line_tile.dart';
import 'package:log_my_ride/views/widgets/metric_container.dart';

class CompleteEventScreen extends StatefulWidget {
  const CompleteEventScreen({super.key});

  @override
  State<CompleteEventScreen> createState() => _CompleteEventScreenState();
}

class _CompleteEventScreenState extends State<CompleteEventScreen> with SingleTickerProviderStateMixin {
  late List<TileSession> allSessions;
  late TabController tabController;

  @override
  void initState() {
    allSessions = List.generate(10, (index) => TileSession(
      title: faker.company.name(),
      isCompleted: index.isEven,
      capacity: 10,
      group: faker.company.name(),
    ));

    tabController = TabController(length: 8, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Event'),
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
              indicatorColor: primaryColor,
              splashBorderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              indicatorPadding: const EdgeInsets.symmetric(horizontal: -25),

              labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Schedule'),
                Tab(text: 'Analysis'),
                Tab(text: 'Challenges'),
                Tab(text: 'Event Performance'),
                Tab(text: 'Key Metrics'),
                Tab(text: 'Financials'),
                Tab(text: 'Historical Analysis'),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: TabBarView(
                controller: tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  // Overview
                  Column(
                    children: [
                      // Points of interest
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MetricContainer(value: '5', text: 'Registered Riders'),
                          MetricContainer(value: '5', text: 'LMR Riders'),
                          MetricContainer(value: '5', text: 'Laps/Session'),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Event Sessions', style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                      Expanded(
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
                      ),
                    ],
                  ),
                  // Schedule
                  Container(),
                  // Analysis
                  Container(),
                  // Challenges
                  Container(),
                  // Event Performance
                  Container(),
                  // Key Metrics
                  Container(),
                  // Financials
                  Container(),
                  // Historical Analysis
                  Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
