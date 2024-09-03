import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class MetricContainer extends StatefulWidget {

  String value;
  IconData icon;
  String? label;
  MetricContainer({super.key, required this.value, this.label, required this.icon});

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
            Icon(widget.icon, size: 35, color: primaryColor,),
            const SizedBox(height: 10,),
            if(widget.label != null) Text(widget.label!, style: const TextStyle(fontSize: 12, color: Colors.grey),),
            Text(widget.value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
          ],
        ),
      ),
    );
  }
}
