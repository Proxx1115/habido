import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/ui/profile_v2/performance/performance.dart';
import 'package:habido_app/ui/profile_v2/badge/badge.dart';
import 'package:habido_app/ui/profile_v2/profile_bloc/profile_bloc.dart';
import 'package:habido_app/ui/profile_v2/profile_card_v2.dart';
import 'package:habido_app/ui/profile_v2/skill/skill_route.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/responsive_flutter/responsive_flutter.dart';
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
  /// Page view
  PageController _controller = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: LocaleKeys.myCorner,
      actionWidget: _actionWidget(context),
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

  Widget _actionWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, Routes.helpV2);
      },
      child: Container(
        padding: EdgeInsets.all(20),
        child: SvgPicture.asset(
          Assets.dots,
          height: 6,
          width: 26,
          // color: Colors.red,
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, ProfileState state) {}

  Widget _blocBuilder(BuildContext context, ProfileState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(SizeHelper.margin, 20.0, SizeHelper.margin, 0.0),
      child: Column(
        children: [
          // AppBarWithProfile(
          //   backIcon: Assets.back,
          //   text: LocaleKeys.myCorner,
          //   secondIcon: Assets.pointButton,
          //   secondFunc: () {
          //     Navigator.pushNamed(context, Routes.helpV2);
          //   },
          // ),
          ProfileCardV2(),
          SizedBox(height: 20),
          _tabItem(),
          SizedBox(height: 10),
          Expanded(child: _pageItem()),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _pageItem() {
    return PageView(
      controller: _controller,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Performance(),
        Badge(),
        SkillRoute(),
      ],
      onPageChanged: (index) {
        _currentIndex = index;
        setState(() {});
      },
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
