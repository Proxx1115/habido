import 'package:flutter/material.dart';

CustomColors customColors = CustomColors.light();

class CustomColors {
  static const orange = const Color(0xfffa6c51); // primary
  static const roseWhite = const Color(0xFFFFF7F6); // background white
  static const athensGray = const Color(0xFFF4F6F8); // background grey
  static const black = const Color(0xFF424852); // txt black
  static const grey = const Color(0xFFA9B0BB); // txt grey
  static const ghost = const Color(0xFFCBD0D7); // icon grey
  static const red = const Color(0xFFE8553E);

  /// Main
  Color primary = orange;
  Color border = athensGray;

  /// Background
  Color backgroundRoseWhite = roseWhite;
  Color backgroundGrey = athensGray;
  Color backgroundWhite = Colors.white;

  /// Txt
  Color txtBlack = black;
  Color txtGrey = grey;
  Color txtWhite = Colors.white;

  /// Button
  Color btnPrimaryBackground = orange;
  Color btnPrimaryText = Colors.white;
  Color btnGreyBackground = athensGray;

  Color get btnGreyText => txtGrey;

  /// Txtbox
  Color txtboxGreyBackground = athensGray;

  /// Icon
  Color iconGrey = ghost;

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
