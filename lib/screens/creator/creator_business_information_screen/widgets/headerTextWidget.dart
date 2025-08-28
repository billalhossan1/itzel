import 'package:flutter/material.dart';

import '../../../../constants/app_colors.dart';
import '../../../../widgets/text_widget/text_widgets.dart';

class HeaderTextWidget extends StatelessWidget {
  final String text;

  const HeaderTextWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return TextWidget(
      text: text,
      fontColor: AppColors.black500,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );
  }
}
