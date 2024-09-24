import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/foundation.dart';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:log_my_ride/utils/constants.dart';
import 'package:multiavatar/multiavatar.dart';

import '../views/widgets/random_spline_chart.dart';

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

void drawRoadOnCanvas(Canvas canvas, Size size, List<GeoPoint> geoPoints, Rect mapBounds) {
  Paint paint = Paint()
    ..color = Colors.blue // Set the color of the road
    ..strokeWidth = 5.0
    ..style = PaintingStyle.stroke;

  Path path = Path();

  // Convert the first point and move the path to its location
  Offset firstPoint = geoToPixel(geoPoints[0], mapBounds, size);
  path.moveTo(firstPoint.dx, firstPoint.dy);

  // Draw lines between consecutive points
  for (int i = 1; i < geoPoints.length; i++) {
    Offset nextPoint = geoToPixel(geoPoints[i], mapBounds, size);
    path.lineTo(nextPoint.dx, nextPoint.dy);
  }

  // Draw the path on the canvas
  canvas.drawPath(path, paint);
}

Offset geoToPixel(GeoPoint geoPoint, Rect mapBounds, Size canvasSize) {
  // Latitude/Longitude bounds of the map view
  final double minLat = mapBounds.top;
  final double maxLat = mapBounds.bottom;
  final double minLon = mapBounds.left;
  final double maxLon = mapBounds.right;

  // Latitude and longitude of the point
  final double latitude = geoPoint.latitude;
  final double longitude = geoPoint.longitude;

  // Map latitude and longitude to x and y (canvas space)
  final double x = ((longitude - minLon) / (maxLon - minLon)) * canvasSize.width;
  final double y = ((latitude - minLat) / (maxLat - minLat)) * canvasSize.height;

  return Offset(x, y);
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

formatTimeOfDay(TimeOfDay? selectedTime) {
  //format : hh:mm a
  if(selectedTime != null) {
    if(selectedTime.hour > 12) {
      return '${(selectedTime.hour - 12 < 10 ? '0${selectedTime.hour - 12}' : selectedTime.hour - 12 )}:${selectedTime.minute < 10 ? '0${selectedTime.minute}' : selectedTime.minute } PM';
    } else {
      return '${selectedTime.hour}:${selectedTime.minute < 10 ? '0${selectedTime.minute}' : selectedTime.minute } AM';
    }
  } else {
    return 'Select Time';
  }
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

Future<String> captureAndStoreImage() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  if (pickedFile == null) {
    return '';
  }

  final appDir = await getApplicationDocumentsDirectory();
  final imagesDir = Directory('${appDir.path}/images');
  await imagesDir.create(recursive: true); // Ensure the directory exists

  final fileName = path.basename(pickedFile.path);
  final savedImage = await File(pickedFile.path).copy('${imagesDir.path}/$fileName');
  return savedImage.path;
}

getSkewedChipText(double skew, String text, {double? textSize = 10, Color? bgColor = Colors.red, Icon? icon, TextStyle? textStyle}) {
  return Transform(
    transform: Matrix4.skew( skew, 0.0 ),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.all(Radius.circular(5),),
      ),
      child:  Row(
        children: [
          Text(text, style: textStyle ?? TextStyle(color: Colors.white, fontSize: textSize ?? 10, fontWeight: FontWeight.bold),),
          if (icon != null) Icon(icon.icon, color: Colors.white, size: 10),
        ],
      ),
    ),
  );
}

getChipText(String text, {double? textSize = 10, Color? bgColor = Colors.red, Icon? icon, TextStyle? textStyle}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(10),
    ),
    child:  Row(
      children: [
        Text(text, style: textStyle ?? TextStyle(color: Colors.white, fontSize: textSize ?? 10, fontWeight: FontWeight.bold),),
        if (icon != null) Icon(icon.icon, color: Colors.white, size: 10),
      ],
    ),
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


List<SpeedData> generateTrackSectorIdealSpeedData() {
  List<SpeedData> data = [];
  List<double> speeds = [
    0, 20, 40, 55, 70, 85, 100, 105, 85, 70, 60, 55, 90, 100, 35, 50, 65, 80, 95, 100,
    90, 85, 75, 70, 65, 90, 100, 110, 95, 80, 70, 55, 40, 35, 30, 25, 20, 35, 50, 65,

  ];

  for (int i = 0; i < speeds.length; i++) {
    data.add(SpeedData('00:${i.toString().padLeft(2, '0')}', speeds[i]));
  }

  return data;
}

