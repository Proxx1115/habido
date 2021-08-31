import 'package:flutter/material.dart';
import 'package:habido_app/ui/habit/daily_habits/daily_habits_widget.dart';
import 'package:habido_app/ui/home/home_app_bar.dart';
import 'package:habido_app/ui/home/slider/custom_carousel_slider.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/scaffold.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: customColors.primary,
      body: Stack(
        children: [
          Column(
            children: [
              /// Slider
              CustomCarouselSlider(margin: EdgeInsets.only(top: 30.0)),

              /// Body
              _habitList(),
            ],
          ),

          /// Calendar, Title, Notification
          HomeAppBar(),
        ],
      ),
      floatingActionButton: ButtonStadium(
        style: ButtonStadiumStyle.Secondary,
        asset: Assets.add,
        onPressed: () {
          Navigator.pushNamed(context, Routes.habitCategories);
        },
      ),
    );
  }

  _habitList() {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(35.0), topRight: Radius.circular(35.0)),
        child: Container(
          decoration: BoxDecoration(
            color: customColors.secondaryBackground,
          ),
          padding: EdgeInsets.fromLTRB(SizeHelper.padding, 35.0, SizeHelper.padding, SizeHelper.marginBottom),
          child: ListView(
            children: [
              DailyHabitsWidget(
                dateTime: DateTime.now(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
