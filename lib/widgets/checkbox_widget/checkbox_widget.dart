import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class CheckboxWidget extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final Color activeColor;
  final Color unselectedColor;
  final double scale;
  final BorderRadiusGeometry borderRadius;

  const CheckboxWidget({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor = AppColors.blue,
    this.unselectedColor = AppColors.grey700,
    this.scale = 0.9,
    this.borderRadius = const BorderRadius.all(Radius.circular(5)),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 12),
      child: Transform.scale(
        scale: scale,
        child: SizedBox(
          height: (MediaQuery.sizeOf(context).height /
              (MediaQuery.sizeOf(context).height / 12)),
          width: (MediaQuery.sizeOf(context).width /
              (MediaQuery.sizeOf(context).width / 12)),
          child: Theme(
            data: Theme.of(context).copyWith(
              unselectedWidgetColor: unselectedColor,
            ),
            child: Checkbox(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              activeColor: activeColor,
              checkColor: Colors.white,
              value: value,
              onChanged: onChanged,
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius,
                side: WidgetStateBorderSide.resolveWith(
                      (states) => const BorderSide(width: 0.5, color: AppColors.grey700),
                ),
              ),
              side:  const BorderSide(
                color: AppColors.grey700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
