import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/ui/notification/notification_button.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/showcase_helper.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/custom_showcase.dart';
import 'package:habido_app/widgets/text.dart';

class DashboardAppBar extends StatelessWidget {
  final String? title;
  final EdgeInsets padding;
  final bool visibleShowCase;

  const DashboardAppBar({
    Key? key,
    this.title,
    this.padding = EdgeInsets.zero,
    this.visibleShowCase = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 60.0,
      padding: padding,
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// Title
          Func.isNotEmpty(title)
              ? CustomText(title, fontWeight: FontWeight.w500)
              :

              /// HabiDo icon
              SvgPicture.asset(
                  Assets.app_icon_name,
                  height: 18.0,
                  fit: BoxFit.contain,
                ),

          Expanded(child: Container()),

          // / Profile // todo
          // visibleShowCase
          //     ? CustomShowcase(
          //         description: LocaleKeys.showcaseProfile,
          //         showcaseKey: ShowcaseKey.profile,
          //         overlayPadding: EdgeInsets.all(-5.0),
          //         shapeBorder: CircleBorder(),
          //         child: _profileButton(context),
          //       )
          //     : _profileButton(context),
          _profileButton(context),

          SizedBox(width: 15.0),

          /// Notification
          visibleShowCase
              ? CustomShowcase(
                  description: LocaleKeys.showcaseNotification,
                  showcaseKey: ShowcaseKey.notification,
                  // overlayPadding: EdgeInsets.all(10.0),
                  // overlayPadding: EdgeInsets.all(-5.0),
                  // shapeBorder: CircleBorder(),
                  // shapeBorder: RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  // ),
                  overlayPadding: EdgeInsets.all(-5.0),
                  shapeBorder: CircleBorder(),
                  child: NotificationButton(),
                )
              : NotificationButton(),
        ],
      ),
    );
  }

  Widget _profileButton(BuildContext context) {
    return ButtonStadium(
      size: 20,
      asset: Assets.profile,
      onPressed: () {
        Navigator.pushNamed(context, Routes.profile);
      },
    );
  }
}
