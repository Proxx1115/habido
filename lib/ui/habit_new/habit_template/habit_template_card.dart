import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:habido_app/models/habit_template.dart';
import 'package:habido_app/models/user_habit_reminders.dart';
import 'package:habido_app/ui/habit_new/tag_item_widget_v2.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/screen_mode.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/utils/theme/hex_color.dart';
import 'package:habido_app/widgets/text.dart';

class HabitTemplateCard extends StatefulWidget {
  final HabitTemplate template;
  final bool? isFromOnboard;
  const HabitTemplateCard({Key? key, required this.template, this.isFromOnboard = false}) : super(key: key);

  @override
  State<HabitTemplateCard> createState() => _HabitTemplateCardState();
}

class _HabitTemplateCardState extends State<HabitTemplateCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, Routes.userHabit, arguments: {
          'screenMode': ScreenMode.HabitTemplate,
          'habitId': widget.template.habitId!,
          'habitTemplate': widget.template,
          'title': LocaleKeys.createHabit,
        });
      },
      borderRadius: BorderRadius.circular(15.0),
      child: Container(
        height: widget.isFromOnboard! ? 100 : 82,
        decoration: BoxDecoration(
          color: customColors.whiteBackground,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Row(
          children: [
            /// Image
            Container(
              margin: EdgeInsets.only(right: 15.0),
              padding: EdgeInsets.all(10.0),
              height: widget.isFromOnboard! ? 100 : 82.0,
              width: widget.isFromOnboard! ? 100 : 82.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(SizeHelper.borderRadius)),
                color: HexColor.fromHex(widget.template.color ?? "#FFFFFF"),
              ),
              child:
                  // SvgPicture.asset(Assets.male_habido)
                  CachedNetworkImage(
                imageUrl: widget.template.icon!,
                fit: BoxFit.fitHeight,
                placeholder: (context, url) => Container(),
                errorWidget: (context, url, error) => Container(),
              ),
            ),

            Expanded(
              child: Column(
                children: [
                  SizedBox(height: widget.isFromOnboard! ? 23 : 11.0),

                  /// Title
                  CustomText(
                    widget.template.name!,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: 3.0),

                  /// Date
                  CustomText(
                    '${LocaleKeys.time} - ${widget.template.duration!} ${LocaleKeys.day}',
                    fontSize: 11.0,
                    fontWeight: FontWeight.w500,
                  ),

                  SizedBox(height: 11.0),

                  /// Time
                  Row(
                    children: [
                      for (UserHabitReminders el in widget.template.templateReminders ?? [])
                        _reminderItem(new TimeOfDay(
                          hour: Func.toInt(el.time) ~/ 60,
                          minute: Func.toInt(el.time) % 60,
                        ))
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _reminderItem(TimeOfDay timeOfDay) {
    String hour = timeOfDay.hour < 10 ? '0${timeOfDay.hour}' : '${timeOfDay.hour}';
    String minute = timeOfDay.minute < 10 ? '0${timeOfDay.minute}' : '${timeOfDay.minute}';

    // _onPressedDeleteItem(timeOfDay);
    return TagItemWidgetV2(
      textColor: widget.isFromOnboard! ? Colors.black : Colors.white,
      fontSize: widget.isFromOnboard! ? 10 : 11.0,
      margin: EdgeInsets.only(right: 8.0),
      width: widget.isFromOnboard! ? 52 : 42.0,
      height: widget.isFromOnboard! ? 22 : 16.0,
      color: widget.isFromOnboard! ? HexColor.fromHex('#F4F6F8') : customColors.primaryButtonDisabledContent,
      text: '$hour:$minute',
    );
  }
}
