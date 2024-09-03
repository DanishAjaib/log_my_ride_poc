import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/router_report.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:log_my_ride/utils/constants.dart';
import 'package:multiavatar/multiavatar.dart';

getTitle(String text) {
  return Text(
    text,
    style: GoogleFonts.robotoFlex(
      color: Colors.white,
      fontSize: titleSize,
    ),
  );
}
getSubtitle(String text) {
  return Text(
    text,
    style: GoogleFonts.robotoFlex(
      color: Colors.white,
      fontSize: subTitleSize,
    ),
  );
}


getLogo(double size) {
  return SizedBox(
    width: size,
    height: size,
    child: Image.asset('assets/images/lmr_logo.png'),
  );
}

getFormField(String label, TextEditingController controller, bool obscureText) {
  return Container(
    height: 75,
    padding: const EdgeInsets.symmetric(horizontal: formFieldPadding, vertical: 10),
    child: TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: GoogleFonts.robotoFlex(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.robotoFlex(
          color: Colors.white,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(formFieldBorderRadius),
          borderSide: const BorderSide(
            color: Colors.grey,

          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(formFieldBorderRadius),
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
        ),
      ),
    ),
  );
}

Widget getActionButton(String text, Color color, Function onPressed, {IconData? leadingIcon, IconData? trailingIcon}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: ElevatedButton(
      onPressed: () {
        print('Button pressed');
        onPressed.call();
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(color),
        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 15)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(formFieldBorderRadius),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (leadingIcon != null) Icon(leadingIcon, color: color == Colors.white ? Colors.black : Colors.black),
          if (leadingIcon != null) const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.orbitron(
              color: color == Colors.white ? Colors.black : Colors.black,
            ),
          ),
          if (trailingIcon != null) const SizedBox(width: 8),
          if (trailingIcon != null) Icon(trailingIcon, color: color == Colors.white ? Colors.black : Colors.black),
        ],
      ),
    ),
  );
}

Widget getHorizontalDividerWithText(String text) {
  return Row(
    children: <Widget>[
      const Expanded(
        child: Divider(
          color: Colors.grey,
          thickness: 1,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          text,
          style: const TextStyle(color: Colors.grey),
        ),
      ),
      const Expanded(
        child: Divider(
          color: Colors.grey,
          thickness: 1,
        ),
      ),
    ],
  );
}

Uint8List getRandomSvgCode() {
  String randomString = _generateRandomString(8);
  return Uint8List.fromList(multiavatar(randomString).codeUnits);
}
String _generateRandomString(int length) {
  const characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final random = Random();
  return String.fromCharCodes(Iterable.generate(
    length,
        (_) => characters.codeUnitAt(random.nextInt(characters.length)),
  ));
}
getTruncatedEmailAddress(String truncatedEmail, int maxLength,) {

  if (truncatedEmail.length > maxLength) {
    truncatedEmail = truncatedEmail.substring(0, maxLength);
  }
  return Text(
    truncatedEmail,
    style: GoogleFonts.robotoFlex(
      color: primaryColor,
      fontSize: paragraphTextSize,
    ),
  );
}

getTruncatedText(String text, int maxLength) {
  if (text.length > maxLength) {
    text = text.substring(0, maxLength);
  }
  return text;
}
getChipText(String text, {double? textSize = 10, Color? bgColor = Colors.red}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(10),
    ),
    child:  Text(text, style: TextStyle(color: Colors.white, fontSize: textSize ?? 10, fontWeight: FontWeight.bold),),
  );
}
iconText(IconData icon, String text, Function onPressed) {
  if (text.length > 5) {
    text = text.substring(0, 5);
  }

  return Container(
    height: 30,
    margin: const EdgeInsets.only(right: 10),
    child: Row(
      children: [
        Icon(icon, color: Colors.black, size: 14),
        const SizedBox(width: 5),
        Text(
          text,
          style: GoogleFonts.robotoFlex(
            color: Colors.white,
            fontSize: 12,
          ),
        ),

      ],
    ),
  );
}


/*
TextButton.icon(
onPressed: () {
onPressed.call();
},
icon: Icon(icon, color: primaryColor, size: 14),
label: Text(
text,

style: GoogleFonts.robotoFlex(
color: primaryColor,
fontSize: 12,
),
),
),*/
