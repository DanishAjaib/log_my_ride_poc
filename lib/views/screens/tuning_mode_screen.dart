import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:log_my_ride/utils/constants.dart';
import 'package:log_my_ride/views/screens/my_profile_screen.dart';
import 'package:log_my_ride/views/screens/tuner_profile_screen.dart';
import 'package:log_my_ride/views/widgets/event_tile.dart';
import 'package:log_my_ride/views/widgets/tuner_filter_dialog.dart';
import 'package:log_my_ride/views/widgets/tuner_subscription_tile.dart';
import 'package:log_my_ride/views/widgets/tuner_tile.dart';

import '../../controllers/user_controller.dart';
import '../../utils/utils.dart';

class TuningModeScreen extends StatefulWidget {

  String? selectedTuner;
  String? selectedSession;
  TuningModeScreen({super.key});

  @override
  State<TuningModeScreen> createState() => _TuningModeScreenState();
}

class _TuningModeScreenState extends State<TuningModeScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;

  var userController = Get.find<UserController>();

  var currentSubscriptions = [
    {
      'tuner': 'Tuner 1',
      'session': 'Session 1',
      'date': faker.date.dateTime(minYear: 2022, maxYear: 2022),
    },
    {
      'tuner': 'Tuner 2',
      'session': 'Session 2',
      'date': faker.date.dateTime(minYear: 2022, maxYear: 2022),
    },
    {
      'tuner': 'Tuner 3',
      'session': 'Session 3',
      'date': faker.date.dateTime(minYear: 2022, maxYear: 2022),
    },
    {
      'tuner': 'Tuner 4',
      'session': 'Session 4',
      'date': faker.date.dateTime(minYear: 2022, maxYear: 2022),
    },
    {
      'tuner': 'Tuner 5',
      'session': 'Session 5',
      'date': faker.date.dateTime(minYear: 2022, maxYear: 2022),
    },
  ];

  var tuners = [
    {
      'location' : faker.address.city(),
      'name': 'Tuner 1',
      'rating': faker.randomGenerator.decimal(scale: 1, min: 3),
      'price': faker.randomGenerator.integer(250, min: 50),
      'mapCount': faker.randomGenerator.integer(50, min: 5),
    },
    {
      'location' : faker.address.city(),
      'name': 'Tuner 2',
      'rating': faker.randomGenerator.decimal(scale: 1, min: 3),
      'price': faker.randomGenerator.integer(250, min: 50),
      'mapCount': faker.randomGenerator.integer(50, min: 5),
    },
    {
      'location' : faker.address.city(),
      'name': 'Tuner 3',
      'rating': faker.randomGenerator.decimal(scale: 1, min: 3),
      'price': faker.randomGenerator.integer(250, min: 50),
      'mapCount': faker.randomGenerator.integer(50, min: 5),
    },
    {
      'location' : faker.address.city(),
      'name': 'Tuner 4',
      'rating': faker.randomGenerator.decimal(scale: 1, min: 3),
      'price': faker.randomGenerator.integer(250, min: 50),
      'mapCount': faker.randomGenerator.integer(50, min: 5),
    },
    {
      'location' : faker.address.city(),
      'name': 'Tuner 5',
      'rating': faker.randomGenerator.decimal(scale: 1, min: 3),
      'price': faker.randomGenerator.integer(250, min: 50),
      'mapCount': faker.randomGenerator.integer(50, min: 5),
    },

  ];

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
    
      body: Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Container(
            height: Get.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TabBar(
                  splashBorderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                  indicatorColor: primaryColor,
                  labelColor: primaryColor,
                
                  controller: tabController,
                  tabs: const [
                    Tab(
                      text: 'Overview',
                    ),
                    Tab(
                      text: 'Find a Tuner',
                    ),
                    Tab(
                      text: 'Received Maps',
                    ),
                  ],
                ),
            
              const SizedBox(height: 10,),
                Expanded(
                  child: TabBarView(
                    controller: tabController,

                    children: [
                      SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            //current tuner subscriptions
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Current Subscriptions', style: TextStyle(fontSize: 14),),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            //list of tuner subscriptions
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: currentSubscriptions.length,
                              itemBuilder: (context, index) {
                                return TunerSubscriptionTile(
                                  tuner: currentSubscriptions[index],
                                  onPressed: () {
                                    //view tuner profile
                                    Get.to(() => const TunerProfileScreen());

                                  },
                                );
                              },
                            ),

                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Find a Tuner', style: TextStyle(fontSize: 14),),
                                //filter
                                TextButton.icon(
                                  onPressed: () {
                                    showDialog(context: context, builder: (context) {
                                      return const TunerFilterDialog();
                                    });
                                  },
                                  label: const Text('Filter'),
                                )

                              ],
                            ),
                            const SizedBox(height: 10,),
                            //list of tuners
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: tuners.length,
                              itemBuilder: (context, index) {
                                return TunerTile(
                                  tuner: tuners[index],
                                  onPressed: () {
                                   showModalBottomSheet(context: context, builder: (context) {
                                       return Container(
                                         padding: const EdgeInsets.all(20),
                                         height: 500,
                                         child: Column(
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: [
                                             Row(
                                               children: [
                                                 CircleAvatar(
                                                   backgroundColor: primaryColor,
                                                   child: SvgPicture.memory(getRandomSvgCode()),
                                                 ),
                                                  const SizedBox(width: 10,),
                                                 Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                   children: [
                                                     Text(tuners[index]['name'].toString(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                                     Row(
                                                        children: [
                                                          const Icon(LineIcons.internetExplorer, size: 16, color: primaryColor,),
                                                          const SizedBox(width: 3,),
                                                          const Text('tuner.com.au', style: TextStyle(fontSize: 12),),
                                                          const SizedBox(width: 10,),
                                                          const Icon(LineIcons.phone, size: 16, color: primaryColor,),
                                                          const SizedBox(width: 3,),
                                                          const Text('04053254687', style: TextStyle(fontSize: 12),),
                                                          const SizedBox(width: 10,),
                                                          const Icon(LineIcons.map, size: 16, color: primaryColor,),
                                                          const SizedBox(width: 3,),
                                                          Text('${tuners[index]['mapCount']} Maps', style: const TextStyle(fontSize: 12),),
                                                        ],
                                                     )
                                                   ],
                                                 )
                                               ],
                                             ),
                                              const SizedBox(height: 15,),
                                             const Divider(color: primaryColor,),
                                             const SizedBox(height: 15,),
                                             Text(faker.lorem.sentences(3).join(' ')),
                                              const SizedBox(height: 15,),
                                             const Spacer(),
                                             SizedBox(
                                               width: double.infinity,
                                               child: ElevatedButton(
                                                 onPressed: () {
                                                    //purchase
                                                   showDialog(context: context, builder: (context) {
                                                      return AlertDialog(
                                                        title: const Text('Purchase Tuner'),
                                                        content: Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            const Text('Selected Payment Method'),
                                                            const SizedBox(height: 10,),
                                                            Container(
                                                              padding: const EdgeInsets.all(10),
                                                              decoration: BoxDecoration(
                                                                border: Border.all(color: primaryColor),
                                                                borderRadius: BorderRadius.circular(10),
                                                              ),
                                                              child: const Row(
                                                                children: [
                                                                  Icon(LineIcons.creditCard, color: primaryColor,),
                                                                  SizedBox(width: 10,),
                                                                  Text('Visa **** 1234', style: TextStyle(color: primaryColor),),
                                                                  Spacer(),
                                                                  Icon(LineIcons.angleRight, color: primaryColor,),
                                                                ],
                                                              ),
                                                            ),

                                                            const SizedBox(height: 20,),

                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                TextButton(
                                                                  onPressed: () {
                                                                    Navigator.pop(context);
                                                                  },
                                                                  child: const Text('Cancel'),
                                                                ),
                                                                ElevatedButton(
                                                                  onPressed: () {
                                                                    //purchase
                                                                    Navigator.pop(context);
                                                                    Get.snackbar('Success', 'Tuner purchased successfully', backgroundColor: Colors.green, colorText: Colors.white);
                                                                    Get.to(() => MyProfileScreen());
                                                                  },
                                                                  style: ElevatedButton.styleFrom(
                                                                    backgroundColor: primaryColor,
                                                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(50),
                                                                    )
                                                                  ), child: const Text('Purchase', style: TextStyle(color:Colors.white),),),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      );
                                                   });

                                                 }, style: ElevatedButton.styleFrom(
                                                 backgroundColor: primaryColor,
                                                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                 shape: RoundedRectangleBorder(
                                                   borderRadius: BorderRadius.circular(50),
                                                 )
                                               ), child: Text('Purchase - \$${tuners[index]['price']}', style: const TextStyle(color:Colors.white),),),
                                             ),
                                             const Align(
                                                alignment: Alignment.center,
                                               child: Text('Terms and Conditions', style: TextStyle(color: Colors.grey),),
                                             )
                                           ],
                                         ),
                                       );
                                   });
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      //received maps
                      SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            //current tuner subscriptions
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Received Maps', style: TextStyle(fontSize: 14),),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            //list of tuner subscriptions
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: currentSubscriptions.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                    ),

                                      onPressed: () {},
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: primaryColor,
                                          child: SvgPicture.memory(getRandomSvgCode()),
                                        ),
                                        title: Text(faker.company.name().toString()),
                                        subtitle: Text(DateFormat.yMMMd().format(faker.date.dateTime(minYear: 2022, maxYear: 2022))),
                                        trailing: const Text('v 1.0.0'),
                                      )),
                                );
                              },
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
