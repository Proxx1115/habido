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
  static const vikingGreen = const Color(0xFF61DDBC);
  static const yellowGreen = const Color(0xFFB4DF80);
  static const seaGreen = const Color(0xFF30A74C);
  static const feijoGreen = const Color(0xFF9ED26A);
  static const froly = const Color(0xFFF76C82);
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

  /// Text
  Color primaryText = ConstantColors.black;
  Color greyText = ConstantColors.grey;
  Color whiteText = Colors.white;

  /// Indicator
  Color grayIndicator = ConstantColors.gray;

  /// Button
  Color get primaryButtonBackground => primary; // enabled
  Color primaryButtonContent = Colors.white; // enabled

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
