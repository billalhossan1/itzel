import 'package:flutter/material.dart';

class ContainerWidget extends StatelessWidget {
  final double containerHeight;
  final double containerWidth;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color containerColor;
  final Alignment containerAlignment;
  final BorderRadius? borderRadius;
  final Widget child;

  const ContainerWidget({
    super.key,
    this.containerHeight = 50,
    this.containerWidth = 50,
    this.padding,
    this.margin,
    this.containerColor = Colors.transparent,
    this.containerAlignment = Alignment.center,
    this.borderRadius,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height /
          (MediaQuery.sizeOf(context).height / containerHeight),
      width: MediaQuery.sizeOf(context).width /
          (MediaQuery.sizeOf(context).width / containerWidth),
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: borderRadius,
      ),
      alignment: containerAlignment,
      child: child,
    );
  }
}
