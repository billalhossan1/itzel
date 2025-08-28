import 'package:flutter/material.dart';

import '../../../../constants/app_colors.dart';
import '../../../../widgets/space_widget/space_widget.dart';
import '../../../../widgets/text_widget/text_widgets.dart';

class ProfileInfoWidget extends StatelessWidget {
  final String label;
  final String value;

  const ProfileInfoWidget({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: size.width / (size.width / 4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size.width / (size.width / 125),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextWidget(
                text: label,
                fontColor: AppColors.black500,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                textAlignment: TextAlign.left,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const SpaceWidget(spaceWidth: 8),
          const TextWidget(
            text: ':',
            fontColor: AppColors.black500,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          const SpaceWidget(spaceWidth: 8),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextWidget(
                text: value,
                fontColor: AppColors.black500,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                textAlignment: TextAlign.left,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
