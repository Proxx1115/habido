import 'package:flutter/material.dart';
import 'package:habido_app/bloc/auth_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/achievements_bloc.dart';
import 'package:habido_app/ui/profile/achievements_widget.dart';
import 'package:habido_app/ui/profile/rank_widget.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/app_bars/dashboard_sliver_app_bar.dart';
import 'package:habido_app/widgets/animations/animations.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'profile_card.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:habido_app/widgets/buttons.dart';

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
              Navigator.pushNamed(context, Routes.help);
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
              margin: EdgeInsets.fromLTRB(SizeHelper.margin, 25.0, SizeHelper.margin, 0.0),
            ),
          ),

          /// Logout
          SliverToBoxAdapter(
            child: _logOut(),
          ),
        ],
      ),
    );
  }

  Widget _logOut(){
    return new MoveInAnimation(
      duration: 400,
      delay: 0.2,
      child: Slidable(
        // controller: _controller,
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        child: InkWell(
          onTap: (){
            AuthBloc.showLogoutDialog(context);
          },
          borderRadius: SizeHelper.borderRadiusOdd,
          child: Container(
            margin: EdgeInsets.fromLTRB(SizeHelper.margin, 10.0, SizeHelper.margin, 20.0),
            height: SizeHelper.listItemHeight70,
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 20.0, 10.0),
            decoration: BoxDecoration(
              borderRadius: SizeHelper.borderRadiusOdd,
              color: customColors.whiteBackground,
            ),
            child: Row(
              children: [
                /// Image
                ButtonStadium(
                  asset: Assets.logout,
                  backgroundColor: customColors.primary,
                  child: Container(
                    padding: EdgeInsets.all(12.0),
                    child: SvgPicture.asset(Assets.logout, color: customColors.whiteBackground),
                  )
                ),

                /// Text
                Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 0.0),
                    child: Column(
                      children: [
                        CustomText(LocaleKeys.logout, fontWeight: FontWeight.w500, color: customColors.primary),

                        SizedBox(height: 4.0),

                        CustomText(LocaleKeys.logoutFromApp, color: customColors.greyText),
                      ],
                    ),
                  ),
                ),

                /// Arrow
                SvgPicture.asset(Assets.arrow_forward, color: customColors.iconGrey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
