import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/bloc/auth_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/home_bloc.dart';
import 'package:habido_app/ui/chat/chatbot_dashboard.dart';
import 'package:habido_app/ui/content/content_dashboard.dart';
import 'package:habido_app/ui/profile_v2/profile_dashboard_v2.dart';
import 'package:habido_app/ui/psy_test/psy_test_dashboard/psy_user_test_dashboard.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/showcase_helper.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/custom_showcase.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:showcaseview/showcaseview.dart';
import 'dashboard/dashboard_screen.dart';
import '../profile/profile_dashboard.dart';
import '../psy_test/psy_test_dashboard/psy_test_dashboard.dart';

class HomeRoute extends StatefulWidget {
  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> with SingleTickerProviderStateMixin {
  // UI
  final _homeKey = GlobalKey<ScaffoldState>();

  // Bottom navigation bar
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    BlocManager.homeBloc.currentTabIndex = 0;
    _tabController = TabController(initialIndex: 0, length: 5, vsync: this);
    BlocManager.homeBloc.add(HomeShowcaseEvent(ShowcaseKeyName.dashboard));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: Builder(builder: (context) {
        return BlocProvider.value(
          value: BlocManager.homeBloc,
          child: BlocListener<HomeBloc, HomeState>(
            listener: (context, state) {
              if (state is NavigateToPageState) {
                _tabController.index = state.index;
              } else if (state is HomeShowcaseState) {
                ShowCaseWidget.of(context)?.startShowCase(state.showcaseKeyList);
              }
            },
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: _blocBuilder,
            ),
          ),
        );
      }),
    );
  }

  Widget _blocBuilder(BuildContext context, HomeState state) {
    return WillPopScope(
      onWillPop: () {
        if (_tabController.index == 0) {
          AuthBloc.showLogoutDialog(context);
        } else {
          BlocManager.homeBloc.add(NavigateToPageEvent(0));
        }

        return Future.value(false);
      },
      child: Scaffold(
        key: _homeKey,
        body: TabBarView(
          controller: _tabController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            /// ????????
            DashboardScreen(),

            /// ????????
            PsyUserTestDashboard(),

            /// ????????????
            ChatbotDashboard(),

            /// ??????????????
            ContentDashboard(),

            /// ??????????????
            // ProfileScreen(),
            ProfileScreenV2(),
          ],
        ),

        /// Bottom navigation bar
        bottomNavigationBar: CustomBottomNavigationBar(),
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  double? _navBarItemWidth;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      color: customColors.whiteBackground,
      elevation: 0.0,
      clipBehavior: Clip.none,
      notchMargin: 4.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          /// ????????
          Expanded(
            child: _bottomNavigationBarItem(0, Assets.home, LocaleKeys.home),
          ),

          /// ????????
          Expanded(
            child: CustomShowcase(
              showcaseKey: ShowcaseKey.psyTest,
              description: LocaleKeys.showcasePsyTest,
              child: _bottomNavigationBarItem(1, Assets.test, LocaleKeys.test),
            ),
          ),

          /// ????????????
          Expanded(
            child: CustomShowcase(
              showcaseKey: ShowcaseKey.assistant,
              description: LocaleKeys.showcaseAssistant,
              child: _bottomNavigationBarItem(2, Assets.assistant, LocaleKeys.habiDo),
            ),
          ),

          /// ??????????????
          Expanded(
            child: CustomShowcase(
              showcaseKey: ShowcaseKey.content,
              description: LocaleKeys.showcaseContent,
              overlayOpacity: 0.7,
              child: _bottomNavigationBarItem(3, Assets.content, LocaleKeys.advice),
            ),
          ),

          /// ??????????????
          Expanded(
            child: CustomShowcase(
              showcaseKey: ShowcaseKey.profile,
              description: LocaleKeys.showcaseProfile,
              child: _bottomNavigationBarItem(4, Assets.profile, LocaleKeys.profile),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomNavigationBarItem(int index, String asset, String text) {
    _navBarItemWidth = _navBarItemWidth ?? (MediaQuery.of(context).size.width) / 5;

    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      onTap: () {
        BlocManager.homeBloc.add(NavigateToPageEvent(index));
      },
      child: Container(
        height: 60.0,
        width: _navBarItemWidth,
        // decoration: BoxDecoration(
        //   border: Border(top: BorderSide(width: SizeHelper.borderWidth, color: customColors.primaryBorder)),
        // ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: HorizontalLine(color: customColors.primaryBorder),
                ),
                Container(
                  width: 20.0,
                  height: SizeHelper.borderWidth,
                  color: BlocManager.homeBloc.currentTabIndex == index ? customColors.primary : customColors.primaryBorder,
                ),
                Expanded(
                  child: HorizontalLine(color: customColors.primaryBorder),
                ),
              ],
            ),
            SizedBox(height: 7.0),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// Icon
                Center(
                  child: SizedBox(
                    width: 24.0,
                    height: 24.0,
                    child: SvgPicture.asset(
                      asset,
                      color: BlocManager.homeBloc.currentTabIndex == index ? customColors.primary : customColors.iconGrey,
                    ),
                  ),
                ),

                /// Text
                CustomText(
                  text,
                  padding: EdgeInsets.only(top: 5.0),
                  alignment: Alignment.center,
                  color: BlocManager.homeBloc.currentTabIndex == index ? customColors.primary : customColors.iconGrey,
                  fontSize: 11.0,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