List<SpeedData> generateTrackSectorActualSpeeddata() {
  List<SpeedData> data = [];
  List<double> speeds = [
    0, 30, 45, 60, 77, 82, 100, 120, 95, 70, 75, 55, 93, 98, 40, 53, 73, 78, 71, 90,
    80, 75, 85, 65, 63, 80, 95, 99, 95, 80, 70, 55, 40, 35, 49, 30, 15, 20, 35, 75,

  ];

  for (int i = 0; i < speeds.length; i++) {
    data.add(SpeedData('00:${i.toString().padLeft(2, '0')}', speeds[i]));
  }

  return data;

}
List<SpeedData> generateLeanAngleData(int count) {
  List<SpeedData> data = [];
  List<double> leanAngles = [
    90, 91, 89, 88, 87, 92, 93, 85, 84, 83, 80, 78, 76, 74, 75, 78, 82, 85, 88, 90,
    91, 89, 87, 86, 85, 92, 94, 95, 90, 85, 82, 78, 74, 72, 70, 68, 65, 70, 75, 80,
    83, 86, 88, 90, 92, 89, 87, 85, 84, 90, 93, 95, 92, 89, 85, 80, 76, 72, 70, 67,
    64, 62, 60, 65, 70, 75, 80, 84, 88, 90, 92, 89, 87, 86, 84, 90, 93, 95, 90, 85,
    82, 79, 76, 72, 70, 68, 65, 70, 75, 80, 83, 86, 88, 90, 92, 89, 87, 85, 84, 90,
    90, 91, 89, 88, 87, 92, 93, 85, 84, 83, 80, 78, 76, 74, 75, 78, 82, 85, 88, 90,
    91, 89, 87, 86, 85, 92, 94, 95, 90, 85, 82, 78, 74, 72, 70, 68, 65, 70, 75, 80,
    83, 86, 88, 90, 92, 89, 87, 85, 84, 90, 93, 95, 92, 89, 85, 80, 76, 72, 70, 67,
    64, 62, 60, 65, 70, 75, 80, 84, 88, 90, 92, 89, 87, 86, 84, 90, 93, 95, 90, 85,
    82, 79, 76, 72, 70, 68, 65, 70, 75, 80, 83, 86, 88, 90, 92, 89, 87, 85, 84, 90,
    90, 91, 89, 88, 87, 92, 93, 85, 84, 83, 80, 78, 76, 74, 75, 78, 82, 85, 88, 90,
    91, 89, 87, 86, 85, 92, 94, 95, 90, 85, 82, 78, 74, 72, 70, 68, 65, 70, 75, 80,
    83, 86, 88, 90, 92, 89, 87, 85, 84, 90, 93, 95, 92, 89, 85, 80, 76, 72, 70, 67,
    64, 62, 60, 65, 70, 75, 80, 84, 88, 90, 92, 89, 87, 86, 84, 90, 93, 95, 90, 85,
    82, 79, 76, 72, 70, 68, 65, 70, 75, 80, 83, 86, 88, 90, 92, 89, 87, 85, 84, 90,
    65, 70, 75, 80, 83, 86, 88, 90, 92, 89, 87, 85, 84, 90,

  ];
  for (int i = 0; i < leanAngles.length; i++) {
    data.add(SpeedData('00:${i.toString().padLeft(2, '0')}', leanAngles[i]));
  }

  return data;
}
List<SpeedData> generateSpeedData(int count) {
  List<SpeedData> data = [];
  List<double> speeds = [
    0, 20, 40, 55, 70, 85, 100, 105, 85, 70, 60, 55, 90, 100, 35, 50, 65, 80, 95, 100,
    90, 85, 75, 70, 65, 90, 100, 110, 95, 80, 70, 55, 40, 35, 30, 25, 20, 35, 50, 65,
    80, 90, 95, 100, 105, 85, 70, 60, 55, 90, 100, 105, 90, 75, 60, 45, 35, 25, 20, 15,
    10, 5, 10, 25, 45, 60, 75, 85, 90, 95, 100, 85, 75, 70, 60, 90, 100, 110, 85, 70,
    60, 50, 40, 30, 25, 20, 15, 25, 40, 55, 70, 80, 90, 95, 100, 80, 70, 55, 40, 20, 10,
    0, 20, 40, 55, 70, 85, 100, 80, 70, 60, 50, 40, 35, 30, 35, 50, 65, 80, 95, 100,
    90, 85, 75, 70, 65, 90, 100, 110, 95, 80, 70, 55, 40, 35, 30, 25, 20, 35, 50, 65,
    80, 90, 95, 100, 105, 85, 70, 60, 55, 90, 100, 105, 90, 75, 60, 45, 35, 25, 20, 15,
    10, 5, 10, 25, 45, 60, 75, 85, 90, 95, 100, 85, 75, 70, 60, 90, 100, 110, 85, 70,
    60, 50, 40, 30, 25, 20, 15, 25, 40, 55, 70, 80, 90, 95, 100, 80, 70, 55, 40, 20, 10,
    0, 20, 40, 55, 70, 85, 100, 80, 70, 60, 50, 40, 35, 30, 35, 50, 65, 80, 95, 100,
    90, 85, 75, 70, 65, 90, 100, 110, 95, 80, 70, 55, 40, 35, 30, 25, 20, 35, 50, 65,
    80, 90, 95, 100, 105, 85, 70, 60, 55, 90, 100, 105, 90, 75, 60, 45, 35, 25, 20, 15,
    10, 5, 10, 25, 45, 60, 75, 85, 90, 95, 100, 85, 75, 70, 60, 90, 100, 110, 85, 70,
    60, 50, 40, 30, 25, 20, 15, 25, 40, 55, 70, 80, 90, 95, 100, 80, 70, 55, 40, 20, 10,
    25, 40, 55, 70, 80, 90, 95, 100, 80, 70, 55, 40, 20, 0
  ];
  for (int i = 0; i < speeds.length; i++) {
    data.add(SpeedData('00:${i.toString().padLeft(2, '0')}', speeds[i]));
  }

  return data;
}

