import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/calendar_bloc.dart';
import 'package:habido_app/models/user_habit.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/localization/localization_helper.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/utils/theme/hex_color.dart';
import 'package:habido_app/widgets/animations/animations.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:table_calendar/table_calendar.dart';

class Event {
  final String title;

  Event({required this.title});
}

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

  // Events
  // Map<DateTime, List<Event>> _selectedEvents = {};

  // List<Event> _getEventsFromDay(DateTime date) {
  //   var res = _selectedEvents[DateTime(date.year, date.month, date.day)];
  //   print(date);
  //   print(res);
  //   return res ?? [];
  // }

  // Dates with habits
  List<DateTime>? _dateListWithHabits;

  // User habits
  List<UserHabit>? _dailyUserHabitList;

  @override
  void initState() {
    // Calendar
    _selectedDay = _focusedDay = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    _startDate = _focusedDay.add(Duration(days: -60));
    _endDate = _focusedDay.add(Duration(days: 365));

    BlocManager.calendarBloc.add(
      GetCalendarDateEvent(
        Func.toDateStr(DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day)),
      ),
    );

    // Events
    // _selectedEvents[DateTime(2021, 9, 3)] = [
    //   Event(title: 'test1'),
    //   Event(title: 'test2'),
    // ];
    //
    // _selectedEvents[DateTime(2021, 9, 4)] = [
    //   Event(title: 'test3'),
    //   Event(title: 'test4'),
    // ];

    var now = DateTime.now();
    BlocManager.calendarBloc.add(
      GetCalendarEvent(
        Func.toDateStr(DateTime(now.year, now.month - 1, 23)),
        Func.toDateStr(DateTime(now.year, now.month + 1, 7)),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: LocaleKeys.monthlyCalendar,
      backgroundColor: customColors.secondaryBackground,
      appBarLeadingBackgroundColor: customColors.primaryBackground,
      body: BlocProvider.value(
        value: BlocManager.calendarBloc,
        child: BlocListener<CalendarBloc, CalendarState>(
          listener: _blocListener,
          child: BlocBuilder<CalendarBloc, CalendarState>(
            builder: (context, state) {
              return Column(
                children: [
                  /// Календар
                  _calendar(),

                  /// Events
                  Expanded(
                    child: Container(
                      color: customColors.primaryBackground,
                      margin: EdgeInsets.only(top: 10.0),
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, SizeHelper.marginBottom),
                      child: (_dailyUserHabitList != null)
                          ? ListView(
                              children: [
                                for (int i = 0; i < _dailyUserHabitList!.length; i++)
                                  MoveInAnimation(
                                    child: ListItemContainer(
                                      title: _dailyUserHabitList![i].name ?? '',
                                      leadingImageUrl: _dailyUserHabitList![i].habit?.photo,
                                      leadingBackgroundColor: (_dailyUserHabitList![i].habit?.color != null)
                                          ? HexColor.fromHex(_dailyUserHabitList![i].habit!.color!)
                                          : null,
                                      margin: EdgeInsets.fromLTRB(15.0, i == 0 ? 25.0 : 10.0, 15.0, 0.0),
                                      height: 70.0,
                                      suffixAsset: Assets.arrow_forward,
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          Routes.habitTimer,
                                          arguments: {
                                            'userHabit': _dailyUserHabitList![i],
                                          },
                                        );
                                      },
                                    ),
                                  ),
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
    );
  }

  void _blocListener(BuildContext context, CalendarState state) {
    if (state is CalendarSuccess) {
      _dateListWithHabits = state.dateList;

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
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    } else if (state is CalendarDateSuccess) {
      _dailyUserHabitList = state.userHabitList;
    } else if (state is CalendarDateFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    }
  }

  Widget _calendar() {
    return Container(
      margin: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
      child: TableCalendar(
        // General
        locale: LocaleCode.mn_MN,
        startingDayOfWeek: StartingDayOfWeek.monday,
        firstDay: _startDate,
        lastDay: _endDate,

        // Style
        calendarStyle: CalendarStyle(
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
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),

        // Builder
        calendarBuilders: CalendarBuilders(
          selectedBuilder: (context, date, events) => Container(
            margin: const EdgeInsets.all(4.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: customColors.primary,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Text(
              date.day.toString(),
              style: TextStyle(color: Colors.white),
            ),
          ),
          todayBuilder: (context, date, events) => Container(
            margin: const EdgeInsets.all(4.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: customColors.primaryBackground,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Text(
              date.day.toString(),
              style: TextStyle(color: customColors.secondaryText),
            ),
          ),
          defaultBuilder: (context, date, events) => Container(
            margin: const EdgeInsets.all(4.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _getColor(date),
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                width: SizeHelper.borderWidth,
                color: _getBorderColor(date),
              ),
            ),
            child: Text(
              date.day.toString(),
              style: TextStyle(color: customColors.secondaryText),
            ),
          ),
        ),

        // Format
        calendarFormat: _calendarFormat,
        availableCalendarFormats: {CalendarFormat.month: 'Month'},
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },

        // Focused day
        focusedDay: _focusedDay,
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },

        // Selected day
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _dailyUserHabitList = [];

            _selectedDay = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
            _focusedDay = DateTime(focusedDay.year, focusedDay.month, focusedDay.day);

            BlocManager.calendarBloc.add(
              GetCalendarDateEvent(
                Func.toDateStr(DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day)),
              ),
            );
          });
        },

        // Event
        // eventLoader: _getEventsFromDay,
      ),
    );
  }

  Color _getColor(DateTime date) {
    DateTime tempDate = convertDate(date);

    if (_dateListWithHabits?.contains(tempDate) ?? false) {
      if (tempDate.isBefore(convertDate(DateTime.now()))) {
        return customColors.greyBackground;
      }
    }

    return Colors.transparent;
  }

  Color _getBorderColor(DateTime date) {
    DateTime tempDate = convertDate(date);

    if (_dateListWithHabits?.contains(tempDate) ?? false) {
      if (tempDate.isBefore(convertDate(DateTime.now()))) {
        return Colors.transparent;
      } else {
        return customColors.primary;
      }
    } else {
      return customColors.roseWhiteBorder;
    }
  }

  DateTime convertDate(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }
}
