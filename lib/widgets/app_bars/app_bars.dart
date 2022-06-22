import 'package:flutter/material.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/text.dart';

// ignore: non_constant_identifier_names
AppBar CustomAppBar(
  BuildContext context, {
  Color? backgroundColor = Colors.transparent,

  // Leading
  Widget? leadingWidget,
  String? leadingAsset = Assets.back,
  Color? leadingColor,
  Color? leadingBackgroundColor,
  VoidCallback? onPressedLeading,

  // Title
  String? titleText,

  // Action
  Widget? actionWidget,
  String? actionAsset,
  Color? actionAssetColor,
  VoidCallback? onPressedAction,
}) {
  /// Init leading
  if (leadingWidget != null) {
    // Nothing but life goes on
  } else if (leadingAsset != null) {
    leadingWidget = ButtonStadium(
      asset: leadingAsset,
      iconColor: leadingColor,
      backgroundColor: leadingBackgroundColor,
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
    actionWidget = ButtonStadium(
      asset: actionAsset,
      iconColor: actionAssetColor,
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
    backgroundColor: Colors.white,
    elevation: 0, // Remove elevation
    titleSpacing: 0,
    automaticallyImplyLeading: false, // Remove back button
    title: Row(
      children: [
        leadingWidget,

        /// Title
        (titleText != null) ? Expanded(child: CustomText(titleText, textAlign: TextAlign.center, fontWeight: FontWeight.w500)) : Container(),

        actionWidget,
      ],
    ),
  );
}

// ignore: non_constant_identifier_names
PreferredSize EmptyAppBar({
  required BuildContext context,
  Brightness brightness = Brightness.light,
  Color backgroundColor = Colors.transparent,
  double elevation = 0.0,
}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(0.0), // here the desired height
    child: AppBar(
      backgroundColor: backgroundColor,
      leading: Container(),
      elevation: elevation,
      actions: <Widget>[],
    ),
  );
}
