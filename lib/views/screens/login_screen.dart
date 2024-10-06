import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:log_my_ride/utils/utils.dart';
import 'package:log_my_ride/views/screens/main_screen.dart';
import 'package:log_my_ride/views/screens/rider_home_screen.dart';

import '../../controllers/user_controller.dart';

enum UserType {
  RIDER,
  PROMOTER,
  CLUB,
  COACH
}
class LoginScreen extends StatefulWidget {

  bool rememberMe = false;
  LoginScreen({super.key, this.rememberMe = false});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  Widget build(BuildContext context) {

    var userController = Get.put(UserController());
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 15,),
                  Text('LogMyRide', style: GoogleFonts.orbitron(fontSize: 25),),
                  const SizedBox(height: 15,),
                  getTitle('Login'),
                  getSubtitle('Please login to continue'),
                  const SizedBox(height: 20),
                  getFormField('Email', TextEditingController(), false),
                  getFormField('Password', TextEditingController(), true),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(50),

                          onTap: () {
                            setState(() {
                              widget.rememberMe = !widget.rememberMe;
                            });
                          },
                          child: Row(
                            children: [

                              Checkbox(value: widget.rememberMe, onChanged: (value) {
                                setState(() {
                                  widget.rememberMe = value!;
                                });
                              }),
                              const Text('Remember Me', style: TextStyle(color: Colors.white),),
                            ],
                          ),
                        ),
                        TextButton(onPressed: () {}, child: const Text('Forgot Password?', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),))

                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Divider(color: Colors.grey.withOpacity(0.3),),
                  const SizedBox(height: 20),
                  getActionButton('Login', Colors.orange, () {
                    userController.selectedUserType.value = UserType.RIDER;
                    Get.to(() => const MainScreen());
                  }),
                  const SizedBox(height: 10),
                  getActionButton('Promoter Login', Colors.white, () {
                    userController.selectedUserType.value = UserType.PROMOTER;
                    Get.to(() => const MainScreen());
                  }),
                  const SizedBox(height: 10),
                  getActionButton('Club Login', Colors.white, () {
                    userController.selectedUserType.value = UserType.CLUB;
                    Get.to(() => const MainScreen());
                  }),
                  const SizedBox(height: 10),
                  getActionButton('Coach Login', Colors.white, () {
                    userController.selectedUserType.value = UserType.COACH;
                    Get.to(() => const MainScreen());
                  }),
                  const SizedBox(height: 20),
                  getHorizontalDividerWithText('Or with'),
                  const SizedBox(height: 20),
                  getActionButton('Facebook', Colors.blue, () {}, leadingIcon: Icons.facebook),
                  const SizedBox(height: 10),
                  getActionButton('Google', Colors.red, () {}, leadingIcon: Icons.g_translate),
                  
            
                ],
              ),
            ),
          ),
        )
    );
  }
}
