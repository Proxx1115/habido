import 'package:flutter/material.dart';

CustomColors customColors = CustomColors.light();

class CustomColors {
  static const pinkishOrange = const Color(0xfffa6c51); // Primary color
  static const lightPeach = const Color(0xFFf4d0b5); // Background color
  static const mako = const Color(0xFF424852); // Primary black
  static const aluminium = const Color(0xFFA9B0BB); // Primary grey

  /// Main
  Color? primary;
  Color? background;

  /// Txt
  Color? txt; // black
  Color? txtSecondary; // grey

  /// Button
  // Color? btnEnabled;
  // Color? btnDisabled;
  // Color? btnEnabledText;
  // Color? btnDisabledText;

  /// Icon
  // Color? icon; // dark grey
  // Color? iconSecondary; // light grey

  /// Shadow
  // Color? shadow;

  /// Container decoration
  // Color? border; // grey
  // Color? gradientBegin;
  // Color? gradientEnd;
  // Color? timeTableBg;

  /// AppBar
  // Color? actionIcon;
  // Color? appBarBackground;
  // Color? appBarTitle;

  /// Line
  // Color? line;

  /// Card
  // Color? cardMenuPos;
  // Color? cardMenuProduct;
  // Color? cardMenuReport;
  // Color? cardMenuSettings;

  // Color? cardIconPos;
  // Color? cardIconProduct;
  // Color? cardIconReport;
  // Color? cardIconSettings;

  /// CardBackground
  // Color? cardIconPosBackground;
  // Color? cardIconProdBackground;
  // Color? cardIconReportBackground;
  // Color? cardIconSettingsBackground;

  CustomColors.constructor();

  /// Light theme
  factory CustomColors.light() => CustomColors.constructor()
        ..primary = pinkishOrange
        ..background = lightPeach
        ..txt = mako
        ..txtSecondary = aluminium
      // ..btnEnabled = primaryColor
      // ..btnDisabled = btnGrey
      // ..btnEnabledText = Colors.white
      // ..btnDisabledText = primaryBlack
      // ..lbl = primaryBlack
      // ..lblSecondary = grey
      // ..icon = darkGrey
      // ..iconSecondary = iconGrey
      // ..border = Colors.black
      // ..actionIcon = Colors.white
      // ..appBarBackground = primaryColor
      // ..appBarTitle = Colors.white
      // ..gradientBegin = primaryGradientBegin
      // ..gradientEnd = primaryGradientEnd
      // ..timeTableBg = btnGrey
      // ..shadow = shadowGrey
      // ..textGrey = grey
      // ..line = lineGrey
      // ..cardMenuPos = eggWhite
      // ..cardMenuProduct = pattensBlue
      // ..cardMenuReport = fog
      // ..cardMenuSettings = carouselPink
      // ..cardIconPosBackground = earlyDawn
      // ..cardIconProdBackground = aliceBlue
      // ..cardIconReportBackground = titanWhite
      // ..cardIconSettingsBackground = tutu
      // ..cardIconPos = rajah
      // ..cardIconProduct = dodgerBlue
      // ..cardIconReport = perfume
      // ..cardIconSettings = persianPink
      ;

  /// Dark theme
  factory CustomColors.dark() => CustomColors.light();
}
