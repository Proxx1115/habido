import 'package:flutter/material.dart';
import 'package:habido_app/models/habit_category.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:showcaseview/showcaseview.dart';
import 'habit_list_screen.dart';

class HabitListRoute extends StatefulWidget {
  final HabitCategory habitCategory;

  const HabitListRoute({Key? key, required this.habitCategory}) : super(key: key);

  @override
  _HabitListRouteState createState() => _HabitListRouteState();
}

class _HabitListRouteState extends State<HabitListRoute> {
  // UI
  final _habitHabitsKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: Builder(
        builder: (context) {
          return CustomScaffold(
            scaffoldKey: _habitHabitsKey,
            appBarTitle: LocaleKeys.createHabit,
            child: HabitListScreen(habitCategory: widget.habitCategory),
          );
        },
      ),
    );
  }
}
