import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconWidget extends StatelessWidget {
  final double height;
  final double width;

  final String icon;

  const IconWidget({
    super.key,
    required this.height,
    required this.width,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      icon,
      height: MediaQuery.sizeOf(context).width /
          (MediaQuery.sizeOf(context).width / height),
      width: MediaQuery.sizeOf(context).width /
          (MediaQuery.sizeOf(context).width / width),
      fit: BoxFit.cover,
    );
  }
}
