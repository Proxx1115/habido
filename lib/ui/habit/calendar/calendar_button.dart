import 'package:flutter/material.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/widgets/buttons.dart';

class CalendarButton extends StatefulWidget {
  const CalendarButton({Key? key}) : super(key: key);

  @override
  _CalendarButtonState createState() => _CalendarButtonState();
}

class _CalendarButtonState extends State<CalendarButton> {
  @override
  Widget build(BuildContext context) {
    return ButtonStadium(
      asset: Assets.calendar,
      onPressed: () {
        Navigator.pushNamed(context, Routes.calendar);
      },
    );
  }
}
