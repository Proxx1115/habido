import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/bloc/auth_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/home_bloc.dart';
import 'package:habido_app/ui/chat/chatbot_dashboard.dart';
import 'package:habido_app/ui/content_v2/content_dashboard_v2.dart';
import 'package:habido_app/ui/habit_new/habit_dashboard.dart';
import 'package:habido_app/ui/psy_test_v2/psy_test_dashboard_v2/psy_test_dashboard_v2.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/globals.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/responsive_flutter/responsive_flutter.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/showcase_helper.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/authDialog.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/custom_showcase.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:showcaseview/showcaseview.dart';
import 'dashboard/dashboard_screen.dart';

class HomeRouteNew extends StatefulWidget {
  @override
  _HomeRouteNewState createState() => _HomeRouteNewState();
}

class _HomeRouteNewState extends State<HomeRouteNew>
    with SingleTickerProviderStateMixin {
  // UI
  final _homeNewKey = GlobalKey<ScaffoldState>();

  // Bottom navigation bar
  late TabController _tabController;

  bool canSkip = true;

  @override
  void initState() {
    super.initState();
    BlocManager.homeBloc.currentTabIndex = 2;
    _tabController = TabController(initialIndex: 2, length: 5, vsync: this);
    BlocManager.homeBloc.add(HomeShowcaseEvent(ShowcaseKeyName.dashboard));
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkOAuth(context));
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
                ShowCaseWidget.of(context)
                    ?.startShowCase(state.showcaseKeyList);
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
        if (_tabController.index == 2) {
          AuthBloc.showLogoutDialog(context);
        } else {
          BlocManager.homeBloc.add(NavigateToPageEvent(2));
        }

        return Future.value(false);
      },
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          key: _homeNewKey,
          body: TabBarView(
            controller: _tabController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              /// HabitScreen
              HabitDashboard(),

              /// Чатбот
              ChatbotDashboard(),

              /// Нүүр
              DashboardScreen(),

              /// Тест
              PsyTestDashboardV2(),

              /// Зөвлөмж
              ContentDashboardV2(),
            ],
          ),

          /// Bottom navigation bar
          bottomNavigationBar: CustomBottomNavigationBar(),
        ),
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
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
          /// Дадал
          Expanded(
            child: _bottomNavigationBarItem(0, Assets.habit, LocaleKeys.habit),
          ),

          /// Чатбот
          Expanded(
            child: _bottomNavigationBarItem(
                1, Assets.assistant, LocaleKeys.chatbot),
          ),

          /// Нүүр
          Expanded(
            child: _bottomNavigationBarItem(2, Assets.home, LocaleKeys.home),
          ),

          /// Тест
          Expanded(
            child: _bottomNavigationBarItem(3, Assets.test, LocaleKeys.test),
          ),

          /// Зөвлөмж
          Expanded(
            child:
                _bottomNavigationBarItem(4, Assets.content, LocaleKeys.advice),
          ),
        ],
      ),
    );
  }

  Widget _bottomNavigationBarItem(int index, String asset, String text) {
    _navBarItemWidth =
        _navBarItemWidth ?? (MediaQuery.of(context).size.width) / 5;

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
                  color: BlocManager.homeBloc.currentTabIndex == index
                      ? customColors.primary
                      : customColors.primaryBorder,
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
                      color: BlocManager.homeBloc.currentTabIndex == index
                          ? customColors.primary
                          : customColors.iconGrey,
                    ),
                  ),
                ),

                /// Text
                CustomText(
                  text,
                  padding: EdgeInsets.only(top: 5.0),
                  alignment: Alignment.center,
                  color: BlocManager.homeBloc.currentTabIndex == index
                      ? customColors.primary
                      : customColors.iconGrey,
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

_checkOAuth(BuildContext context) {
  if (globals.userData!.hasOAuth2 == false) {
    showAuthDialog(
      context,
      isDismissible: false,
      child: AuthDialog(
          asset: Assets.error, skipCount: globals.userData!.oAuth2SkipCount),
    );
  }
}
