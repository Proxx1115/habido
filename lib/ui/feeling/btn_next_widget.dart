import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';

class ButtonNextWidget extends StatelessWidget {
  final Function onTap;
  final bool isVisible;
  const ButtonNextWidget({Key? key, required this.onTap, this.isVisible = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isVisible
          ? () {
              onTap();
            }
          : null,
      child: Opacity(
        opacity: isVisible ? 1 : 0.6,
        child: Container(
          height: 67.0,
          width: 67.0,
          padding: EdgeInsets.all(47.0 / 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(67.0 / 2),
            color: customColors.primary,
          ),
          child: SvgPicture.asset(
            Assets.arrow_right,
            fit: BoxFit.contain,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
