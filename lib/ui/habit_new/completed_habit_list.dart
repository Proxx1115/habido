import 'package:flutter/material.dart';
import 'package:habido_app/ui/habit_new/habit_item_widget.dart';

class CompletedHabitList extends StatelessWidget {
  const CompletedHabitList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List _completedHabitList = [
      {
        "leadingUrl": "https://i.stack.imgur.com/ILTQq.png",
        "leadingBackgroundColor": "#cccccc",
        "title": "Ус уух",
        "detail": "6 аяга ус уух",
        "startDate": "2022.03.30",
        "endDate": "2022.04.20",
        "type": "Долоо хоног бүр",
        "planDays": [
          "Даваа",
          "Лхагва",
          "Пүрэв",
          "Баас",
        ]
      }
    ];

    return ListView.builder(
      itemBuilder: (context, index) => HabitItemWidget(
        data: _completedHabitList[index],
        isActiveHabit: false,
      ),
      // itemExtent: 90.0,

      itemCount: _completedHabitList.length,
    );
  }

  _navigateToHabitDetailRoute() {
    /// todo
  }
}
