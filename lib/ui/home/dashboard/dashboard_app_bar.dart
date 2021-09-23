import 'package:flutter/material.dart';
import 'package:habido_app/ui/habit/calendar/calendar_button.dart';
import 'package:habido_app/ui/notification/notif_button.dart';
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

  const DashboardAppBar({
    Key? key,
    this.title,
    this.padding = EdgeInsets.zero,
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
          CustomShowcase(
            description: LocaleKeys.showcaseCalendar,
            showcaseKey: ShowcaseKey.calendar,
            shapeBorder: CircleBorder(),
            child: CalendarButton(),
          ),

          /// Title
          if (Func.isNotEmpty(title))
            Expanded(
              child: CustomText(title, alignment: Alignment.center, fontWeight: FontWeight.w500),
            ),

          /// Notification
          CustomShowcase(
            description: LocaleKeys.showcaseNotification,
            showcaseKey: ShowcaseKey.notification,
            overlayPadding: EdgeInsets.all(-5.0),
            shapeBorder: CircleBorder(),
            child: NotifButton(),
          ),
        ],
      ),
    );
  }
}
