import 'package:flutter/material.dart';
import 'package:habido_app/widgets/scaffold.dart';

class CalendarRoute extends StatefulWidget {
  const CalendarRoute({Key? key}) : super(key: key);

  @override
  _CalendarRouteState createState() => _CalendarRouteState();
}

class _CalendarRouteState extends State<CalendarRoute> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: 'Calendar',
      body: Column(
        children: [
          //
        ],
      ),
    );
  }
}
