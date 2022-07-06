import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/ui/notification/notification_button.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/showcase_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/containers/containers.dart';
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
      color: customColors.whiteBackground,
      height: 60.0,
      padding: padding,
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// Title
          Func.isNotEmpty(title)
              ? CustomText(title, fontWeight: FontWeight.w800)
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

          /// Notification
          visibleShowCase ? NotificationButton() : NotificationButton(),
        ],
      ),
    );
  }

  Widget _profileButton(BuildContext context) {
    // return ButtonStadium(
    //   size: 20,
    //   asset: Assets.profile,
    //   onPressed: () {
    //     Navigator.pushNamed(context, Routes.profile);
    //   },
    // );
    return NoSplashContainer(
        child: InkWell(
      onTap: () {
        Navigator.pushNamed(context, Routes.profile);
      },
      child: Container(
        padding: EdgeInsets.all(7.5),
        child: SvgPicture.asset(
          Assets.profile,
          height: 20,
        ),
      ),
    ));
  }
}
