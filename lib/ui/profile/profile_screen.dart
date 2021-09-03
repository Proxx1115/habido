import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/achievements_bloc.dart';
import 'package:habido_app/models/all_time_achievement.dart';
import 'package:habido_app/models/habit_categories_achievement.dart';
import 'package:habido_app/models/monthly_achievement.dart';
import 'package:habido_app/ui/profile/achievements_widget.dart';
import 'package:habido_app/ui/profile/rank_widget.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';

import 'profile_card.dart';

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
      body: SingleChildScrollView(
        padding: SizeHelper.paddingScreen,
        child: Column(
          children: [
            SizedBox(height: 25.0),

            /// Profile card
            ProfileCard(),

            SizedBox(height: 25.0),

            /// Rank
            RankWidget(),

            SizedBox(height: 25.0),

            /// Achievement
            AchievementsWidget(),
          ],
        ),
      ),
    );
  }
}
