import 'package:flutter/material.dart';
import 'package:habido_app/models/user_habit.dart';
import 'package:habido_app/ui/habit/progress/habit_finance/total_expense_route.dart';

class HabitDetailWithExpenseRoute extends StatefulWidget {
  final UserHabit? userHabit;
  final bool? isActive;
  final Function? refreshHabits;
  const HabitDetailWithExpenseRoute({
    Key? key,
    this.userHabit,
    this.isActive = false,
    this.refreshHabits,
  }) : super(key: key);

  @override
  State<HabitDetailWithExpenseRoute> createState() => _HabitDetailWithCountRouteState();
}

class _HabitDetailWithCountRouteState extends State<HabitDetailWithExpenseRoute> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HabitTotalExpenseRoute(userHabit: widget.userHabit!, isActive: widget.isActive, refreshHabits: widget.refreshHabits);
  }
}
