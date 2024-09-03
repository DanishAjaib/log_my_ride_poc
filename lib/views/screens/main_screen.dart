import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:log_my_ride/controllers/user_controller.dart';
import 'package:log_my_ride/views/screens/events_screen.dart';
import 'package:log_my_ride/views/screens/login_screen.dart';
import 'package:log_my_ride/views/screens/my_challenges_screen.dart';
import 'package:log_my_ride/views/screens/my_sessions_screen.dart';
import 'package:log_my_ride/views/screens/my_vehicles_screen.dart';
import 'package:log_my_ride/views/screens/rider_home_screen.dart';
import 'package:log_my_ride/views/screens/road_mode_screen.dart';
import 'package:log_my_ride/views/screens/settings_screen.dart';
import 'package:log_my_ride/views/screens/track_mode_screen.dart';
import 'package:log_my_ride/views/screens/track_my_bike_screen.dart';
import 'package:log_my_ride/views/screens/tuning_mode_screen.dart';

import '../../utils/constants.dart';
import '../../utils/utils.dart';
import 'my_profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,

    ]);
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text('LogMyRide', style: GoogleFonts.orbitron(color:Colors.white, fontSize:15)),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu_sharp),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },


          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {

              },
            ),
          ],
          /*bottom: _selectedIndex == 0 ? PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: Obx(() {
              return userController.currentUser.isEmpty ? const CircularProgressIndicator() : Container(
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
                      backgroundImage: NetworkImage(faker.image.image()),
                    ),
                  ],
                ),
              );
            }),
          ) : null,*/
        ),
        drawer: Drawer(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
          ),
          child: ListView(
            children: [
              DrawerHeader(

                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 50,
                      height: 50,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/images/lmr_logo.png'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Obx(() => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        userController.currentUser.isEmpty ? const CircularProgressIndicator() : getSubtitle(userController.currentUser.first.name ?? 'John Doe'),
                        userController.currentUser.isEmpty ? const CircularProgressIndicator() : getTruncatedEmailAddress(userController.currentUser.first.email ?? '', 25,),
                      ],
                    ))
                  ],
                ),
              ),
              ListTile(
                selected: true,
                selectedTileColor: primaryColor.withOpacity(0.2),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                ),
                iconColor: Colors.white,
                trailing: Icon(LineIcons.home),
                title: const Text('Home', style: TextStyle(color: Colors.white),),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                ),
                iconColor: Colors.white,
                trailing: Icon(LineIcons.user),
                title: const Text('My Profile', style: TextStyle(color: Colors.white),),
                onTap: () {
                  Navigator.pop(context);
                  Get.to(() => const MyProfileScreen());
                },
              ),
              ListTile(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                ),
                trailing: Icon(LineIcons.biking),
                title: const Text('My Sessions', style: TextStyle(color: Colors.white),),
                onTap: () {
                  Navigator.pop(context);
                  Get.to(() => const MySessionsScreen());
                },
              ),
              ListTile(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                ),
                trailing: Icon(LineIcons.medal, color: Colors.white,),
                title: const Text('My Challenges', style: TextStyle(color: Colors.white),),
                onTap: () {
                  Navigator.pop(context);
                  Get.to(() => const MyChallengesScreen());
                },
              ),
              ListTile(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                ),
                trailing: Icon(LineIcons.calendar, color: Colors.white,),
                title: const Text('My Events', style: TextStyle(color: Colors.white),),
                onTap: () {
                  Navigator.pop(context);
                  Get.to(() => const EventsScreen());
                },
              ),
              ListTile(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                ),
                trailing: SvgPicture.asset('assets/icons/settings_icon.svg', width: 22, color: Colors.white,),
                title: const Text('Settings', style: TextStyle(color: Colors.white),),
                onTap: () {
                  Navigator.pop(context);
                  Get.to(() => const SettingsScreen());
                },
              ),


              ListTile(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                ),
                trailing: Icon(LineIcons.alternateSignOut),
                title: const Text('Logout', style: TextStyle(color: Colors.white),),
                onTap: () {
                  Navigator.pop(context);
                },
              ),

            ],
          ),
        ),

      bottomNavigationBar: NavigationBarTheme(

        data: NavigationBarThemeData(

          labelTextStyle: WidgetStateProperty.all(
            GoogleFonts.roboto(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
        child: NavigationBar(
          indicatorColor: primaryColor,

          elevation: 3,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          },
          destinations: [
            NavigationDestination(
              icon: SvgPicture.asset('assets/icons/home_icon.svg',
                width: 25, color: Colors.white,),
                label: 'Home',
            ),
            NavigationDestination(
              icon: SvgPicture.asset('assets/icons/map_icon.svg',
              width: 25,
              color: Colors.white,),
              label: 'GPS',
            ),
            NavigationDestination(
              icon: SvgPicture.asset(
                'assets/icons/bike_icon.svg',
                width: 25,
                color:Colors.white,
              ),
              label: 'Track Mode',
            ),
            NavigationDestination(
              icon: SvgPicture.asset(
                'assets/icons/road_icon.svg',
                 width: 25,
                 color:Colors.white,),
              label: 'Road Mode',
            ),
            NavigationDestination(
              icon: SvgPicture.asset('assets/icons/settings_icon.svg', width: 25, color: _selectedIndex == 4 ? Colors.black : Colors.white,),
              label: 'Tuning Mode',
            ),
          ],
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          const RiderHomeScreen(),
          const TrackMyBikeScreen(),
          TrackModeScreen(),
          RoadModeScreen(),
          TuningModeScreen(),
        ],
      )
    );
  }
}
