import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconButtonWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String icon; // Path to the SVG asset
  final Color color;
  final double size;

  const IconButtonWidget({
    super.key,
    required this.onTap,
    required this.icon,
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      style: const ButtonStyle(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      icon: SvgPicture.asset(
        icon, // SVG asset path
        color: color,
        width: size,
        height: size,
      ),
    );
  }
}
