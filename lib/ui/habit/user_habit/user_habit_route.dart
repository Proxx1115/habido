import 'package:flutter/material.dart';
import 'package:habido_app/models/custom_habit_settings_response.dart';
import 'package:habido_app/models/habit.dart';
import 'package:habido_app/models/user_habit.dart';
import 'package:showcaseview/showcaseview.dart';
import 'user_habit_screen.dart';

class UserHabitRoute extends StatefulWidget {
  final String screenMode;
  final Habit habit;
  final UserHabit? userHabit;
  final CustomHabitSettingsResponse? customHabitSettings;
  final String? title;

  const UserHabitRoute({
    Key? key,
    required this.screenMode,
    required this.habit,
    this.userHabit,
    this.customHabitSettings,
    this.title,
  }) : super(key: key);

  @override
  _UserHabitRouteState createState() => _UserHabitRouteState();
}

class _UserHabitRouteState extends State<UserHabitRoute> {
  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: Builder(
        builder: (context) {
          return UserHabitScreen(
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
