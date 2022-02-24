import 'package:flutter/material.dart';
import 'package:habido_app/models/skip_user_habit_request.dart';
import 'package:habido_app/ui/habit/habit_helper.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/screen_mode.dart';
import 'package:habido_app/utils/showcase_helper.dart';
import 'package:habido_app/ui/home/dashboard/dashboard_app_bar.dart';
import 'package:habido_app/ui/home/slider/custom_carousel_slider.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/custom_showcase.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/dashboard_bloc.dart';
import 'package:habido_app/models/user_habit.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/theme/hex_color.dart';
import 'package:habido_app/widgets/containers/expandable_container/expandable_container.dart';
import 'package:habido_app/widgets/containers/expandable_container/expandable_list_item.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/text_field/text_fields.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Slider
  double _sliderAspectRatio = 2.0;
  double? _sliderHeight;
  double _sliderTopMargin = 0.0;
  double _indicatorHeight = 15.0;
  double _indicatorVerticalMargin = 0;
  double _scrollHeaderHeight = 35.0;

  bool _isUserHabitEmpty = false;

  // User habits
  List<UserHabit>? _todayUserHabits;

  // bool _isExpandedTodayUserHabits = false;
  List<UserHabit>? _tomorrowUserHabits;

  @override
  void initState() {
    super.initState();

    BlocManager.dashboardBloc.add(RefreshDashboardUserHabits());
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: customColors.primary,
      child: Container(
        color: customColors.primaryBackground,
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            /// Header
            _header(),

            /// Today
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return _userHabitListWidget();
                },
                childCount: 1,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: CustomShowcase(
        showcaseKey: ShowcaseKey.addHabit,
        description: LocaleKeys.showcaseAddHabit,
        shapeBorder: CircleBorder(),
        overlayPadding: EdgeInsets.all(10.0),
        child: BlocProvider.value(
          value: BlocManager.dashboardBloc,
          child: BlocListener<DashboardBloc, DashboardState>(
            listener: _blocListener,
            child: BlocBuilder<DashboardBloc, DashboardState>(builder: (context, state) {
              return _isUserHabitEmpty
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(25.0),
                          bottomRight: Radius.circular(25.0),
                          bottomLeft: Radius.circular(25.0),
                        ),
                        color: customColors.whiteBackground,
                      ),
                      width: 217.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          /// Text
                          Container(
                            margin: EdgeInsets.only(right: 15),
                            // width: 162.0,
                            child: Text(
                              LocaleKeys.createNewHabit,
                              style: TextStyle(fontFamily: FontAsset.FiraSansCondensed, fontWeight: FontWeight.w500, fontSize: 15.0, color: HexColor.fromHex('#424852')),
                            ),
                          ),

                          /// Button
                          ButtonStadium(
                            style: ButtonStadiumStyle.Secondary,
                            asset: Assets.add,
                            onPressed: () {
                              Navigator.pushNamed(context, Routes.habitCategories);
                            },
                          ),
                        ],
                      ),
                    )
                  : ButtonStadium(
                      style: ButtonStadiumStyle.Secondary,
                      asset: Assets.add,
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.habitCategories);
                      },
                    );
            }),
          ),
        ),
      ),
    );
  }

  _header() {
    _sliderHeight = _sliderHeight ?? (MediaQuery.of(context).size.width) / 1.6;

    return SliverAppBar(
      pinned: false,
      snap: true,
      floating: true,
      expandedHeight: _sliderHeight!,
      collapsedHeight: _sliderHeight!,
      backgroundColor: customColors.primaryBackground,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: Stack(
        children: [
          // Removed orange line
          Container(color: customColors.primary, margin: EdgeInsets.only(bottom: 1.0)),

          /// Banner
          CustomCarouselSlider(
            aspectRatio: _sliderAspectRatio,
            sliderHeight: _sliderHeight!,
            sliderMargin: EdgeInsets.only(top: _sliderTopMargin),
            indicatorHeight: _indicatorHeight,
            indicatorMargin: EdgeInsets.symmetric(vertical: _indicatorVerticalMargin, horizontal: 2.0),
          ),

          /// Calendar, Notification
          DashboardAppBar(
            padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
            visibleShowCase: true,
          ),

          /// Scroll header
          Positioned(
            bottom: 0,
            child: Container(
              height: _scrollHeaderHeight,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: customColors.primaryBackground,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(35.0), topRight: Radius.circular(35.0)),
                  boxShadow: [
                    BoxShadow(
                      color: customColors.primaryBackground,
                      blurRadius: 0.0,
                      spreadRadius: 0.0,
                      offset: Offset(0, 2),
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _userHabitListWidget() {
    return Container(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(SizeHelper.padding, 0.0, SizeHelper.padding, SizeHelper.marginBottom),
        child: BlocProvider.value(
          value: BlocManager.dashboardBloc,
          child: BlocListener<DashboardBloc, DashboardState>(
            listener: _blocListener,
            child: BlocBuilder<DashboardBloc, DashboardState>(
              builder: (context, state) {
                String todayDone = '';
                List<UserHabit>? todayUserHabits = _todayUserHabits;
                if (todayUserHabits != null) {
                  todayDone = todayUserHabits.where((element) => element.isDone!).toList().length.toString() + '/' + _todayUserHabits!.length.toString();
                }
                return Column(
                  children: [
                    /// Today
                    if (_todayUserHabits != null && _todayUserHabits!.isNotEmpty) _expandableHabitList(LocaleKeys.today, _todayUserHabits!, true, true, todayDone),

                    /// Tomorrow
                    if (_tomorrowUserHabits != null && _tomorrowUserHabits!.isNotEmpty) _expandableHabitList(LocaleKeys.tomorrow, _tomorrowUserHabits!, false, false, ''),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, DashboardState state) {
    if (state is RefreshDashboardUserHabitsSuccess) {
      _todayUserHabits = state.todayUserHabits;
      _tomorrowUserHabits = state.tomorrowUserHabits;
      if ((_todayUserHabits == null && _tomorrowUserHabits == null) || ((_todayUserHabits?.length == 0) && (_tomorrowUserHabits?.length == 0)))
        _isUserHabitEmpty = true;
      else
        _isUserHabitEmpty = false;
    } else if (state is SkipUserHabitSuccess) {
      print('SkipUserHabitSuccess');
    } else if (state is SkipUserHabitFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    }
  }

  String _getSuffixAsset(UserHabit userHabit) {
    var suffixAsset;
    if (userHabit.habitState == UserHabitPlanState.Done) {
      suffixAsset = Assets.check3;
    } else if (userHabit.habitState == UserHabitPlanState.New) {
      suffixAsset = Assets.arrow_forward;
    } else {
      suffixAsset = Assets.refresh;
    }
    return suffixAsset;
  }

  Color _getSuffixColor(UserHabit userHabit) {
    var suffixColor;
    if (userHabit.habitState == UserHabitPlanState.Done) {
      suffixColor = customColors.iconSeaGreen;
    } else if (userHabit.habitState == UserHabitPlanState.New) {
      suffixColor = customColors.primary;
    } else {
      suffixColor = customColors.iconSeaGreen;
    }
    return suffixColor;
  }

  Widget _expandableHabitList(String title, List<UserHabit> userHabitList, bool enabled, bool isToday, String? todayText) {
    return ExpandableContainer(
      isToday: isToday,
      todayText: todayText,
      title: title,
      expandableListItems: List.generate(
        userHabitList.length,
        (index) => ExpandableListItem(
          delay: index * 0.2,
          text: userHabitList[index].name ?? '',
          leadingUrl: userHabitList[index].habit?.photo,
          leadingColor: customColors.iconWhite,
          leadingBackgroundColor: (userHabitList[index].habit?.color != null) ? HexColor.fromHex(userHabitList[index].habit!.color!) : null,
          suffixAsset: _getSuffixAsset(userHabitList[index]),
          suffixColor: _getSuffixColor(userHabitList[index]),
          // suffixAsset: (userHabitList[index].isDone ?? false) ? Assets.check2 : Assets.arrow_forward,
          // suffixColor: (userHabitList[index].isDone ?? false) ? customColors.iconSeaGreen : customColors.primary,
          onPressed: () {
            // Is finished
            if (userHabitList[index].isDone ?? false) return;

            // Navigate
            if (enabled && userHabitList[index].habit?.goalSettings != null) {
              String? route = HabitHelper.getProgressRoute(userHabitList[index].habit!);
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
          onPressedSkip: (userHabitList[index].isDone ?? false)
              ? null
              : () {
                  showCustomDialog(
                    context,
                    isDismissible: true,
                    child: CustomDialogBody(
                      text: LocaleKeys.sureToSkipHabit,
                      // height: 300.0,
                      buttonText: LocaleKeys.skip,
                      button2Text: LocaleKeys.no,
                      onPressedButton: () {
                        var skipUserHabitRequest = SkipUserHabitRequest()
                          ..userHabitId = userHabitList[index].userHabitId
                          ..skipDay = Func.toDateStr(DateTime.now());
                        BlocManager.dashboardBloc.add(SkipUserHabitEvent(skipUserHabitRequest));
                      },
                    ),
                  );
                },
          onPressedEdit: (userHabitList[index].isDone ?? false)
              ? null
              : () {
                  Navigator.pushNamed(
                    context,
                    Routes.userHabit,
                    arguments: {
                      'screenMode': (userHabitList[index].isDynamicHabit ?? false) ? ScreenMode.CustomEdit : ScreenMode.Edit,
                      'habit': userHabitList[index].habit,
                      'userHabit': userHabitList[index],
                      'title': LocaleKeys.ediHabit,
                    },
                  );
                },
        ),
      ),
    );
  }
}
