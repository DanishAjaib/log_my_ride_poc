import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:log_my_ride/firebase_options.dart';
import 'package:log_my_ride/views/screens/splash_screen.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

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
/*
        primarySwatch: Colors.deepOrange,
*/
        visualDensity: VisualDensity.adaptivePlatformDensity,
/*        colorSchemeSeed: const MaterialColor(0xffffd700, <int, Color>{
          50: Color(0xffffffe7),
          100: Color(0xfffeffc1),
          200: Color(0xfffffd86),
          300: Color(0xfffff441),
          400: Color(0xffffe60d),
          500: Color(0xffffd700),
          600: Color(0xffd19e00),
          700: Color(0xffa67102),
          800: Color(0xff89580a),
          900: Color(0xff74480f),
          950: Color(0xff442604),
        }),*/
        useMaterial3: true,

      ),
      home: const SplashScreen(),
    );
  }
}
