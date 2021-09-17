import 'package:flutter/material.dart';

class SizeHelper {
  /// Box constraint
  static const double margin = 20.0;
  static const double padding = margin;
  static const double marginLeft = margin;
  static const double marginTop = 10.0;
  static const double marginBottom = 30.0;

  static const double boxHeight = 50.0;
  static const boxPadding = EdgeInsets.fromLTRB(18.0, 16.0, 18.0, 16.0);
  static const boxPaddingHorizontal = EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 0.0);

  /// Border
  static const double borderWidth = 2.0;
  static const double borderRadius = 15.0;
  static const borderRadiusOdd = BorderRadius.only(
    topLeft: Radius.circular(5.0),
    topRight: Radius.circular(borderRadius),
    bottomRight: Radius.circular(borderRadius),
    bottomLeft: Radius.circular(borderRadius),
  );

  /// Screen
  static const paddingScreen =
      EdgeInsets.fromLTRB(SizeHelper.margin, SizeHelper.marginTop, SizeHelper.margin, SizeHelper.marginBottom);
  static const double heightStatusBar = 20.0;
  static double heightBottomNavigationBar = 65.0;
  static const double minHeightScreen = 650.0; // Дэлгэцний хамгийн доод өндөр

  /// Button
  static const double heightBtnSmall = 35.0;
  static const double borderRadiusBtnStadium = 10.0;

  /// Checkbox
  static const double borderRadiusChkbox = 5.0;

  /// Icon
  static const double iconSize = 20.0;
  static const double iconSizeSmall = 18.0;
  static const double iconContainerHeight = 40.0;

  /// Combo
  static const double comboHeight = boxHeight;
  static const double comboRadius = borderRadius;
  static const double comboListItemHeight = 35.0;

  /// List
  static const double listItemHeight = 50.0;
  static const double listItemHeight70 = 70.0;
  static const double menuItemHeight114 = 114.0;

  /// Loader
  static const double loaderSize = 30.0;

  /// Font size
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
  static const double fontSizeColoredHeader = 18.0;

  /// Content
  static const double contentImageRatio = 0.7;
}
