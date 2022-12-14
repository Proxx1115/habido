import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/calendar_bloc.dart';
import 'package:habido_app/models/habit_calendar_response.dart';
import 'package:habido_app/models/user_habit.dart';
import 'package:habido_app/ui/habit/habit_helper.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/localization/localization_helper.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/utils/theme/hex_color.dart';
import 'package:habido_app/widgets/animations/animations.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarRoute extends StatefulWidget {
  const CalendarRoute({Key? key}) : super(key: key);

  @override
  _CalendarRouteState createState() => _CalendarRouteState();
}

class _CalendarRouteState extends State<CalendarRoute> {
  // Calendar
  var _calendarFormat = CalendarFormat.month;
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  late DateTime _startDate;
  late DateTime _endDate;

  // Dates with habits
  List<HabitCalendarEvent>? _calendarEventList;

  // User habits
  List<UserHabit>? _dailyUserHabitList;

  @override
  void initState() {
    // Calendar
    _selectedDay = _focusedDay =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    _startDate = _focusedDay.add(Duration(days: -60));
    _endDate = _focusedDay.add(Duration(days: 365));

    BlocManager.calendarBloc.add(
      GetCalendarDateEvent(
        Func.toDateStr(
            DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day)),
      ),
    );

    var now = DateTime.now();
    BlocManager.calendarBloc.add(
      GetCalendarEvent(
        Func.toDateStr(DateTime(now.year, now.month - 2, 1)),
        Func.toDateStr(DateTime(now.year + 1, now.month, 28)),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScaffold(
        appBarTitle: LocaleKeys.monthlyCalendar,
        backgroundColor: customColors.whiteBackground,
        appBarLeadingBackgroundColor: customColors.primaryBackground,
        child: BlocProvider.value(
          value: BlocManager.calendarBloc,
          child: BlocListener<CalendarBloc, CalendarState>(
            listener: _blocListener,
            child: BlocBuilder<CalendarBloc, CalendarState>(
              builder: (context, state) {
                return Column(
                  children: [
                    /// ????????????????
                    _calendar(),

                    /// Events
                    Expanded(
                      child: Container(
                        color: customColors.primaryBackground,
                        margin: EdgeInsets.only(top: 10.0),
                        padding: EdgeInsets.fromLTRB(
                            0.0, 0.0, 0.0, SizeHelper.marginBottom),
                        child: (_dailyUserHabitList != null)
                            ? ListView(
                                children: [
                                  for (int i = 0;
                                      i < _dailyUserHabitList!.length;
                                      i++)
                                    _listItem(i),
                                ],
                              )
                            : Container(),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, CalendarState state) {
    if (state is CalendarSuccess) {
      _calendarEventList = state.calendarEventList;

      setState(() {
        print('hello there');
      });

      // Future.delayed(Duration(milliseconds: 2000), () {
      //   setState(() {
      //     print('hello there');
      //   });
      // });
    } else if (state is CalendarFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(
            asset: Assets.error,
            text: state.message,
            buttonText: LocaleKeys.ok),
      );
    } else if (state is CalendarDateSuccess) {
      _dailyUserHabitList = state.userHabitList;
    } else if (state is CalendarDateFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(
            asset: Assets.error,
            text: state.message,
            buttonText: LocaleKeys.ok),
      );
    }
  }

  Widget _calendar() {
    return Container(
      margin: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
      child: TableCalendar(
        /// General
        locale: LocaleCode.mn_MN,
        startingDayOfWeek: StartingDayOfWeek.monday,
        firstDay: _startDate,
        lastDay: _endDate,

        /// Style
        calendarStyle: _calendarStyle(),
        headerStyle: _headerStyle(),
        // weekendDays: [5, 6, 7],

        /// Builders
        calendarBuilders: CalendarBuilders(
          selectedBuilder: _selectedBuilder,
          todayBuilder: _todayBuilder,
          defaultBuilder: _defaultBuilder,
          markerBuilder: _markerBuilder,
          // outsideBuilder: _markerBuilder,
          // disabledBuilder: _defaultBuilder,
        ),

        /// Format
        calendarFormat: _calendarFormat,
        availableCalendarFormats: {CalendarFormat.month: 'Month'},
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },

        /// Focused day
        focusedDay: _focusedDay,
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },

        /// Selected day
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _dailyUserHabitList = [];

            _selectedDay =
                DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
            _focusedDay =
                DateTime(focusedDay.year, focusedDay.month, focusedDay.day);

            BlocManager.calendarBloc.add(
              GetCalendarDateEvent(
                Func.toDateStr(DateTime(
                    _selectedDay.year, _selectedDay.month, _selectedDay.day)),
              ),
            );
          });
        },

        // Events
        eventLoader: _getEventsFromDay,
      ),
    );
  }

  List<Color> _getEventsFromDay(DateTime date) {
    List<Color> colorList = [];
    if (_calendarEventList != null) {
      for (var el in _calendarEventList!) {
        try {
          DateTime? tempDate = convertDate(Func.toDate(el.date));
          if (tempDate != null &&
              Func.isSameDay(tempDate, date) &&
              el.colors != null &&
              el.colors!.isNotEmpty) {
            for (var c in el.colors!) {
              late Color color;
              if (isSameDay(_selectedDay, date)) {
                color = customColors.iconWhite;
              } else {
                color = Func.isNotEmpty(c)
                    ? HexColor.fromHex(c)
                    : customColors.primary;
              }

              colorList.add(color);
            }
          }
        } catch (e) {
          print(e);
        }
      }
    }

    List<Color> res = [];
    if (colorList.length > 3) {
      for (int i = 0; i < 3; i++) res.add(colorList[i]);
    } else {
      res = colorList;
    }

    return res;
  }

  CalendarStyle _calendarStyle() {
    return CalendarStyle(
      isTodayHighlighted: true,
      // selectedDecoration: BoxDecoration(
      // color: customColors.primary,
      // shape: BoxShape.rectangle,
      // borderRadius: BorderRadius.all(Radius.circular(10.0)),
      // ),
      // selectedTextStyle: TextStyle(color: customColors.whiteText),
      canMarkersOverflow: true,
      // canEventMarkersOverflow: true,
      // todayColor: Colors.orange,
      // selectedColor: Theme.of(context).primaryColor,
      // todayStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.white),
    );
  }

  HeaderStyle _headerStyle() {
    return HeaderStyle(
      formatButtonVisible: false,
      titleCentered: true,
      decoration: BoxDecoration(
        color: customColors.primaryBackground,
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      headerPadding: EdgeInsets.all(4.0),
      headerMargin: EdgeInsets.only(top: 15.0, bottom: 20.0),
      titleTextStyle:
          TextStyle(color: customColors.primary, fontWeight: FontWeight.w500),
      // titleTextFormatter: (DateTime date, dynamic locale) {
      //   return Func.toDateStr(date);
      // },
      leftChevronIcon: Container(
        height: 20.0,
        width: 20.0,
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: customColors.whiteBackground,
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
        ),
        child: SvgPicture.asset(Assets.back10),
      ),
      rightChevronIcon: Container(
        height: 20.0,
        width: 20.0,
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: customColors.whiteBackground,
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
        ),
        child: SvgPicture.asset(Assets.forward10),
      ),
    );
  }

  Widget? _todayBuilder(
          BuildContext context, DateTime day, DateTime focusedDay) =>
      Container(
        margin: const EdgeInsets.all(4.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: customColors.primaryBackground,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            width: SizeHelper.borderWidth,
            color: _getBorderColor(day),
          ),
        ),
        child: Text(
          day.day.toString(),
          style: TextStyle(color: customColors.greyText),
        ),
      );

  Widget? _defaultBuilder(
          BuildContext context, DateTime day, DateTime focusedDay) =>
      Container(
        margin: const EdgeInsets.all(4.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _getColor(day),
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            width: SizeHelper.borderWidth,
            color: _getBorderColor(day),
          ),
        ),
        child: Text(
          day.day.toString(),
          style: TextStyle(color: customColors.greyText),
        ),
      );

