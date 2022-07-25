import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/calendar_bloc.dart';
import 'package:habido_app/models/date_interval_progress_response.dart';
import 'package:habido_app/ui/calendar_new/day_item.dart';
import 'package:habido_app/ui/calendar_new/day_model.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/responsive_flutter/responsive_flutter.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:square_percent_indicater/square_percent_indicater.dart';

class RectangleCalendarScreen extends StatefulWidget {
  final ValueChanged<DateTime> onDateTimeChanged;
  const RectangleCalendarScreen({Key? key, required this.onDateTimeChanged}) : super(key: key);

  @override
  State<RectangleCalendarScreen> createState() => _RectangleCalendarScreenState();
}

class _RectangleCalendarScreenState extends State<RectangleCalendarScreen> {
  List<DayModel> days = [];
  List<DayModel> fixedWeek = [];
  DayModel? _selectedDay;
  var _currentDate = DateTime.now();

  List<DateProgress>? _datesProgress;
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    _currentDate = DateTime.now();
    int weekDay = _currentDate.weekday;
    DateTime firstDayOfWeek = _currentDate.subtract(Duration(days: weekDay));
    _selectedDay = new DayModel(_currentDate.day, _weekDay(_currentDate.weekday), "0.0", month: _currentDate.month);
    _startDate = firstDayOfWeek.add(new Duration(days: 1));
    _endDate = firstDayOfWeek.add(new Duration(days: 8));
    BlocManager.calendarBloc.add(
      GetDateIntervalProgressEvent(
        Func.toDateStr(_startDate),
        Func.toDateStr(_endDate),
      ),
    );
    // _initList(currentDate);

