import 'package:flutter/material.dart';
import 'package:habido_app/ui/habit/progress/habit_finance/total_expense_route.dart';

class HabitDetailWithExpenseRoute extends StatefulWidget {
  final int? userHabitId;
  final String? name;
  const HabitDetailWithExpenseRoute({
    Key? key,
    this.userHabitId,
    this.name,
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
    return HabitTotalExpenseRoute(userHabitId: widget.userHabitId!);
  }
}
