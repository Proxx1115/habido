import 'package:flutter/material.dart';

class SizeHelper {
  /// Box constraint
  static const double padding = 20.0;
  static const double margin = padding;
  static const double marginLeft = margin;
  static const double marginTop = margin;
  static const double marginBottom = 25.0;
  static const double borderRadius = 15.0;
  static const double borderRadius2 = 5.0;
  static const double boxHeight = 50.0;

  /// Screen
  static const paddingScreen = EdgeInsets.fromLTRB(SizeHelper.margin, SizeHelper.marginTop, SizeHelper.margin, SizeHelper.marginBottom);
  static const double statusBarHeight = 20.0;
  static double bottomNavigationBarHeight = 65.0;
  static const double minHeightScreen = 700.0; // Дэлгэцний хамгийн доод өндөр

  /// Button
  static const double buttonHeight = 50.0;
  static const double borderRadiusBtn = borderRadius;
  static const double borderRadiusBtn2 = borderRadius2;
  static const double buttonHeightSmall = 35.0;
  static const double borderRadiusBtnSmall = 10.0;

  /// Card
  static const double borderRadiusCard = borderRadius;

  /// CodeInput
  static const double borderRadiusCodeInput = borderRadius;

  /// Textbox
  static const double textboxHeight = boxHeight;

  /// Icon
  static const double iconSize = 20.0;
  static const double iconSizeSmall = 18.0;
  static const double iconContainerHeight = 40.0;

  /// Combo
  static const double comboHeight = boxHeight;
  static const double comboRadius = borderRadius;
  static const double comboListItemHeight = 35.0;

  /// List
  static const double listItemHeight = 52.0;
  static const double listItemHeight70 = 70.0;
  static const double menuItemHeight114 = 114.0;

  /// Loader
  static const double loaderSize = 30.0;

  /// Font size
  static const double fontSizeCaption = 12.0;
  static const double fontSizeNormal = 14.0;
  static const double fontSizeMedium = 16.0;
  static const double fontSizeLarge = 18.0;
  static const double fontSizeHeadline6 = 20.0;
  static const double fontSizeHeadline5 = 24.0;
  static const double fontSize28 = 28.0;
  static const double fontSizeHeadline4 = 32.0;
  static const double fontSizeHeadline3 = 45.0;
  static const double fontSizeHeadline2 = 56.0;
  static const double fontSizeHeadline1 = 112.0;
  static const double fontSizeTextButton = 15.0;
  static const double fontSizeColoredHeader = 18.0;
// NAME       SIZE   WEIGHT   SPACING  2018 NAME
// display4   112.0  thin     0.0      headline1
// display3   56.0   normal   0.0      headline2
// display2   45.0   normal   0.0      headline3
// display1   34.0   normal   0.0      headline4
// headline   24.0   normal   0.0      headline5
// title      20.0   medium   0.0      headline6
// subhead    16.0   normal   0.0      subtitle1
// body2      14.0   medium   0.0      body1 (bodyText1)
// body1      14.0   normal   0.0      body2 (bodyText2)
// caption    12.0   normal   0.0      caption
// button     14.0   medium   0.0      button
// subtitle   14.0   medium   0.0      subtitle2
// overline   10.0   normal   0.0      overline
}
