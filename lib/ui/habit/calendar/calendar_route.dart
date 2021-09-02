import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/calendar_bloc.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/localization/localization_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
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

  @override
  void initState() {
    // Calendar
    _selectedDay = _focusedDay = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    _startDate = _focusedDay.add(Duration(days: -60));
    _endDate = _focusedDay.add(Duration(days: 365));
    _endDate = _focusedDay.add(Duration(days: 365));
    _endDate = _focusedDay.add(Duration(days: 365));

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
    BlocManager.calendarBloc.add(GetCalendarEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: LocaleKeys.monthlyCalendar,
      body: BlocProvider.value(
        value: BlocManager.calendarBloc,
        child: BlocListener<CalendarBloc, CalendarState>(
          listener: _blocListener,
          child: Column(
            children: [
              /// Календар
              _calendar(),

              /// Events
              // ..._getEventsFromDay(_selectedDay).map((e) => CustomText(e.title)),
            ],
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
    }
  }

  Widget _calendar() {
    return TableCalendar(
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
          decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(10.0)),
          child: Text(
            date.day.toString(),
            style: TextStyle(color: Colors.white),
          ),
        ),
        todayBuilder: (context, date, events) => Container(
          margin: const EdgeInsets.all(4.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(10.0)),
          child: Text(
            date.day.toString(),
            style: TextStyle(color: Colors.white),
          ),
        ),
        // markerBuilder:
        defaultBuilder: (context, date, events) => Container(
          margin: const EdgeInsets.all(4.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _getColor(date),
            borderRadius: BorderRadius.circular(10.0),
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
          _selectedDay = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
          _focusedDay = DateTime(focusedDay.year, focusedDay.month, focusedDay.day);
        });
      },

      // Event
      // eventLoader: _getEventsFromDay,
    );
  }

  Color _getColor(DateTime date) {
    DateTime tempDate = convertDate(date);

    if (_dateListWithHabits?.contains(tempDate) ?? false) {
      return customColors.iconRed;
    } else {
      return Colors.transparent;
    }
    // return (_dateListWithHabits?.contains(tempDate) ?? false) ? customColors.iconRed : Colors.transparent;
  }

  DateTime convertDate(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }
}
