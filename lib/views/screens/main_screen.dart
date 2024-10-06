import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:log_my_ride/controllers/location_controller.dart';
import 'package:log_my_ride/controllers/logging_controller.dart';
import 'package:log_my_ride/controllers/replay_timer_controller.dart';
import 'package:log_my_ride/controllers/user_controller.dart';
import 'package:log_my_ride/views/screens/club_home_screen.dart';
import 'package:log_my_ride/views/screens/coach_home_screen.dart';
import 'package:log_my_ride/views/screens/events_screen.dart';
import 'package:log_my_ride/views/screens/gps_mode_screen.dart';
import 'package:log_my_ride/views/screens/login_screen.dart';
import 'package:log_my_ride/views/screens/my_challenges_screen.dart';
import 'package:log_my_ride/views/screens/my_sessions_screen.dart';
import 'package:log_my_ride/views/screens/my_vehicles_screen.dart';
import 'package:log_my_ride/views/screens/promoter_home_screen.dart';
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
  final LoggingController loggingController = Get.put(LoggingController());
  final ReplayTimerController replayTimerController = Get.put(ReplayTimerController());
  final LocationController _mapController = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,

    ]);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        onPressed: () {
          // select track mode or ride mode
          showDialog(context: context, builder: (context) {
            return AlertDialog(
              title: const Text('Select Mode'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    title: const Text('Track Mode'),
                    onTap: () {
                      Navigator.pop(context);
                      //_pageController.animateToPage(2, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
                      Get.to(() => TrackModeScreen());
                    },
                  ),
                  ListTile(
                    title: const Text('Road Mode'),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(() => RoadModeScreen());
                    },
                  ),
                ],
              ),
            );
          });
        },
        child: const Icon(Icons.add),
      ),
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
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: CircleAvatar(
                        radius: 50,
                        child: SvgPicture.memory(getRandomSvgCode()),
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
                selectedTileColor: primaryColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                ),
                iconColor: Colors.white,
                trailing: const Icon(LineIcons.home, color: Colors.white,),
                title: const Text('Home', style: TextStyle(color: Colors.white),),
                onTap: () {
                  Navigator.pop(context);
                },
              ),

              ListTile(
                selectedTileColor: primaryColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                ),
                iconColor: Colors.white,
                trailing: const Icon(LineIcons.user, color: Colors.white,),
                title: const Text('My Profile',),
                onTap: () {
                  Navigator.pop(context);
                  Get.to(() => MyProfileScreen());
                },
              ),

              ListTile(
                selectedTileColor: primaryColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                ),
                trailing: const Icon(LineIcons.calendar, color: Colors.white,),
                title: const Text('FindARide', style: TextStyle(color: Colors.white),),
                onTap: () {
                  Navigator.pop(context);
                  Get.to(() => const EventsScreen());
                },
              ),
              ListTile(
                selectedTileColor: primaryColor,
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
                selectedTileColor: primaryColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                ),
                trailing: const Icon(LineIcons.alternateSignOut),
                title: const Text('Logout', style: TextStyle(color: Colors.white),),
                onTap: () {
                  Navigator.pop(context);
                  Get.offAll( () => LoginScreen());
                },
              ),

            ],
          ),
        ),

      bottomNavigationBar: Stack(
        children: [
          NavigationBarTheme(
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
                const NavigationDestination(
                  icon: Icon(Icons.home_filled,),
                  label: 'Home',
                ),
                const NavigationDestination(
                  icon: Icon(LineIcons.mapPin),
                  label: 'TrackMyRide',
                ),
                const NavigationDestination(
                  icon: Icon(Icons.people_alt_outlined),
                  label: 'MyChallenges',
                ),
                //const SizedBox(width: 100),
                //add button
                const NavigationDestination(
                  icon: Icon(LineIcons.biking, color: Colors.white,),
                  label: 'LogMyRide',
                ),

                NavigationDestination(
                  icon: SvgPicture.asset('assets/icons/settings_icon.svg', width: 25, color: Colors.white),
                  label: 'Tuning Mode',
                ),
              ],
            ),
          ),
         /* Positioned(


            bottom: 15,
            left: MediaQuery.of(context).size.width / 2 - 30,

            child: FloatingActionButton(
              backgroundColor: primaryColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              onPressed: () {
                // select track mode or ride mode
                showDialog(context: context, builder: (context) {
                  return AlertDialog(
                    title: const Text('Select Mode'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          title: const Text('Track Mode'),
                          onTap: () {
                            Navigator.pop(context);
                            //_pageController.animateToPage(2, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
                            Get.to(() => TrackModeScreen());
                          },
                        ),
                        ListTile(
                          title: const Text('Road Mode'),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          onTap: () {
                            Navigator.pop(context);
                            Get.to(() => RoadModeScreen());
                          },
                        ),
                      ],
                    ),
                  );
                });
              },
              child: const Icon(Icons.add),
            ),
          ),*/

        ],
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: getUserTypeScreens(),
      )
    );
  }

  getUserTypeScreens() {
    switch(userController.selectedUserType.value) {
      case UserType.RIDER:
        return [
          const RiderHomeScreen(),
          const GpsModeScreen(),
          const MyChallengesScreen(),
          const TrackMyBikeScreen(),
          TuningModeScreen(),
        ];
      case UserType.PROMOTER:
        return [
          const PromoterHomeScreen(),
          const GpsModeScreen(),
          const MyChallengesScreen(),
          const TrackMyBikeScreen(),
          TuningModeScreen(),
        ];
      case UserType.COACH:
        return [
          const CoachHomeScreen(),
          const GpsModeScreen(),
          const MyChallengesScreen(),
          const TrackMyBikeScreen(),
          TuningModeScreen(),
        ];
      case UserType.CLUB:
        return [
          const ClubHomeScreen(),
          const GpsModeScreen(),
          const MyChallengesScreen(),
          const TrackMyBikeScreen(),
          TuningModeScreen(),
        ];
      default:
        return [
          const RiderHomeScreen(),
          const GpsModeScreen(),
          const MyChallengesScreen(),
          const TrackMyBikeScreen(),
          TuningModeScreen(),
        ];
    }
  }
}
//rider_home_screen.dart
