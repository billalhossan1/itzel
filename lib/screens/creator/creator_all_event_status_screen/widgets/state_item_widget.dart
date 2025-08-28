import 'package:flutter/material.dart';

import '../../../../constants/app_colors.dart';
import '../../../../widgets/space_widget/space_widget.dart';
import '../../../../widgets/text_widget/text_widgets.dart';

class StatItemWidget extends StatelessWidget {
  final String title;
  final String value;

  const StatItemWidget({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextWidget(
          text: title,
          fontColor: AppColors.black900,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        const SpaceWidget(spaceHeight: 8),
        TextWidget(
          text: value,
          fontColor: AppColors.black900,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }
}
