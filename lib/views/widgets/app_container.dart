
import 'package:flutter/material.dart';

class AppContainer extends StatefulWidget {
  final Widget child;
  final Color? color;
  final double? height;
  final double? padding;

  const AppContainer({super.key, required this.child, this.color, this.height, this.padding});

  @override
  State<AppContainer> createState() => _AppContainerState();
}

class _AppContainerState extends State<AppContainer> {

  @override
  Widget build(BuildContext context) {

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      width: double.infinity,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Card(
        color: widget.color,
        child: widget.child,
      ),
    );
  }
}
