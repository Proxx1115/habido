import 'package:flutter/material.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';

/// LABEL TYPE
enum TxtStyle {
  Caption, // 12.0
  Normal, // 14.0
  Medium, // 16.0
  Large, // 18.0
  Headline6, // 20.0
  Headline5, // 24.0
}

// ignore: must_be_immutable
class Txt extends StatelessWidget {
  Txt(
    this.text, {
    this.style = TxtStyle.Medium,
    this.color,
    this.bgColor,
    this.fontSize,
    this.fontWeight,
    this.softWrap,
    this.maxLines,
    this.lineSpace,
    this.textAlign,
    this.overflow,
    this.fontStyle = FontStyle.normal,
    this.fontFamily,
    this.padding,
    this.margin,
    this.alignment,
  });

  final String? text;
  final TxtStyle style;

  /// Text arguments
  final Color? color;
  final Color? bgColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool? softWrap;
  final int? maxLines;
  final double? lineSpace;
  TextAlign? textAlign;
  final TextOverflow? overflow;
  final String? fontFamily;
  final FontStyle fontStyle;

  /// Box constraint arguments
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Alignment? alignment;

  @override
  Widget build(BuildContext context) {
    if (alignment == Alignment.center) this.textAlign = TextAlign.center;

    return Container(
      margin: margin ?? EdgeInsets.all(0.0),
      padding: padding ?? EdgeInsets.all(0.0),
      alignment: alignment ?? Alignment.centerLeft,
      child: Text(
        text ?? '',
        softWrap: softWrap ?? true,
        maxLines: maxLines ?? 1,
        textAlign: textAlign ?? TextAlign.start,
        overflow: overflow ?? TextOverflow.ellipsis,
        style: TextStyle(
          color: color ?? _color(),
          fontSize: fontSize ?? _fontSize(),
          fontWeight: fontWeight ?? _fontWeight(),
          height: lineSpace,
          backgroundColor: bgColor,
          fontStyle: fontStyle,
          fontFamily: fontFamily,
        ),
      ),
    );
  }

  double _fontSize() {
    switch (style) {
      case TxtStyle.Caption:
        return SizeHelper.fontSizeCaption;
      case TxtStyle.Normal:
        return SizeHelper.fontSizeNormal;
      case TxtStyle.Medium:
        return SizeHelper.fontSizeMedium;
      case TxtStyle.Large:
        return SizeHelper.fontSizeLarge;
      case TxtStyle.Headline6:
        return SizeHelper.fontSizeHeadline6;
      case TxtStyle.Headline5:
        return SizeHelper.fontSizeHeadline5;
      default:
        return SizeHelper.fontSizeNormal;
    }
  }

  Color? _color() {
    switch (style) {
      default:
        return customColors.txtBlack;
    }
  }

  FontWeight _fontWeight() {
    switch (style) {
      default:
        return FontWeight.normal;
    }
  }
}
