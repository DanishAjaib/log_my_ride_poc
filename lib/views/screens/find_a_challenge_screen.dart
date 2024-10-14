import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:log_my_ride/views/widgets/dummy_map_container.dart';

import '../../utils/constants.dart';
import '../../utils/utils.dart';

class FindAChallengeScreen extends StatefulWidget {
  const FindAChallengeScreen({super.key});

  @override
  State<FindAChallengeScreen> createState() => _FindAChallengeScreenState();
}

class _FindAChallengeScreenState extends State<FindAChallengeScreen>  with SingleTickerProviderStateMixin {

  late TabController tabController;
  var feedPosts = [
    {
      'user': faker.person.name(),
      'challengeType': 'Max Lean Angle',
      'venue' : 'Venue',
      'likes': faker.randomGenerator.integer(100),
      'comments': faker.randomGenerator.integer(100),
      'shares': faker.randomGenerator.integer(100),
      'text': faker.lorem.sentences(3).join(' '),
      'date': DateFormat.yMMMd().format(faker.date.dateTime(minYear: 2024)),
      'images': [
        'assets/images/wallpaper1.jpg',
        'assets/images/wallpaper2.jpg',
        'assets/images/wallpaper3.jpg',
      ],
      'type': 'Time Trial'
    },
    {
      'user': faker.person.name(),
      'challengeType': 'Max Lean Angle',
      'venue' : 'Venue',
      'likes': faker.randomGenerator.integer(100),
      'comments': faker.randomGenerator.integer(100),
      'shares': faker.randomGenerator.integer(100),
      'text': faker.lorem.sentences(3).join(' '),
      'date': DateFormat.yMMMd().format(faker.date.dateTime(minYear: 2024)),
      'images': [
        'assets/images/wallpaper1.jpg',
        'assets/images/wallpaper2.jpg',
        'assets/images/wallpaper3.jpg',
      ],
      'type': 'Max Lean Angle'
    },
    {
      'user': faker.person.name(),
      'challengeType': 'Max Lean Angle',
      'venue' : 'Venue',
      'likes': faker.randomGenerator.integer(100),
      'comments': faker.randomGenerator.integer(100),
      'shares': faker.randomGenerator.integer(100),
      'text': faker.lorem.sentences(3).join(' '),
      'date': DateFormat.yMMMd().format(faker.date.dateTime(minYear: 2024)),
      'images': [
        'assets/images/wallpaper1.jpg',
        'assets/images/wallpaper2.jpg',
        'assets/images/wallpaper3.jpg',
      ],
      'type': 'Average Speed'
    },
    {
      'user':   faker.person.name(),
      'challengeType': 'Max Lean Angle',
      'venue' : 'Venue',
      'likes': faker.randomGenerator.integer(100),
      'comments': faker.randomGenerator.integer(100),
      'shares': faker.randomGenerator.integer(100),
      'text': faker.lorem.sentences(3).join(' '),
      'date': DateFormat.yMMMd().format(faker.date.dateTime(minYear: 2024)),
      'images': [
        'assets/images/wallpaper1.jpg',
        'assets/images/wallpaper2.jpg',
        'assets/images/wallpaper3.jpg',
      ],
      'type': 'Time Trial'
    },
    {
      'user': faker.person.name(),
      'challengeType': 'Average Speed',
      'venue': 'Venue',
      'likes': faker.randomGenerator.integer(100),
      'comments': faker.randomGenerator.integer(100),
      'shares': faker.randomGenerator.integer(100),
      'text': faker.lorem.sentences(3).join(' '),
      'images': [
        'assets/images/wallpaper1.jpg',
        'assets/images/wallpaper2.jpg',
        'assets/images/wallpaper3.jpg',
      ],
      'date': DateFormat.yMMMd().format(faker.date.dateTime(minYear: 2024)),
      'type': 'Time Trial'

    }
  ];

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find a Challenge'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TabBar(
              dividerColor: primaryColor,
              dividerHeight: 2,
              splashBorderRadius: BorderRadius.only( topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              indicatorWeight: 10,
              indicatorSize: TabBarIndicatorSize.label,
              isScrollable: true,
              indicatorColor: primaryColor,
              labelColor: primaryColor,
              controller: tabController,
              tabs: const [
                Tab(icon:  Icon(Icons.search),),
                Tab(icon:  Icon(Icons.people),),
              ],
              onTap: (index) {
                //change challenge type
              },
            ),
            const SizedBox(height: 10,),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  //browse
                  Column(
                    children: [
                      //recent challenges
                      const Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Recent Challenges')),
                      const SizedBox(height: 10,),
                      Expanded(
                        child: ListView.builder(
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom:8.0),
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                    shape: WidgetStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: primaryColor,
                                      child: SvgPicture.memory(getRandomSvgCode()),
                                    ),
                                    title: Text('Challenge $index'),
                                    subtitle: const Text('Details'),
                                    trailing: const Text('Join'),
                                  )),
                            );
                          },
                        ),
                      ),
                    
              
              
              
                    ],
                  ),
                  //community
                  Column(
                    children: [

                      const SizedBox(height: 10,),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            itemCount: feedPosts.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom:8.0),
                                child: Column(
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
                                            Text(faker.person.name()),
                                           Row(
                                             children: [
                                               Text(feedPosts[index]['type'].toString(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                                const SizedBox(width: 5,),
                                               Text(feedPosts[index]['date'].toString(), style: const TextStyle(color: Colors.grey),),
                                             ],
                                           )
                                          ],
                                        ),
                                        const Spacer(),
                                      ],
                                    ),
                                    const SizedBox(height: 20,),
                                    Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          children: [
                                            Text(faker.lorem.sentences(3).join(' ')),
                                            const SizedBox(height: 12,),
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              physics: const BouncingScrollPhysics(),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 150,
                                                    height: 150,

                                                    decoration: BoxDecoration(

                                                      color: primaryColor,
                                                      borderRadius: BorderRadius.circular(5)
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(5),
                                                      child: Image.asset('assets/images/wallpaper1.jpg', fit: BoxFit.cover,),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5,),
                                                  Container(
                                                    width: 150,
                                                    height: 150,

                                                    decoration: BoxDecoration(

                                                        color: primaryColor,
                                                        borderRadius: BorderRadius.circular(5)
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(5),
                                                      child: Image.asset('assets/images/wallpaper2.jpg', fit: BoxFit.cover,),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5,),
                                                  Container(
                                                    width: 150,
                                                    height: 150,
                                                    decoration: BoxDecoration(
                                                        color: primaryColor,
                                                        borderRadius: BorderRadius.circular(5)
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(5),
                                                      child: Image.asset('assets/images/wallpaper3.jpg', fit: BoxFit.cover,),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5,),
                                                  DummyMapContainer(width: 150, height: 150)
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),

                                    ),
                                    const SizedBox(height: 2,),
                                    Card(
                                      color: Theme.of(context).scaffoldBackgroundColor,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          TextButton.icon(
                                            onPressed: () {

                                            },
                                            label: Text(feedPosts[index]['likes'].toString()),
                                            icon: const Icon(LineIcons.heartAlt, color: primaryColor,),
                                          ),
                                          TextButton.icon(
                                            onPressed: () {},
                                            label: Text(feedPosts[index]['comments'].toString()),
                                            icon: const Icon(LineIcons.comment, color: primaryColor,),
                                          ),

                                          TextButton.icon(
                                            onPressed: () {},
                                            label: Text(feedPosts[index]['shares'].toString()),
                                            icon: const Icon(LineIcons.share, color: primaryColor,),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 20,),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
