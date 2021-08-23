import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/text.dart';
import 'containers.dart';

enum CustomButtonStyle {
  Primary,
  Secondary, // Зүүн дээд өнцөг нь шовх
  Mini, // Үндсэн button-с арай жижиг хэмжээтэй
}

// ignore: non_constant_identifier_names
Widget CustomButton({
  CustomButtonStyle? style = CustomButtonStyle.Primary,
  VoidCallback? onPressed,
  bool visible = true,
  BorderRadius? borderRadius,
  EdgeInsets? margin = EdgeInsets.zero,
  Alignment? alignment,
  double? width,
  Color? backgroundColor,
  Color? disabledBackgroundColor,
  String? text,
  String? asset,
  Color? textColor, // text, asset color
  Color? disabledTextColor,
}) {
  // Width, alignment
  switch (style) {
    case CustomButtonStyle.Secondary:
      width = width ?? 155.0;
      alignment = alignment ?? Alignment.centerRight;
      borderRadius = borderRadius ??
          BorderRadius.only(
            topLeft: Radius.circular(5.0),
            topRight: Radius.circular(15.0),
            bottomRight: Radius.circular(15.0),
            bottomLeft: Radius.circular(15.0),
          );
      break;

    case CustomButtonStyle.Mini:
      width = width ?? 135.0;
      alignment = alignment ?? Alignment.center;
      break;

    case CustomButtonStyle.Primary:
    default:
      width = width ?? double.infinity;
      alignment = alignment ?? Alignment.center;
  }

  // Background color
  backgroundColor = backgroundColor ?? customColors.primaryButtonBackground;
  disabledBackgroundColor = disabledBackgroundColor ?? customColors.primaryButtonDisabledBackground;

  // Text, asset color
  textColor = textColor ?? customColors.primaryButtonContent;
  disabledTextColor = disabledTextColor ?? customColors.primaryButtonDisabledContent;

  // Text or Asset
  Widget _child = Container();
  if (text != null) {
    _child = Text(text);
  } else if (asset != null) {
    _child = SvgPicture.asset(asset, color: onPressed != null ? textColor : disabledTextColor);
  }

  return Align(
    alignment: alignment,
    child: Visibility(
      visible: visible,
      child: Container(
        margin: margin,
        width: width,
        height: SizeHelper.boxHeight,
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            backgroundColor: onPressed != null ? backgroundColor : disabledBackgroundColor,
            primary: onPressed != null ? textColor : disabledTextColor,
            textStyle: TextStyle(fontWeight: FontWeight.w500),
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(10.0),
              side: BorderSide.none,
            ),
          ),
          child: _child,
        ),
      ),
    ),
  );
}

enum ButtonStadiumStyle {
  Primary, // Icon-той, white
  Secondary, // Зүүн дээд өнцөг нь шовх, primary color
}

// Icon-той, stadium хэлбэртэй
class ButtonStadium extends StatelessWidget {
  final ButtonStadiumStyle style;
  final String asset;
  final VoidCallback onPressed;
  final EdgeInsets margin;
  final double? size;
  final double? borderRadius;
  final bool visibleBorder;
  final Color? backgroundColor;
  final Color? iconColor;

  const ButtonStadium({
    Key? key,
    this.style = ButtonStadiumStyle.Primary,
    required this.asset,
    required this.onPressed,
    this.margin = EdgeInsets.zero,
    this.size,
    this.borderRadius,
    this.visibleBorder = false,
    this.backgroundColor,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: InkWell(
        borderRadius: _getBorderRadius(),
        child: Container(
          height: size ?? _getSize(),
          width: size ?? _getSize(),
          decoration: BoxDecoration(
            borderRadius: _getBorderRadius(),
            border: visibleBorder ? Border.all(width: SizeHelper.borderWidth, color: customColors.primaryBorder) : null,
            color: backgroundColor ?? _getBackgroundColor(),
          ),
          child: SvgPicture.asset(asset, fit: BoxFit.scaleDown, color: iconColor ?? _getContentColor()),
        ),
        onTap: () {
          onPressed();
        },
      ),
    );
  }

  double _getSize() {
    switch (style) {
      case ButtonStadiumStyle.Secondary:
        return 55.0;

      case ButtonStadiumStyle.Primary:
        return 40.0;
    }
  }

  BorderRadius _getBorderRadius() {
    if (borderRadius != null) return BorderRadius.circular(borderRadius!);

    switch (style) {
      case ButtonStadiumStyle.Primary:
        return BorderRadius.circular(10.0);

      case ButtonStadiumStyle.Secondary:
        return BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(25.0),
          bottomRight: Radius.circular(25.0),
          bottomLeft: Radius.circular(25.0),
        );
    }
  }

  Color _getBackgroundColor() {
    switch (style) {
      case ButtonStadiumStyle.Primary:
        return customColors.secondaryBackground;

      case ButtonStadiumStyle.Secondary:
        return customColors.primaryButtonBackground;
    }
  }

  Color _getContentColor() {
    switch (style) {
      case ButtonStadiumStyle.Primary:
        return customColors.iconGrey;

      case ButtonStadiumStyle.Secondary:
        return customColors.primaryButtonContent;
    }
  }
}

class ButtonText extends StatelessWidget {
  const ButtonText({
    Key? key,
    required this.text,
    required this.onPressed,
    this.fontWeight = FontWeight.normal,
    this.color,
    this.fontSize = SizeHelper.fontSizeNormal,
    this.alignment = Alignment.center,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  final String text;
  final VoidCallback onPressed;
  final FontWeight fontWeight;
  final Color? color;
  final double fontSize;
  final Alignment alignment;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return NoSplashContainer(
      child: InkWell(
        onTap: () {
          onPressed();
        },
        child: CustomText(
          text,
          padding: padding,
          color: color ?? customColors.primaryText,
          fontWeight: fontWeight,
          fontSize: fontSize,
          alignment: alignment,
          maxLines: 10,
        ),
      ),
    );
  }
}

// Текст нь 2 хэсгээс бүрдсэн
class ButtonMultiPartText extends StatelessWidget {
  const ButtonMultiPartText({
    Key? key,
    required this.text1,
    required this.text2,
    required this.onPressed,
    this.padding = EdgeInsets.zero,
    this.backgroundColor,
    this.fontWeight1 = FontWeight.normal,
    this.fontWeight2 = FontWeight.w500,
    this.textColor,
    this.fontSize = 13.0,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.alignment = Alignment.center,
  }) : super(key: key);

  final String text1;
  final String text2;
  final VoidCallback onPressed;
  final EdgeInsets padding;
  final Color? backgroundColor;
  final FontWeight fontWeight1;
  final FontWeight fontWeight2;
  final Color? textColor;
  final double fontSize;
  final MainAxisAlignment mainAxisAlignment;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return NoSplashContainer(
      child: InkWell(
        onTap: () {
          onPressed();
        },
        child: Container(
          padding: padding,
          color: backgroundColor ?? Colors.transparent,
          child: Row(
            mainAxisAlignment: mainAxisAlignment,
            children: [
              /// Text1
              CustomText(
                text1,
                color: textColor ?? customColors.primaryText,
                fontWeight: fontWeight1,
                fontSize: fontSize,
                alignment: alignment,
              ),

              MarginHorizontal(width: 5.0),

              /// Text2
              CustomText(
                text2,
                color: textColor ?? customColors.primaryText,
                fontWeight: fontWeight2,
                fontSize: fontSize,
                alignment: alignment,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
