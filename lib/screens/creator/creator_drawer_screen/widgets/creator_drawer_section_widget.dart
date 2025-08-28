import 'package:flutter/material.dart';

import '../../../../constants/app_colors.dart';
import '../../../../widgets/icon_widget/icon_widget.dart';
import '../../../../widgets/space_widget/space_widget.dart';
import '../../../../widgets/text_widget/text_widgets.dart';

class CreatorDrawerSectionWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String icon;
  final String text;

  const CreatorDrawerSectionWidget({
    super.key,
    required this.onTap,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(13),
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: AppColors.grey100,
              spreadRadius: 1,
              blurRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconWidget(
                  icon: icon,
                  height: 24,
                  width: 24,
                ),
                const SpaceWidget(spaceWidth: 8),
                TextWidget(
                  text: text,
                  fontColor: AppColors.black500,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 20,
              color: AppColors.black500,
            ),
          ],
        ),
      ),
    );
  }
}
