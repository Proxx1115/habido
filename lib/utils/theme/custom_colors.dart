import 'package:flutter/material.dart';

CustomColors customColors = CustomColors.light();

class ConstantColors {
  static const primary = const Color(0xfffa6c51); // primary
  static const roseWhite = const Color(0xFFFFF7F6); // background
  static const athensGray = const Color(0xFFF4F6F8); // background
  static const black = const Color(0xFF424852); // text
  static const grey = const Color(0xFFA9B0BB); // text
  static const cornflowerBlue = const Color(0xFFCAD0D7); // button text
  static const ghostGrey = const Color(0xFFCBD0D7); // icon
  static const red = const Color(0xFFE8553E);
}

class CustomColors {
  /// Main
  Color primary = ConstantColors.primary;
  Color border = ConstantColors.athensGray;

  /// Background
  Color primaryBackground = ConstantColors.roseWhite;
  Color secondaryBackground = Colors.white;

  /// Text
  Color primaryText = ConstantColors.black;
  Color secondaryText = ConstantColors.grey;
  Color whiteText = Colors.white;

  /// Button
  Color get primaryButtonBackground => primary; // enabled
  Color primaryButtonText = Colors.white; // enabled

  Color get primaryButtonDisabledBackground => secondaryBackground; // disabled
  Color primaryButtonDisabledText = ConstantColors.cornflowerBlue; // disabled

  /// TextField
  Color get primaryTextFieldBackground => secondaryBackground;

  Color get secondaryTextFieldBackground => ConstantColors.athensGray;

  /// Icon
  Color iconGrey = ConstantColors.ghostGrey;

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
      // ..primary = ConstantColors.primary
      ;

  /// Dark theme
  factory CustomColors.dark() => CustomColors.light();
}

// Test habit colors
// #FBD277
// #46CEAC
// #F76C82
// #9ED26A
// #E3B692
// #EB86BE
// #9ED26A
// #9ED26A
// #9ED26A