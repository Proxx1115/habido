import 'package:flutter/material.dart';
import 'package:habido_app/models/custom_habit_settings_response.dart';
import 'package:habido_app/models/habit.dart';
import 'package:habido_app/models/user_habit.dart';
import 'package:habido_app/ui/habit_new/user_habit_v2/user_habit_screen_v2.dart';
import 'package:showcaseview/showcaseview.dart';

class UserHabitRouteV2 extends StatefulWidget {
  final String screenMode;
  final Habit habit;
  final UserHabit? userHabit;
  final CustomHabitSettingsResponse? customHabitSettings;
  final String? title;

  const UserHabitRouteV2({
    Key? key,
    required this.screenMode,
    required this.habit,
    this.userHabit,
    this.customHabitSettings,
    this.title,
  }) : super(key: key);

  @override
  UserHabitRouteV2State createState() => UserHabitRouteV2State();
}

class UserHabitRouteV2State extends State<UserHabitRouteV2> {
  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: Builder(
        builder: (context) {
          return UserHabitScreenV2(
            screenMode: widget.screenMode,
            habit: widget.habit,
            userHabit: widget.userHabit,
            customHabitSettings: widget.customHabitSettings,
            title: widget.title,
          );
        },
      ),
    );
  }
}
