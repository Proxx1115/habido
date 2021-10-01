import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/ui/habit/calendar/calendar_button.dart';
import 'package:habido_app/ui/notification/notification_button.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/showcase_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:showcaseview/showcaseview.dart';

class DashboardSliverAppBar extends StatelessWidget {
  final String? title;
  final EdgeInsets padding;
  final VoidCallback? onPressedLogout;

  const DashboardSliverAppBar({
    Key? key,
    this.title,
    this.padding = EdgeInsets.zero,
    this.onPressedLogout,
  }) : super(key: key);

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
        padding: padding,
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

            (onPressedLogout != null)
                ?

                /// Logout
                ButtonStadium(
                    asset: Assets.logout,
                    child: Container(
                      margin: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: customColors.primaryButtonDisabledContent,
                      ),
                      padding: EdgeInsets.all(7.0),
                      child: SvgPicture.asset(Assets.logout),
                    ),
                    iconColor: customColors.iconGrey,
                    onPressed: () {
                      if (onPressedLogout != null) {
                        onPressedLogout!();
                      }
                    },
                  )

                /// Notification
                : NotificationButton(),
          ],
        ),
      ),
    );
  }
}
