
import 'package:flutter/material.dart';

class AppContainer extends StatefulWidget {
  final Widget child;
  final Color? color;
  final double? height;
  final double? width;
  final double? padding;
  final Color? borderColor;

  const AppContainer({super.key, required this.child, this.color, this.height, this.borderColor, this.width,  this.padding});

  @override
  State<AppContainer> createState() => _AppContainerState();
}

class _AppContainerState extends State<AppContainer> {

  @override
  Widget build(BuildContext context) {

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      width: widget.width ?? double.infinity,
      height: widget.height,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: widget.borderColor ?? Colors.transparent),

      ),
      child: Card(
        color: widget.color,
        child: widget.child,
      ),
    );
  }
}
