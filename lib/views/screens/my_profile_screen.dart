import 'dart:math';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:log_my_ride/utils/constants.dart';
import 'package:log_my_ride/views/widgets/app_container.dart';
import 'package:log_my_ride/views/widgets/app_social.dart';
import 'package:multiavatar/multiavatar.dart';

import '../../controllers/user_controller.dart';
import '../widgets/rating_bar.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  bool _sortAscendingVehicles = true;
  int _sortColumnIndexVehicles = 0;

  bool _sortAscendingSensors = true;
  int _sortColumnIndexSensors = 0;

  bool _sortAscendingFriends = true;
  int _sortColumnIndexFriends = 0;

  final TextEditingController _vehicleSearchController = TextEditingController();
  final TextEditingController _sensorSearchController = TextEditingController();
  final TextEditingController _friendSearchController = TextEditingController();

  String _vehicleSearchQuery = '';
  String _sensorSearchQuery = '';
  String _friendSearchQuery = '';

  var userController = Get.find<UserController>();

  final List<Map<String, dynamic>> _vehicleData = [
    {
      'image': 'assets/images/bike_image.jpg',
      'type': 'Bajaj Pulsar 150',
      'year': '2012',
      'offset': '2012',
      'wheelSizeFront': '2012',
      'wheelSizeRear': '2012',
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

  final List<Map<String, dynamic>> _friendData = [
    {
      'name': 'John Doe',
      'location': faker.address.city(),
      'rating': 5.0,
    },
    {
      'name': 'Jane Smith',
      'location': faker.address.city(),
      'rating': 4.5,
    },
    {
      'name': 'Alice Johnson',
      'location': faker.address.city(),
      'rating': 3.5,
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
  Widget build(BuildContext context) {
    var svgCode = Uint8List.fromList(multiavatar('X-SLAYER').codeUnits);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_drop_down),
            onPressed: () {
              //show dropdown
              showMenu(context: context, position:  const RelativeRect.fromLTRB(double.infinity, 0, 0, 0), items: [
                const PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.settings),
                      SizedBox(width: 10),
                      Text('Settings'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app),
                      SizedBox(width: 10),
                      Text('Sign Out'),
                    ],
                  ),
                ),

              ]);
            },
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                Row(
                  children: [
                    const Text('MY VEHICLES', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                    const Spacer(),
                    TextButton.icon(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(primaryColor),
                        ),
                        onPressed: () {

                        }, label: const Text('Add New', style: TextStyle(color: Colors.white),),
                        icon: const Icon(Icons.add, color: Colors.white, size: 16)
                    )
                  ],
                ),
                const SizedBox(height: 10,),
                TextField(
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
                ),
                AppContainer(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: DataTable(
                    sortColumnIndex: _sortColumnIndexVehicles,
                    sortAscending: _sortAscendingVehicles,
                  dataRowMaxHeight: 75,

                    columns: [
                      const DataColumn(label: Text('Image')),
                      DataColumn(label: const Text('Type'), onSort: (columnIndex, ascending) => _sort<String>(_vehicleData, (d) => d['type'], columnIndex, ascending, _setVehicleSortState),
              ),
                      DataColumn(label: const Text('Year/Make/Model'), onSort: (columnIndex, ascending) => _sort<String>(_vehicleData, (d) => d['year'], columnIndex, ascending, _setVehicleSortState)),
                      DataColumn(label: const Text('Offset'), onSort: (columnIndex, ascending) => _sort<String>(_vehicleData, (d) => d['offset'], columnIndex, ascending, _setVehicleSortState)),
                      DataColumn(label: const Text('Wheel Size(Front)'), onSort: (columnIndex, ascending) => _sort<String>(_vehicleData, (d) => d['wheelSizeFront'], columnIndex, ascending, _setVehicleSortState)),
                      DataColumn(label: const Text('Wheel Size(Rear)'), onSort: (columnIndex, ascending) => _sort<String>(_vehicleData, (d) => d['wheelSizeRear'], columnIndex, ascending, _setVehicleSortState)),
                    ],
                    rows:  _filterData(_vehicleData, _vehicleSearchQuery).map((vehicle) {
                      return DataRow(
                        cells: [
                          DataCell(
                            CircleAvatar(
                              backgroundImage: AssetImage(vehicle['image']),
                            ),
                          ),
                          DataCell(Text(vehicle['type'])),
                          DataCell(Text(vehicle['year'])),
                          DataCell(Text(vehicle['offset'])),
                          DataCell(Text(vehicle['wheelSizeFront'])),
                          DataCell(Text(vehicle['wheelSizeRear'])),
                        ],
                      );
                    }).toList(),
                ),
              )
          ),
                /*AppContainer(
                  height: null,
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: primaryColor,
                          child: ClipOval(
                            child: Image.asset('assets/images/bike_image.jpg', width: 75, height: 85, fit: BoxFit.fill,),
                          ),
                        ),
                        title: Text(faker.vehicle.model()),
                        subtitle: Text(faker.vehicle.make() + ' - 2012'),
                      ),
                      Divider(
                        color: Colors.grey.withOpacity(0.1),
                        thickness: 1,
                      ),
                      ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: primaryColor,
                          child: ClipOval(
                            child: Image.asset('assets/images/bike_image_2.PNG', width: 75, height: 85, fit: BoxFit.fill,),
                          ),
                        ),
                        title: Text(faker.vehicle.model()),
                        subtitle: Text(faker.vehicle.make() + ' - 2018'),
                      ),
                      Divider(
                        color: Colors.grey.withOpacity(0.1),
                        thickness: 1,
                      ),
                      ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: primaryColor,
                          child: ClipOval(
                            child: Image.asset('assets/images/bike_image.jpg', width: 75, height: 85, fit: BoxFit.fill,),
                          ),
                        ),
                        title: Text(faker.vehicle.model()),
                        subtitle: Text(faker.vehicle.make() + ' - 2022'),
                      ),

                    ],
                  ),
                ),*/
                Row(
                  children: [
                    const Text('MY SENSORS', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                    const Spacer(),
                    TextButton.icon(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(primaryColor),
                        ),
                        onPressed: () {

                        }, label: const Text('Add New', style: TextStyle(color: Colors.white),),
                        icon: const Icon(Icons.add, color: Colors.white, size: 16)
                    )
                  ],
                ),
                const SizedBox(height: 10,),
                TextField(
                  controller: _sensorSearchController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    labelText: 'Search Sensors',
                    prefixIcon: const Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _sensorSearchQuery = value;
                    });
                  },
                ),

                AppContainer(
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
                ),
                const Row(
                  children: [
                    Text('MY SKILLS', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),

                  ],
                ),
                const SizedBox(height: 10,),
                AppContainer(
                  child: const Column(
                    children: [
                      ListTile(
                        title: Text('Total Sessions'),
                        subtitle: Text('5'),
                      ),
                      Divider(),
                      ListTile(
                        title: Text('Skill Level'),
                        subtitle: Text('Confirmed'),
                      ),
                      Divider(),
                      ListTile(
                        title: Text('Rider Ranking'),
                        subtitle: Text('Top 8%', style:  TextStyle(color: primaryColor, fontWeight: FontWeight.bold),),
                      ),
                    ],
                  ),
                ),

                Row(
                  children: [
                    const Text('MY FRIENDS', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                    const Spacer(),
                    TextButton.icon(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(primaryColor),
                        ),
                        onPressed: () {

                        }, label: const Text('Add New', style: TextStyle(color: Colors.white),),
                        icon: const Icon(Icons.add, color: Colors.white, size: 16)
                    )
                  ],
                ),
                const SizedBox(height: 10,),
                TextField(
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
                ),


               /* AppContainer(
                  height: null,
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: primaryColor,
                          child: ClipOval(
                            child: Image.asset('assets/images/sensor_1.jpg', width: 75, height: 85, fit: BoxFit.fill,),
                          ),
                        ),
                        title: const Text('Bajaj Pulsar 150'),
                        subtitle: const Text('MH 12 AB 1234'),
                      ),
                      Divider(
                        color: Colors.grey.withOpacity(0.1),
                        thickness: 1,
                      ),
                      ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: primaryColor,
                          child: ClipOval(
                            child: Image.asset('assets/images/sensor_2.PNG', width: 75, height: 85, fit: BoxFit.fill,),
                          ),
                        ),
                        title: const Text('Royal Enfield Classic 350'),
                        subtitle: const Text('MH 12 AB 1234'),
                      ),
                      Divider(
                        color: Colors.grey.withOpacity(0.1),
                        thickness: 1,
                      ),
                      ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: primaryColor,
                          child: ClipOval(
                            child: Image.asset('assets/images/sensor_3.jpg', width: 75, height: 85, fit: BoxFit.fill,),
                          ),
                        ),
                        title: const Text('Bajaj Pulsar 150'),
                        subtitle: const Text('MH 12 AB 1234'),
                      ),

                    ],
                  ),
                ),*/
                const SizedBox(height: 20,),
                const Divider(),
                const SizedBox(height: 20,),
                //a row of social media icons

                AppSocial()

              ],
            ),
          ),
        ),
      ),
    );
  }



}
