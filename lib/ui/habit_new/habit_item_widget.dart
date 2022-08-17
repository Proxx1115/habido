import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:habido_app/models/active_habit.dart';
import 'package:habido_app/ui/habit/user_habit/plan_terms/plan_term_helper.dart';
import 'package:habido_app/ui/habit_new/progress_indicator_widget.dart';
import 'package:habido_app/ui/habit_new/tag_item_widget.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/utils/theme/hex_color.dart';
import 'package:habido_app/widgets/text.dart';

class HabitItemWidget extends StatelessWidget {
  final dynamic data;
  final bool isActiveHabit;
  final Function onTap;
  const HabitItemWidget({Key? key, required this.data, required this.isActiveHabit, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        height: 110.0,
        padding: EdgeInsets.fromLTRB(22.0, 12.0, 22.0, 12.0),
        margin: EdgeInsets.only(bottom: 15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(SizeHelper.borderRadius)),
          color: customColors.whiteBackground,
        ),
        child: InkWell(
          onTap: () {
            onTap();
          },
          borderRadius: SizeHelper.startHabitItemRadius,
          child: Row(
            children: [
              /// Image
              // if (Func.isNotEmpty(data["leadingUrl"]))
              Container(
                margin: EdgeInsets.only(right: 20.0),
                child: CachedNetworkImage(
                  imageUrl: data.photo!,
                  color: HexColor.fromHex(data.color!),
                  height: 30.0,
                  width: 30.0,
                  placeholder: (context, url) => Container(),
                  errorWidget: (context, url, error) => Container(),
                ),
              ),

              /// Text
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(data.name, fontSize: 15.0, fontWeight: FontWeight.w500),
                    SizedBox(height: 1.0),
                    CustomText(data.goalValue, fontSize: 11.0),
                    SizedBox(height: 5.0),
                    Row(
                      children: [
                        TagItemWidget(text: Func.toDateStr(Func.toDate(data.startDate), dateFormat: 'yyyy.MM.dd')),
                        Container(
                          height: 1,
                          width: 18.0,
                          color: customColors.primaryButtonDisabledContent,
                        ),
                        TagItemWidget(text: Func.toDateStr(Func.toDate(data.endDate), dateFormat: 'yyyy.MM.dd')),
                      ],
                    )
                  ],
                ),
              ),
              isActiveHabit
                  ? Container()
                  : ProgressIndicatorWidget(
                      value: Func.toDouble(data.progressPercentage),
                      status: data.status,
                    ),
            ],
          ),
        ),
      ),
      Positioned(right: 0, top: 0, child: _dayInterval())
    ]);
  }

  Color _getColor() {
    switch (data.status) {
      case "Failed":
        return customColors.iconRed;
      case "Completed":
        return customColors.iconSeaGreen;
      case "StartedNotCompleted":
        return customColors.iconYellow;
      default:
        return customColors.iconYellowGreen;
    }
  }

  Widget _dayInterval() {
    return Container(
      height: 20,
      constraints: BoxConstraints(
        minWidth: 105.0,
      ),
      decoration: BoxDecoration(
        color: customColors.greyBackground,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(SizeHelper.borderRadius),
          bottomLeft: Radius.circular(SizeHelper.borderRadius),
        ),
      ),
      child: CustomText(isActiveHabit ? _activeHabitDays(data.planTerm) : _overHabitStatus(data.status),
          fontSize: 11.0, alignment: Alignment.center, overflow: TextOverflow.ellipsis),
    );
  }

  String _activeHabitDays(String term) {
    switch (term) {
      case PlanTerm.Daily:
        return "Өдөр бүр";
      case PlanTerm.Weekly:
        var res = "";
        List<String> dayList = data.plans.toString().split(",");
        var lastElementIndex = dayList.length - 1;
        dayList.forEach((element) {
          res += PlanTerm.getWeekDayText(int.parse(element));
          if (element != dayList[lastElementIndex]) res += ",";
        });
        return res;
      case PlanTerm.Monthly:
        return "Сар бүрийн ${data.plans}";
      default:
        return "";
    }
  }

  String _overHabitStatus(String status) {
    switch (status) {
      case "Completed":
        return LocaleKeys.completedHabits;
      case "Failed":
        return LocaleKeys.uncompletedHabits;
      case "NotStartedFailed":
        return LocaleKeys.failedHabits;
      default:
        return "";
    }
  }
}
