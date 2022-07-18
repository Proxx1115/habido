import 'package:flutter/material.dart';
import 'package:habido_app/ui/habit/habit_categories/habit_categories_screen.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:showcaseview/showcaseview.dart';

class HabitCategoriesRoute extends StatefulWidget {
  const HabitCategoriesRoute({Key? key}) : super(key: key);

  @override
  _HabitCategoriesRouteState createState() => _HabitCategoriesRouteState();
}

class _HabitCategoriesRouteState extends State<HabitCategoriesRoute> {
  // UI
  final _habitCategoriesKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: Builder(
        builder: (context) {
          return SafeArea(
            child: CustomScaffold(
              scaffoldKey: _habitCategoriesKey,
              appBarTitle: LocaleKeys.createHabit,
              child: HabitCategoriesScreen(),
            ),
          );
        },
      ),
    );
  }
}
