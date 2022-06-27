import 'package:flutter/material.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';

class IndicatorItem extends StatelessWidget {
  final int? index;
  final int? currentIndex;
  const IndicatorItem({Key? key, this.index, this.currentIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6.0,
      width: 6.0,
      margin: EdgeInsets.symmetric(horizontal: 3.5),
      decoration: (index == null)
          ? null
          : BoxDecoration(
              // shape: BoxShape.circle,
              color: currentIndex == index ? customColors.primary : customColors.primaryButtonDisabledContent,
              borderRadius: BorderRadius.all(Radius.circular(6.0 / 2)),
            ),
    );
  }
}
