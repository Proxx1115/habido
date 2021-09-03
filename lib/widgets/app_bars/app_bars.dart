import 'package:flutter/material.dart';
import 'package:habido_app/ui/habit/calendar/calendar_button.dart';
import 'package:habido_app/ui/notification/notif_button.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/app_bars/home_app_bar.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/text.dart';

// ignore: non_constant_identifier_names
AppBar CustomAppBar(
  BuildContext context, {
  Color? backgroundColor = Colors.transparent,

  // Leading
  Widget? leadingWidget,
  String? leadingAsset = Assets.back,
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
    backgroundColor: backgroundColor,
    elevation: 0, // Remove elevation
    automaticallyImplyLeading: false, // Remove back button
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        leadingWidget,

        /// Title
        Expanded(
          child: (titleText != null)
              ? CustomText(titleText,
                  alignment: Alignment.center, textAlign: TextAlign.center, fontWeight: FontWeight.w500)
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

class HomeAppBar extends StatelessWidget {
  final String? title;

  const HomeAppBar({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: false,
      snap: true,
      floating: true,
      expandedHeight: 70.0,
      collapsedHeight: 70.0,
      backgroundColor: customColors.primaryBackground,
      // Remove elevation
      elevation: 0,
      // Remove back button
      automaticallyImplyLeading: false,
      title: Container(
        margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// Calendar
            CalendarButton(),

            /// Title
            if (Func.isNotEmpty(title))
              Expanded(
                child: CustomText(title, alignment: Alignment.center, fontWeight: FontWeight.w500),
              ),

            /// Notification
            NotifButton(),
          ],
        ),
      ),
    );
  }
}
