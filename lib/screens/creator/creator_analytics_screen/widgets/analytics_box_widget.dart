import 'package:flutter/widgets.dart';

import '../../../../constants/app_colors.dart';
import '../../../../utils/app_size.dart';
import '../../../../widgets/space_widget/space_widget.dart';
import '../../../../widgets/text_widget/text_widgets.dart';

class AnalyticsBoxWidget extends StatelessWidget {
  final String title;
  final String count;

  const AnalyticsBoxWidget({
    super.key,
    required this.title,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveUtils.initialize(context);
    return Container(
      width: ResponsiveUtils.height(160),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.blueNormal,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          TextWidget(
            text: title,
            fontColor: AppColors.grey50,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          const SpaceWidget(spaceHeight: 4),
          TextWidget(
            text: count,
            fontColor: AppColors.grey50,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ],
      ),
    );
  }
}
