import 'package:flutter/material.dart';
import 'package:habido_app/models/habit.dart';
import 'package:habido_app/models/plans.dart';
import 'package:habido_app/models/user_habit.dart';
import 'package:habido_app/models/user_habit_reminders.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/widgets/scaffold.dart';

class HabitRoute extends StatefulWidget {
  final String? title;
  final Habit habit;

  const HabitRoute({Key? key, this.title, required this.habit}) : super(key: key);

  @override
  _HabitRouteState createState() => _HabitRouteState();
}

class _HabitRouteState extends State<HabitRoute> {
  @override
  void initState() {
    print(widget.habit.name);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: LocaleKeys.createHabit,
      body: Container(),
    );
  }

  // Habit
  // int? habitId;
  // int? categoryId;
  // String? name;
  // bool? hasGoal;
  // int? goalTypeId;
  // int? toolId;
  // int? contentId;
  // bool? isFinance;
  // String? note;

  // goalTypeId = ''
  //

  //

  // Duration

  // static const String Time = 'Time';
  // static const String Water = 'Water';
  // static const String Breathing = 'Breathing';

  _onPressedButtonSave() {
    var request = UserHabit()
      // ..userHabitId = 0
      // ..userId = 1
      ..habitId = widget.habit.habitId
      ..name = 'Явган алхах'
      ..startDate = '' //everyday
      ..endDate = '' //everyday
      ..isReminder = true
      ..repeatName = PlanTerm.Daily //'Daily' //'Weekly', 'Monthly'
      ..hasGoal = false
      ..goalValue = ''
      ..note = ''
      ..userNote = ''
      ..status = ''
      ..userHabitReminders = [
        UserHabitReminders()
          // ..reminderId;
          // ..userHabitId;
          ..time = 1 // minutaar
      ]
      ..plans = [
        // monthly
        // Plans()
        //   ..planDate = '2021-08-27'
        //   ..term = PlanTerm.Monthly,
        // Plans()
        //   ..weekDay = '2021-08-27'
        //   ..term = PlanTerm.Monthly,
        //
        // // weekly
        // Plans()
        //   ..weekDay = WeekDays.Mon
        //   ..term = PlanTerm.Weekly,
        // Plans()
        //   ..weekDay = WeekDays.Fri
        //   ..term = PlanTerm.Week,

        //everyday null
      ];
  }
}
