import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/txt.dart';

// ignore: non_constant_identifier_names
Widget CustomAppBar({
  required BuildContext context,
  Color? backgroundColor,

  // Leading
  Widget? leadingWidget,
  String? leadingAsset = Assets.back,
  VoidCallback? onPressedLeading,

  // Title
  String? titleText,

  // Action
  Widget? actionWidget,
  String? actionAsset,
  VoidCallback? onPressedAction,
}) {
  /// Init leading
  if (leadingWidget != null) {
    // Nothing but life goes on
  } else if (leadingAsset != null) {
    leadingWidget = BtnStadium(
      asset: leadingAsset,
      onPressed: () {
        if (onPressedLeading != null) {
          // Custom action
          onPressedLeading();
        } else {
          // Btn back
          Navigator.pop(context);
        }
      },
    );
  } else {
    leadingWidget = Container();
  }

  /// Init action
  if (actionWidget != null) {
    // Nothing but life goes on
  } else if (actionAsset != null) {
    actionWidget = BtnStadium(
      asset: actionAsset,
      margin: EdgeInsets.only(left: 15.0),
      onPressed: () {
        if (onPressedAction != null) onPressedAction();
      },
    );
  } else {
    actionWidget = AbsorbPointer(
      child: Opacity(opacity: 0.0, child: leadingWidget),
    );
  }

  return AppBar(
    backgroundColor: backgroundColor ?? Colors.transparent,
    elevation: 0, // Remove elevation
    automaticallyImplyLeading: false, // Remove back button
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        leadingWidget,

        /// Title
        Expanded(
          child: (titleText != null)
              ? Txt(titleText, alignment: Alignment.center, textAlign: TextAlign.center, fontWeight: FontWeight.w500, fontSize: 15.0)
              : Container(),
        ),

        actionWidget,
      ],
    ),
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
