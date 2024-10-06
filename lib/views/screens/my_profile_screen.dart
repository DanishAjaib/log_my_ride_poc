import 'dart:math';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:log_my_ride/utils/constants.dart';
import 'package:log_my_ride/utils/utils.dart';
import 'package:log_my_ride/views/screens/friend_profile_screen.dart';
import 'package:log_my_ride/views/screens/my_challenges_screen.dart';
import 'package:log_my_ride/views/widgets/app_container.dart';
import 'package:log_my_ride/views/widgets/app_social.dart';
import 'package:log_my_ride/views/widgets/customer_tile.dart';
import 'package:log_my_ride/views/widgets/friend_tile.dart';
import 'package:log_my_ride/views/widgets/my_custom_tune_tile.dart';
import 'package:log_my_ride/views/widgets/new_custom_tune_dialog.dart';
import 'package:log_my_ride/views/widgets/new_sensor_dialog.dart';
import 'package:log_my_ride/views/widgets/new_vehicle_dialog.dart';
import 'package:log_my_ride/views/widgets/random_spline_chart.dart';
import 'package:log_my_ride/views/widgets/sensor_tile.dart';
import 'package:log_my_ride/views/widgets/vehicle_tile.dart';
import 'package:multiavatar/multiavatar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:timelines/timelines.dart';

import '../../controllers/events_controller.dart';
import '../../controllers/sensors_controller.dart';
import '../../controllers/user_controller.dart';
import '../../controllers/vehicles_controller.dart';
import '../widgets/event_tile.dart';
import '../widgets/rating_bar.dart';
import 'event_summary_screen.dart';
import 'login_screen.dart';


enum TuningStatus {
  Delivered,
  PendingSubmission,
  InProgress,
}
class MyProfileScreen extends StatefulWidget {