List<SpeedData> generateRPMData(int count) {
  List<SpeedData> data = [];
  List<double> rpms = [
    0, 1000, 2000, 3000, 4000, 5000, 6000, 5000, 4000, 3000, 2000, 1000, 800, 600, 800, 1000, 2000, 3000, 4000, 5000,
    6000, 5000, 4000, 3000, 2000, 5000, 6000, 7000, 6000, 5000, 4000, 3000, 2000, 1000, 800, 600, 400, 200, 400, 600, 800,
    1000, 2000, 3000, 4000, 5000, 6000, 5000, 4000, 3000, 2000, 1000, 5000, 6000, 7000, 6000, 5000, 4000, 3000, 2000, 1000,
    800, 600, 400, 200, 100, 200, 400, 600, 800, 1000, 2000, 3000, 4000, 5000, 6000, 5000, 4000, 3000, 2000, 1000, 5000,
    6000, 7000, 6000, 5000, 4000, 3000, 2000, 1000, 800, 600, 400, 200, 100, 200, 400, 600, 800, 1000, 800, 500, 0,
    0, 1000, 2000, 3000, 4000, 5000, 6000, 5000, 4000, 3000, 2000, 1000, 800, 600, 800, 1000, 2000, 3000, 4000, 5000,
    6000, 5000, 4000, 3000, 2000, 5000, 6000, 7000, 6000, 5000, 4000, 3000, 2000, 1000, 800, 600, 400, 200, 400, 600, 800,
    1000, 2000, 3000, 4000, 5000, 6000, 5000, 4000, 3000, 2000, 1000, 5000, 6000, 7000, 6000, 5000, 4000, 3000, 2000, 1000,
    800, 600, 400, 200, 100, 200, 400, 600, 800, 1000, 2000, 3000, 4000, 5000, 6000, 5000, 4000, 3000, 2000, 1000, 5000,
    6000, 7000, 6000, 5000, 4000, 3000, 2000, 1000, 800, 600, 400, 200, 100, 200, 400, 600, 800, 1000, 800, 500, 0,
    0, 1000, 2000, 3000, 4000, 5000, 6000, 5000, 4000, 3000, 2000, 1000, 800, 600, 800, 1000, 2000, 3000, 4000, 5000,
    6000, 5000, 4000, 3000, 2000, 5000, 6000, 7000, 6000, 5000, 4000, 3000, 2000, 1000, 800, 600, 400, 200, 400, 600, 800,
    1000, 2000, 3000, 4000, 5000, 6000, 5000, 4000, 3000, 2000, 1000, 5000, 6000, 7000, 6000, 5000, 4000, 3000, 2000, 1000,
    800, 600, 400, 200, 100, 200, 400, 600, 800, 1000, 2000, 3000, 4000, 5000, 6000, 5000, 4000, 3000, 2000, 1000, 5000,
    6000, 7000, 6000, 5000, 4000, 3000, 2000, 1000, 800, 600, 400, 200, 100, 200, 400, 600, 800, 1000, 800, 500, 0,
    500, 800, 600, 400, 200, 100, 200, 400, 600, 800, 1000, 800, 500, 0,
  ];
  for (int i = 0; i < rpms.length; i++) {
    data.add(SpeedData('00:${i.toString().padLeft(2, '0')}', rpms[i]));


  }
  return data;
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
