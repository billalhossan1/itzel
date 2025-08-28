import 'package:flutter/material.dart';

class DividerWidget extends StatelessWidget {
  final double height;
  final double width;
  final Color color;

  const DividerWidget({
    super.key,
    required this.height,
    required this.width,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      color: color,
    );
  }
}
