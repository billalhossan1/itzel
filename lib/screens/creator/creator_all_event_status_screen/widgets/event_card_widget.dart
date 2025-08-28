import 'package:flutter/material.dart';

import '../../../../constants/app_colors.dart';

class EventCardWidget extends StatelessWidget {
  final Widget child;

  const EventCardWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: EdgeInsets.only(
        left: size.width / (size.width / 20),
        right: size.width / (size.width / 20),
        bottom: size.width / (size.width / 12),
      ),
      decoration: BoxDecoration(
        color: AppColors.blueNormal,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: AppColors.grey200,
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: child,
    );
  }
}
