import 'package:flutter/material.dart';

CustomColors customColors = CustomColors.light();

class CustomColors {
  static const orange = const Color(0xfffa6c51); // primary
  static const lightPeach = const Color(0xFFf4d0b5); // background
  static const athensGray = const Color(0xFFF4F6F8); // background2
  static const black = const Color(0xFF424852); // txt
  static const grey = const Color(0xFFA9B0BB); // txt2

  /// Main
  Color primary = orange;

  /// Background
  Color backgroundPeach = lightPeach;
  Color backgroundGrey = athensGray;
  Color backgroundWhite = Colors.white;

  /// Txt
  Color txtBlack = black;
  Color txtGrey = grey;
  Color txtWhite = Colors.white;

  /// Button
  Color btnPrimary = orange;
  Color btnPrimaryText = Colors.white;
  
  Color btnGrey = athensGray;
  Color get btnGreyText => txtGrey;

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
      // ..primary = orange
      ;

  /// Dark theme
  factory CustomColors.dark() => CustomColors.light();
}
