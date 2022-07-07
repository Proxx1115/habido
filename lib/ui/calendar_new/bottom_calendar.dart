import 'package:flutter/material.dart';
import 'package:habido_app/ui/calendar_new/day_model.dart';
import 'package:habido_app/utils/responsive_flutter/responsive_flutter.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';

class BottomCalendar extends StatefulWidget {
  final DateTime? initialDate;
  final ValueChanged<DateTime> onDateTimeChanged;
  BottomCalendar({Key? key, required this.onDateTimeChanged, this.initialDate}) : super(key: key);

  @override
  State<BottomCalendar> createState() => _BottomCalendarState();
}

class _BottomCalendarState extends State<BottomCalendar> {
  List<DayModel> _monthList = [];
  DateTime _currentDateTime = DateTime.now();
  List<String> _weekNameList = ['Да', 'Мя', 'Лх', 'Пү', 'Ба', 'Бя', 'Ня'];
  DayModel? _selectedDayModel;
  late DateTime _selectedDate;

  @override
  void initState() {
    _currentDateTime = DateTime(_currentDateTime.year, _currentDateTime.month);
    _initList(_currentDateTime);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  _initList(DateTime date) {
    _monthList.clear();
    var weekDay = date.weekday;
    for (int i = 1; i <= 35; i++) {
      var firstDayOfWeek = date.subtract(Duration(days: weekDay - i));
      DayModel currentDay =
          DayModel(firstDayOfWeek.day, _weekDay(firstDayOfWeek.weekday), (i * 10).toString(), month: firstDayOfWeek.month, year: firstDayOfWeek.year);
      _monthList.add(currentDay);
    }
    var curDay = widget.initialDate ?? DateTime.now();
    print("curDay ${widget.initialDate}");
    _selectedDayModel = _monthList.where((element) => element.day == curDay.day).first;
    setState(() {});
  }

  String _weekDay(int week) {
    if (week == 0) {
      return 'Да';
    } else if (week == 1) {
      return 'Мя';
    } else if (week == 2) {
      return 'Лх';
    } else if (week == 3) {
      return 'Пү';
    } else if (week == 4) {
      return 'Ба';
    } else if (week == 5) {
      return 'Бя';
    } else {
      return 'Ня';
    }
  }

  String _weekFullName(int week) {
    if (week == 1) {
      return 'Даваа';
    } else if (week == 2) {
      return 'Мягмар';
    } else if (week == 3) {
      return 'Лхагва';
    } else if (week == 4) {
      return 'Пүрэв';
    } else if (week == 5) {
      return 'Баасан';
    } else if (week == 6) {
      return 'Бямба';
    } else {
      return 'Ням';
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
    return Container(
      margin: EdgeInsets.all(ResponsiveFlutter.of(context).fontSize(1.5)),
      padding: EdgeInsets.all(ResponsiveFlutter.of(context).fontSize(2)),
      width: ResponsiveFlutter.of(context).wp(100),
      height: ResponsiveFlutter.of(context).hp(50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(ResponsiveFlutter.of(context).fontSize(1)),
              color: Colors.grey[100],
              child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                SizedBox(
                  width: ResponsiveFlutter.of(context).wp(2),
                ),
                Expanded(
                  child: InkWell(
                      onTap: (() {
                        _currentDateTime = DateTime(
                          _currentDateTime.year,
                          _currentDateTime.month - 1,
                        );
                        _initList(_currentDateTime);
                      }),
                      child: Container(
                          decoration: BoxDecoration(
                              // border: Border.all(width: 0),
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(ResponsiveFlutter.of(context).fontSize(7)))),
                          child: const Icon(Icons.keyboard_arrow_left))),
                ),
                Expanded(
                  flex: 8,
                  child: Text(
                    ' ${_monthName(_currentDateTime.month)} - ${_currentDateTime.year}',
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                    child: InkWell(
                  onTap: (() {
                    _currentDateTime = DateTime(_currentDateTime.year, _currentDateTime.month + 1, _currentDateTime.day);
                    _initList(_currentDateTime);
                  }),
                  child: Container(
                      decoration: BoxDecoration(
                          // border: Border.all(),
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(ResponsiveFlutter.of(context).fontSize(7)))),
                      child: const Icon(Icons.keyboard_arrow_right)),
                )),
                SizedBox(
                  width: ResponsiveFlutter.of(context).wp(2),
                ),
              ]),
            ),
          ),
          SizedBox(
            height: ResponsiveFlutter.of(context).hp(1),
          ),
          Expanded(
            child: Container(
                // padding: EdgeInsets.all(ResponsiveFlutter.of(context).fontSize(1)),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(ResponsiveFlutter.of(context).fontSize(2))),
                    border: Border.all(width: 0, color: Colors.grey)),
                child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _weekNameList.length,
                  primary: false,
                  itemBuilder: (context, index) {
                    return Center(child: Text(_weekNameList[index]));
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                  ),
                )),
          ),
          SizedBox(
            height: ResponsiveFlutter.of(context).fontSize(1),
          ),
          Expanded(
            flex: 7,
            child: GridView.builder(
              itemCount: _monthList.length,
              primary: false,
              // padding: const EdgeInsets.all(20),
              itemBuilder: (context, index) {
                return _dayItem(_monthList[index]);
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _dayItem(DayModel day) {
    return Container(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedDayModel = day;
            _selectedDate = new DateTime(day.year!, day.month!, day.day!);
            widget.onDateTimeChanged(_selectedDate);
          });
          print(_selectedDayModel!.day);

          // Navigator.pop(context);
        },
        child: Container(
          decoration: BoxDecoration(
            color: _selectedDayModel == day ? customColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(5.0),
          ),
          margin: EdgeInsets.all(ResponsiveFlutter.of(context).fontSize(1)),
          child: Center(
              child: Text(day.day.toString(),
                  style: TextStyle(
                    // color: (currentDateTime.month != day.month ? Colors.grey : Colors.black),
                    color: _selectedDayModel == day
                        ? customColors.whiteText
                        : _currentDateTime.month != day.month
                            ? Colors.grey
                            : Colors.black,
                    fontSize: ResponsiveFlutter.of(context).fontSize(1.9),
                  ))),
        ),
      ),
    );
  }

  Widget _weekName(index) {
    print('index:$index');
    return Container(
        margin: EdgeInsets.only(right: ResponsiveFlutter.of(context).fontSize(2), left: ResponsiveFlutter.of(context).fontSize(1.3)),
        child: Center(
          child: Text(
            _weekDay(index),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: ResponsiveFlutter.of(context).fontSize(1.9),
            ),
          ),
        ));
  }
}
