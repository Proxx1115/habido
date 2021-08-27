import 'package:flutter/material.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/widgets/scaffold.dart';

class HabitCategoriesRoute extends StatefulWidget {
  const HabitCategoriesRoute({Key? key}) : super(key: key);

  @override
  _HabitCategoriesRouteState createState() => _HabitCategoriesRouteState();
}

class _HabitCategoriesRouteState extends State<HabitCategoriesRoute> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: LocaleKeys.createHabit,
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //
            ],
          ),
        ),
      ),
    );
  }
}
