import 'package:flutter/material.dart';
import 'package:habido_app/ui/habit/calendar/calendar_button.dart';
import 'package:habido_app/ui/notification/notification_button.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/showcase_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
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
      margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// Calendar
          visibleShowCase
              ? CustomShowcase(
                  description: LocaleKeys.showcaseCalendar,
                  showcaseKey: ShowcaseKey.calendar,
                  // overlayPadding: EdgeInsets.all(10.0),
                  overlayPadding: EdgeInsets.all(-5.0),
                  shapeBorder: CircleBorder(),
                  // shapeBorder: ContinuousRectangleBorder(
                  //   borderRadius: BorderRadius.circular(28.0),
                  // ),
                  child: CalendarButton(),
                )
              : CalendarButton(),

          /// Title
          if (Func.isNotEmpty(title))
            Expanded(
              child: CustomText(title, alignment: Alignment.center, fontWeight: FontWeight.w500),
            ),

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
}
