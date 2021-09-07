import 'package:flutter/material.dart';
import 'package:habido_app/widgets/app_bars/dashboard_app_bar.dart';
import 'package:habido_app/ui/home/slider/custom_carousel_slider.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/scaffold.dart';

import 'dashboard_user_habits.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    // return CustomScaffold(body: body);

    return CustomScaffold(
      backgroundColor: customColors.primary,
      body: CustomScrollView(
        slivers: [
          /// Header
          _header(),

          /// Content list
          if (_contentList != null && _contentList!.isNotEmpty)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return _contentRow(index);
                },
                childCount: Func.toInt(_contentList!.length / 2) + (_contentList!.length.isEven ? 0 : 1),
              ),
            ),

          const SliverToBoxAdapter(
            child: SizedBox(height: SizeHelper.marginBottom),
          ),

          // Stack(
          //   children: [
          //     Column(
          //       children: [
          //         /// Slider
          //         CustomCarouselSlider(margin: EdgeInsets.only(top: 30.0)),
          //
          //         /// Body
          //         _userHabitList(),
          //       ],
          //     ),
          //
          //     /// Calendar, Title, Notification
          //     DashboardAppBar(),
          //   ],
          // ),
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

  _header() {
    return SliverAppBar(
      pinned: false,
      snap: true,
      floating: true,
      expandedHeight: 70.0,
      collapsedHeight: 70.0,
      backgroundColor: customColors.primaryBackground,
      // Remove elevation
      elevation: 0,
      // Remove back button
      automaticallyImplyLeading: false,
      title: DashboardAppBar(),
    );
  }

  _userHabitList() {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(35.0), topRight: Radius.circular(35.0)),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(color: customColors.primaryBackground),
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(SizeHelper.padding, 35.0, SizeHelper.padding, SizeHelper.marginBottom),
            child: Container(
              // padding: EdgeInsets.fromLTRB(SizeHelper.padding, 35.0, SizeHelper.padding, SizeHelper.marginBottom),
              child: DashboardUserHabits(),
            ),
          ),
        ),
      ),
    );
  }
}
