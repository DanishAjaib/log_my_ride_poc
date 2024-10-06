import 'dart:typed_data';

import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:log_my_ride/controllers/user_controller.dart';
import 'package:log_my_ride/utils/constants.dart';
import 'package:log_my_ride/utils/utils.dart';
import 'package:log_my_ride/views/screens/my_profile_screen.dart';
import 'package:log_my_ride/views/widgets/home_button.dart';
import 'package:log_my_ride/views/widgets/square_button.dart';
import 'package:multiavatar/multiavatar.dart';

import '../../controllers/logging_controller.dart';
import '../../controllers/navigation_controller.dart';

class PromoterHomeScreen extends StatefulWidget {

  const PromoterHomeScreen({super.key});

  @override
  State<PromoterHomeScreen> createState() => _RiderHomeScreenState();


}

class _RiderHomeScreenState extends State<PromoterHomeScreen> {

  var  userController = Get.find<UserController>();

  var logginController = Get.put(LoggingController());
  var navigationController = Get.put(NavigationController());

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var svgCode = Uint8List.fromList(multiavatar('X-SLAYER').codeUnits);

    return Scaffold(
      body: Obx(() {
        var vehicle = userController.vehicles.isNotEmpty ? userController.vehicles.first : null;

        return  vehicle != null ?

          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
            children: [
              InkWell(
                onTap: () {
                  Get.to(() => MyProfileScreen());

                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          getSubtitle('Welcome back,'),
                          Text(userController.currentUser.first.name ?? 'John Doe', style: const TextStyle(color: primaryColor),),
                        ],
                      ),

                      CircleAvatar(
                        radius: 30,
                        child: ClipOval(
                          child: SvgPicture.memory(svgCode),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25,),
              HomeButton(
                  iconText: '1',
                  column2Children: [
                    const Text('ACTIVE EVENT', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold),),
                   const SizedBox(height: 5,),
                   Row(
                     children: [
                       const Icon(Icons.location_on, color: Colors.grey, size: 15,),
                       const SizedBox(width: 5,),
                       Text(faker.address.city(), style: const TextStyle(color: primaryColor, fontSize: 15),),
                     ],
                   ),
                   Row(
                     children: [
                        const Icon(Icons.timer, color: Colors.grey, size: 15,),
                       const SizedBox(width: 5,),
                       Text('${getRandomDateTime()}', style: const TextStyle(color: Colors.grey, fontSize: 10),),
                     ],
                   )
                  ],
                  image: 'assets/images/bike_image.jpg',
                  icon: null),
              const SizedBox(height: 10,),
              HomeButton(
                  height: 150,
                  iconText: '1',
                  column2Children: [
                    const Text('FINANCIALS - MOST RECENT EVENT', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold),),
                    const SizedBox(height: 5,),
                    Text(faker.vehicle.model(), style: const TextStyle(color: primaryColor, fontSize: 15, fontWeight: FontWeight.bold),),
                    Text('${getRandomDateTime()}', style: const TextStyle(color: Colors.grey, fontSize: 10),),
                    const SizedBox(height: 15,),
                    Row(
                      children: [
                        Column(

                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Total Revenue', style: TextStyle(color: Colors.grey, fontSize: 10),),
                            Text('\$${faker.randomGenerator.decimal(min: 1000, scale: 2).toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),),
                          ],
                        ),
                        //vertical divider
                        const SizedBox(width: 15,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Total Expenses', style: TextStyle(color: Colors.grey, fontSize: 10),),
                            Text('\$${faker.randomGenerator.decimal(min: 1000, scale: 2).toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),),
                          ],
                        ),
                        const SizedBox(width: 15,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Registrations', style: TextStyle(color: Colors.grey, fontSize: 10),),
                            Text(faker.randomGenerator.decimal(min: 50, scale: 2).toStringAsFixed(0), style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ],
                    )
                  ],
                  icon: null),
              const SizedBox(height: 10,),
              HomeButton(
                  iconText: '5',
                  column2Children: [
                    getChipText('RECENT EVENT'),
                    const SizedBox(height: 5,),
                    Text(faker.company.name(), style: const TextStyle(color: primaryColor, fontSize: 15, fontWeight: FontWeight.bold),),
                    Text('${faker.address.streetName()} - ${getRandomDateTime()}', style: const TextStyle(color: Colors.white, fontSize: 12),),
                  ],
                  icon: null,
                image: 'assets/images/bike_image.jpg',
              ),
              const SizedBox(height: 10,),
              HomeButton(
                  iconText: '8',
                  column2Children: [
                    getChipText('LRM Request Approved', bgColor: Colors.green),
                    const SizedBox(height: 5,),
                    Text(faker.person.name(), style: const TextStyle(color: primaryColor, fontSize: 15, fontWeight: FontWeight.bold),),
                    const Text('Secretary', style: TextStyle(color: Colors.white, fontSize: 12,),),
                  ],
                  icon: null,
                image : 'assets/images/bike_image.jpg',
              ),
            ],
            ),
          ) :
        const Center(child: CircularProgressIndicator());
      }),
    );
  }

  getRandomDateTime() {
    var format = DateFormat('dd/MM/yyyy HH:mm a');
    return format.format(faker.date.dateTime(minYear: 2023, maxYear: 2024));

  }
}
