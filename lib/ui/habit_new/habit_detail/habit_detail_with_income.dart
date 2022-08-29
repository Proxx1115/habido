import 'package:flutter/material.dart';
import 'package:habido_app/models/user_habit.dart';
import 'package:habido_app/ui/habit/progress/habit_finance/habit_finance_route.dart';

class HabitDetailWithIncomeRoute extends StatefulWidget {
  final UserHabit? userHabit;
  const HabitDetailWithIncomeRoute({
    Key? key,
    this.userHabit,
  }) : super(key: key);

  @override
  State<HabitDetailWithIncomeRoute> createState() => _HabitDetailWithCountRouteState();
}

class _HabitDetailWithCountRouteState extends State<HabitDetailWithIncomeRoute> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HabitFinanceRoute(userHabit: widget.userHabit!);
  }
}
