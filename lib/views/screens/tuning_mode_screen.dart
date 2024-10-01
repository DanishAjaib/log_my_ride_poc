import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:log_my_ride/utils/constants.dart';

import '../../controllers/user_controller.dart';

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

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
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
                  ],
                ),
            
              const SizedBox(height: 10,),
                Expanded(
                  child: TabBarView(

                              
                    controller: tabController,
                              
                    children: [
                      SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            //current tuner subscriptions
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Current Tuner Subscriptions', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                                //filter
                                TextButton.icon(
                                  onPressed: () {},
                                  label: const Text('Filter'),
                                  icon: const Icon(Icons.filter_list),
                                )

                              ],
                            )

                          ],
                        ),
                      ),
                      Container(),
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
