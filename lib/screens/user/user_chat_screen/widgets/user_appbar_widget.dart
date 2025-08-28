import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/app_icons_path.dart';
import '../../../../widgets/icon_button_widget/icon_button_widget.dart';
import '../../../../widgets/space_widget/space_widget.dart';
import '../../../../widgets/text_widget/text_widgets.dart';

class UserAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback onTitleTap;
  final VoidCallback onInfoTap;
  final VoidCallback onMoreTap;
  final String titleText;
  final String subTitleText;

  const UserAppBarWidget({
    super.key,
    required this.onTitleTap,
    required this.onInfoTap,
    required this.onMoreTap,
    required this.titleText,
    required this.subTitleText,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      flexibleSpace: Container(
        color: AppColors.whiteBg,
      ),
      titleSpacing: -1,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(
          Icons.arrow_back,
          color: AppColors.black500,
        ),
      ),
      title: InkWell(
        onTap: onTitleTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
              text: titleText,
              fontColor: AppColors.black500,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            TextWidget(
              text: subTitleText,
              fontColor: AppColors.grey900,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
      actions: [
        IconButtonWidget(
          onTap: onInfoTap,
          icon: AppIconsPath.infoIcon,
          size: 24,
          color: AppColors.black500,
        ),
        const SpaceWidget(spaceWidth: 8),
        IconButtonWidget(
          onTap: onMoreTap,
          icon: AppIconsPath.moreIcon,
          size: 24,
          color: AppColors.black500,
        ),
        const SpaceWidget(spaceWidth: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
