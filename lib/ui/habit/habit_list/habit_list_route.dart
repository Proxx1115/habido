import 'package:flutter/material.dart';
import 'package:habido_app/models/habit_category.dart';
import 'package:showcaseview/showcaseview.dart';
import 'habit_list_screen.dart';

class HabitListRoute extends StatefulWidget {
  final HabitCategory habitCategory;

  const HabitListRoute({Key? key, required this.habitCategory}) : super(key: key);

  @override
  _HabitListRouteState createState() => _HabitListRouteState();
}

class _HabitListRouteState extends State<HabitListRoute> {
  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: Builder(
        builder: (context) {
          return HabitListScreen(habitCategory: widget.habitCategory);
        },
      ),
    );
  }
}
