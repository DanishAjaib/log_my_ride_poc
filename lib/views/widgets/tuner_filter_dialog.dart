import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class TunerFilterDialog extends StatefulWidget {
  const TunerFilterDialog({super.key});

  @override
  State<TunerFilterDialog> createState() => _TunerFilterDialogState();
}

class _TunerFilterDialogState extends State<TunerFilterDialog> {

  RangeValues currentPriceRange = RangeValues(150, 250);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(

      actions: [
        //cancel
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        //apply
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Apply'),
        ),
      ],
      title: const Text('Filter'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //select location
          DropdownButtonFormField(
            decoration: const InputDecoration(
              labelText: 'Select Location',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                value: 'Location 1',
                child: Text('Location 1'),
              ),
              DropdownMenuItem(
                value: 'Location 2',
                child: Text('Location 2'),
              ),
              DropdownMenuItem(
                value: 'Location 3',
                child: Text('Location 3'),
              ),
            ],
            onChanged: (value) {},
          ),
          const SizedBox(height: 10,),
          //review score
          DropdownButtonFormField(
            decoration: const InputDecoration(
              labelText: 'Review Score',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                value: '1 Star',
                child: Text('1 Star'),
              ),
              DropdownMenuItem(
                value: '2 Stars',
                child: Text('2 Stars'),
              ),
              DropdownMenuItem(
                value: '3 Stars',
                child: Text('3 Stars'),
              ),
              DropdownMenuItem(
                value: '4 Stars',
                child: Text('4 Stars'),
              ),
              DropdownMenuItem(
                value: '5 Stars',
                child: Text('5 Stars'),
              ),
            ],
            onChanged: (value) {},
          ),
          //map count
          const SizedBox(height: 10,),
          DropdownButtonFormField(
            decoration: const InputDecoration(
              labelText: 'Map Count',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                value: '1-5',
                child: Text('1-5'),
              ),
              DropdownMenuItem(
                value: '6-10',
                child: Text('6-10'),
              ),
              DropdownMenuItem(
                value: '11-15',
                child: Text('11-15'),
              ),
              DropdownMenuItem(
                value: '16-20',
                child: Text('16-20'),
              ),
              DropdownMenuItem(
                value: '21-25',
                child: Text('21-25'),
              ),
              DropdownMenuItem(
                value: '26-30',
                child: Text('26-30'),
              ),
              DropdownMenuItem(
                value: '31-35',
                child: Text('31-35'),
              ),
              DropdownMenuItem(
                value: '36-40',
                child: Text('36-40'),
              ),
              DropdownMenuItem(
                value: '41-45',
                child: Text('41-45'),
              ),
              DropdownMenuItem(
                value: '46-50',
                child: Text('46-50'),
              ),
            ],
            onChanged: (value) {},
          ),
          //price range slider
          const SizedBox(height: 10,),
          const Text('Price Range'),
          const SizedBox(height: 3,),
          RangeSlider(
            activeColor: primaryColor,
            values: currentPriceRange,
            onChanged: (value) {
              setState(() {
                currentPriceRange = value;
              });
            },
            min: 0,
            max: 500,
            divisions: 10,
            labels: RangeLabels(
              '\$${currentPriceRange.start.round()}',
              '\$${currentPriceRange.end.round()}',
            ),
          ),
        ],

      ),
    );
  }
}
