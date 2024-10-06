import 'package:flutter/material.dart';
import 'package:log_my_ride/views/screens/login_screen.dart';
import 'dart:async';

import 'package:log_my_ride/views/screens/rider_home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        _opacity = _opacity == 0.0 ? 1.0 : 0.0;
      });


      if (_opacity == 1.0) {
        timer.cancel();
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(milliseconds: 500),
          child: SizedBox(
              width: 150,
              height: 150,
              child: Image.asset('assets/images/lmr_logo.png')
          ), // Ensure the logo is in the assets folder
        ),
      ),
    );
  }
}