import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../../constants/app_colors.dart';

class AppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final Widget? action;
  final PreferredSizeWidget? bottom;

  const AppbarWidget({
    super.key,
    required this.text,
    this.action,
    this.bottom,
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
      actions: action != null ? [action!] : null,
      title: Text(
        text,
        style: TextStyle(
          fontSize: MediaQuery.sizeOf(context).width /
              (MediaQuery.sizeOf(context).width / 18),
          fontWeight: FontWeight.w500,
          color: AppColors.black500,
        ),
      ),
      bottom: bottom, // Add bottom to AppBar
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}
