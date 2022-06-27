import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/models/mood_tracker_monthly_reason_response.dart';
import 'package:habido_app/ui/profile_v2/ability/ability.dart';
import 'package:habido_app/ui/profile_v2/performance/performance.dart';
import 'package:habido_app/ui/profile_v2/badge/badge.dart';
import 'package:habido_app/ui/profile_v2/profile_bloc/profile_bloc.dart';
import 'package:habido_app/ui/profile_v2/profile_card_v2.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/app_bars/app_bar_with_profile.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';

class ProfileScreenV2 extends StatefulWidget {
  const ProfileScreenV2({Key? key}) : super(key: key);

  @override
  State<ProfileScreenV2> createState() => _ProfileScreenV2State();
}

class _ProfileScreenV2State extends State<ProfileScreenV2> {
  // Page view
  PageController _controller = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: BlocProvider.value(
        value: BlocManager.profileBloc,
        child: BlocListener<ProfileBloc, ProfileState>(
          listener: _blocListener,
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: _blocBuilder,
          ),
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, ProfileState state) {}

  Widget _blocBuilder(BuildContext context, ProfileState state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          AppBarWithProfile(
            backIcon: Assets.back,
            text: LocaleKeys.myCorner,
            secondIcon: Assets.pointButton,
            secondFunc: () {
              Navigator.pushNamed(context, Routes.helpV2);
            },
          ),
          Container(
            margin: EdgeInsets.fromLTRB(SizeHelper.margin, 20.0, SizeHelper.margin, 0.0),
            child: Column(
              children: [
                ProfileCardV2(),
                SizedBox(height: 20),
                _tabItem(),
                SizedBox(height: 10),
                _pageItem(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _pageItem() {
    return Container(
      height: MediaQuery.of(context).size.height * 1.2,
      width: MediaQuery.of(context).size.width,
      child: PageView(
        controller: _controller,
        children: [
          Performance(),
          Badge(),
          Ability(),
        ],
        onPageChanged: (index) {
          _currentIndex = index;
          setState(() {});
        },
      ),
    );
  }

  Widget _tabItem() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        border: Border.all(color: Colors.white, width: 1.0),
      ),
      child: Row(
        children: [
          _tabButtonItem(index: 0, text: LocaleKeys.performance),
          _tabButtonItem(index: 1, text: LocaleKeys.badge),
          _tabButtonItem(index: 2, text: LocaleKeys.ability),
        ],
      ),
    );
  }

  Widget _tabButtonItem({required int index, required String text}) {
    return Expanded(
      child: InkWell(
        onTap: () {
          _controller.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
          setState(() {});
        },
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration:
              BoxDecoration(borderRadius: BorderRadius.circular(20), color: _currentIndex == index ? customColors.primary : Colors.transparent),
          child: CustomText(
            text,
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: _currentIndex == index ? Colors.white : customColors.primaryText,
            alignment: Alignment.center,
          ),
        ),
      ),
    );
  }
}
