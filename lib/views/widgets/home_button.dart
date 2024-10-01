import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:log_my_ride/utils/constants.dart';

class HomeButton extends StatelessWidget {

  String iconText;
  List<Widget> column2Children;
  IconData? icon;
  String? image;
  double? height;


  HomeButton({super.key, required this.iconText ,required this.column2Children, required this.icon, this.image, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: height ?? 100,
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
            Spacer(),
            if(image != null)
              CircleAvatar(
                backgroundColor: primaryColor,
                child: ClipOval(
                    child: Image.asset(
                      image!,
                      width: 75,
                      height: 85,
                      fit: BoxFit.fill,
                    )
                ),
              ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
