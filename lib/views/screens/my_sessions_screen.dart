import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:log_my_ride/utils/constants.dart';
import 'package:log_my_ride/utils/track_curve.dart';
import 'package:log_my_ride/utils/utils.dart';
import 'package:log_my_ride/views/screens/session_summary_screen.dart';
import 'package:log_my_ride/views/widgets/app_container.dart';
import 'package:log_my_ride/views/widgets/session_title.dart';

import '../../controllers/user_controller.dart';

class MySessionsScreen extends StatefulWidget {
  const MySessionsScreen({super.key});

  @override
  State<MySessionsScreen> createState() => _MySessionsScreenState();
}

class _MySessionsScreenState extends State<MySessionsScreen> {

  final userController = Get.find<UserController>();

  bool _sortAscending = true;
  int _sortColumnIndex = 0;
  final TextEditingController _SearchController = TextEditingController();
  String searchQuery = '';

  final List<Map<String, dynamic>> sessions = [
    {
      'date': '2022/01/01',
      'time': '12:00',
      'duration': '1 hr 30 mins',
      'location': faker.address.city(),
      'type': 'Race',
      'rating': 4.5
    },
    {
      'date': '2022/01/01',
      'time': '12:00',
      'duration': '1 hr 30 mins',
      'location': faker.address.city(),
      'type': 'Practice',
      'rating': 5.0
    },
    {
      'date': '2022/01/01',
      'time': '12:00',
      'duration': '1 hr 30 mins',
      'location': faker.address.city(),
      'type': 'Race',
      'rating': 3.5
    },
    {
      'date': '2022/01/01',
      'time': '12:00',
      'duration': '1 hr 30 mins',
      'location': faker.address.city(),
      'type': 'Leisure',
      'rating': 4.5
    },

  ];

  void _setSortState(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });

  }

  void _onRowTap(Map<String, dynamic> session) {
    Get.to(() => const SessionSummaryScreen());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Sessions'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Last Session'),
              const SizedBox(height: 20),
              SessionTile(session: userController.sessions.first, onTap: () {

              }),
              const SizedBox(height: 20),
              const Text('All Sessions'),
              const SizedBox(height: 20),
              TextField(
                controller: _SearchController,
                decoration: InputDecoration(
                  labelText: 'Search Sessions',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
              AppContainer(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: DataTable(
                    showCheckboxColumn: false,
                      sortAscending: _sortAscending,
                      sortColumnIndex: _sortColumnIndex,
                      dataRowMaxHeight: 75,

                      columns: [
                        DataColumn(label: const Text('Date'), onSort: (columnIndex, ascending) => _sort<String>(sessions, (d) => d['date'], columnIndex, ascending, _setSortState)),
                        DataColumn(label: const Text('Time'), onSort: (columnIndex, ascending) => _sort<String>(sessions, (d) => d['time'], columnIndex, ascending, _setSortState)),
                        DataColumn(label: const Text('Duration'), onSort: (columnIndex, ascending) => _sort<String>(sessions, (d) => d['duration'], columnIndex, ascending, _setSortState)),
                        DataColumn(label: const Text('Location'), onSort: (columnIndex, ascending) => _sort<String>(sessions, (d) => d['location'], columnIndex, ascending, _setSortState)),
                        DataColumn(label: const Text('Type'), onSort: (columnIndex, ascending) => _sort<String>(sessions, (d) => d['type'], columnIndex, ascending, _setSortState)),
                        DataColumn(label: const Text('Rating'), onSort: (columnIndex, ascending) => _sort<String>(sessions, (d) => d['rating'].toString(), columnIndex, ascending, _setSortState)),
                      ],
                      rows: _filterData(sessions, searchQuery).map((session)  {
                        return DataRow(
                          onSelectChanged: (value) {
                            _onRowTap(session);
                          },

                          cells: [
                            DataCell(Text(session['date'])),
                            DataCell(Text(session['time'])),
                            DataCell(Text(session['duration'])),
                            DataCell(Text(session['location'])),
                            DataCell(Text(session['type'])),
                            DataCell(getChipText(session['rating'].toString(), textSize: 15, bgColor: primaryColor)),
                          ]
                        );
                      }).toList()
                  ),
                ),
              ),
             /* Expanded(
                  child: ListView.builder(
                    itemCount: userController.sessions.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        height: 100,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          onPressed: () {},
                          child: ListTile(
                            title: Text(faker.lorem.word()),
                            subtitle: Text(getSessionDuration(userController.sessions[index].session_start_time, userController.sessions[index].session_end_time)),
                            trailing: const Icon(Icons.arrow_forward_ios_outlined),
                          ),
                        ),
                      );
                    },
                  ),
                ),*/
            ],
          ),
        ),
      )
    );
  }
}

String getSessionDuration(int session_start_time, int session_end_time) {

  var duration = session_end_time - session_start_time;
  var minutes = (duration / 60).floor();
  var seconds = duration % 60;
  return '$minutes mins $seconds secs';
}
