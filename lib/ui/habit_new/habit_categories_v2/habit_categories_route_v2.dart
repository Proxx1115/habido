import 'package:flutter/material.dart';
import 'package:habido_app/ui/habit/habit_categories/habit_categories_screen.dart';
import 'package:habido_app/ui/habit_new/habit_categories_v2/habit_categories_screen_v2.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:showcaseview/showcaseview.dart';

class HabitCategoriesRouteV2 extends StatefulWidget {
  const HabitCategoriesRouteV2({Key? key}) : super(key: key);

  @override
  _HabitCategoriesRouteV2State createState() => _HabitCategoriesRouteV2State();
}

class _HabitCategoriesRouteV2State extends State<HabitCategoriesRouteV2> {
  // UI
  final _habitCategoriesKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: Builder(
        builder: (context) {
          return CustomScaffold(
            scaffoldKey: _habitCategoriesKey,
            appBarTitle: LocaleKeys.createHabit,
            child: HabitCategoriesScreenV2(),
          );
        },
      ),
    );
  }
}
