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
                  SectionTitleText(text: LocaleKeys.myAchievements),

                  /// Бүх цаг үеийн амжилт
                  if (_allTimeAchievement != null)
                    _achievementItem(
                      leadingAsset: Assets.clock2,
                      percentTitle: LocaleKeys.allTime,
                      percentage: _allTimeAchievement!.allTimePercentage,
                      achievement: _allTimeAchievement!.allTimeAchievement,
                      completedHabits: _allTimeAchievement!.allTimeTotalCompletedHabits,
                    ),

                  /// Сарын амжилт
                  if (_monthlyAchievement != null)
                    _achievementItem(
                      leadingAsset: Assets.calendar2,
                      percentTitle: LocaleKeys.allTime,
                      percentage: _monthlyAchievement!.monthlyPercentage,
                      achievement: _monthlyAchievement!.monthlyAchievement,
                      completedHabits: _monthlyAchievement!.monthlyTotalCompletedHabits,
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
    int? completedHabits,
  }) {
    return Container(
      margin: EdgeInsets.only(top: 15.0),
      padding: EdgeInsets.all(15.0),
      height: 70.0,
      decoration: BoxDecoration(
        borderRadius: SizeHelper.borderRadiusOdd,
        color: customColors.whiteBackground,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// Image
          Container(
            padding: EdgeInsets.all(10.0),
            height: 40.0,
            width: 40.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(SizeHelper.borderRadius)),
              color: customColors.primaryBackground,
            ),
            child: SvgPicture.asset(leadingAsset!),
          ),

          /// Term
          _achievementRowItem(title: percentTitle, body: percentage != null ? '$percentage%' : ''),

          /// Гүйцэтгэл
          _achievementRowItem(title: LocaleKeys.progress, body: achievement),

          /// Хэвшсэн дадал
          _achievementRowItem(title: LocaleKeys.completedHabit, body: Func.toStr(completedHabits)),
        ],
      ),
    );
  }

  Widget _achievementRowItem({required String title, String? body}) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(title, fontSize: 13.0, color: customColors.secondaryText),
            if (body != null) CustomText(body, fontWeight: FontWeight.w500),
          ],
        ),
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
                            Func.toStr(_allTimeAchievement!.allTimeTotalCompletedHabits),
                            alignment: Alignment.center,
                            fontSize: 35.0,
                            fontWeight: FontWeight.w500,
                          ),

                          /// Дадал
                          CustomText(
                            LocaleKeys.habit,
                            alignment: Alignment.center,
                            fontSize: 13.0,
                            color: customColors.secondaryText,
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
              for (var el in _habitCategoryAchievements!) _pieChartData(el),
            ],
          ),
        ),
      ),
    );
  }

  PieChartSectionData _pieChartData(HabitCategoriesAchievement habitCategoriesAchievement) {
    return PieChartSectionData(
      color: HexColor.fromHex(habitCategoriesAchievement.categoryColor ?? '#A9B0BB'),
      value: Func.toDouble(habitCategoriesAchievement.habitCatPercentage),
      title: '${Func.toInt(habitCategoriesAchievement.habitCatPercentage)}%',
      titleStyle: TextStyle(
        fontSize: 10.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _categoryChartLabels() {
    return Container(
      margin: EdgeInsets.only(top: 15.0),
      child: Column(
        children: [
          for (int i = 0; i < _habitCategoryAchievements!.length; i += 2)
            _categoryChartLabelRow(
              _habitCategoryAchievements![i],
              (i + 1 < _habitCategoryAchievements!.length) ? _habitCategoryAchievements![i + 1] : null,
            ),
        ],
      ),
    );
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
                      color: customColors.secondaryText,
                    ),
                  ),
                ],
              ),
            )
          : Container(),
    );
  }
}
