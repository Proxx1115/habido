import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/text.dart';
import 'containers/containers.dart';

enum CustomButtonStyle {
  Primary,
  Secondary, // Зүүн дээд өнцөг нь шовх
  Mini, // Үндсэн button-с арай жижиг хэмжээтэй
}

class CustomButton extends StatelessWidget {
  final CustomButtonStyle? style;

  final VoidCallback? onPressed;
  final bool visible;
  final BorderRadius? borderRadius;
  final EdgeInsets? margin;
  final Alignment? alignment;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? disabledBackgroundColor;
  final String? text;
  final FontWeight? fontWeight;
  final String? asset;
  final Color? contentColor;
  final Color? disabledContentColor; // Text, image and so on...

  const CustomButton({
    Key? key,
    this.style = CustomButtonStyle.Primary,
    this.onPressed,
    this.visible = true,
    this.borderRadius,
    this.margin = EdgeInsets.zero,
    this.alignment,
    this.width,
    this.height,
    this.backgroundColor,
    this.disabledBackgroundColor,
    this.text,
    this.fontWeight,
    this.asset,
    this.contentColor,
    this.disabledContentColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: _alignment,
      child: Visibility(
        visible: visible,
        child: Container(
          margin: margin,
          width: _width,
          height: _height,
          child: TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
              backgroundColor: onPressed != null ? _backgroundColor : _disabledBackgroundColor,
              primary: onPressed != null ? _contentColor : _disabledContentColor,
              textStyle: TextStyle(fontWeight: FontWeight.w500),
              shape: RoundedRectangleBorder(
                borderRadius: _borderRadius,
                side: BorderSide.none,
              ),
            ),
            child: _child,
          ),
        ),
      ),
    );
  }

  double get _width {
    switch (style) {
      case CustomButtonStyle.Secondary:
        return width ?? 155.0;
      case CustomButtonStyle.Mini:
        return width ?? 135.0;
      case CustomButtonStyle.Primary:
      default:
        return width ?? double.infinity;
    }
  }

  double get _height {
    switch (style) {
      case CustomButtonStyle.Secondary:
        return height ?? SizeHelper.boxHeight;
      case CustomButtonStyle.Mini:
        return height ?? SizeHelper.heightBtnSmall;
      case CustomButtonStyle.Primary:
      default:
        return height ?? SizeHelper.boxHeight;
    }
  }

  Alignment get _alignment {
    switch (style) {
      case CustomButtonStyle.Secondary:
        return alignment ?? Alignment.centerRight;
      case CustomButtonStyle.Mini:
        return alignment ?? Alignment.center;
      case CustomButtonStyle.Primary:
      default:
        return alignment ?? Alignment.center;
    }
  }

  BorderRadius get _borderRadius {
    switch (style) {
      case CustomButtonStyle.Secondary:
        return borderRadius ?? SizeHelper.borderRadiusOdd;
      case CustomButtonStyle.Mini:
      case CustomButtonStyle.Primary:
      default:
        return borderRadius ?? BorderRadius.circular(10.0);
    }
  }

  Color get _backgroundColor {
    return backgroundColor ?? customColors.primaryButtonBackground;
  }

  Color get _disabledBackgroundColor {
    return disabledBackgroundColor ?? customColors.primaryButtonDisabledBackground;
  }

  Color get _contentColor {
    return contentColor ?? customColors.primaryButtonContent;
  }

  Color get _disabledContentColor {
    return disabledContentColor ?? customColors.primaryButtonDisabledContent;
  }

  Widget get _child {
    if (text != null) {
      return CustomText(
        text,
        color: onPressed != null ? _contentColor : _disabledContentColor,
        alignment: Alignment.center,
      );
    } else if (asset != null) {
      return SvgPicture.asset(asset!, color: onPressed != null ? _contentColor : _disabledContentColor);
    } else {
      return Container();
    }
  }
}

enum ButtonStadiumStyle {
  Primary, // Icon-той, white
  Secondary, // Зүүн дээд өнцөг нь шовх, primary color
}

// Icon-той, stadium хэлбэртэй
class ButtonStadium extends StatelessWidget {
  final ButtonStadiumStyle style;
  final String asset;
  final VoidCallback? onPressed;
  final bool enabled;
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
    this.onPressed,
    this.enabled = true,
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
      child: enabled
          ? InkWell(
              borderRadius: _getBorderRadius(),
              child: _body(),
              onTap: () {
                if (onPressed != null) onPressed!();
              },
            )
          : _body(),
    );
  }

  Widget _body() {
    return Container(
      height: size ?? _getSize(),
      width: size ?? _getSize(),
      decoration: BoxDecoration(
        borderRadius: _getBorderRadius(),
        border: visibleBorder ? Border.all(width: SizeHelper.borderWidth, color: customColors.primaryBorder) : null,
        color: backgroundColor ?? _getBackgroundColor(),
      ),
      child: SvgPicture.asset(asset, fit: BoxFit.scaleDown, color: iconColor ?? _getContentColor()),
    );
  }

  double _getSize() {
    switch (style) {
      case ButtonStadiumStyle.Secondary:
        return 55.0;

      case ButtonStadiumStyle.Primary:
        return SizeHelper.boxHeight;
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
        return customColors.whiteBackground;

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

class CircleButton extends StatelessWidget {
  final String asset;
  final VoidCallback? onPressed;
  final Color? contentColor;
  final Color? backgroundColor;
  final double? size;

  const CircleButton({
    Key? key,
    required this.asset,
    this.onPressed,
    this.contentColor,
    this.backgroundColor,
    this.size = 20.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: TextButton(
        child: SvgPicture.asset(asset, color: contentColor ?? customColors.primaryButtonContent),
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          ),
          backgroundColor: MaterialStateProperty.all(backgroundColor ?? customColors.primaryButtonBackground),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
