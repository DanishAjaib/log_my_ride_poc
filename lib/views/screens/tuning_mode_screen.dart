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

class _TuningModeScreenState extends State<TuningModeScreen> {

  var userController = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('${faker.lorem.sentence()} ${faker.lorem.sentence()} ${faker.lorem.sentence()}'),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              const Text('Select a Session'),
              const SizedBox(height: 5),
              DropdownButtonFormField(
                decoration:  InputDecoration( contentPadding: const EdgeInsets.symmetric(horizontal: 10), border: OutlineInputBorder( borderRadius: BorderRadius.circular(10), ), ),
                  items: const [
                DropdownMenuItem(value: 'Session 1', child: Text('Session 1')),
                DropdownMenuItem(value: 'Session 2', child: Text('Session 2')),
                DropdownMenuItem(value: 'Session 3', child: Text('Session 3')),
              ], onChanged: (value) {}),
              const SizedBox(height: 20),
              const Text('Select a tuner'),
              const SizedBox(height: 5),
              DropdownButtonFormField(
                  decoration:  InputDecoration( contentPadding: const EdgeInsets.symmetric(horizontal: 10), border: OutlineInputBorder( borderRadius: BorderRadius.circular(10), ), ),
                  items: const [
                    DropdownMenuItem(value: 'Tuner 1', child: Text('Tuner 1')),
                    DropdownMenuItem(value: 'Tuner 2', child: Text('Tuner 2')),
                    DropdownMenuItem(value: 'Tuner 3', child: Text('Tuner 3')),
                  ], onChanged: (value) {}),
              const SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(primaryColor),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text('Send'),
                    ),
                  ),
                ],
              )

            ],
          ),
        ),
      ),
    );
  }
}
