import 'package:flutter/material.dart';
import 'package:habido_app/ui/habit/habit_helper.dart';
import 'package:habido_app/widgets/app_bars/dashboard_app_bar.dart';
import 'package:habido_app/ui/home/slider/custom_carousel_slider.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'dashboard_user_habits.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/dashboard_bloc.dart';
import 'package:habido_app/models/user_habit.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/theme/hex_color.dart';
import 'package:habido_app/widgets/containers/expandable_container/expandable_container.dart';
import 'package:habido_app/widgets/containers/expandable_container/expandable_list_item.dart';
import 'package:habido_app/widgets/dialogs.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Slider
  double _sliderAspectRatio = 2.0;
  double? _sliderHeight;
  double _sliderTopMargin = 25.0;
  double _indicatorHeight = 15.0;
  double _indicatorVerticalMargin = 20.0;
  double _scrollHeaderHeight = 35.0;

  // User habits
  List<UserHabit>? _todayUserHabits;

  // bool _isExpandedTodayUserHabits = false;
  List<UserHabit>? _tomorrowUserHabits;

  @override
  void initState() {
    BlocManager.dashboardBloc.add(RefreshDashboardUserHabits());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return CustomScaffold(body: body);

    return CustomScaffold(
      backgroundColor: customColors.primary,
      body: Container(
        color: customColors.primaryBackground,
        child: CustomScrollView(
          slivers: [
            /// Header
            _header(),

            /// Today
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return _userHabits();
                },
                childCount: 1,
              ),
            ),

            // const SliverToBoxAdapter(
            //   child: SizedBox(height: SizeHelper.marginBottom),
            // ),

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
    _sliderHeight = _sliderHeight ?? (MediaQuery.of(context).size.width) / _sliderAspectRatio;

    return SliverAppBar(
      pinned: false,
      snap: true,
      floating: true,
      expandedHeight: _sliderHeight! + _indicatorHeight + _indicatorVerticalMargin * 2 + _scrollHeaderHeight,
      collapsedHeight: _sliderHeight! + _indicatorHeight + _indicatorVerticalMargin * 2 + _scrollHeaderHeight,
      backgroundColor: customColors.primary,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: Stack(
        children: [
          /// Banner
          CustomCarouselSlider(
            aspectRatio: _sliderAspectRatio,
            sliderHeight: _sliderHeight!,
            sliderMargin: EdgeInsets.only(top: _sliderTopMargin),
            indicatorHeight: _indicatorHeight,
            indicatorMargin: EdgeInsets.symmetric(vertical: _indicatorVerticalMargin, horizontal: 2.0),
          ),

          /// Calendar, Title, Notification
          DashboardAppBar(
            padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
          ),

          /// Scroll header
          Positioned(
            bottom: 0.0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(35.0), topRight: Radius.circular(35.0)),
              child: Container(
                height: _scrollHeaderHeight,
                width: MediaQuery.of(context).size.width,
                color: customColors.primaryBackground,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _userHabits() {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(SizeHelper.padding, 0.0, SizeHelper.padding, SizeHelper.marginBottom),
      child: Container(
        child: BlocProvider.value(
          value: BlocManager.dashboardBloc,
          child: BlocListener<DashboardBloc, DashboardState>(
            listener: _blocListener,
            child: BlocBuilder<DashboardBloc, DashboardState>(
              builder: (context, state) {
                return Column(
                  children: [
                    /// Today
                    if (_todayUserHabits != null && _todayUserHabits!.isNotEmpty)
                      _expandableHabitList(
                        LocaleKeys.today,
                        _todayUserHabits!,
                      ),

                    /// Tomorrow
                    if (_tomorrowUserHabits != null && _tomorrowUserHabits!.isNotEmpty)
                      _expandableHabitList(
                        LocaleKeys.tomorrow,
                        _tomorrowUserHabits!,
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _expandableHabitList(String title, List<UserHabit> userHabitList) {
    return ExpandableContainer(
      title: title,
      expandableListItems: List.generate(
        userHabitList.length,
        (index) => ExpandableListItem(
          text: userHabitList[index].name ?? '',
          leadingImageUrl: userHabitList[index].habit?.photo,
          leadingBackgroundColor:
              (userHabitList[index].habit?.color != null) ? HexColor.fromHex(userHabitList[index].habit!.color!) : null,
          onPressed: () {
            if (userHabitList[index].habit?.goalSettings != null) {
              String? route = HabitHelper.getProgressRoute(userHabitList[index].habit!.goalSettings!);
              if (route != null) {
                Navigator.pushNamed(
                  context,
                  route,
                  arguments: {
                    'userHabit': userHabitList[index],
                  },
                );
              }
            }
          },
          onPressedSkip: () {
            showCustomDialog(
              context,
              isDismissible: true,
              child: CustomDialogBody(
                text: LocaleKeys.sureToSkipHabit,
                height: 300.0,
                buttonText: LocaleKeys.skip,
                button2Text: LocaleKeys.no,
                onPressedButton: () {
                  //
                },
              ),
            );
          },
          onPressedEdit: () {
            Navigator.pushNamed(
              context,
              Routes.userHabit,
              arguments: {
                'title': LocaleKeys.ediHabit,
                'habit': null,
                'userHabit': userHabitList[index],
              },
            );
          },
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, DashboardState state) {
    if (state is RefreshDashboardUserHabitsSuccess) {
      _todayUserHabits = state.todayUserHabits;
      _tomorrowUserHabits = state.tomorrowUserHabits;
    }
  }

  _userHabitListOld() {
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
