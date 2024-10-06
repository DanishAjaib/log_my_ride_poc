import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:log_my_ride/utils/constants.dart';

import '../../utils/utils.dart';

class TunerProfileScreen extends StatefulWidget {
  const TunerProfileScreen({super.key});

  @override
  State<TunerProfileScreen> createState() => _TunerProfileScreenState();
}

class _TunerProfileScreenState extends State<TunerProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tuner Profile'),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              child: SvgPicture.memory(getRandomSvgCode()),
            ),
            const SizedBox(height: 20),
            Text(faker.company.name(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            Text(faker.address.city(), style: const TextStyle(fontSize: 16),),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const Text('Rating', style: TextStyle(fontSize: 12, color: Colors.grey),),
                    Text(faker.randomGenerator.integer(5, min: 1).toString(), style: const TextStyle(fontSize: 14, color: primaryColor),),
                  ],
                ),
                const SizedBox(width: 10),
                const VerticalDivider(color: Colors.grey),
                const SizedBox(width: 10),
                Column(
                  children: [
                    const Text('Cost', style: TextStyle(fontSize: 12, color: Colors.grey),),
                    Text(' \$${faker.randomGenerator.integer(100, min: 1)} - \$${faker.randomGenerator.integer(500, min: 100)}', style: const TextStyle(fontSize: 14, color: primaryColor),),
                  ],
                ),
                const SizedBox(width: 10),
                const VerticalDivider(color: Colors.red, thickness: 5,),
                const SizedBox(width: 10),
                Column(
                  children: [
                    const Text('Maps', style: TextStyle(fontSize: 12, color: Colors.grey),),
                    Text(faker.randomGenerator.integer(50, min: 1).toString(), style: const TextStyle(fontSize: 14, color: primaryColor),),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(faker.lorem.sentences(4).join(' '), style: const TextStyle(fontSize: 12,  color: primaryColor, fontStyle: FontStyle.italic), textAlign: TextAlign.center, )),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(primaryColor),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              onPressed: (){},
              child: const Text('Purchase' , style: TextStyle(color: Colors.black),),
            ),
            const SizedBox(height: 10),
            //list of active licenses
           const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
             child: Align(
                alignment: Alignment.centerLeft,
               child:  Text('Active Licenses',),
             ),
           ),
            const SizedBox(height: 10),
            //list of active licenses
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      onPressed: () {  },
                      child: ListTile(

                        leading: CircleAvatar(
                          backgroundColor: primaryColor,
                          child: SvgPicture.memory(getRandomSvgCode()),
                        ),
                        title: Text(faker.vehicle.model(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5,),
                            Row(
                              children: [
                                const Icon(Icons.map_outlined, size: 16, color: primaryColor,),
                                const SizedBox(width: 3),
                                Text(getTruncatedText(faker.vehicle.model(), 10), style: const TextStyle(fontSize: 12),),
                                const SizedBox(width: 8),
                                const Icon(LineIcons.calendarAlt, size: 16, color: primaryColor,),
                                const SizedBox(width: 3),
                                Text(DateFormat.yMMMd().format(faker.date.dateTime(minYear: 2022, maxYear: 2022)), style: const TextStyle(fontSize: 12),),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}
