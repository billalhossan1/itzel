import 'package:flutter/material.dart';

class SpaceWidget extends StatelessWidget {
  final double spaceHeight;
  final double spaceWidth;

  const SpaceWidget({
    super.key,
    this.spaceHeight = 0.0,
    this.spaceWidth = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    if (spaceHeight != 0.0 && spaceWidth != 0.0) {
      return SizedBox(
        height: MediaQuery.sizeOf(context).height /
            (MediaQuery.sizeOf(context).height / spaceHeight),
        width: MediaQuery.sizeOf(context).width /
            (MediaQuery.sizeOf(context).width / spaceWidth),
      );
    } else if (spaceHeight != 0.0 && spaceWidth == 0.0) {
      return SizedBox(
        height: MediaQuery.sizeOf(context).height /
            (MediaQuery.sizeOf(context).height / spaceHeight),
      );
    } else if (spaceHeight == 0.0 && spaceWidth != 0.0) {
      return SizedBox(
        width: MediaQuery.sizeOf(context).width /
            (MediaQuery.sizeOf(context).width / spaceWidth),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
