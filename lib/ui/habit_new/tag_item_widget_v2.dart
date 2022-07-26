import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/text.dart';

class TagItemWidgetV2 extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? text;
  final EdgeInsets margin;
  final Color? color;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? fontSize;
  final String? asset;
  TagItemWidgetV2({
    Key? key,
    this.text,
    this.margin = EdgeInsets.zero,
    this.color,
    this.width,
    this.height,
    this.fontSize,
    this.asset,
    this.onPressed,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width != null ? width : null,
      height: height != null ? height : null,
      margin: margin,
      padding: width == null && height == null ? EdgeInsets.symmetric(horizontal: 12.0, vertical: 3) : EdgeInsets.all(0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: color == null ? customColors.primaryButtonDisabledContent : color,
      ),
      child: InkWell(
        onTap: onPressed,
        child: text != null
            ? CustomText(
                text,
                fontSize: fontSize == null ? 8.0 : fontSize,
                fontWeight: FontWeight.w500,
                color: textColor ?? customColors.whiteText,
                alignment: Alignment.center,
              )
            : Container(
                padding: EdgeInsets.all(5),
                child: SvgPicture.asset(
                  asset!,
                  color: ConstantColors.blackIcon,
                ),
              ),
      ),
    );
  }
}
