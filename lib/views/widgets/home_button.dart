import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:log_my_ride/utils/constants.dart';

class HomeButton extends StatelessWidget {

  String iconText;
  List<Widget> column2Children;
  IconData? icon;
  String image;


  HomeButton({super.key, required this.iconText ,required this.column2Children, required this.icon, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 100,
      child: ElevatedButton(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 15)),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(formFieldBorderRadius),
            ),
          ),
        ),
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: primaryColor,
                      child: ClipOval(

                          child: Image.asset(image, width: 75, height: 85, fit: BoxFit.fill,)),

                    ),
                    //vertical divider
                    Container(
                      width: 1,
                      color: Colors.grey.withOpacity(0.3),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(width: 10),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: column2Children,
            ),
            icon != null ?
            SizedBox(
              child:Icon(icon, size: 50, color: Colors.black,),
            ) : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
