import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class AppSocial extends StatelessWidget {
  const AppSocial({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(

                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(const Color(0xFF395693)),
                ),
                onPressed: () {

                }, label: const Text('Facebook', style: TextStyle(color: Colors.white),),
                icon: const Icon(Icons.facebook, color:  Colors.white, size: 16)
            ),
            //twitter
            TextButton.icon(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(const Color(0xFF1DA1F2)),
                ),
                onPressed: () {

                }, label: const Text('Twitter', style: TextStyle(color: Colors.white),),
                icon: const Icon(LineIcons.twitter, color:  Colors.white, size: 16)
            ),
            //instagram
            TextButton.icon(

                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(const Color(0xFFC13584)),
                ),
                onPressed: () {

                }, label: const Text('Facebook', style: TextStyle(color: Colors.white),),
                icon: const Icon(LineIcons.instagram, color:  Colors.white, size: 16)
            )
          ],
        ),
        const SizedBox(height: 20,),
        const Align(
            alignment: Alignment.center,
            child: Text('© 2022 Motorcycle App. All rights reserved.', style: TextStyle(color: Colors.grey),)),
        const SizedBox(height: 50,),
      ],
    );
  }
}
