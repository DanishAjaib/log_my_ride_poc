import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class MetricContainer extends StatefulWidget {

  String value;
  IconData? icon;
  String? text;
  String? label;
  MetricContainer({super.key, required this.value, this.label, this.icon, this.text});

  @override
  State<MetricContainer> createState() => _MetricContainerState();
}

class _MetricContainerState extends State<MetricContainer> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      height: 130,
      child: Card(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.icon != null ? Icon(widget.icon, size: 35, color: primaryColor,) : (widget.text != null ? Text(widget.text!, style: const TextStyle(fontSize: 12, color: Colors.grey),) : Container()),
            const SizedBox(height: 10,),
            if(widget.label != null) Text(widget.label!, style: const TextStyle(fontSize: 12, color: Colors.grey),),
            Text(widget.value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
          ],
        ),
      ),
    );
  }
}
