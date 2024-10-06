import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:log_my_ride/firebase_options.dart';
import 'package:log_my_ride/utils/constants.dart';
import 'package:log_my_ride/views/screens/splash_screen.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(


      title: 'Log(My)Ride',
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'RobotoFlex',
        primarySwatch: Colors.deepOrange,

        inputDecorationTheme: const InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
            borderRadius: BorderRadius.all(Radius.circular(10))
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),

            borderRadius: BorderRadius.all(Radius.circular(10))
          )
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
