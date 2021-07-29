import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/txt.dart';

// ignore: non_constant_identifier_names
Widget CustomAppBar({
  required BuildContext context,
  Color? backgroundColor,
  Widget? leadingWidget,
  String? leadingAsset = Assets.back,
  VoidCallback? onPressedLeading,
  String? titleText,
}) {
  Widget? _leading;
  if (leadingWidget != null) {
    _leading = leadingWidget;
  } else if (leadingAsset != null) {
    _leading = BtnStadium(
      asset: leadingAsset,
      margin: EdgeInsets.only(left: 15.0),
      onPressed: () {},
    );

    // _leading = IconButton(
    //   icon: ,
    // );
  }

  return AppBar(
    backgroundColor: backgroundColor ?? Colors.transparent,
    elevation: 0,
    leading: _leading,
    title: titleText != null
        ? Txt(
            titleText,
            alignment: Alignment.center,
            fontWeight: FontWeight.w500,
            fontSize: 15.0,
          )
        : null,
  );
}

// ignore: non_constant_identifier_names
PreferredSize AppBarEmpty({
  required BuildContext context,
  Brightness brightness = Brightness.light,
  Color backgroundColor = Colors.transparent,
  double elevation = 0.0,
}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(0.0), // here the desired height
    child: AppBar(
      backgroundColor: backgroundColor,
      brightness: brightness,
      leading: Container(),
      elevation: elevation,
      actions: <Widget>[],
    ),
  );
}
