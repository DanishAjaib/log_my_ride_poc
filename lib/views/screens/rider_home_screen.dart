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

class RiderHomeScreen extends StatefulWidget {

  const RiderHomeScreen({super.key});

  @override
  State<RiderHomeScreen> createState() => _RiderHomeScreenState();


}

class _RiderHomeScreenState extends State<RiderHomeScreen> {

  UserController userController = Get.put(UserController());

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
                    Text('MY RIDE', style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold),),
                    Text(faker.vehicle.model(), style: const TextStyle(color: primaryColor, fontSize: 15),),
                    Text('Last Ride ${getRandomDateTime()}', style: const TextStyle(color: Colors.white, fontSize: 12),),
                  ],
                  image: 'assets/images/bike_image.jpg',
                  icon: null),
              const SizedBox(height: 10,),
              HomeButton(
                  iconText: '1',
                  column2Children: [
                    Text('GPS', style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold),),
                    Text(faker.vehicle.model(), style: const TextStyle(color: primaryColor, fontSize: 15, fontWeight: FontWeight.bold),),
                    Text('Static at  ${getRandomDateTime()}', style: const TextStyle(color: Colors.white, fontSize: 12),),
                  ],
                  image: 'assets/images/bike_image_2.PNG',
                  icon: null),
              const SizedBox(height: 10,),
              HomeButton(
                  iconText: '5',
                  column2Children: [
                    getChipText('NEW EVENT'),

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
                    getChipText('BEST LAP RECORD'),
                    Text(faker.person.name(), style: const TextStyle(color: primaryColor, fontSize: 15, fontWeight: FontWeight.bold),),
                    Text(faker.company.name(), style: const TextStyle(color: Colors.white, fontSize: 12,),),
                  ],
                  icon: null,
                image : 'assets/images/bike_image.jpg',
              ),
          /*    const SizedBox(height: 10,),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Expanded(
                  child: Row(
                    children: [
                      SquareButton(label: 'Log My Ride', icon: Icons.add, onPressed: (){}),
                      SquareButton(label: 'Track My Ride', icon: Icons.add, onPressed: (){}),
                      SquareButton(label: 'New Track Ride', icon: Icons.add, onPressed: (){}),
                      SquareButton(label: 'New Road Ride', icon: Icons.add, onPressed: (){}),
                      SquareButton(label: 'Events', icon: Icons.add, onPressed: (){}),
                    ],
                  ),
                ),
              )*/
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
