import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconButtonWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String icon;

  const IconButtonWidget({
    super.key,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: MediaQuery.sizeOf(context).width /
            (MediaQuery.sizeOf(context).width / 44),
        width: MediaQuery.sizeOf(context).width /
            (MediaQuery.sizeOf(context).width / 44),
        padding: EdgeInsets.all(
          MediaQuery.sizeOf(context).width /
              (MediaQuery.sizeOf(context).width / 12),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              spreadRadius: 1,
              blurRadius: 3,
            ),
          ],
        ),
        child: SvgPicture.asset(
          icon,
          height: MediaQuery.sizeOf(context).width /
              (MediaQuery.sizeOf(context).width / 24),
          width: MediaQuery.sizeOf(context).width /
              (MediaQuery.sizeOf(context).width / 24),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
