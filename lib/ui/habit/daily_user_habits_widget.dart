import 'package:flutter/material.dart';

class DailyUserHabits extends StatefulWidget {
  final DateTime date;

  const DailyUserHabits({
    Key? key,
    required this.date,
  }) : super(key: key);

  @override
  _DailyUserHabitsState createState() => _DailyUserHabitsState();
}

class _DailyUserHabitsState extends State<DailyUserHabits> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //
      ],
    );
  }
}
