import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/achievements_bloc.dart';
import 'package:habido_app/models/all_time_achievement.dart';
import 'package:habido_app/models/habit_categories_achievement.dart';
import 'package:habido_app/models/monthly_achievement.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/utils/theme/hex_color.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/text.dart';

class AchievementsWidget extends StatefulWidget {
  final EdgeInsets? margin;

  const AchievementsWidget({Key? key, this.margin}) : super(key: key);

  @override
  _AchievementsWidgetState createState() => _AchievementsWidgetState();
}

class _AchievementsWidgetState extends State<AchievementsWidget> {
  AllTimeAchievement? _allTimeAchievement;
  MonthlyAchievement? _monthlyAchievement;
  List<HabitCategoriesAchievement>? _habitCategoryAchievements;
  List<HabitCategoriesAchievement>? _touchedHabitCategoryAchievements;

  // Pie chart
  int _pieChartTouchedIndex = -1;

  @override
  void initState() {
    BlocManager.achievementBloc.add(GetAchievementsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocManager.achievementBloc,
      child: BlocListener<AchievementBloc, AchievementState>(
        listener: _blocListener,
        child: BlocBuilder<AchievementBloc, AchievementState>(
          builder: (context, state) {
            return Container(
              margin: widget.margin,
              child: Column(
                children: [
                  /// Миний амжилт
                  if (_allTimeAchievement != null)
                    SectionTitleText(
                      text: LocaleKeys.myAchievements,
                      margin: EdgeInsets.symmetric(vertical: 0.0),
                    ),

                  /// Сарын амжилт
                  if (_monthlyAchievement != null)
                    _achievementItem(
                      leadingAsset: Assets.calendar2,
                      percentTitle: LocaleKeys.thisMonth,
                      percentage: _monthlyAchievement!.monthlyPercentage,
                      achievement: _monthlyAchievement!.monthlyAchievement,
                      completedHabitTitle: LocaleKeys.completedHabit2,
                      completedHabits: _monthlyAchievement!.monthlyTotalCompletedHabits,
                    ),

                  /// Бүх цаг үеийн амжилт
                  if (_allTimeAchievement != null)
                    _achievementItem(
                      leadingAsset: Assets.clock2,
                      percentTitle: LocaleKeys.allTime,
                      percentage: _allTimeAchievement!.allTimePercentage,
                      achievement: _allTimeAchievement!.allTimeAchievement,
                      completedHabitTitle: LocaleKeys.completedHabit3,
                      completedHabits: _allTimeAchievement!.allTimeTotalCompletedHabits,
                      margin: EdgeInsets.only(top: 15.0),
                    ),

                  /// Category achievements
                  _categoryAchievements(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, AchievementState state) {
    if (state is AchievementsSuccess) {
      _allTimeAchievement = state.response.allTimeAchievement;
      _monthlyAchievement = state.response.monthlyAchievement;

      if (state.response.habitCategoryAchievements != null && state.response.habitCategoryAchievements!.isNotEmpty) {
        _habitCategoryAchievements = [];
        for (var el in state.response.habitCategoryAchievements!) {
          if ((el.habitCatPercentage ?? 0) > 0) {
            _habitCategoryAchievements!.add(el);
          }
        }
      }
    }
  }

  Widget _achievementItem({
    String? leadingAsset,
    required String percentTitle,
    int? percentage,
    String? achievement,
    required String completedHabitTitle,
    String? completedHabits,
    EdgeInsets? margin,
  }) {
    return Container(
      margin: margin ?? EdgeInsets.only(top: 20.0),
      padding: EdgeInsets.all(12.0),
      height: 76.0,
      decoration: BoxDecoration(
        borderRadius: SizeHelper.borderRadiusOdd,
        color: customColors.whiteBackground,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// Term
          _achievementRowItem(
            title: percentTitle,
            body: percentage != null ? '$percentage%' : '',
          ),

          /// Гүйцэтгэл
          Expanded(
            child: _achievementRowItem(
              title: LocaleKeys.progress,
              body: achievement,
            ),
          ),

          /// Хэвшсэн дадал
          _achievementRowItem(
            title: completedHabitTitle, //LocaleKeys.completedHabit2,
            body: completedHabits ?? '',
          ),
        ],
      ),
    );
  }

  Widget _achievementRowItem({required String title, String? body}) {
    return Container(
      margin: EdgeInsets.only(left: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
            title,
            fontSize: 13.0,
            color: customColors.greyText,
            alignment: Alignment.center,
          ),
          if (body != null)
            CustomText(
              body,
              fontWeight: FontWeight.w500,
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 6.0),
            ),
        ],
      ),
    );
  }

  Widget _categoryAchievements() {
    return (_habitCategoryAchievements != null && _habitCategoryAchievements!.isNotEmpty)
        ? StadiumContainer(
            margin: EdgeInsets.only(top: 15.0),
            padding: EdgeInsets.fromLTRB(15.0, SizeHelper.margin, 15.0, SizeHelper.margin),
            borderRadius: SizeHelper.borderRadiusOdd,
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    /// Chart
                    _categoryChart(),

                    Center(
                      child: Column(
                        children: [
                          /// Хэвшсэн дадал
                          CustomText(
                            Func.toStr(_allTimeAchievement!.allTimeTotalCompletedHabits!.split('/')[0]),
                            alignment: Alignment.center,
                            fontSize: 28.0,
                            fontWeight: FontWeight.w500,
                          ),

                          /// Дадал
                          CustomText(
                            LocaleKeys.completedHabit3,
                            alignment: Alignment.center,
                            fontSize: 13.0,
                            maxLines: 2,
                            color: customColors.greyText,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                /// Labels
                _categoryChartLabels(),
              ],
            ),
          )
        : Container();
  }

  Widget _categoryChart() {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.6,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: PieChart(
          PieChartData(
            sections: [
              for (int i = 0; i < _habitCategoryAchievements!.length; i++) _pieChartData(i),
            ],
            pieTouchData: PieTouchData(
              touchCallback: (FlTouchEvent event, PieTouchResponse? pieTouchResponse) {
                setState(() {
                  if (pieTouchResponse?.touchedSection is FlLongPressEnd || pieTouchResponse?.touchedSection is FlPanEndEvent) {
                    _pieChartTouchedIndex = -1;
                  } else {
                    _pieChartTouchedIndex = pieTouchResponse?.touchedSection?.touchedSectionIndex ?? -1;
                    if (_pieChartTouchedIndex >= 0) {
                      if (_touchedHabitCategoryAchievements == null) {
                        _touchedHabitCategoryAchievements = [_habitCategoryAchievements![_pieChartTouchedIndex]];
                      } else {
                        bool alreadyAdded = false;
                        for (var el in _touchedHabitCategoryAchievements!) {
                          if (el.habitCatName == _habitCategoryAchievements![_pieChartTouchedIndex].habitCatName) {
                            alreadyAdded = true;
                            break;
                          }
                        }

                        if (!alreadyAdded) {
                          _touchedHabitCategoryAchievements!.add(_habitCategoryAchievements![_pieChartTouchedIndex]);
                        }
                      }
                    }
                  }
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  PieChartSectionData _pieChartData(int index) {
    return PieChartSectionData(
      color: HexColor.fromHex(_habitCategoryAchievements![index].categoryColor ?? '#A9B0BB'),
      value: Func.toDouble(_habitCategoryAchievements![index].habitCatPercentage),
      title: '${Func.toInt(_habitCategoryAchievements![index].habitCatPercentage)}%',
      radius: index == _pieChartTouchedIndex ? 50.0 : 40.0,
      titleStyle: TextStyle(
        fontSize: 10.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      titlePositionPercentageOffset: 0.5,
      badgePositionPercentageOffset: 0.5,
    );
  }

  Widget _categoryChartLabels() {
    return (_touchedHabitCategoryAchievements != null && _touchedHabitCategoryAchievements!.isNotEmpty)
        ? Container(
            margin: EdgeInsets.only(top: 15.0),
            child: Column(
              children: [
                for (int i = 0; i < _touchedHabitCategoryAchievements!.length; i += 2)
                  _categoryChartLabelRow(
                    _touchedHabitCategoryAchievements![i],
                    (i + 1 < _touchedHabitCategoryAchievements!.length) ? _touchedHabitCategoryAchievements![i + 1] : null,
                  ),
              ],
            ),
          )
        : Container();
  }

  Widget _categoryChartLabelRow(
    HabitCategoriesAchievement habitCategoriesAchievement1,
    HabitCategoriesAchievement? habitCategoriesAchievement2,
  ) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _categoryChartLabelItem(habitCategoriesAchievement1),
          SizedBox(width: 15.0),
          _categoryChartLabelItem(habitCategoriesAchievement2),
        ],
      ),
    );
  }

  Widget _categoryChartLabelItem(HabitCategoriesAchievement? habitCategoriesAchievement) {
    return Expanded(
      child: habitCategoriesAchievement != null
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              height: 40.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: customColors.primaryBackground,
              ),
              child: Row(
                children: [
                  /// Dot
                  Container(
                    height: 10.0,
                    width: 10.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      color: HexColor.fromHex(habitCategoriesAchievement.categoryColor ?? '#fa6c51'),
                    ),
                  ),

                  SizedBox(width: 10.0),

                  /// Text
                  Expanded(
                    child: CustomText(
                      habitCategoriesAchievement.habitCatName,
                      fontSize: 13.0,
                      color: customColors.greyText,
                    ),
                  ),
                ],
              ),
            )
          : Container(),
    );
  }
}
