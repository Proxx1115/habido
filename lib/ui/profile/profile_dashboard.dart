import 'package:flutter/material.dart';
import 'package:habido_app/bloc/auth_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/achievements_bloc.dart';
import 'package:habido_app/ui/profile/achievements_widget.dart';
import 'package:habido_app/ui/profile/rank_widget.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/app_bars/dashboard_sliver_app_bar.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'profile_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    BlocManager.achievementBloc.add(GetAchievementsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: CustomScrollView(
        slivers: [
          /// App bar
          DashboardSliverAppBar(
            title: LocaleKeys.myCorner,
            onPressedHelp: () {
              //
            },
            onPressedLogout: () {
              AuthBloc.showLogoutDialog(context);
            },
          ),

          /// Profile card
          SliverToBoxAdapter(
            child: ProfileCard(
              margin: EdgeInsets.fromLTRB(SizeHelper.margin, 10.0, SizeHelper.margin, 0.0),
            ),
          ),

          /// Rank
          SliverToBoxAdapter(
            child: RankWidget(
              margin: EdgeInsets.fromLTRB(SizeHelper.margin, 20.0, SizeHelper.margin, 0.0),
            ),
          ),

          /// Achievements
          SliverToBoxAdapter(
            child: AchievementsWidget(
              margin: EdgeInsets.fromLTRB(SizeHelper.margin, 25.0, SizeHelper.margin, SizeHelper.marginBottom),
            ),
          ),
        ],
      ),
    );
  }
}
