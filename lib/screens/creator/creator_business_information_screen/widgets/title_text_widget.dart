import 'package:flutter/material.dart';

import '../../../../constants/app_colors.dart';
import '../../../../widgets/text_widget/text_widgets.dart';

class TitleTextWidget extends StatelessWidget {
  final String text;

  const TitleTextWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextWidget(
        text: text,
        fontColor: AppColors.grey900,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