  int defaultIndex;
  MyProfileScreen({super.key, this.defaultIndex = 0});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> with SingleTickerProviderStateMixin {
  bool _sortAscendingVehicles = true;
  int _sortColumnIndexVehicles = 0;

  bool _sortAscendingSensors = true;
  int _sortColumnIndexSensors = 0;

  bool _sortAscendingFriends = true;
  int _sortColumnIndexFriends = 0;

  bool _friendsSortState = true;

  final TextEditingController _vehicleSearchController = TextEditingController();
  final TextEditingController _sensorSearchController = TextEditingController();
  final TextEditingController _friendSearchController = TextEditingController();

  String _vehicleSearchQuery = '';
  String _sensorSearchQuery = '';
  String _friendSearchQuery = '';

  var userController = Get.find<UserController>();
  var vehiclesController = Get.put(VehiclesController());
  late TabController tabController;
  var eventsController = Get.put(EventController());
  var sensorsController = Get.put(SensorsController());
  var _studentsCategory = 'enduro';
  var _allStudentCategories = ['dirt', 'road', 'speedway', 'mx', 'enduro', 'trials', 'sprint', 'supermoto', 'side-cars', 'scooters'];

  final List<Map<String, dynamic>> _vehicleData = [
    {
      'image': 'assets/images/bike_image.jpg',
      'type': 'Supermoto',
      'year': '2012',
      'offset': '2012',
      'wheelSizeFront': '2012',
      'wheelDiameterFront': '2012',
      'wheelDiameterRear': '2012',
      'wheelPressureFront': '2012',
      'wheelPressureRear': '2012',
      'suspensionFront': '2012',
      'suspensionReboundRear': '2012',
      'reboundFront': '2012',
      'reboundRear': '',
      'compressionFront': '',
      'compressionRear': '',
      'preloadFront': '',
      'preloadRear': '',
      'lengthFront': '',
      'lengthRear': '',
      'strokeFront': '',
      'strokeRear': '',


      'category': 'Car',
    },
    {
      'image': 'assets/images/bike_image.jpg',
      'type': 'Royal Enfield Classic 350',
      'year': '2018',
      'offset': '2018',
      'wheelSizeFront': '2018',
      'wheelSizeRear': '2018',
    },
    {
      'image': 'assets/images/bike_image.jpg',
      'type': 'Bajaj Pulsar 150',
      'year': '2022',
      'offset': '2022',
      'wheelSizeFront': '2022',
      'wheelSizeRear': '2022',
    },
  ];

  List<Map<String, dynamic>> skillsData = [
    {
      'time_spent_minutes': 30,
      'average_speed_kmh': 80.5
    },
    {
      'time_spent_minutes': 45,
      'average_speed_kmh': 85.3
    },
    {
      'time_spent_minutes': 60,
      'average_speed_kmh': 82.1
    },
    {
      'time_spent_minutes': 25,
      'average_speed_kmh': 78.0
    },
    {
      'time_spent_minutes': 50,
      'average_speed_kmh': 88.7
    },
    {
      'time_spent_minutes': 55,
      'average_speed_kmh': 90.1
    },
    {
      'time_spent_minutes': 40,
      'average_speed_kmh': 83.2
    },
    {
      'time_spent_minutes': 35,
      'average_speed_kmh': 79.4
    },
    {
      'time_spent_minutes': 65,
      'average_speed_kmh': 91.5
    },
    {
      'time_spent_minutes': 70,
      'average_speed_kmh': 93.0
    }
  ];


  final List<Map<String, dynamic>> _sensorData = [
    {
      'image': 'assets/images/sensor_1.jpg',
      'type': 'Bajaj Pulsar 150',
      'sn': '1234567890',
      'lastActive': '2022-01-01',
      'lastSession': 'Session 1',
    },
    {
      'image': 'assets/images/sensor_2.PNG',
      'type': 'Royal Enfield Classic 350',
      'sn': '1234567890',
      'lastActive': '2022-01-01',
      'lastSession': 'Session 2',
    },
    {
      'image': 'assets/images/sensor_3.jpg',
      'type': 'Bajaj Pulsar 150',
      'sn': '1234567890',
      'lastActive': '2022-01-01',
      'lastSession': 'Session 3',
    },
  ];

  final List<Map<String, dynamic>> _customersData = List<Map<String, dynamic>>.generate(
    6, (index) => {
      'name': faker.person.name(),
      'events': faker.randomGenerator.integer(18, min: 5),
      'email': faker.internet.email(),
      'added': faker.date.dateTime(minYear: 2024, maxYear: 2025).millisecondsSinceEpoch,
    },
  );

  final List<Map<String, dynamic>> _friendData = [
    {
      'name': faker.person.name(),
      'location': faker.address.city(),
      'rideTime': faker.randomGenerator.integer(1000, min: 50),
      'email': faker.internet.email(),
      'added': faker.date.dateTime(minYear: 2024, maxYear: 2025).millisecondsSinceEpoch,
    },
    {
      'name': faker.person.name(),
      'location': faker.address.city(),
      'rideTime': faker.randomGenerator.integer(1000, min: 50),
      'email': faker.internet.email(),
      'added': faker.date.dateTime(minYear: 2024, maxYear: 2025).millisecondsSinceEpoch,
      
    },
    {
      'name': faker.person.name(),
      'location': faker.address.city(),
      'rideTime': faker.randomGenerator.integer(1000, min: 50),
      'email': faker.internet.email(),
      'added': faker.date.dateTime(minYear: 2024, maxYear: 2025).millisecondsSinceEpoch,
    },
    {
      'name': faker.person.name(),
      'location': faker.address.city(),
      'rideTime': faker.randomGenerator.integer(1000, min: 50),
      'email': faker.internet.email(),
      'added': faker.date.dateTime(minYear: 2024, maxYear: 2025).millisecondsSinceEpoch,
    },
    {
      'name': faker.person.name(),
      'location': faker.address.city(),
      'rideTime': faker.randomGenerator.integer(1000, min: 50),
      'email': faker.internet.email(),
      'added': faker.date.dateTime(minYear: 2024, maxYear: 2025).millisecondsSinceEpoch,
    },
    {
      'name': faker.person.name(),
      'location': faker.address.city(),
      'rideTime': faker.randomGenerator.integer(1000, min: 50),
      'email': faker.internet.email(),
      'added': faker.date.dateTime(minYear: 2024, maxYear: 2025).millisecondsSinceEpoch,
    },
  ];

  //clubs data
  final List<Map<String, dynamic>> _clubData = [
    {
      'name': faker.company.name(),
      'location': faker.address.city(),
      'rating': 5.0,
    },
    {
      'name': faker.company.name(),
      'location': faker.address.city(),
      'rating': 4.5,
    },
    {
      'name': faker.company.name(),
      'location': faker.address.city(),
      'rating': 3.5,
    },
  ];

  //notifications data
  final List<Map<String, dynamic>> _notificationData = [
    {
      'name':'Event Starting Soon',
      'description':  faker.lorem.sentence(),
      'time': faker.date.dateTime(minYear: 2024, maxYear: 2025),
    },
    {
      'name': 'Next session starting in 5 minutes',
      'description': faker.address.city(),
      'time': faker.date.dateTime(minYear: 2024, maxYear: 2025),
    },
    {
      'name': 'New Event Created',
      'description': faker.address.city(),
      'time': faker.date.dateTime(minYear: 2024, maxYear: 2025),
    },
  ];

  var recentActivity = [
    {
      'title' : 'Event',
      'date' : DateFormat.yMMMd().format(faker.date.dateTime(minYear: 2022, maxYear: 2022)),
      'icon' : LineIcons.calendarAlt,
      'avgSpeed' : '30',
      'before' : '10',
      'after' : '20',
      'distance' : '200.5km',
      'maxLeanAngle' : '45',
    },
    {
      'title' : 'Road',
      'date' : DateFormat.yMMMd().format(faker.date.dateTime(minYear: 2022, maxYear: 2022)),
      'icon' : LineIcons.road,
      'avgSpeed' : '30',
      'before' : '10',
      'after' : '20',
      'distance' : '2.5km',
      'maxLeanAngle' : '30',
    },
    {
      'title' : 'Ride',
      'date' : DateFormat.yMMMd().format(faker.date.dateTime(minYear: 2022, maxYear: 2022)),
      'time' : '11:30',
      'icon' : LineIcons.car,
      'avgSpeed' : '30',
      'distance' : '2.5km',
      'before' : '10',
      'after' : '20',
      'maxLeanAngle' : '30',

    },
    {
      'title' : 'Ride',
      'date' : DateFormat.yMMMd().format(faker.date.dateTime(minYear: 2022, maxYear: 2022)),
      'time' : '11:30',
      'icon' : LineIcons.car,
      'avgSpeed' : '30',
      'distance' : '2.5km',
      'before' : '10',
      'after' : '20',
      'maxLeanAngle' : '30',

    },


  ];


  final  List<Map<String, dynamic>> mySkills = [
    {
      'name': 'Max Lean Angle',
      'value': 35,
    },
    {
      'name': 'Average Speed',
      'value': 85,
    },
    {
      'name': 'Max Speed',
      'value': 150,
    },
    {
      'name': 'Sector Timing',
      'value': 75,
    },
    {
      'name': 'Max RPM',
      'value': 9000,
    },
    {
      'name': 'Average RPM',
      'value': 6000,
    },
    //max lateral g-force
    {
      'name': 'Max Lateral G-Force',
      'value': 6.8,
    },



  ];



  void _setVehicleSortState(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndexVehicles = columnIndex;
      _sortAscendingVehicles = ascending;
    });
  }

  void _setSensorSortState(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndexSensors = columnIndex;
      _sortAscendingSensors = ascending;
    });
  }

  void _setFriendSortState(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndexFriends = columnIndex;
      _sortAscendingFriends = ascending;
    });
  }

  void _sort<T>(List<Map<String, dynamic>> data, Comparable<T> Function(Map<String, dynamic> d) getField, int columnIndex, bool ascending, Function setStateCallback) {
    data.sort((a, b) {
      if (!ascending) {
        final Map<String, dynamic> c = a;
        a = b;
        b = c;
      }
      final Comparable<T> aValue = getField(a);
      final Comparable<T> bValue = getField(b);
      return Comparable.compare(aValue, bValue);
    });
    setStateCallback(columnIndex, ascending);
  }

  List<Map<String, dynamic>> _filterData(List<Map<String, dynamic>> data, String query) {
    if (query.isEmpty) {
      return data;
    }
    return data.where((element) {
      return element.values.any((value) => value.toString().toLowerCase().contains(query.toLowerCase()));
    }).toList();
  }

  String _generateRandomString(int length) {
    const characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
      length,
          (_) => characters.codeUnitAt(random.nextInt(characters.length)),
    ));
  }

  Uint8List getRandomSvgCode() {
    String randomString = _generateRandomString(8); // Generate a random string of length 8
    return Uint8List.fromList(multiavatar(randomString).codeUnits);
  }

  @override
  void initState() {
    tabController = TabController(length: 10, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      tabController.animateTo(widget.defaultIndex);
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    _friendData.sort((b, a) => a['rideTime'].compareTo(b['rideTime']));
    var svgCode = Uint8List.fromList(multiavatar('X-SLAYER').codeUnits);
    //post frame callback

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),

      ),
      body: Column(
        children: [
          TabBar(
            splashBorderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            isScrollable: true,
            indicatorColor: primaryColor,
            labelColor: primaryColor,
            controller: tabController,
            tabs: [
              Tab(text: 'Personal Info'),
              Tab(text: 'My Vehicles'),
              Tab(text: 'My Sensors'),
              Tab(text: getUserTabName( userController.selectedUserType.value)),
              Tab(text: 'My Friends'),
              Tab(text: 'My Events'),
              Tab(text: 'My Clubs'),
              /*Tab(text: 'My Challenges'),*/
              Tab(text: 'My Notifications'),
            ],
          ),
          Expanded(
            child: TabBarView(

              controller: tabController,
              children: [
                //personal info
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20,),
                        AppContainer(
                          height: 180,
                          color: primaryColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    child: ClipOval(
                                      child: SvgPicture.memory(svgCode),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(userController.currentUser.first.name.toString(), style: const TextStyle(fontWeight: FontWeight.bold),),
                                  Text(faker.internet.email()),

                                ],
                              )
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            const Text('PERSONAL INFO', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                            const Spacer(),
                            TextButton.icon(
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(primaryColor),
                                ),
                                onPressed: () {

                                }, label: const Text('Edit', style: TextStyle(color: Colors.white),), icon: const Icon(Icons.edit, color: Colors.white, size: 16)
                            )
                          ],
                        ),
                        AppContainer(
                            height: null,
                            child: Column(
                              children: [
                                ListTile(

                                  title: const Text('Name'),
                                  subtitle: Text(userController.currentUser.first.name.toString()),
                                ),
                                Divider(
                                  color: Colors.grey.withOpacity(0.1),
                                  thickness: 1,
                                ),
                                ListTile(
                                  title: const Text('Email'),
                                  subtitle: Text(userController.currentUser.first.email.toString()),
                                ),
                                Divider(
                                  color: Colors.grey.withOpacity(0.1),
                                  thickness: 1,
                                ),
                                ListTile(
                                  title: const Text('Phone'),
                                  subtitle: Text(faker.phoneNumber.us()),
                                ),
                                Divider(
                                  color: Colors.grey.withOpacity(0.1),
                                  thickness: 1,
                                ),
                                ListTile(
                                  title: const Text('Address'),
                                  subtitle: Text(userController.currentUser.first.address.toString()),
                                ),
                              ],
                            )
                        ),
                        const SizedBox(height: 20,),
                        const Divider(),
                        const SizedBox(height: 20,),
                        //a row of social media icons

                        const AppSocial()

                      ],
                    ),
                  ),
                ),
                //vehicles
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              const Text('MY VEHICLES', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                              const Spacer(),
                              TextButton.icon(


                                  onPressed: () {
                                    showDialog(context: context, builder: (context) {
                                      return NewVehicleDialog();
                                    });


                                  }, label: const Text('Add New', style: TextStyle(color: Colors.white),),
                                  icon: const Icon(Icons.add, color: Colors.white, size: 16)
                              )
                            ],
                          ),
                        ),
                        /*TextField(
                          controller: _vehicleSearchController,
                          decoration: InputDecoration(
                            labelText: 'Search Vehicles',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _vehicleSearchQuery = value;
                            });
                          },
                        ),*/
                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10,),
                                  Obx(() {

                                    return ListView.builder(

                                      shrinkWrap: true,
                                      itemCount: vehiclesController.vehicles.length,
                                      itemBuilder: (context, index) {
                                        var currentVehicle = vehiclesController.vehicles[index];

                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: 5),
                                          child: VehicleTile(onPressed: (vehicle) {

                                            //show bottom sheet
                                            showModalBottomSheet(
                                              context: context,
                                              builder: (context) {
                                                return Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [

                                                    Row(
                                                      children: [
                                                        const Padding(
                                                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                                            child: Text('Vehicle Configuration', style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor),)),
                                                        const Spacer(),
                                                        //delete button
                                                        TextButton.icon(

                                                            onPressed: () {
                                                              Navigator.pop(context);
                                                              showDialog(context: context, builder: (context) {
                                                                return AlertDialog(
                                                                  title: const Text('Delete Vehicle'),
                                                                  content: const Text('Are you sure you want to delete this vehicle?'),
                                                                  actions: [
                                                                    TextButton(onPressed: () {
                                                                      Navigator.pop(context);
                                                                    }, child: const Text('Cancel')),
                                                                    TextButton(onPressed: () {
                                                                      vehiclesController.removeVehicle(vehicle);
                                                                      Navigator.pop(context);
                                                                    }, child: const Text('Delete')),
                                                                  ],
                                                                );
                                                              });
                                                            }, label: const Text('Delete', style: TextStyle(color: Colors.white),),
                                                            icon: const Icon(Icons.delete, color: Colors.white, size: 16)
                                                        )
                                                      ],
                                                    ),


                                                    const Divider(color: primaryColor,),
                                                    const SizedBox(height: 10,),
                                                    AppContainer(
                                                      height: 350,

                                                      child: SingleChildScrollView(
                                                        physics: const BouncingScrollPhysics(),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            //diameter
                                                            ListTile(
                                                              title: const Text('Wheel Diameter', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),),
                                                              subtitle: Row(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  const Text('Front: ', style: TextStyle(color: Colors.white),),
                                                                  Text(vehicle['diameter']['front'].toString(), style: const TextStyle(color: primaryColor),),
                                                                  const SizedBox(width: 10,),
                                                                  const Text('Rear: ', style: TextStyle(color: Colors.white),),
                                                                  Text( vehicle['diameter']['rear'].toString() , style: const TextStyle(color: primaryColor),),
                                                                ],
                                                              ),
                                                            ),
                                                            const Divider(color: Colors.grey, thickness: 1,),
                                                            //pressure
                                                            ListTile(
                                                              title: const Text('Wheel Pressure', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),),
                                                              subtitle: Row(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  const Text('Front: ', style: TextStyle(color: Colors.white),),
                                                                  Text(vehicle['pressure']['front'].toString(), style: const TextStyle(color: primaryColor),),
                                                                  const SizedBox(width: 10,),
                                                                  const Text('Rear: ', style: TextStyle(color: Colors.white),),
                                                                  Text(  vehicle['pressure']['rear'].toString(), style: const TextStyle(color: primaryColor),),
                                                                ],
                                                              ),
                                                            ),
                                                            const Divider(color: Colors.grey, thickness: 1,),
                                                            //suspension
                                                            ListTile(
                                                              title: const Text('Suspension', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),),
                                                              subtitle: Row(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  const Text('Front: ', style: TextStyle(color: Colors.white),),
                                                                  Text(vehicle['suspension']['front'].toString(), style: const TextStyle(color: primaryColor),),
                                                                  const SizedBox(width: 10,),
                                                                  const Text('Rear: ', style: TextStyle(color: Colors.white),),
                                                                  Text(vehicle['suspension']['rear'].toString() , style: const TextStyle(color: primaryColor),),
                                                                ],
                                                              ),
                                                            ),
                                                            const Divider(color: Colors.grey, thickness: 1,),
                                                            //rebound
                                                            ListTile(
                                                              title: const Text('Rebound', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),),
                                                              subtitle: Row(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  const Text('Front: ', style: TextStyle(color: Colors.white),),
                                                                  Text(vehicle['rebound']['front'].toString(), style: const TextStyle(color: primaryColor),),
                                                                  const SizedBox(width: 10,),
                                                                  const Text('Rear: ', style: TextStyle(color: Colors.white),),
                                                                  Text(vehicle['rebound']['rear'].toString() , style: const TextStyle(color: primaryColor),),
                                                                ],
                                                              ),
                                                            ),
                                                            const Divider(color: Colors.grey, thickness: 1,),
                                                            //compression
                                                            ListTile(
                                                              title: const Text('Compression', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),),
                                                              subtitle: Row(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  const Text('Front: ', style: TextStyle(color: Colors.white),),
                                                                  Text(vehicle['compression']['front'].toString(), style: const TextStyle(color: primaryColor),),
                                                                  const SizedBox(width: 10,),
                                                                  const Text('Rear: ', style: TextStyle(color: Colors.white),),
                                                                  Text(vehicle['compression']['rear'].toString() , style: const TextStyle(color: primaryColor),),
                                                                ],
                                                              ),
                                                            ),
                                                            const Divider(color: Colors.grey, thickness: 1,),
                                                            //preload
                                                            ListTile(
                                                              title: const Text('Preload', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),),
                                                              subtitle: Row(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  const Text('Front: ', style: TextStyle(color: Colors.white),),
                                                                  Text(vehicle['preload']['front'].toString(), style: const TextStyle(color: primaryColor),),
                                                                  const SizedBox(width: 10,),
                                                                  const Text('Rear: ', style: TextStyle(color: Colors.white),),
                                                                  Text(vehicle['preload']['rear'].toString() , style: const TextStyle(color: primaryColor),),
                                                                ],
                                                              ),
                                                            ),
                                                        
                                                          ],
                                                        ),
                                                      ),
                                                    )


                                                  ],
                                                );
                                              },
                                            );
                                          }, vehicle: vehiclesController.vehicles[index]),
                                        );
                                      },
                                    );
                                  }),

                                ]
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
                //sensors
                SingleChildScrollView(
                  child:Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text('MY SENSORS', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                            const Spacer(),
                            TextButton.icon(

                                onPressed: () {
                                  showDialog(context: context, builder: (context) {
                                    return NewSensorDialog();
                                  });

                                }, label: const Text('Add New', style: TextStyle(color: Colors.white),),
                                icon: const Icon(Icons.add, color: Colors.white, size: 16)
                            )
                          ],
                        ),

                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10,),
                                  Obx(() {

                                    return ListView.builder(

                                      shrinkWrap: true,
                                      itemCount: sensorsController.sensors.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: 5),
                                          child: SensorTile(onPressed:(sensor) {
                                            //delete
                                            showDialog(context: context, builder: (context) {
                                              return AlertDialog(
                                                title: const Text('Delete Sensor'),
                                                content: const Text('Are you sure you want to delete this sensor?'),
                                                actions: [
                                                  TextButton(onPressed: () {
                                                    Navigator.pop(context);
                                                  }, child: const Text('Cancel')),
                                                  TextButton(onPressed: () {
                                                    sensorsController.removeSensor(sensor);
                                                    Navigator.pop(context);
                                                  }, child: const Text('Delete')),
                                                ],
                                              );
                                            });
                                          }, sensor: sensorsController.sensors[index],),
                                        );
                                      },
                                    );
                                  }),

                                ]
                            ),
                          ),
                        ),

                        /*AppContainer(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            child: DataTable(
                              sortColumnIndex: _sortColumnIndexSensors,
                              sortAscending: _sortAscendingSensors,

                              dataRowMaxHeight: 75,
                              columns: [
                                const DataColumn(label: Text('Image'), ),
                                DataColumn(label: const Text('Type'), onSort: (columnIndex, ascending) => _sort<String>(_sensorData, (d) => d['type'], columnIndex, ascending, _setSensorSortState)),
                                DataColumn(label: const Text('S/N'), onSort: (columnIndex, ascending) => _sort<String>(_sensorData, (d) => d['sn'], columnIndex, ascending, _setSensorSortState)),
                                DataColumn(label: const Text('Last Active'), onSort: (columnIndex, ascending) => _sort<String>(_sensorData, (d) => d['lastActive'], columnIndex, ascending, _setSensorSortState)),
                                DataColumn(label: const Text('Last Session Recorded'), onSort: (columnIndex, ascending) => _sort<String>(_sensorData, (d) => d['lastSession'], columnIndex, ascending, _setSensorSortState)),
                              ],
                              rows: _filterData(_sensorData, _sensorSearchQuery).map((sensor) {
                                return DataRow(
                                  cells: [
                                    DataCell(
                                      CircleAvatar(
                                        backgroundImage: AssetImage(sensor['image']),
                                      ),
                                    ),
                                    DataCell(Text(sensor['type'])),
                                    DataCell(Text(sensor['sn'])),
                                    DataCell(Text(sensor['lastActive'])),
                                    DataCell(Text(sensor['lastSession'])),
                                  ],
                                );
                              }).toList(),

                            ),
                          ),
                        ),*/
                      ],
                    ),
                  ),
                ),
                //skills

                if(Get.find<UserController>().selectedUserType.value == UserType.COACH)
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              children: [
                                const Text('Students', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                                const Spacer(),
                                //search button
                                TextButton.icon(onPressed: () {

                                  //show bottom modal sheet
                                  showModalBottomSheet(context: context, builder: (context) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                            child: Text('Search Students', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),)),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextField(
                                            decoration: InputDecoration(
                                              labelText: 'Search symmetric',
                                              prefixIcon: const Icon(Icons.search),
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                            ),
                                          ),
                                        ),
                                        const Divider(color: primaryColor,),
                                        ListView.builder(itemBuilder:  (context, index) {
                                          return ListTile(
                                            title: Text(_customersData[index]['name']),
                                            subtitle: Text(_customersData[index]['email']),

                                          );
                                        },
                                          itemCount: _clubData.length,
                                          shrinkWrap: true,
                                        ),

                                      ],
                                    );
                                  });

                                }, label: const Text('Search', style: TextStyle(color: Colors.white),), icon: const Icon(Icons.search, color: Colors.white, size: 16)) ,
                                TextButton.icon(onPressed: () {
                                  showDialog(context: context, builder:  (context) {
                                    return AlertDialog(
                                      title: const Text('Select Category'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: _allStudentCategories.map((category) {
                                          return ListTile(
                                            title: Text(category),
                                            onTap: () {
                                              setState(() {
                                                _studentsCategory = category;
                                              });
                                              Navigator.pop(context);
                                            },
                                          );
                                        }).toList(),
                                      ),
                                    );
                                  });

                                }, label: Text(_studentsCategory, style: const TextStyle(color: Colors.white),), icon: const Icon(Icons.sort, color: Colors.white, size: 16)),
                              ],
                            ),
                          ),
                          ..._customersData.map((friend) {
                            return Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: CustomerTile(onPressed: (friend) {
                                  Get.to(() => const FriendProfileScreen());

                                }, friend: friend));
                          }).toList(),

                        ],
                      )
                    )
                  ),


                if(Get.find<UserController>().selectedUserType.value == UserType.PROMOTER)
                  //my customers
                  SingleChildScrollView(
                    physics:  const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              children: [
                                const Text('Customers', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                                const Spacer(),
                                //search button
                                TextButton.icon(onPressed: () {

                                  //show bottom modal sheet
                                  showModalBottomSheet(context: context, builder: (context) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                            child: Text('Search Customers', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),)),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextField(
                                            decoration: InputDecoration(
                                              labelText: 'Search Customers',
                                              prefixIcon: const Icon(Icons.search),
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                            ),
                                          ),
                                        ),
                                        const Divider(color: primaryColor,),
                                        ListView.builder(itemBuilder:  (context, index) {
                                          return ListTile(
                                            title: Text(_customersData[index]['name']),
                                            subtitle: Text(_customersData[index]['email']),

                                          );
                                        },
                                          itemCount: _clubData.length,
                                          shrinkWrap: true,
                                        ),

                                      ],
                                    );
                                  });

                                }, label: const Text('Search', style: TextStyle(color: Colors.white),), icon: const Icon(Icons.search, color: Colors.white, size: 16)) ,
                                TextButton.icon(onPressed: () {
                                  if(_friendsSortState) {

                                    setState(() {
                                      _friendData.sort((b, a) => a['added'].compareTo(b['added']));
                                      _friendsSortState = false;
                                    });
                                  } else {

                                    setState(() {
                                      _friendData.sort((b, a) => a['rideTime'].compareTo(b['rideTime']));
                                      _friendsSortState = true;
                                    });
                                  }
                                  setState(() {});
                                }, label: Text(_friendsSortState ? 'Past' : 'Suggested', style: const TextStyle(color: Colors.white),), icon: const Icon(Icons.sort, color: Colors.white, size: 16)),

                              ],
                            ),
                          ),
                          const SizedBox(height: 10,),

                          ..._customersData.map((friend) {
                            return Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: CustomerTile(onPressed: (friend) {
                                  Get.to(() => const FriendProfileScreen());

                                }, friend: friend));
                          }).toList(),
                        ]
                      ),
                    ),
                  ),


                if(Get.find<UserController>().selectedUserType.value == UserType.RIDER)
                  //my skills
                SingleChildScrollView(
                  physics:  const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment:  CrossAxisAlignment.start,
                      children: [

                        const SizedBox(height: 10,),
                        const AppContainer(
                          child: Column(
                            children: [
                              ListTile(
                                title: Text('Total Sessions'),
                                subtitle: Text('5'),
                              ),
                              Divider(),
                              ListTile(
                                title: Text('Skill Level'),
                                subtitle: Text('Intermediate'),
                                trailing: Stack(
                                  children: [
                                    CircularProgressIndicator(
                                      value: 0.75,
                                      backgroundColor: Colors.grey,
                                      valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                                    ),
                                    Positioned(
                                        right: 0,
                                        top: 9,
                                        left: 8,
                                        child: Text('75%', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),))

                                  ],
                                ),
                              ),
                              Divider(),
                              ListTile(
                                title: Text('Rider Ranking'),
                                subtitle: Text('Top 8%', style:  TextStyle(color: primaryColor, fontWeight: FontWeight.bold),),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10,),
                        //skills
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              Text('Skills'),
                              const Spacer(),
                              TextButton(onPressed: () {

                              }, child: const Text('Add', style: TextStyle(color: primaryColor),))
                            ],
                          ),
                        ),
                        const SizedBox(height: 10,),
                        ...mySkills.map((skill) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: ElevatedButton(
                                
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:  BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () {
                                  showModalBottomSheet(
                                    isScrollControlled:true,
                                      context: context, builder: (context) {
                                    return SizedBox(
                                      width: double.infinity,
                                      height: 800,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: SingleChildScrollView(
                                          physics:  const BouncingScrollPhysics(),
                                          child: Column(
                                            crossAxisAlignment:  CrossAxisAlignment.start,
                                            children: [
                                              Text(skill['name'].toString(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                              const Text('Analysis'),
                                              const SizedBox(height: 10,),
                                              const Divider(color: primaryColor,),
                                              const SizedBox(height: 10,),
                                              const Align(
                                                alignment: Alignment.center,
                                                child: Text('Time Spent on LMR (mins) vs Skill'),
                                              ),
                                              AppContainer(
                                                child: SfCartesianChart(


                                                  primaryXAxis: CategoryAxis(
                                                    labelAlignment: LabelAlignment.center,
                                                    minorGridLines: null,
                                                    majorGridLines: null,
                                                  ),
                                                  series: <ChartSeries>[
                                                    ColumnSeries<Map<String, dynamic>, String>(

                                                      color: primaryColor,
                                                      dataLabelSettings: const DataLabelSettings(isVisible: true),

                                                      dataSource: skillsData,
                                                      xValueMapper: (datum, index) => datum['time_spent_minutes'].toString(),
                                                      yValueMapper: (datum, index) => datum['average_speed_kmh'],
                                                    )
                                                  ],
                                                ),
                                              ),

                                              const SizedBox(height: 10,),
                                              const Divider(color: primaryColor,),
                                              const SizedBox(height: 10,),
                                              const Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text('Activities contributing to this skill'),
                                              ),
                                              const SizedBox(height: 10,),
                                              ...recentActivity.map((activity) {

                                                return Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                                                  child: ElevatedButton(
                                                      style:  ButtonStyle(
                                                        shape: WidgetStateProperty.all(
                                                          RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(10),
                                                          ),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Get.to(() => EventSummaryScreen(event: eventsController.events[0]));
                                                      },
                                                      child: ListTile(
                                                        leading: CircleAvatar(
                                                          radius: 25,
                                                          backgroundColor: primaryColor,
                                                          child: Icon(activity['icon']as IconData, color: Colors.white,),
                                                        ),
                                                        title: Text(activity['title'].toString()),
                                                        subtitle: Row(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            const Icon(Icons.calendar_month, color: primaryColor, size: 18,),
                                                            const SizedBox(width: 5,),
                                                            Text(activity['date'].toString(), style: const TextStyle(color: Colors.grey, fontSize: 14),),
                                                            const SizedBox(width: 15,),
                                                            const Icon(Icons.timer, color: primaryColor, size: 18,),
                                                            const SizedBox(width: 5,),
                                                            Text(activity['distance'].toString(), style: const TextStyle(color: Colors.grey, fontSize: 14),),



                                                          ],
                                                        ),
                                                      )),
                                                );

                                              })
                                              /*Expanded(
                                                child: ListView.builder(
                                                    itemCount:  recentActivity.length,
                                                    itemBuilder: (context, index) {

                                                      return Padding(
                                                        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                                                        child: ElevatedButton(
                                                            style:  ButtonStyle(
                                                              shape: MaterialStateProperty.all(
                                                                RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(10),
                                                                ),
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              Get.to(() => EventSummaryScreen(event: eventsController.events[0]));
                                                            },
                                                            child: ListTile(
                                                              leading: CircleAvatar(
                                                                radius: 25,
                                                                backgroundColor: primaryColor,
                                                                child: Icon(recentActivity[index]['icon']as IconData, color: Colors.white,),
                                                              ),
                                                              title: Text(recentActivity[index]['title'].toString()),
                                                              subtitle: Row(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  const Icon(Icons.calendar_month, color: primaryColor, size: 18,),
                                                                  const SizedBox(width: 5,),
                                                                  Text(recentActivity[index]['date'].toString(), style: const TextStyle(color: Colors.grey, fontSize: 14),),
                                                                  const SizedBox(width: 15,),
                                                                  const Icon(Icons.timer, color: primaryColor, size: 18,),
                                                                  const SizedBox(width: 5,),
                                                                  Text(recentActivity[index]['distance'].toString(), style: const TextStyle(color: Colors.grey, fontSize: 14),),



                                                                ],
                                                              ),
                                                            )),
                                                      );
                                                    }),
                                              ),*/


                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                                },
                                child: ListTile(
                                  leading: CircleAvatar(
                                    child: SvgPicture.memory(getRandomSvgCode()),
                                  ),
                                  title: Text(skill['name'].toString(),),
                                  subtitle: Text(skill['value'].toString(), style: const TextStyle(color: primaryColor),),
                                )
                            ),
                          );
                        }).toList()


                      ]
                    ),
                  ),
                ),
                //friends
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        children: [
                          Row(
                            children: [
                              const Text('MY FRIENDS', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                              const Spacer(),
                              //sort
                              TextButton.icon(onPressed: () {
                                if(_friendsSortState) {

                                  setState(() {
                                    _friendData.sort((b, a) => a['added'].compareTo(b['added']));
                                    _friendsSortState = false;
                                  });
                                } else {

                                  setState(() {
                                    _friendData.sort((b, a) => a['rideTime'].compareTo(b['rideTime']));
                                    _friendsSortState = true;
                                  });
                                }
                                setState(() {});
                              }, label: Text(_friendsSortState ? 'Ride Time' : 'Date Added', style: const TextStyle(color: Colors.white),), icon: const Icon(Icons.sort, color: Colors.white, size: 16)),
                              TextButton.icon(

                                  onPressed: () {

                                  }, label: const Text('Add New', style: TextStyle(color: Colors.white),),
                                  icon: const Icon(Icons.add, color: Colors.white, size: 16)
                              )
                            ],
                          ),
                          const SizedBox(height: 10,),
                          /*TextField(
                            controller: _friendSearchController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              labelText: 'Search Friends',
                              prefixIcon: const Icon(Icons.search),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _friendSearchQuery = value;
                              });
                            },
                          ),
                          AppContainer(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              child: DataTable(
                                sortColumnIndex: _sortColumnIndexFriends,
                                sortAscending: _sortAscendingFriends,
                                dataRowMaxHeight: 75,
                                columns: [
                                  const DataColumn(label: Text('Image'), ),
                                  DataColumn(label: const Text('Name'), onSort: (columnIndex, ascending) => _sort<String>(_friendData, (d) => d['name'], columnIndex, ascending, _setFriendSortState)),
                                  DataColumn(label: const Text('Location'), onSort: (columnIndex, ascending) => _sort<String>(_friendData, (d) => d['location'], columnIndex, ascending, _setFriendSortState)),
                                  DataColumn(label: const Text('Rating'), onSort: (columnIndex, ascending) => _sort<String>(_friendData, (d) => d['rating'], columnIndex, ascending, _setFriendSortState)),
                                ],
                                rows: _filterData(_friendData, _friendSearchQuery).map((friend) {
                                  return DataRow(
                                    cells: [
                                      DataCell(
                                        CircleAvatar(
                                          child: ClipOval(
                                            child: SvgPicture.memory(getRandomSvgCode()),
                                          ),
                                        ),
                                      ),
                                      DataCell(Text(friend['name'])),
                                      DataCell(Text(friend['location'])),
                                      DataCell(
                                        RatingBar(
                                          allowHalfRating: true,
                                          initialRating: friend['rating'],
                                          iconSize: 16,
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),*/
                          Column(
                            children: _friendData.map((friend) {
                              return Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: FriendTile(onPressed: (friend) {
                                    Get.to(() => const FriendProfileScreen());

                                  }, friend: friend));
                            }).toList(),
                          )

                        ]
                    ),
                  ),
                ),
                //events
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //sort
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              children: [
                                const Text('MY EVENTS', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                                const Spacer(),
                                TextButton.icon(onPressed: () {
                                  if(_friendsSortState) {

                                    setState(() {
                                      _friendData.sort((b, a) => a['added'].compareTo(b['added']));
                                      _friendsSortState = false;
                                    });
                                  } else {

                                    setState(() {
                                      _friendData.sort((b, a) => a['rideTime'].compareTo(b['rideTime']));
                                      _friendsSortState = true;
                                    });
                                  }
                                  setState(() {});
                                }, label: Text(_friendsSortState ? 'Past' : 'Upcoming', style: const TextStyle(color: Colors.white),), icon: const Icon(Icons.sort, color: Colors.white, size: 16)),

                              ],
                            ),
                          ),
                          Obx(() {

                            return ListView.builder(

                              shrinkWrap: true,
                              itemCount: eventsController.events.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: EventTile(
                                    event: eventsController.events[index],
                                    onPressed: () {
                                      Get.to(() => EventSummaryScreen(event: eventsController.events[index],));
                                    },
                                  ),
                                );
                              },
                            );
                          }),

                        ]
                    ),
                  ),
                ),
                //clubs
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              children: [
                                const Text('MY Clubs', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                                const Spacer(),
                                //search button
                                TextButton.icon(onPressed: () {

                                  //show bottom modal sheet
                                  showModalBottomSheet(context: context, builder: (context) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                            child: Text('Search Clubs', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),)),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextField(
                                            decoration: InputDecoration(
                                              labelText: 'Search Clubs',
                                              prefixIcon: const Icon(Icons.search),
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                            ),
                                          ),
                                        ),
                                        const Divider(color: primaryColor,),
                                        ListView.builder(itemBuilder:  (context, index) {
                                          return ListTile(
                                            title: Text(_clubData[index]['name']),
                                            subtitle: Text(_clubData[index]['location']),
                                            trailing: RatingBar(
                                              allowHalfRating: true,
                                              initialRating: _clubData[index]['rating'],
                                              iconSize: 16,
                                            ),
                                          );
                                        },
                                          itemCount: _clubData.length,
                                          shrinkWrap: true,
                                        ),

                                      ],
                                    );
                                  });

                                }, label: const Text('Search', style: TextStyle(color: Colors.white),), icon: const Icon(Icons.search, color: Colors.white, size: 16)) ,
                                TextButton.icon(onPressed: () {
                                  if(_friendsSortState) {

                                    setState(() {
                                      _friendData.sort((b, a) => a['added'].compareTo(b['added']));
                                      _friendsSortState = false;
                                    });
                                  } else {

                                    setState(() {
                                      _friendData.sort((b, a) => a['rideTime'].compareTo(b['rideTime']));
                                      _friendsSortState = true;
                                    });
                                  }
                                  setState(() {});
                                }, label: Text(_friendsSortState ? 'Past' : 'Suggested', style: const TextStyle(color: Colors.white),), icon: const Icon(Icons.sort, color: Colors.white, size: 16)),

                              ],
                            ),
                          ),
                          Obx(() {

                            return ListView.builder(

                              shrinkWrap: true,
                              itemCount: eventsController.events.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: EventTile(
                                    event: eventsController.events[index],
                                    onPressed: () {
                                      Get.to(() => EventSummaryScreen(event: eventsController.events[index],));
                                    },
                                  ),
                                );
                              },
                            );
                          }),

                        ]
                    ),
                  ),
                ),
               /* //challenges
                const MyChallengesScreen(),*/
                //notifications
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        children: [
                          const SizedBox(height: 20,),
                          ListView.builder(itemBuilder:  (context, index) {
                            return ListTile(
                              leading: const CircleAvatar(
                                backgroundColor: primaryColor,
                                child: Icon(LineIcons.bell, color: Colors.white),
                              ),
                              title: Text(_notificationData[index]['name']),
                              subtitle: Text(_notificationData[index]['description']),
                              trailing: Text(DateFormat('dd-MM-yyyy').format(_notificationData[index]['time'])),
                            );
                          },
                            itemCount: _notificationData.length,
                            shrinkWrap: true,
                          ),

                        ]
                    ),
                  ),
                ),



              ],
            ),
          )
        ],
      ),
    );
  }

  String getUserTabName(UserType value) {
    if(value == UserType.RIDER) {
      return 'My Skills';
    } else if(value == UserType.PROMOTER) {
      return 'My Customers';
    } else if(value == UserType.COACH) {
      return 'My Students';
    } else {
      return 'My Skills';
    }

  }

}
