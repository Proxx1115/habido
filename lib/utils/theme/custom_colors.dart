import 'package:flutter/material.dart';

CustomColors customColors = CustomColors.light();

class ColorCodes {
  static const primary = 'FA6C51';
  static const ghostGrey = 'CBD0D7';
  static const roseWhite = 'FFF7F6';
}

class ConstantColors {
  static const primary = const Color(0xfffa6c51); // primary
  static const roseWhite = const Color(0xFFFFF7F6); // background
  static const athensGrey = const Color(0xFFF4F6F8); // background
  static const black = const Color(0xFF424852); // text
  static const grey = const Color(0xFFA9B0BB); // text
  static const gray = const Color(0xFFADB2B9); // indicator
  static const cornflowerBlue = const Color(0xFFCAD0D7); // button text
  static const ghostGrey = const Color(0xFFCBD0D7); // icon
  static const red = const Color(0xFFE8553E);
  static const frolyRed = const Color(0xFFE8553E); // trash icon
  static const yellow = const Color(0xFFFDCD56);
  static const blue = const Color(0xFF73B0F4);
  static const blueRibbon = const Color(0xFF006CEB);
  static const vikingGreen = const Color(0xFF61DDBC);
  static const yellowGreen = const Color(0xFFB4DF80);
  static const seaGreen = const Color(0xFF30A74C);
  static const feijoGreen = const Color(0xFF9ED26A);
  static const froly = const Color(0xFFF76C82);
  static const loblolly = const Color(0xFFC2CAD1);
  static const athensGray = const Color(0xFFF2F5F7);
  // feeling backgrounds
  static const feeling1Top = const Color(0xFF76BDB8); // Гайхалтай
  static const feeling1Btm = const Color(0xFFC5F4F1); // Гайхалтай
  static const feeling2Top = const Color(0xFF77759C); // Дажгүй шүү
  static const feeling2Btm = const Color(0xFFB2AFDD); // Дажгүй шүү
  static const feeling3Top = const Color(0xFFF0B99F); // Мэдэхгүй ээ
  static const feeling3Btm = const Color(0xFFFFF1EB); // Мэдэхгүй ээ
  static const feeling4Top = const Color(0xFFE47876); // Тааламжгүй ээ
  static const feeling4Btm = const Color(0xFFFFD5D5); // Тааламжгүй ээ
  static const feeling5Top = const Color(0xFF5E7F9C); // Онцгүй ээ
  static const feeling5Btm = const Color(0xFF9DC0DE); // Онцгүй ээ
  static const feelingCauseTop = const Color(0xFF46A1BC);
  static const feelingCauseBtm = const Color(0xFF8BCCE2);
  static const feelingCauseItem = const Color(0xFF3D93AD);
  static const feelingCauseLight = const Color(0x663D93AD);
  static const feelingDetailHint = const Color(0xFFE2E2E2);
}

class CustomColors {
  /// Main
  Color primary = ConstantColors.primary;

  /// Background
  Color primaryBackground = ConstantColors.roseWhite;
  Color whiteBackground = Colors.white;
  Color greyBackground = ConstantColors.athensGrey;
  Color yellowBackground = ConstantColors.yellow;
  Color blueBackground = ConstantColors.blue;
  Color pinkBackground = ConstantColors.froly;
  Color feijoBackground = ConstantColors.feijoGreen;

  /// Border
  Color primaryBorder = ConstantColors.athensGrey;
  Color secondaryBorder = Colors.white;
  Color roseWhiteBorder = ConstantColors.roseWhite;
  Color grayBorder = ConstantColors.loblolly;
  Color athensGrayBorder = ConstantColors.athensGray;

  /// Text
  Color primaryText = ConstantColors.black;
  Color greyText = ConstantColors.grey;
  Color whiteText = Colors.white;
  Color disabledText = ConstantColors.cornflowerBlue;

  /// Indicator
  Color grayIndicator = ConstantColors.gray;

  /// Button
  Color get primaryButtonBackground => primary; // enabled
  Color get whiteButtonBackground => Colors.white; // bordered
  Color get blackButtonBackground => Colors.black;
  Color get blueButtonBackground => ConstantColors.blueRibbon;
  Color primaryButtonContent = Colors.white; // enabled
  Color blackButtonContent = ConstantColors.black; // bordered

  Color get primaryButtonDisabledBackground => whiteBackground; // disabled
  Color primaryButtonDisabledContent = ConstantColors.cornflowerBlue; // disabled

  Color get secondaryButtonBackground => greyBackground; // enabled
  Color secondaryButtonContent = ConstantColors.black; // enabled

  /// TextField
  Color get primaryTextFieldBackground => whiteBackground;

  Color get secondaryTextFieldBackground => ConstantColors.athensGrey;

  /// Icon
  Color iconWhite = Colors.white;
  Color iconGrey = ConstantColors.ghostGrey;
  Color iconRed = ConstantColors.frolyRed;
  Color iconYellow = ConstantColors.yellow;
  Color iconBlue = ConstantColors.blue;
  Color iconVikingGreen = ConstantColors.vikingGreen;
  Color iconYellowGreen = ConstantColors.yellowGreen;
  Color iconSeaGreen = ConstantColors.seaGreen;

  /// Feeling Backgrounds
  Color feeling1Top = ConstantColors.feeling1Top;
  Color feeling1Btm = ConstantColors.feeling1Btm;
  Color feeling2Top = ConstantColors.feeling2Top;
  Color feeling2Btm = ConstantColors.feeling2Btm;
  Color feeling3Top = ConstantColors.feeling3Top;
  Color feeling3Btm = ConstantColors.feeling3Btm;
  Color feeling4Top = ConstantColors.feeling4Top;
  Color feeling4Btm = ConstantColors.feeling4Btm;
  Color feeling5Top = ConstantColors.feeling5Top;
  Color feeling5Btm = ConstantColors.feeling5Btm;

  /// Feeling Cause, Detail background
  Color feelingCauseTop = ConstantColors.feelingCauseTop;
  Color feelingCauseBtm = ConstantColors.feelingCauseBtm;
  Color feelingCauseItem = ConstantColors.feelingCauseItem;
  Color feelingCauseLight = ConstantColors.feelingCauseLight;
  Color feelingDetailHint = ConstantColors.feelingDetailHint;

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
