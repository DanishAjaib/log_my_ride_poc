import 'package:flutter/material.dart';

class DummyMapContainer extends StatelessWidget {

  double width;
  double height;

  DummyMapContainer({Key? key, required this.width, required this.height}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: height,
      width: width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10)
      ) ,
      child: ClipRRect(
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(10),
          child: Image.asset('assets/images/track_mode_map.jpeg', fit: BoxFit.cover,)),
    );
  }
}

