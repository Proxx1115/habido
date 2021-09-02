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
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
    return CustomScaffold(
      backgroundColor: customColors.primaryBackground,
      body: BlocProvider.value(
        value: BlocManager.achievementBloc,
        child: BlocListener<AchievementBloc, AchievementState>(
          listener: _blocListener,
          child: BlocBuilder<AchievementBloc, AchievementState>(
            builder: (context, state) {
              return SingleChildScrollView(
                padding: SizeHelper.paddingScreen,
                child: Column(
                  children: [
                    /// Миний амжилт
                    Row(
                      children: [
                        SvgPicture.asset(Assets.scratch),
                        CustomText(
                          LocaleKeys.myAchievements,
                          margin: EdgeInsets.only(left: 15.0),
                          fontWeight: FontWeight.w500,
                          fontSize: 19.0,
                        ),
                      ],
                    ),

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
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, AchievementState state) {
    if (state is AchievementsSuccess) {
      _allTimeAchievement = state.response.allTimeAchievement;
      _monthlyAchievement = state.response.monthlyAchievement;
      _habitCategoryAchievements = state.response.habitCategoryAchievements;
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
        color: customColors.secondaryBackground,
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
          Expanded(
            child: _achievementRowItem(title: LocaleKeys.completedHabit, body: Func.toStr(completedHabits)),
          ),
        ],
      ),
    );
  }

  Widget _achievementRowItem({required String title, String? body}) {
    return Container(
      margin: EdgeInsets.only(left: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(title, fontSize: 13.0, color: customColors.secondaryText),
          if (body != null) CustomText(body, fontWeight: FontWeight.w500),
        ],
      ),
    );
  }
}
