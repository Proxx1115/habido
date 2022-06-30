import 'package:flutter/material.dart';
import 'package:habido_app/ui/calendar_new/day_model.dart';
import 'package:habido_app/utils/responsive_flutter/responsive_flutter.dart';

class BottomCalendar extends StatefulWidget {
  BottomCalendar({Key? key}) : super(key: key);

  @override
  State<BottomCalendar> createState() => _BottomCalendarState();
}

class _BottomCalendarState extends State<BottomCalendar> {
  List<DayModel> monthList = [];
  var currentDateTime = DateTime.now();
  List<String> weekNameList = ['Да', 'Мя', 'Лх', 'Пү', 'Ба', 'Бя', 'Ня'];
  DayModel? selectedDate;

  @override
  void initState() {
    currentDateTime = DateTime(currentDateTime.year, currentDateTime.month);
    _initList(currentDateTime);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  _initList(DateTime date) {
    monthList.clear();
    var weekDay = date.weekday;
    for (int i = 1; i <= 35; i++) {
      var firstDayOfWeek = date.subtract(Duration(days: weekDay - i));
      DayModel currentDay =
          DayModel(firstDayOfWeek.day, _weekDay(firstDayOfWeek.weekday), (i * 10).toString(), firstDayOfWeek.month, firstDayOfWeek.year);
      monthList.add(currentDay);
    }
    var curDay = DateTime.now();
    selectedDate = monthList.where((element) => element.day == curDay.day).first;
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
                        currentDateTime = DateTime(
                          currentDateTime.year,
                          currentDateTime.month - 1,
                        );
                        _initList(currentDateTime);
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
                    ' ${_monthName(currentDateTime.month)} - ${currentDateTime.year}',
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                    child: InkWell(
                  onTap: (() {
                    currentDateTime = DateTime(currentDateTime.year, currentDateTime.month + 1, currentDateTime.day);
                    _initList(currentDateTime);
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
                  itemCount: weekNameList.length,
                  primary: false,
                  itemBuilder: (context, index) {
                    return Center(child: Text(weekNameList[index]));
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
              itemCount: monthList.length,
              primary: false,
              // padding: const EdgeInsets.all(20),
              itemBuilder: (context, index) {
                return _dayItem(monthList[index]);
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
    return InkWell(
      onTap: () {
        print('test:${currentDateTime.month}:: ${day.month}');
        setState(() {
          selectedDate = day;
        });
      },
      child: Container(
        color: selectedDate == day ? Colors.orange : Colors.transparent,
        margin: EdgeInsets.all(ResponsiveFlutter.of(context).fontSize(1)),
        child: Center(
            child: Text(day.day.toString(),
                style: TextStyle(
                  color: currentDateTime.month != day.month ? Colors.grey : Colors.black,
                  fontSize: ResponsiveFlutter.of(context).fontSize(1.9),
                ))),
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
