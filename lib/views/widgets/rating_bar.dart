import 'package:flutter/material.dart';
import 'package:log_my_ride/utils/constants.dart';

class RatingBar extends StatelessWidget {
  final int maxRating;
  final double iconSize;
  final Color filledColor;
  final Color unfilledColor;
  final double initialRating;
  final bool allowHalfRating;

  const RatingBar({
    Key? key,
    this.maxRating = 5,
    this.iconSize = 24.0,
    this.filledColor = primaryColor,
    this.unfilledColor = Colors.grey,
    required this.initialRating,
    this.allowHalfRating = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          initialRating.toString(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxRating, (index) {
        IconData icon;
        if (index < initialRating.floor()) {
          icon = Icons.star;
        } else if (allowHalfRating && index < initialRating) {
          icon = Icons.star_half;
        } else {
          icon = Icons.star_border;
        }
        return Icon(

          icon,
          color: index < initialRating ? filledColor : unfilledColor,
          size: iconSize,
        );
      }),
    )
      ],
    );
  }
}