  Widget? _markerBuilder(BuildContext context, DateTime day, events) {
    List<Color> colorList = _getEventsFromDay(day);

    return Positioned(
      bottom: 10.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var el in colorList) _marker(el),
        ],
      ),
    );
  }

  Widget _marker(Color color) {
    return Container(
      margin: EdgeInsets.fromLTRB(1.0, 0.0, 1.0, 0.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      width: 5.0,
      height: 5.0,
    );
  }

  // Widget _buildEventsMarkerNum(List events) {
  //   return DaisyWidget().buildCalendarDayMarker(
  //       text: '${events.length}',
  //       backColor: privateLength == 0
  //           ? DaisyColors.main0Color
  //           : DaisyColors.serveColor);
  // }

  // markersBuilder: (context, date, events, holidays) {
  // final children = <Widget>[];
  // if (events.isNotEmpty) {
  // children.add(
  // Positioned(
  // bottom: 1,
  // child: _buildEventsMarkerNum(date),
  // ),
  // );
  // }
  // return children;
  // },

  Widget? _selectedBuilder(
          BuildContext context, DateTime day, DateTime focusedDay) =>
      Container(
        margin: const EdgeInsets.all(4.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: customColors.primary,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          day.day.toString(),
          style: TextStyle(color: Colors.white),
        ),
      );

  Color _getColor(DateTime date) {
    DateTime? tempDate = convertDate(date);

    // if (_calendarEventList?.contains(tempDate) ?? false) {
    //   if (tempDate.isBefore(convertDate(DateTime.now()))) {
    //     return customColors.greyBackground;
    //   }
    // }

    return Colors.transparent;
  }

  Color _getBorderColor(DateTime date) {
    if (_calendarEventList != null) {
      // bool isFound = false;
      // for (var el in _calendarEventList!) {
      //
      // }

      // if(isFound) {
      //   if (tempDate.isBefore(convertDate(DateTime.now()))) {
      //     return Colors.transparent;
      //   } else {
      //     return customColors.primary;
      //   }
      // } else {
      //   return customColors.roseWhiteBorder;
      // }

      // DateTime? tempDate = convertDate(Func.toDate(el.date));
      // if (tempDate != null && tempDate!.isBefore(convertDate(DateTime.now()))) {
      //   return Colors.transparent;
      // } else {
      //   return customColors.primary;
      // }
      //
      // if (_calendarEventList?.contains(tempDate) ?? false) {
      //   if (tempDate.isBefore(convertDate(DateTime.now()))) {
      //     return Colors.transparent;
      //   } else {
      //     return customColors.primary;
      //   }
      // } else {
      //   return customColors.roseWhiteBorder;
      // }
    } else {
      return customColors.roseWhiteBorder;
    }

    // if (_calendarEventList?.contains(tempDate) ?? false) {
    //   if (tempDate.isBefore(convertDate(DateTime.now()))) {
    //     return Colors.transparent;
    //   } else {
    //     return customColors.primary;
    //   }
    // } else {
    //   return customColors.roseWhiteBorder;
    // }

    return customColors.roseWhiteBorder;
  }

  DateTime? convertDate(DateTime? dateTime) {
    return dateTime != null
        ? DateTime(dateTime.year, dateTime.month, dateTime.day)
        : null;
  }

  Widget _listItem(int i) {
    var suffixAsset;
    var suffixColor;
    if (_dailyUserHabitList![i].habitState == UserHabitPlanState.Done) {
      suffixAsset = Assets.check3;
      suffixColor = customColors.iconSeaGreen;
    } else if (_dailyUserHabitList![i].habitState == UserHabitPlanState.New) {
      suffixAsset = Assets.arrow_forward;
      suffixColor = customColors.primary;
    } else {
      suffixAsset = Assets.refresh;
      suffixColor = customColors.iconSeaGreen;
    }

    return MoveInAnimation(
      delay: i * 0.2,
      child: ListItemContainer(
        title: _dailyUserHabitList![i].name ?? '',
        leadingImageUrl: _dailyUserHabitList![i].habit?.photo,
        leadingColor: customColors.iconWhite,
        leadingBackgroundColor: (_dailyUserHabitList![i].habit?.color != null)
            ? HexColor.fromHex(_dailyUserHabitList![i].habit!.color!)
            : null,
        margin: EdgeInsets.fromLTRB(15.0, i == 0 ? 25.0 : 10.0, 15.0, 0.0),
        height: 70.0,
        suffixAsset: suffixAsset,
        suffixColor: suffixColor,
        // suffixAsset: (_dailyUserHabitList![i].isDone ?? false) ? Assets.check2 : Assets.arrow_forward,
        // suffixColor: (_dailyUserHabitList![i].isDone ?? false) ? customColors.iconSeaGreen : customColors.primary,
        onPressed: () {
          // Is finished
          if (_dailyUserHabitList![i].isDone ?? false) return;

          // Validation
          if (!isSameDay(_selectedDay, DateTime.now()) ||
              !(_dailyUserHabitList![i].habit?.goalSettings != null)) {
            print('not validated');
            return;
          }

          // Navigate
          String? route =
              HabitHelper.getProgressRoute(_dailyUserHabitList![i].habit!);
          if (route != null) {
            Navigator.pushNamed(
              context,
              route,
              arguments: {
                'userHabit': _dailyUserHabitList![i],
                'callBack': () {
                  // Refresh calendar
                  BlocManager.calendarBloc.add(
                    GetCalendarDateEvent(
                      Func.toDateStr(DateTime(_selectedDay.year,
                          _selectedDay.month, _selectedDay.day)),
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
