import 'package:flutter/material.dart';
import 'package:habido_app/widgets/text.dart';

class DailyHabitsWidget extends StatefulWidget {
  final DateTime dateTime;

  const DailyHabitsWidget({Key? key, required this.dateTime}) : super(key: key);

  @override
  _DailyHabitsWidgetState createState() => _DailyHabitsWidgetState();
}

class _DailyHabitsWidgetState extends State<DailyHabitsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomText('Daily habits'),
      ],
    );
  }
}
