import 'package:flutter/material.dart';
import 'package:log_my_ride/utils/constants.dart';

class SquareButton extends StatefulWidget {
  String label;
  IconData icon;
  Function onPressed;
  SquareButton({super.key, required this.label, required this.icon, required this.onPressed});

  @override
  State<SquareButton> createState() => _SquareButtonState();
}

class _SquareButtonState extends State<SquareButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      width: 200,
      height: 100,

      child: ElevatedButton.icon(

        icon: Icon(widget.icon, color: Colors.white,),
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        onPressed: () {
          widget.onPressed.call();
        }, label: Text(widget.label, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),),
      ),
    );
  }
}