    super.initState();
  }

  _initList(DateTime date) {
    print("and sel ${date}");
    fixedWeek.clear();
    var weekDay = date.weekday;
    for (int i = 1; i <= 7; i++) {
      var firstDayOfWeek = date.subtract(Duration(days: weekDay - i));
      print("monthss: ${date.add(new Duration(days: i)).month}");
      DayModel currentDay = DayModel(firstDayOfWeek.day, _weekDay(firstDayOfWeek.weekday), _datesProgress![i - 1].percentage.toString(),
          month: date.add(new Duration(days: i)).month);
      print("Current day and today: ${currentDay.day} and ${_selectedDay!.day}");
      print("Current month and today month: ${currentDay.month} and ${_selectedDay!.month}");
      print("Current dayname and today dayname: ${currentDay.dayName} and ${_selectedDay!.dayName}");
      print("Current process and today process: ${currentDay.process} and ${_selectedDay!.process}");
      print("Current year and today year: ${currentDay.year} and ${_selectedDay!.year}");
      fixedWeek.add(currentDay);
    }
    // setState(() {});
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
    return BlocProvider.value(
        value: BlocManager.calendarBloc,
        child: BlocListener<CalendarBloc, CalendarState>(
            listener: _blocListener,
            child: BlocBuilder<CalendarBloc, CalendarState>(builder: (context, state) {
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
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _monthName(_currentDate.month),
                                  style: TextStyle(color: Colors.black, fontSize: ResponsiveFlutter.of(context).fontSize(2)),
                                ),
                              ),
                              NoSplashContainer(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(context, Routes.allHabits);
                                  },
                                  child: CustomText(
                                    LocaleKeys.seeAllHabits,
                                    fontSize: 11,
                                    color: customColors.primary,
                                    underlined: true,
                                  ),
                                ),
                              ),
                              SizedBox(width: 23.0),
                            ],
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
                                  _onLeft();
                                }),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 12),
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
                                  ),
                                )),
                            SizedBox(
                              width: ResponsiveFlutter.of(context).wp(2),
                            ),
                            Expanded(
                              child: fixedWeek.isEmpty
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : GestureDetector(
                                      onHorizontalDragEnd: (DragEndDetails details) {
                                        if (details.primaryVelocity! > 0) {
                                          _onLeft();
                                        } else if (details.primaryVelocity! < 0) {
                                          _onRight();
                                        }
                                      },
                                      child: ListView.builder(
                                          physics: const NeverScrollableScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          primary: true,
                                          shrinkWrap: true,
                                          itemCount: fixedWeek.length,
                                          itemBuilder: (context, index) {
                                            return _day(index);
                                          }),
                                    ),
                            ),
                            // const SizedBox(
                            //   width: 1,
                            // ),
                            InkWell(
                                onTap: (() {
                                  _onRight();
                                }),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 12),
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
                                  ),
                                )),
                          ]),
                        ),
                      ],
                    )),
              );
            })));
  }

  void _blocListener(BuildContext context, CalendarState state) {
    if (state is GetDateIntervalProgressSuccess) {
      _datesProgress = state.datesProgress;

      _initList(_currentDate);
    } else if (state is GetDateIntervalProgressFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    }
  }

  _onLeft() {
    _currentDate = DateTime(_currentDate.year, _currentDate.month, _currentDate.day - 7);
    _startDate = _startDate.add(new Duration(days: -7));
    _endDate = _endDate.add(new Duration(days: -7));
    BlocManager.calendarBloc.add(
      GetDateIntervalProgressEvent(
        Func.toDateStr(_startDate),
        Func.toDateStr(_endDate),
      ),
    );
    _initList(_currentDate);
  }

  _onRight() {
    _currentDate = DateTime(_currentDate.year, _currentDate.month, _currentDate.day + 7);
    _startDate = _startDate.add(new Duration(days: 7));
    _endDate = _endDate.add(new Duration(days: 7));
    BlocManager.calendarBloc.add(
      GetDateIntervalProgressEvent(
        Func.toDateStr(_startDate),
        Func.toDateStr(_endDate),
      ),
    );
    _initList(_currentDate);
  }

  Widget _day(int index) {
    // double progress = double.parse(days[index].process ?? '0.0');

    return InkWell(
        onTap: () {
          setState(() {
            _selectedDay = fixedWeek[index];

            var date = DateTime(_selectedDay!.year!, fixedWeek[index].month!, _selectedDay!.day!);
            widget.onDateTimeChanged(date);
          });
        },
        child: (fixedWeek[index].year == _selectedDay!.year &&
                fixedWeek[index].day == _selectedDay!.day &&
                fixedWeek[index].dayName == _selectedDay!.dayName)
            ? Container(
                width: ResponsiveFlutter.of(context).wp(10),
                height: ResponsiveFlutter.of(context).hp(14),
                margin: EdgeInsets.only(right: 8),
                padding: EdgeInsets.only(top: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: customColors.primary,
                ),
                child: Column(
                  children: [
                    Text(
                      '${fixedWeek[index].dayName}',
                      style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                    Text('${fixedWeek[index].day}', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                  ],
                ),
              )
            : Container(
                padding: EdgeInsets.all(1),
                margin: EdgeInsets.only(
                  right: 5.5,
                ),
                child: SquarePercentIndicator(
                  width: ResponsiveFlutter.of(context).wp(10),
                  height: ResponsiveFlutter.of(context).hp(14),
                  borderRadius: 10,
                  progressWidth: 1,
                  shadowWidth: 1,
                  shadowColor: customColors.greyText,
                  progressColor: customColors.primary,
                  startAngle: StartAngle.topLeft,
                  progress: double.parse(fixedWeek[index].process ?? "0.0") / 100,
                  child: Container(
                    padding: EdgeInsets.only(top: 5),
                    child: Column(
                      children: [
                        Text(
                          '${fixedWeek[index].dayName}',
                          style: TextStyle(
                              color: fixedWeek[index] == _selectedDay ? Colors.black : Colors.grey, fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                        Text('${fixedWeek[index].day}',
                            style: TextStyle(
                                color: fixedWeek[index] == _selectedDay ? Colors.black : Colors.grey, fontSize: 13, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
              ));
  }
}
