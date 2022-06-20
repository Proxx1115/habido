import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:habido_app/utils/assets.dart';

class HeroHelper {
  static Widget getAppLogoWithName() {
    return Hero(
      tag: 'appLogoWithName',
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 30.0),
        child: SvgPicture.asset(
          Assets.app_icon_name,
          height: 48.0,
          width: 205.0,
          fit: BoxFit.scaleDown,
        ),
      ),
    );
  }

  static Widget getAppLogoWithText() {
    return Hero(
      tag: 'appLogoWithText',
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 30.0),
        child: Image.asset(
          // todo svg error
          Assets.app_icon_text,
          height: 92.0,
          width: 179.0,
          fit: BoxFit.scaleDown,
        ),
      ),
    );
  }
}

// class IntroHelper {
//   static Widget appLogoWithName = Container(
//     margin: EdgeInsets.symmetric(vertical: 30.0),
//     child: SvgPicture.asset(
//       Assets.app_icon_name,
//       height: 48.0,
//       width: 205.0,
//       fit: BoxFit.scaleDown,
//     ),
//   );
// }
