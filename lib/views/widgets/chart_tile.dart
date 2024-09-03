import 'package:flutter/material.dart';

class ChartWidget extends StatefulWidget {

  String title;
  ChartWidget({super.key, required this.title});

  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180,
      child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Text(widget.title),
                    const Spacer(),
                    Text('00.00 Km/h')
                  ],
                ),
              ),

              const SizedBox(height: 30),
             ClipRRect(
               borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
               child: Container(
                  width: double.infinity,
                  height: 100,
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(10),
               
                 ),
                 child:  Image.asset('assets/images/bar_chart.png', fit: BoxFit.cover,),
               ),
             )
            ],
          )
      ),
    );
  }
}
