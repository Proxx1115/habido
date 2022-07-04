import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/ui/calendar_new/day_item.dart';
import 'package:habido_app/ui/calendar_new/day_model.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/responsive_flutter/responsive_flutter.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/containers/containers.dart';

class CalendarScreen extends StatefulWidget {
  final ValueChanged<DateTime> onDateTimeChanged;
  const CalendarScreen({Key? key, required this.onDateTimeChanged}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  List<DayModel> days = [];
  List<DayModel> fixedWeek = [];
  DayModel? selectedDay;
  var currentDate = DateTime.now();
  @override
  void initState() {
    currentDate = DateTime.now();
    int weekDay = currentDate.weekday;
    DateTime firstDayOfWeek = currentDate.subtract(Duration(days: weekDay));
    selectedDay = new DayModel(currentDate.day, _weekDay(firstDayOfWeek.weekday), "0");
    _initList(currentDate);
    super.initState();
  }

  _initList(DateTime date) {
    fixedWeek.clear();
    var weekDay = date.weekday;
    for (int i = 1; i <= 7; i++) {
      var firstDayOfWeek = date.subtract(Duration(days: weekDay - i));
      print("monthss: ${date.add(new Duration(days: i)).month}");
      DayModel currentDay = DayModel(firstDayOfWeek.day, _weekDay(firstDayOfWeek.weekday), "0", month: date.add(new Duration(days: i)).month);
      fixedWeek.add(currentDay);
    }
    setState(() {});
  }

  String _weekDay(int week) {
    if (week == 1) {
      return LocaleKeys.mo;
    } else if (week == 2) {
      return LocaleKeys.tu;
    } else if (week == 3) {
      return LocaleKeys.we;
    } else if (week == 4) {
      return LocaleKeys.th;
    } else if (week == 5) {
      return LocaleKeys.fr;
    } else if (week == 6) {
      return LocaleKeys.sa;
    } else {
      return LocaleKeys.su;
    }
  }

  String _monthName(int month) {
    if (month == 1) {
      return 'Нэгдүгээр сар';
    } else if (month == 2) {
      return 'Хоёрдугаар сар';
    } else if (month == 3) {
      return 'Гуравдугаар сар';
    } else if (month == 4) {
      return 'Дөрөвдүгээр сар';
    } else if (month == 5) {
      return 'Тавдугаар сар';
    } else if (month == 6) {
      return 'Зургаадугаар сар';
    } else if (month == 7) {
      return 'Долоодугаар сар';
    } else if (month == 8) {
      return 'Наймдугаар сар';
    } else if (month == 9) {
      return 'Есдүгээр сар';
    } else if (month == 10) {
      return 'Аравдугаар сар';
    } else if (month == 11) {
      return 'Арваннэгдүгээр сар';
    } else {
      return 'Арванхоёрдугаар сар';
    }
  }

  @override
  Widget build(BuildContext context) {
    return NoSplashContainer(
      child: Container(
          width: ResponsiveFlutter.of(context).wp(100),
          height: ResponsiveFlutter.of(context).hp(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: ResponsiveFlutter.of(context).hp(1),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: SizeHelper.margin),
                child: Text(
                  _monthName(currentDate.month),
                  style: TextStyle(color: Colors.black, fontSize: ResponsiveFlutter.of(context).fontSize(2)),
                ),
              ),
              SizedBox(
                height: ResponsiveFlutter.of(context).hp(1),
              ),
              Container(
                height: ResponsiveFlutter.of(context).hp(7),
                child: Row(children: [
                  InkWell(
                      onTap: (() {
                        currentDate = DateTime(currentDate.year, currentDate.month, currentDate.day - 7);
                        _initList(currentDate);
                      }),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          SvgPicture.asset(
                            Assets.back10,
                            height: 14,
                            width: 8,
                          ),
                        ],
                      )),
                  SizedBox(
                    width: ResponsiveFlutter.of(context).wp(2),
                  ),
                  Expanded(
                    child: fixedWeek.isEmpty
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            primary: true,
                            shrinkWrap: true,
                            itemCount: fixedWeek.length,
                            itemBuilder: (context, index) {
                              return _day(index);
                            }),
                  ),
                  // const SizedBox(
                  //   width: 1,
                  // ),
                  InkWell(
                      onTap: (() {
                        currentDate = DateTime(currentDate.year, currentDate.month, currentDate.day + 7);
                        _initList(currentDate);
                      }),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            Assets.forward10,
                            height: 14,
                            width: 8,
                          ),
                          SizedBox(
                            width: 15,
                          )
                        ],
                      )),
                ]),
              ),
            ],
          )),
    );
  }

  Widget _day(int index) {
    // double progress = double.parse(days[index].process ?? '0.0');

    return InkWell(
        onTap: () {
          setState(() {
            selectedDay = fixedWeek[index];
            print("Sar: ${fixedWeek[index].month}");
            var date = DateTime(selectedDay!.year!, fixedWeek[index].month!, selectedDay!.day!);
            widget.onDateTimeChanged(date);
          });
        },
        child: fixedWeek[index] == selectedDay
            ? Container(
                margin: EdgeInsets.only(right: ResponsiveFlutter.of(context).fontSize(0.6)),
                padding: EdgeInsets.all(ResponsiveFlutter.of(context).fontSize(1.5)),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: customColors.primary,
                ),
                child: Column(
                  children: [
                    Text(
                      '${fixedWeek[index].dayName}',
                      style: TextStyle(color: Colors.white, fontSize: ResponsiveFlutter.of(context).fontSize(1.3), fontWeight: FontWeight.w500),
                    ),
                    Text('${fixedWeek[index].day}',
                        style: TextStyle(color: Colors.white, fontSize: ResponsiveFlutter.of(context).fontSize(1.3), fontWeight: FontWeight.w500)),
                    SizedBox(
                        // height: ResponsiveFlutter.of(context).hp(0.5),
                        ),
                  ],
                ),
              )
            : Container(
                margin: EdgeInsets.only(right: ResponsiveFlutter.of(context).fontSize(0.7)),
                // padding: EdgeInsets.only(right: ResponsiveFlutter.of(context).fontSize(0.3), left: ResponsiveFlutter.of(context).fontSize(0.3)),
                child: CircularPercentIndicator(
                  isSelected: fixedWeek[index] == selectedDay ? true : false,
                  radius: ResponsiveFlutter.of(context).fontSize(2.5),
                  lineWidth: ResponsiveFlutter.of(context).fontSize(0.2),
                  percent: double.parse(fixedWeek[index].process ?? "0.0") / 100,
                  center: Column(
                    children: [
                      SizedBox(
                        height: ResponsiveFlutter.of(context).hp(0.7),
                      ),
                      Text(
                        '${fixedWeek[index].dayName}',
                        style: TextStyle(
                            color: fixedWeek[index] == selectedDay ? Colors.black : Colors.grey,
                            fontSize: ResponsiveFlutter.of(context).fontSize(1.3),
                            fontWeight: FontWeight.w500),
                      ),
                      Text('${fixedWeek[index].day}',
                          style: TextStyle(
                              color: fixedWeek[index] == selectedDay ? Colors.black : Colors.grey,
                              fontSize: ResponsiveFlutter.of(context).fontSize(1.3),
                              fontWeight: FontWeight.w500)),
                      SizedBox(
                        height: ResponsiveFlutter.of(context).hp(0.5),
                      ),
                    ],
                  ),
                  backgroundColor: Colors.grey,
                  progressColor: customColors.primary,
                )));
  }
}
